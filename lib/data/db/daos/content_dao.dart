import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';
part 'content_dao.g.dart';

@DriftAccessor(tables: [MotivationContent])
class ContentDao extends DatabaseAccessor<AppDatabase> {
  ContentDao(super.db);

  Future<void> upsertAll(List<MotivationContentCompanion> rows) =>
      batch((b) {
        b.insertAllOnConflictUpdate(attachedDatabase.motivationContent, rows);
      });

  Stream<List<MotivationContentRow>> watchByLanguage(String lang) {
    return (select(attachedDatabase.motivationContent)
          ..where((c) => c.lang.equals(lang))
          ..orderBy([(c) => OrderingTerm.asc(c.id)]))
        .watch();
  }

  Future<List<MotivationContentRow>> getByLanguageAndCategory(
    String lang,
    String category,
  ) {
    return (select(attachedDatabase.motivationContent)
          ..where((c) => c.lang.equals(lang))
          ..where((c) => c.category.equals(category)))
        .get();
  }
}
