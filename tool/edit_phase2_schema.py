# -*- coding: utf-8 -*-
"""Schema v6: pack purchases and the pack label values (items 2, 3, 4)."""
import io
import sys


def load(p):
    return io.open(p, encoding='utf-8').read()


def save(p, s):
    io.open(p, 'w', encoding='utf-8').write(s)


def replace(s, old, new, path):
    if old not in s:
        sys.exit('ANCHOR MISSING in %s: %s' % (path, old[:100]))
    return s.replace(old, new, 1)


TABLES = 'lib/data/db/tables.dart'
s = load(TABLES)
s = replace(s, '''  TextColumn get metabolism => textEnum<MetabolismSpeed>()
      .withDefault(const Constant('normal'))();
}''', '''  TextColumn get metabolism => textEnum<MetabolismSpeed>()
      .withDefault(const Constant('normal'))();

  // The pack label's machine yields per cigarette (item 4). Optional: when
  // absent, the legal maximum is used and the screen says so.
  RealColumn get tarMgPerCigarette => real().nullable()();
  RealColumn get nicotineMgPerCigarette => real().nullable()();
}''', TABLES)
s += '''

/// A pack purchase, as it happened (items 2 and 3). Price and brand are per
/// purchase, not per profile, because people do not buy one pack at one price
/// forever.
@DataClassName('PackPurchaseRow')
class PackPurchaseTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get ts => dateTime()();
  IntColumn get packs => integer().withDefault(const Constant(1))();
  RealColumn get pricePerPack => real()();
  IntColumn get packSize => integer().withDefault(const Constant(20))();
  TextColumn get brand => text().nullable()();
}
'''
save(TABLES, s)

DB = 'lib/data/db/app_database.dart'
s = load(DB)
s = replace(s, '  int get schemaVersion => 5;', '  int get schemaVersion => 6;', DB)
s = replace(s, '''            await m.createTable(moodScreen);
          }''', '''            await m.createTable(moodScreen);
          }
          if (from < 6) {
            // v6 — purchase history and the pack label values. Additive.
            await m.addColumn(smokingProfile, smokingProfile.tarMgPerCigarette);
            await m.addColumn(
              smokingProfile,
              smokingProfile.nicotineMgPerCigarette,
            );
            await m.createTable(packPurchaseTable);
          }''', DB)
s = replace(s, '''    MoodScreen,
  ],''', '''    MoodScreen,
    PackPurchaseTable,
  ],''', DB)
s = replace(s, '''    CessationDao,''', '''    CessationDao,
    PackPurchaseDao,''', DB)
s = replace(s, "import 'daos/module_dao.dart';",
            "import 'daos/module_dao.dart';\nimport 'daos/pack_purchase_dao.dart';", DB)
save(DB, s)
print('schema v6 ok')
