const DAY_MS = 24 * 60 * 60 * 1000;
const MAX_BODY_BYTES = 512;

function json(body, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      "content-type": "application/json; charset=utf-8",
      "cache-control": "no-store",
      "x-content-type-options": "nosniff",
    },
  });
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (request.method !== "POST" || url.pathname !== "/v1/trial") {
      return json({ error: "not_found" }, 404);
    }
    if (Number(request.headers.get("content-length") || 0) > MAX_BODY_BYTES) {
      return json({ error: "request_too_large" }, 413);
    }

    let payload;
    try {
      const body = await request.text();
      if (new TextEncoder().encode(body).byteLength > MAX_BODY_BYTES) {
        return json({ error: "request_too_large" }, 413);
      }
      payload = JSON.parse(body);
    } catch {
      return json({ error: "invalid_json" }, 400);
    }

    const deviceHash = payload?.deviceHash;
    if (typeof deviceHash !== "string" || !/^[a-f0-9]{64}$/.test(deviceHash)) {
      return json({ error: "invalid_device_hash" }, 400);
    }

    const now = Date.now();
    const candidate = Date.parse(payload?.candidateStartedAt || "");
    // Accept an earlier on-device start when syncing an offline first launch.
    // Future client clocks are never trusted to create a later grant.
    const startedAt = Number.isFinite(candidate) && candidate <= now
      ? candidate
      : now;

    try {
      await env.DB.prepare(
        "INSERT OR IGNORE INTO trial_claims (device_hash, started_at_ms) VALUES (?, ?)",
      ).bind(deviceHash, startedAt).run();
      const row = await env.DB.prepare(
        "SELECT started_at_ms FROM trial_claims WHERE device_hash = ?",
      ).bind(deviceHash).first();
      if (!row || !Number.isSafeInteger(row.started_at_ms)) {
        return json({ error: "claim_unavailable" }, 503);
      }

      const canonicalStart = row.started_at_ms;
      return json({
        startedAt: new Date(canonicalStart).toISOString(),
        serverNow: new Date(now).toISOString(),
        trialActive: now >= canonicalStart && now < canonicalStart + DAY_MS,
      });
    } catch {
      return json({ error: "claim_unavailable" }, 503);
    }
  },
};
