import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/app_database.dart';
import '../data/db/daos/pack_purchase_dao.dart';
import '../domain/pack_purchases.dart';
import '../domain/tar_intake.dart';
import 'module_providers.dart';
import 'providers.dart';

/// Pack purchases and pack label values (device feedback, items 2, 3, 4).
final packPurchaseRowsProvider = StreamProvider<List<PackPurchaseRow>>((ref) {
  return ref.watch(databaseProvider).packPurchaseDao.watchAll();
});

final purchaseSummaryProvider = Provider<AsyncValue<PurchaseSummary>>((ref) {
  return ref.watch(packPurchaseRowsProvider).whenData(
        (rows) => PurchaseSummary.of(
          [for (final row in rows) row.toDomain()],
          DateTime.now(),
        ),
      );
});

/// The user's own pack label values, or the legal maximum where absent.
final tarIntakeProvider = Provider<TarIntake>((ref) {
  final profile = ref.watch(smokingProfileProvider).value;
  return TarIntake(
    tarMgPerCigarette: profile?.tarMgPerCigarette,
    nicotineMgPerCigarette: profile?.nicotineMgPerCigarette,
  );
});

/// Tar taken in per week for the last eight weeks, oldest first.
final weeklyTarProvider = Provider<List<double>>((ref) {
  final events = ref.watch(eventTimestampsProvider).value ?? const [];
  return weeklyTarGrams(
    events: events,
    now: DateTime.now(),
    intake: ref.watch(tarIntakeProvider),
  );
});

class PackController {
  const PackController(this._ref);

  final Ref _ref;

  /// Records a purchase and makes it the current pack.
  ///
  /// The latest purchase is the best evidence of what somebody smokes now,
  /// so its price, size and brand become the profile's. That is the whole
  /// fix for the frozen-onboarding-price problem: nobody has to remember to
  /// go and edit a setting.
  Future<void> addPurchase({
    required DateTime at,
    required int packs,
    required double pricePerPack,
    required int packSize,
    String? brand,
  }) async {
    final db = _ref.read(databaseProvider);
    await db.packPurchaseDao.add(
      at: at,
      packs: packs,
      pricePerPack: pricePerPack,
      packSize: packSize,
      brand: brand,
    );
    final latest = (await db.packPurchaseDao.all()).first;
    if (latest.ts == at) {
      await db.profileDao.saveSmokingProfile(
        SmokingProfileCompanion(
          pricePerPack: Value(pricePerPack),
          packSize: Value(packSize),
          brandName: Value(brand?.trim().isEmpty ?? true ? null : brand!.trim()),
        ),
      );
    }
  }

  Future<void> removePurchase(int id) =>
      _ref.read(databaseProvider).packPurchaseDao.remove(id);

  /// Edits the current pack directly (item 2). Every field is optional in
  /// the sense that null leaves it unchanged — except the two label values,
  /// where clearing them is meaningful: it falls back to the legal maximum.
  Future<void> updatePack({
    required double pricePerPack,
    required int packSize,
    String? brand,
    double? tarMgPerCigarette,
    double? nicotineMgPerCigarette,
  }) =>
      _ref.read(databaseProvider).profileDao.saveSmokingProfile(
            SmokingProfileCompanion(
              pricePerPack: Value(pricePerPack),
              packSize: Value(packSize),
              brandName:
                  Value(brand?.trim().isEmpty ?? true ? null : brand!.trim()),
              tarMgPerCigarette: Value(tarMgPerCigarette),
              nicotineMgPerCigarette: Value(nicotineMgPerCigarette),
            ),
          );
}

final packControllerProvider = Provider<PackController>(PackController.new);
