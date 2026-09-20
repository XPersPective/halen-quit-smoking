import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/widget_service.dart';
import 'package:drift/drift.dart' show Value;
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/widgets/premium_badge.dart';
import 'package:halen/presentation/widgets/widget_settings_section.dart';

import 'package:halen/application/providers.dart';
import 'package:halen/core/theme.dart';

import '../helpers/pump_app.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = await seedOnboardedProfile();
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('free badge (trial expired) leads to the paywall', (
    tester,
  ) async {
    final expired = DateTime.now().subtract(const Duration(days: 30));
    await db.settingsDao.updateSettings(
      SettingsCompanion(trialStartedAt: Value(expired)),
    );
    String? route;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: HalenTheme.light(),
          onGenerateRoute: (settings) {
            route = settings.name;
            return MaterialPageRoute<void>(
              builder: (_) => const Scaffold(body: PremiumBadge()),
              settings: settings,
            );
          },
          home: const Scaffold(body: PremiumBadge()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(PremiumBadge)),
    )!;
    expect(find.text(l10n.premiumBadgeFree), findsOneWidget);
    await tester.tap(find.byType(PremiumBadge));
    await tester.pump();
    expect(route, Routes.paywall);
    await disposeApp(tester);
  });

  testWidgets('trial badge shows the remaining days', (tester) async {
    final trialStart = DateTime.now().subtract(const Duration(days: 1));
    await db.settingsDao.updateSettings(
      SettingsCompanion(trialStartedAt: Value(trialStart)),
    );
    await pumpModuleWidget(
      tester,
      db: db,
      child: const PremiumBadge(),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('6'),
      findsOneWidget,
      reason: 'trial day count visible in the badge',
    );
    await disposeApp(tester);
  });

  test('widget summary honours the privacy toggle', () {
    final now = DateTime(2026, 9, 18, 12, 0);
    final earlier = now.subtract(const Duration(hours: 1, minutes: 12));
    expect(
      WidgetService.formatSummary(
        count: 4,
        target: 8,
        last: earlier,
        now: now,
        showLast: true,
      ),
      '4/8 · 1h 12m',
    );
    expect(
      WidgetService.formatSummary(
        count: 4,
        target: 8,
        last: earlier,
        now: now,
        showLast: false,
      ),
      '4/8',
    );
    expect(
      WidgetService.formatSummary(
        count: 0,
        target: 8,
        last: null,
        now: now,
        showLast: true,
      ),
      '0/8',
    );
  });

  testWidgets('widget settings write through to the database', (
    tester,
  ) async {
    await pumpModuleWidget(
      tester,
      db: db,
      child: const WidgetSettingsSection(),
    );
    await tester.pumpAndSettle();

    // Default is "show last cigarette" — toggle it off.
    final sw = find.byType(SwitchListTile);
    await tester.tap(sw);
    await tester.pumpAndSettle();
    expect(
      (await db.settingsDao.getSettings()).widgetShowLastCigarette,
      isFalse,
    );

    // Theme choice: pick "Dark".
    final l10n = AppLocalizations.of(
      tester.element(find.byType(WidgetSettingsSection)),
    )!;
    await tester.tap(find.text(l10n.themeDark));
    await tester.pumpAndSettle();
    expect((await db.settingsDao.getSettings()).widgetTheme, 'dark');
    await disposeApp(tester);
  });
}
