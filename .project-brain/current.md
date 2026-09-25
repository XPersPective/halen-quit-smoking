# Current Architecture

## Scope

Repo-wide Flutter mobile application. This file reflects the working tree at
the latest Project Brain checkpoint.

## Runtime

**Status:** VERIFIED

- Flutter/Dart app; entry points are `lib/main.dart` and `lib/app.dart`.
- State flow is Riverpod providers/controllers → domain models → repositories
  and Drift DAOs.
- Local persistence is Drift over SQLCipher; secure key material comes from
  `flutter_secure_storage`.
- Localizations are TR/EN/DE in `lib/l10n/`.
- Android and iOS identifiers are `com.crazypenguin.halenquitsmoking`.
- Package version is `1.3.1+4`.

## Domains

### Onboarding and profile

**Status:** VERIFIED

**Sources:** `lib/domain/onboarding.dart`, `lib/application/onboarding_controller.dart`,
`lib/data/repositories/profile_repository.dart`, `test/widget/onboarding_flow_test.dart`

Onboarding validates required price/brand and bounded optional age, TTFC,
rhythm, body and smoking-history inputs. Answers are persisted into one
`SmokingProfile`; navigation preserves answers and system Back follows the same
step flow. The current widget test covers the 10-step flow.

### Database, backup and recovery

**Status:** VERIFIED

**Sources:** `lib/data/db/app_database.dart`, `lib/data/db/tables.dart`,
`lib/data/db_opener.dart`, `lib/data/secure_key_store.dart`,
`lib/data/backup_repository.dart`, `test/data/`

`AppDatabase` is schema version 10. Migrations are additive through v10,
including widget preferences. Existing encrypted databases require their
existing key; wrong keys/corrupt files fail without replacement. Backup/import
intentionally excludes purchase and trial entitlement data; personal tables
and wipe behavior are covered by tests.

### Notifications and app shell

**Status:** VERIFIED

**Sources:** `lib/data/notification_service.dart`,
`lib/presentation/widgets/notification_permission_card.dart`, `lib/app.dart`,
`test/widget/notification_status_test.dart`, `test/widget/startup_failure_test.dart`

Permission state is read from the OS, the shared permission card is used by
splash/settings, and resume refreshes state. Trial nudges are separately
opt-in. Startup database failures render the failure screen without querying
the unavailable database.

### Premium and advertising

**Status:** VERIFIED locally; store behavior remains externally unverified

**Sources:** `lib/data/purchase_service.dart`, `lib/domain/entitlement.dart`,
`lib/domain/ad_policy.dart`, `lib/data/ads_service.dart`,
`test/data/purchase_stream_test.dart`, `test/domain/ad_policy_test.dart`

Purchase updates are serialized, pending purchases grant no entitlement, and
Android/iOS store refresh can demote stale ownership. The 7-day local trial is
not imported from JSON. Ads are policy-gated: no ads during trial/premium,
onboarding, SOS, payments or health detail; eligible free surfaces use
labelled banners and app-open frequency is capped at 24 hours.

### Product UI and content

**Status:** VERIFIED by automated coverage

**Sources:** `lib/presentation/`, `lib/domain/`, `lib/l10n/`, `test/widget/`

Today, plan, body, timeline, economy, guides, SOS, settings and paywall are
implemented with shared design tokens, responsive layouts, reduced-motion
handling, evidence/formula transparency and region-aware quitline behavior.
AdMob release identifiers, Android package cleanup and iOS privacy manifest
are present in platform configuration.

## Verification baseline

- `flutter analyze`: no issues found.
- `flutter test`: 392 tests passed.
- Test output includes expected Drift multiple-instance warnings and deliberate
  SQLCipher wrong-key diagnostics; neither is a test failure.

## Known Unknowns

- Real App Store/Play sandbox refund, expiry, restore and reinstall matrix is
  not executable without store accounts and devices.
- Device-owner migration/key-survival matrix and signed release validation are
  not fully evidenced by repository tests.
- Store-console legal declarations and listing sign-off remain external.
