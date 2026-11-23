import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/app_database.dart';
import '../data/android_trial_start_store.dart';
import '../data/purchase_service.dart';
import '../data/trial_start_store.dart';
import '../domain/entities.dart';
import '../domain/entitlement.dart';
import 'notification_texts.dart';
import 'providers.dart';
import 'settings_screen_controller.dart';

/// Single purchase service wired to the app database.
final purchaseServiceProvider = Provider<PurchaseService>(
  (ref) => PurchaseService(ref.watch(databaseProvider)),
);

/// Injectable so entitlement flows can be tested without Android platform or
/// network dependencies.
final androidTrialStartStoreProvider = Provider<AndroidTrialStartStore>(
  (ref) => AndroidTrialStartStore(),
);

/// Owned-state changes written by the purchase stream (a finished purchase,
/// a restore, a refund). The entitlement re-evaluates when it flips, so the
/// paywall and every gate update on their own — the owner's first real
/// purchase left "Get lifetime access" on screen until a manual refresh.
final ownedEntitlementProvider = StreamProvider<bool>((ref) {
  return ref.watch(databaseProvider).purchaseDao.watchHasOwnedEntitlement();
});

/// Initialize the local trial once per database, independently of purchase events.
final _trialStartProvider = FutureProvider<DateTime?>((ref) async {
  final db = ref.watch(databaseProvider);
  final settings = await db.settingsDao.getSettings();
  final recorded = settings.trialStartedAt;
  final now = DateTime.now();
  final startedAt = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS
      ? await TrialStartStore().keepEarliest(recorded: recorded, now: now)
      : !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? await ref
            .watch(androidTrialStartStoreProvider)
            .resolve(
              recorded: recorded,
              consented: settings.androidTrialConsent == true,
            )
      : recorded ?? now;
  if (startedAt != null &&
      (recorded == null || !recorded.isAtSameMomentAs(startedAt))) {
    await db.settingsDao.updateSettings(
      SettingsCompanion(trialStartedAt: Value(startedAt)),
    );
  }
  // Refresh opted-in reminders to replace those scheduled by older versions.
  try {
    final notifications = ref.read(notificationServiceProvider);
    if (startedAt != null &&
        settings.trialNudge &&
        settings.notifLevel != NotificationDensity.off) {
      await notifications.scheduleTrialReminder(
        trialStartedAt: startedAt,
        texts: notificationTextsFor(ref.read(resolvedLocaleProvider)),
      );
    } else {
      await notifications.cancelTrialReminder();
    }
  } catch (_) {}
  return startedAt;
});

/// Cold-start entitlement refresh: store verification runs on every launch.
final entitlementProvider = FutureProvider<PremiumAccess>((ref) async {
  final db = ref.watch(databaseProvider);
  ref.watch(ownedEntitlementProvider);
  final startedAt = await ref.watch(_trialStartProvider.future);

  // Store verification — never trust the local row alone.
  try {
    await ref.read(purchaseServiceProvider).start();
  } catch (_) {
    // Offline: fall back to the last store-verified row (report §26).
  }
  final owned = await db.purchaseDao.hasOwnedEntitlement();
  if (owned) {
    // A paying user must not get the "choose a plan" nudge.
    try {
      await ref.read(notificationServiceProvider).cancelTrialReminder();
    } catch (_) {}
  }

  final now = DateTime.now();
  final access = evaluateAccess(
    storeVerifiedOwned: owned,
    trialStartedAt: startedAt,
    now: now,
  );
  if (access.trialActive && startedAt != null) {
    final remaining = startedAt.add(trialDuration).difference(now);
    final expiryTimer = Timer(remaining, ref.invalidateSelf);
    ref.onDispose(expiryTimer.cancel);
  }
  return access;
});

/// Convenience boolean gate for UI.
final isPremiumProvider = Provider<bool>((ref) {
  return ref.watch(entitlementProvider).value?.premium ?? false;
});
