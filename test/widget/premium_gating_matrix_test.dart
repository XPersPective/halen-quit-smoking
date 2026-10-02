import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/application/entitlement_providers.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/domain/entitlement.dart';
import 'package:halen/presentation/screens/sos/ear_acupressure_screen.dart';
import 'package:halen/presentation/screens/sos/nutrition_guide_screen.dart';
import 'package:halen/presentation/screens/timeline/health_timeline_screen.dart';
import 'package:halen/presentation/widgets/premium_gate.dart';
import 'package:halen/presentation/widgets/widget_settings_section.dart';

import '../helpers/pump_app.dart';

/// Every Premium promise on the paywall must have a lock behind it, and the
/// lock must open for a trial user and an owner. Owner audit 2026-10-02: only
/// the Plan screen was gated while the paywall promised five more things.
void main() {
  const free = PremiumAccess(
    storeOwned: false,
    trialActive: false,
    trialDaysLeft: 0,
  );
  const owner = PremiumAccess(
    storeOwned: true,
    trialActive: false,
    trialDaysLeft: 0,
  );
  const trial = PremiumAccess(
    storeOwned: false,
    trialActive: true,
    trialDaysLeft: 5,
  );

  Future<AppDatabase> pumpWith(
    WidgetTester tester,
    Widget screen,
    PremiumAccess access,
  ) async {
    tester.view.physicalSize = const Size(900, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final db = await seedOnboardedProfile();
    await pumpModuleWidget(
      tester,
      db: db,
      child: screen,
      scrollable: false,
      extraOverrides: [
        entitlementProvider.overrideWith((ref) async => access),
      ],
    );
    await tester.pumpAndSettle();
    return db;
  }

  Future<void> finish(WidgetTester tester, AppDatabase db) async {
    await disposeApp(tester);
    await db.close();
  }

  final screens = <String, Widget>{
    'ear acupressure': const EarAcupressureScreen(),
    'nutrition guide': const NutritionGuideScreen(),
    'full health timeline': const HealthTimelineScreen(),
    'widget customisation': const Scaffold(body: WidgetSettingsSection()),
  };

  for (final entry in screens.entries) {
    testWidgets('${entry.key}: free user meets the lock', (tester) async {
      final db = await pumpWith(tester, entry.value, free);
      expect(find.byIcon(Icons.lock_outline_rounded), findsWidgets);
      await finish(tester, db);
    });

    testWidgets('${entry.key}: owner is never locked', (tester) async {
      final db = await pumpWith(tester, entry.value, owner);
      expect(find.byIcon(Icons.lock_outline_rounded), findsNothing);
      await finish(tester, db);
    });

    testWidgets('${entry.key}: trial user is never locked', (tester) async {
      final db = await pumpWith(tester, entry.value, trial);
      expect(find.byIcon(Icons.lock_outline_rounded), findsNothing);
      await finish(tester, db);
    });
  }

  test('every promised feature is enumerated', () {
    expect(PremiumFeature.values, hasLength(7));
  });
}
