import 'package:drift/drift.dart';

import '../../../domain/pack_purchases.dart';
import '../app_database.dart';
import '../tables.dart';

part 'pack_purchase_dao.g.dart';

/// Recorded pack purchases (device feedback, item 3).
///
/// Named for what it stores, not "PurchaseDao": that name is already the
/// in-app-purchase entitlement store, and two unrelated things sharing one
/// word is how the HalenCard collision happened.
@DriftAccessor(tables: [PackPurchaseTable])
class PackPurchaseDao extends DatabaseAccessor<AppDatabase>
    with _$PackPurchaseDaoMixin {
  PackPurchaseDao(super.db);

  Future<int> add({
    required DateTime at,
    required int packs,
    required double pricePerPack,
    required int packSize,
    String? brand,
  }) =>
      into(packPurchaseTable).insert(
        PackPurchaseTableCompanion.insert(
          ts: at,
          packs: Value(packs),
          pricePerPack: pricePerPack,
          packSize: Value(packSize),
          brand: Value(brand?.trim().isEmpty ?? true ? null : brand!.trim()),
        ),
      );

  Future<void> remove(int id) =>
      (delete(packPurchaseTable)..where((t) => t.id.equals(id))).go();

  Stream<List<PackPurchaseRow>> watchAll() => (select(packPurchaseTable)
        ..orderBy([(t) => OrderingTerm.desc(t.ts)]))
      .watch();

  Future<List<PackPurchaseRow>> all() => (select(packPurchaseTable)
        ..orderBy([(t) => OrderingTerm.desc(t.ts)]))
      .get();
}

extension PackPurchaseRowDomain on PackPurchaseRow {
  PackPurchase toDomain() => PackPurchase(
        at: ts,
        packs: packs,
        pricePerPack: pricePerPack,
        packSize: packSize,
        brand: brand,
      );
}
