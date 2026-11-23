import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/core/dates.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/presentation/screens/plan/plan_screen.dart';
import 'package:halen/presentation/screens/stats/stats_screen.dart';
import 'package:halen/presentation/screens/today/today_screen.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/pump_app.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('Capture Halen tabs with demo data', (tester) async {
    final db = AppDatabase(inMemoryExecutor());
    addTearDown(() async {
      await disposeApp(tester);
      await db.close();
    });
    final now = DateTime.now();
    await db.profileDao.saveUserProfile(locale: 'en', ageBand: AgeBand.y35to44);
    await db.profileDao.saveSmokingProfile(
      SmokingProfileCompanion.insert(
        baselineCpd: 20,
        ttfcBand: TtfcBand.five30,
        pricePerPack: 12,
        targetMode: TargetMode.reduce,
        pace: Pace.standard,
        startedAt: now.subtract(const Duration(days: 21)),
      ),
    );
    for (var day = 0; day <= 21; day++) {
      final date = dayKey(now.subtract(Duration(days: day)));
      final count = 11 + day ~/ 3;
      await db.statsDao.upsertSummary(
        DailySummaryCompanion.insert(
          date: date,
          count: count,
          planTarget: Value(count + 1),
          adherence: const Value(0.8),
          savings: Value((20 - count) * 0.6),
        ),
      );
    }
    for (var index = 0; index < 5; index++) {
      await db.recordDao.insertEvent(
        CigaretteEventCompanion.insert(
          ts: now.subtract(Duration(minutes: 20 + 40 * index)),
          source: RecordSource.app,
        ),
      );
    }

    Future<void> capture(String name, Type screen) async {
      final visible = find.byType(screen);
      for (
        var attempt = 0;
        attempt < 30 && visible.evaluate().isEmpty;
        attempt++
      ) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(visible, findsOneWidget);
      for (var frame = 0; frame < 6; frame++) {
        await tester.pump(const Duration(milliseconds: 150));
      }
      expect(tester.takeException(), isNull);
      await binding.takeScreenshot(name);
    }

    Finder destination(String label) => find.byWidgetPredicate(
      (widget) => widget is NavigationDestination && widget.label == label,
    );

    await pumpHalenApp(tester, database: db);
    await capture('01-today', TodayScreen);
    await tester.tap(destination('Analytics'));
    await capture('02-analytics', StatsScreen);
    await tester.tap(destination('Plan'));
    await capture('03-plan', PlanScreen);
  });
}
