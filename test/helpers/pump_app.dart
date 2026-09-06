import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/app.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/application/providers.dart';

/// Boots the real app with an in-memory database override and returns the
/// database handle so tests can assert on persisted rows.
Future<AppDatabase> pumpHalenApp(WidgetTester tester, {AppDatabase? database}) async {
  final db = database ?? AppDatabase(inMemoryExecutor());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const HalenApp(),
    ),
  );
  return db;
}
