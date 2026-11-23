import assert from "node:assert/strict";
import test from "node:test";
import worker from "./worker.mjs";

function mockDb() {
  const claims = new Map();
  return {
    prepare(sql) {
      return {
        bind(...values) {
          return {
            async run() {
              if (sql.startsWith("INSERT")) {
                const [hash, start] = values;
                if (!claims.has(hash)) claims.set(hash, start);
              }
            },
            async first() {
              return { started_at_ms: claims.get(values[0]) };
            },
          };
        },
      };
    },
  };
}

test("the first server claim is preserved on later installs", async () => {
  const env = { DB: mockDb() };
  const hash = "a".repeat(64);
  const send = (candidateStartedAt) => worker.fetch(new Request(
    "https://trial.example/v1/trial",
    {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ deviceHash: hash, candidateStartedAt }),
    },
  ), env);

  const first = await (await send(undefined)).json();
  const second = await (await send("2000-01-01T00:00:00.000Z")).json();
  assert.equal(second.startedAt, first.startedAt);
});

test("invalid hashes and unrelated routes are rejected", async () => {
  const env = { DB: mockDb() };
  const invalid = await worker.fetch(new Request("https://trial.example/v1/trial", {
    method: "POST",
    body: JSON.stringify({ deviceHash: "not-a-device-hash" }),
  }), env);
  const missing = await worker.fetch(new Request("https://trial.example/"), env);
  assert.equal(invalid.status, 400);
  assert.equal(missing.status, 404);
});

test("oversized bodies are rejected", async () => {
  const env = { DB: mockDb() };
  const response = await worker.fetch(new Request("https://trial.example/v1/trial", {
    method: "POST",
    body: JSON.stringify({ deviceHash: "a".repeat(64), padding: "x".repeat(600) }),
  }), env);
  assert.equal(response.status, 413);
});
