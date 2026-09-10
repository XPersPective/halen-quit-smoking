import 'package:drift/drift.dart' show Value;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:halen/application/entitlement_providers.dart';
import 'package:halen/data/purchase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/core/dates.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/presentation/screens/body/body_screen.dart';
import 'package:halen/presentation/screens/economy/economy_screen.dart';
import 'package:halen/presentation/screens/plan/plan_switch_screen.dart';
import 'package:halen/presentation/screens/sos/ear_acupressure_screen.dart';
import 'package:halen/presentation/screens/transparency/glossary_screen.dart';
import 'package:halen/presentation/screens/cessation/medicines_screen.dart';
import 'package:halen/presentation/screens/cessation/quit_plan_screen.dart';
import 'package:halen/presentation/screens/articles/articles_screen.dart';
import 'package:halen/presentation/screens/onboarding/onboarding_result_screen.dart';
import 'package:halen/presentation/screens/paywall/paywall_screen.dart';
import 'package:halen/presentation/screens/plan/plan_screen.dart';
import 'package:halen/presentation/screens/settings/settings_screen.dart';
import 'package:halen/presentation/screens/sos/sos_screen.dart';
import 'package:halen/presentation/screens/stats/stats_screen.dart';
import 'package:halen/presentation/screens/timeline/health_timeline_screen.dart';
import 'package:halen/presentation/screens/today/today_screen.dart';
import 'package:halen/presentation/screens/status/status_flow_screen.dart';
import 'package:halen/presentation/widgets/indices_card.dart';
import 'package:halen/presentation/widgets/today/now_in_body_strip.dart';

import '../helpers/design_font.dart';
import '../helpers/pump_app.dart';

/// Headless visual capture of the module screens (`screenshots/module/`).
///
/// The main tour lives in `tour_capture_test.dart` and boots the whole app;
/// this one renders single screens and cards straight, which is how the
/// pieces that are not reachable as a route get into the tour at all.
///
/// Same opt-in as the tour:
///   flutter test test/widget/design_capture_test.dart --update-goldens
///   --dart-define=CAPTURE_DESIGN=true --dart-define=DESIGN_FONT=...
/// A purchase service whose store is simply unavailable, which is also what
/// a real device does offline.
class _OfflineStore extends PurchaseService {
  _OfflineStore(super.db);

  @override
  Future<void> start() async {}

  @override
  Future<List<ProductDetails>> productDetails() async => const [];

  @override
  Future<bool> buy() async => false;

  @override
  Future<void> restore() async {}
}

