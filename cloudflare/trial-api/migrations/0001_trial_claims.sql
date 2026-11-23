CREATE TABLE IF NOT EXISTS trial_claims (
  device_hash TEXT PRIMARY KEY NOT NULL CHECK (length(device_hash) = 64),
  started_at_ms INTEGER NOT NULL
);
