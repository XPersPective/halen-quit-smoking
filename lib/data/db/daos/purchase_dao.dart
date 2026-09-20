import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';
part 'purchase_dao.g.dart';

/// Entitlement rows are replaced wholesale on every store verification
/// (report §25: refreshed from the store on every launch; never trusted from
/// a local flag alone).
@DriftAccessor(tables: [PurchaseEntitlement])
class PurchaseDao extends DatabaseAccessor<AppDatabase> {
  PurchaseDao(super.db);

  Future<void> replaceEntitlements(List<PurchaseEntitlementCompanion> rows) {
    return transaction(() async {
      await delete(attachedDatabase.purchaseEntitlement).go();
      if (rows.isNotEmpty) {
        await batch((b) => b.insertAll(attachedDatabase.purchaseEntitlement, rows));
      }
    });
  }

  /// True when at least one store-verified row is in the owned state.
  Stream<bool> watchHasOwnedEntitlement() {
    final query = selectOnly(attachedDatabase.purchaseEntitlement)
      ..addColumns([attachedDatabase.purchaseEntitlement.id])
      ..where(attachedDatabase.purchaseEntitlement.state.equals('owned'))
      ..limit(1);
    return query.watchSingleOrNull().map((row) => row != null);
  }

  Future<bool> hasOwnedEntitlement() async {
    final query = selectOnly(attachedDatabase.purchaseEntitlement)
      ..addColumns([attachedDatabase.purchaseEntitlement.id])
      ..where(attachedDatabase.purchaseEntitlement.state.equals('owned'))
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row != null;
  }

  /// Removes cached rows before a successful full ownership refresh.
  /// A failed store query must not call this: the last verified state is the
  /// only safe offline grace period the app has.
  Future<void> clear() => delete(attachedDatabase.purchaseEntitlement).go();

  /// Most recent entitlement row (any state) for refresh decisions.
  Future<PurchaseEntitlementRow?> latest() {
    return (select(attachedDatabase.purchaseEntitlement)
          ..orderBy([(e) => OrderingTerm.desc(e.lastVerifiedAt)]))
        .getSingleOrNull();
  }

  Future<void> upsertEntitlement(PurchaseEntitlementCompanion row) {
    if (!row.store.present || !row.productId.present) {
      throw ArgumentError('Store and productId are required for an entitlement');
    }
    return transaction(() async {
      final table = attachedDatabase.purchaseEntitlement;
      await (delete(table)
            ..where(
              (item) =>
                  item.store.equals(row.store.value) &
                  item.productId.equals(row.productId.value),
            ))
          .go();
      await into(table).insert(row);
    });
  }

}