void main() {
  setUpAll(loadDesignFonts);

  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(inMemoryExecutor());
    await db.profileDao.saveUserProfile(locale: 'tr', ageBand: AgeBand.y35to44);
    await db.profileDao.saveSmokingProfile(
      SmokingProfileCompanion.insert(
        baselineCpd: 20,
        ttfcBand: TtfcBand.five30,
        pricePerPack: 100,
        targetMode: TargetMode.reduce,
        pace: Pace.standard,
        startedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    );

    final now = DateTime.now();
    for (var d = 29; d >= 0; d--) {
      final day = now.subtract(Duration(days: d));
      final count = (18 - (29 - d) ~/ 3).clamp(4, 20);
      await db.statsDao.upsertSummary(
        DailySummaryCompanion.insert(
          date: dayKey(day),
          count: count,
          planTarget: Value(count + 1),
          adherence: const Value(0.8),
          savings: Value(8.0 + d),
        ),
      );
      await db.moduleDao.putIndexSnapshot(
        date: dayKey(day),
        progressScore: (35 + (29 - d)).clamp(0, 100),
        harmLoad: (78 - (29 - d) ~/ 2).clamp(0, 100),
      );
    }
    for (var i = 0; i < 9; i++) {
      await db.recordDao.insertEvent(
        CigaretteEventCompanion.insert(
          ts: now.subtract(Duration(hours: 2 * i + 1)),
          source: RecordSource.app,
          triggerLabel: Value(i.isEven ? TriggerLabel.coffee : null),
        ),
      );
    }
  });

  Future<void> shot(
    WidgetTester tester,
    String name,
    Widget screen, {
    Brightness brightness = Brightness.light,
  }) async {
    tester.view.physicalSize = const Size(420, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpModuleWidget(
      tester,
      db: db,
      child: screen,
      scrollable: screen is IndicesCard,
      brightness: brightness,
      // Any screen that reads the entitlement reaches for the store, and a
      // billing client cannot exist in a test binding. Without this the plan
      // and paywall captures fail on a platform channel rather than on
      // anything about how they look.
      extraOverrides: [
        purchaseServiceProvider.overrideWithValue(_OfflineStore(db)),
      ],
    );
    // Fixed frames rather than settle: several of these screens breathe or
    // animate on purpose and would never come to rest.
    await tester.pump();
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 80));
    }
    expect(tester.takeException(), isNull, reason: name);

    if (captureDesign) {
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          name.startsWith(RegExp(r'0[1-8]-'))
              // The core tour lives at the root; the module screens keep
              // their own folder.
              ? '../../screenshots/$name.png'
              : '../../screenshots/module/$name.png',
        ),
      );
    }
    await disposeApp(tester);
  }

  testWidgets('indices', (t) => shot(t, '20-indeksler', const IndicesCard()));
  testWidgets('body', (t) => shot(t, '21-beden', const BodyScreen()));
  testWidgets('organ map', (t) async {
    await shot(t, '26-organ-haritasi', const BodyScreen(initialTab: 1));
  });

  testWidgets('organ detail', (tester) async {
    tester.view.physicalSize = const Size(420, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpModuleWidget(
      tester,
      db: db,
      child: const BodyScreen(initialTab: 1),
      scrollable: false,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.bySemanticsLabel('Lungs').first);
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 80));
    }
    expect(tester.takeException(), isNull);
    if (captureDesign) {
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('../../screenshots/module/27-organ-detay.png'),
      );
    }
    await disposeApp(tester);
  });
  testWidgets('economy', (t) => shot(t, '22-ekonomi', const EconomyScreen()));
  testWidgets(
    'plan switch',
    (t) => shot(t, '23-plan-degistir', const PlanSwitchScreen()),
  );
  testWidgets(
    'ear acupressure',
    (t) => shot(t, '24-kulak-akupresuru', const EarAcupressureScreen()),
  );
  testWidgets('glossary', (t) => shot(t, '25-sozluk', const GlossaryScreen()));
  // The core screens. Captured one at a time from the widget tree rather
  // than by driving the whole app: booting the shell needs pumpAndSettle,
  // and several of these breathe forever by design.
  testWidgets('today', (t) => shot(t, '01-bugun', const TodayScreen()));
  testWidgets('stats', (t) => shot(t, '02-grafikler', const StatsScreen()));
  testWidgets('plan', (t) => shot(t, '03-plan', const PlanScreen()));
  testWidgets('articles', (t) => shot(t, '04-rehber', const ArticlesScreen()));
  testWidgets('sos', (t) => shot(t, '05-kriz-sos', const SosScreen()));
  testWidgets(
    'settings',
    (t) => shot(t, '06-ayarlar', const SettingsScreen()),
  );
  testWidgets(
    'timeline',
    (t) => shot(t, '07-saglik-zaman-cizelgesi', const HealthTimelineScreen()),
  );
  testWidgets('paywall', (t) => shot(t, '08-paywall', const PaywallScreen()));

  testWidgets(
    'onboarding result',
    (t) => shot(t, '32-onboarding-sonuc', const OnboardingResultScreen()),
  );
  testWidgets(
    'quit plan',
    (t) => shot(t, '33-birakma-plani', const QuitPlanScreen()),
  );
  testWidgets(
    'medicines',
    (t) => shot(t, '34-ilaclar', const MedicinesScreen()),
  );
  testWidgets(
    'status flow',
    (t) => shot(t, '35-durum-akisi', const StatusFlowScreen()),
  );
  testWidgets(
    'now in body',
    (t) => shot(t, '28-su-an-vucudunda', const NowInBodyStrip()),
  );

  // Dark mode was supported in code and had never been looked at (premium
  // brief §B.5). These captures are how it gets verified rather than assumed.
  testWidgets(
    'now in body, dark',
    (t) => shot(
      t,
      '29-su-an-vucudunda-koyu',
      const NowInBodyStrip(),
      brightness: Brightness.dark,
    ),
  );
  testWidgets(
    'body map, dark',
    (t) => shot(
      t,
      '30-organ-haritasi-koyu',
      const BodyScreen(initialTab: 1),
      brightness: Brightness.dark,
    ),
  );
  testWidgets(
    'quit plan, dark',
    (t) => shot(
      t,
      '36-birakma-plani-koyu',
      const QuitPlanScreen(),
      brightness: Brightness.dark,
    ),
  );
  testWidgets(
    'medicines, dark',
    (t) => shot(
      t,
      '37-ilaclar-koyu',
      const MedicinesScreen(),
      brightness: Brightness.dark,
    ),
  );
  testWidgets(
    'status flow, dark',
    (t) => shot(
      t,
      '38-durum-akisi-koyu',
      const StatusFlowScreen(),
      brightness: Brightness.dark,
    ),
  );
  testWidgets(
    'onboarding result, dark',
    (t) => shot(
      t,
      '39-onboarding-sonuc-koyu',
      const OnboardingResultScreen(),
      brightness: Brightness.dark,
    ),
  );
  testWidgets(
    'indices, dark',
    (t) => shot(
      t,
      '31-indeksler-koyu',
      const IndicesCard(),
      brightness: Brightness.dark,
    ),
  );
}
