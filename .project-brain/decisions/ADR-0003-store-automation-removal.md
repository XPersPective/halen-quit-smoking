# ADR-0003 — Store otomasyonunu depodan kaldır

**Date:** 2026-10-18 · **Status:** Accepted · **Scope:** repository publishing/listing tooling

The user asked to move Store automation state into Project Brain, delete its old data,
and remove it fully from the project. No `.store-automation/` tracker existed. This
decision records the useful state from PB-052 before retiring its generated listing
pipeline and the stale PB-055 release task.

## Preserved progress

- The former generator prepared metadata for 73 Google Play locales and 46 App Store
  locales; the first-draft translations had not received native-speaker review.
- The Turkish Play title was changed to `Halen: Sigara Bırakma Takibi`; the last
  generator run reported no metadata length-limit errors. This generated content is
  retired and must not be treated as current listing copy.
- Play feature graphics were generated per locale at 1024x500. Metadata and graphics
  were generated under `D:\AppPublishing\apps\halen-quit-smoking\stores`.
- Console submission and sign-off were owner-only and had not been performed by the
  automation. PB-052 also recorded that non-TR/EN/DE screenshots inherited the default
  app language and that screenshots needed refresh after the Today screen change.
- The external per-app `stores` output contained 830 files (11,820,711 bytes) across
  1,106 files and directories; it was deleted at the user's request. The enclosing
  `D:\AppPublishing\apps\halen-quit-smoking` directory was retained.
- Version 1.4.0+5 was already uploaded to Play tracks on 2026-10-02; its review outcome
  was still pending in the last verified Current checkpoint.

## Decision

Remove repository Store listing generators, their data and bundled artwork, Store-only
screenshot/icon export paths, Fastlane publishing lanes and dependency, and stale
references. Keep the app's Store purchase/billing implementation and ordinary visual
capture/launcher icon generation. Future distribution work is manual and owner-controlled;
this repository no longer contains publishing automation or generated listing data.
