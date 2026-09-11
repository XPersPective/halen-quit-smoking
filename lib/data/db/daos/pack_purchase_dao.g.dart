// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pack_purchase_dao.dart';

// ignore_for_file: type=lint
mixin _$PackPurchaseDaoMixin on DatabaseAccessor<AppDatabase> {
  $PackPurchaseTableTable get packPurchaseTable =>
      attachedDatabase.packPurchaseTable;
  PackPurchaseDaoManager get managers => PackPurchaseDaoManager(this);
}

class PackPurchaseDaoManager {
  final _$PackPurchaseDaoMixin _db;
  PackPurchaseDaoManager(this._db);
  $$PackPurchaseTableTableTableManager get packPurchaseTable =>
      $$PackPurchaseTableTableTableManager(
        _db.attachedDatabase,
        _db.packPurchaseTable,
      );
}
