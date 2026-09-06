import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';
part 'settings_dao.g.dart';

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase> {
  SettingsDao(super.db);

  Future<SettingsRow> getSettings() async {
    final row = await select(attachedDatabase.settings).getSingleOrNull();
    if (row != null) return row;
    await into(attachedDatabase.settings)
        .insert(SettingsCompanion.insert(), mode: InsertMode.insertOrIgnore);
    return select(attachedDatabase.settings).getSingle();
  }

  Stream<SettingsRow> watchSettings() => select(attachedDatabase.settings).watchSingle();

  Future<void> updateSettings(SettingsCompanion companion) =>
      (update(attachedDatabase.settings)..where((s) => s.id.equals(1))).write(companion);
}
