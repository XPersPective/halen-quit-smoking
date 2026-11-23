# Halen Android trial API

The Worker stores one SHA-256 app-scoped Android SSAID hash and the first
server timestamp in D1. Claims are retained until a user requests deletion.
The API prevents an ordinary reinstall from restarting the 24-hour trial; it
does not attest the device and cannot stop a rooted device or spoofed Android
ID from creating a different claim.

## Privacy request handling

1. The user opens **Settings → Request deletion of the Android trial record**.
   The app opens an email draft with the hash support code; the user reviews and
   sends it themselves.
2. Verify that the request is for the Halen Android trial record. Do not ask for
   the raw Android ID or any health/smoking data.
3. In the authenticated Cloudflare account, validate that the support code is
   exactly 64 lowercase hexadecimal characters, then delete that single row:

   ```sql
   DELETE FROM trial_claims WHERE device_hash = '<64-character support code>';
   ```

4. Confirm that one row was deleted, then tell the user the request is done.
   Do not retain the support code in support notes. A later, separately
   consented trial claim may be created after deletion; this is the consequence
   of honoring erasure rather than retaining an identifier to enforce a block.

## Release gate

Before production, update and verify Google Play Data safety for the
pseudonymous Android ID/hash (`Device or other IDs`, `App functionality`,
optional collection, TLS; Cloudflare is used as a service provider). Do not
describe this implementation as protection against identity spoofing.
