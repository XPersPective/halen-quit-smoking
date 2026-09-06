// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_dao.dart';

// ignore_for_file: type=lint
mixin _$PurchaseDaoMixin on DatabaseAccessor<AppDatabase> {
  $PurchaseEntitlementTable get purchaseEntitlement =>
      attachedDatabase.purchaseEntitlement;
  PurchaseDaoManager get managers => PurchaseDaoManager(this);
}

class PurchaseDaoManager {
  final _$PurchaseDaoMixin _db;
  PurchaseDaoManager(this._db);
  $$PurchaseEntitlementTableTableManager get purchaseEntitlement =>
      $$PurchaseEntitlementTableTableManager(
        _db.attachedDatabase,
        _db.purchaseEntitlement,
      );
}
