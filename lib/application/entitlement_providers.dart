import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/app_database.dart';
import '../data/purchase_service.dart';
import '../domain/entitlement.dart';
import 'providers.dart';

/// Single purchase service wired to the app database.
final purchaseServiceProvider =
    Provider<PurchaseService>((ref) => PurchaseService(ref.watch(databaseProvider)));

/// Cold-start entitlement refresh: store verification runs on every launch
/// (report §29). Also ensures the 7-day trial clock started on first launch.
final entitlementProvider = FutureProvider<PremiumAccess>((ref) async {
  final db = ref.watch(databaseProvider);

  // First launch: start the no-card 7-day premium trial (report §28).
  final settings = await db.settingsDao.getSettings();
  if (settings.trialStartedAt == null) {
    await db.settingsDao.updateSettings(
      SettingsCompanion(trialStartedAt: Value(DateTime.now())),
    );
  }
  final fresh = await db.settingsDao.getSettings();

  // Store verification — never trust the local row alone.
  try {
    await ref.read(purchaseServiceProvider).start();
  } catch (_) {
    // Offline: fall back to the last store-verified row (report §26).
  }
  final owned = await db.purchaseDao.hasOwnedEntitlement();

  return evaluateAccess(
    storeVerifiedOwned: owned,
    trialStartedAt: fresh.trialStartedAt,
    now: DateTime.now(),
  );
});

/// Convenience boolean gate for UI.
final isPremiumProvider = Provider<bool>((ref) {
  return ref.watch(entitlementProvider).value?.premium ?? false;
});
