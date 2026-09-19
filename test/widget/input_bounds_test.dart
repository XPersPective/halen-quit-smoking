import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/economy/economy_screen.dart'
    show showEconomyGoalDialog;
import 'package:halen/presentation/screens/purchases/purchases_screen.dart';
import 'package:halen/presentation/widgets/model_settings_section.dart';
import 'package:halen/presentation/widgets/pack_settings_section.dart';

import '../helpers/pump_app.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = await seedOnboardedProfile();
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('pack edit dialog blocks each invalid field on its own', (
    tester,
  ) async {
    await pumpModuleWidget(
      tester,
      db: db,
      child: const PackSettingsSection(),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    FilledButton save() => tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Save'),
        );
    // Seeded values (price 100 / size 20, blank chemistry) are valid.
    expect(save().onPressed, isNotNull);

    // One bad value at a time: each rule alone must disable Save.
    const cases = [
      (1, '0'), // price: must be > 0
      (1, 'abc'), // price: not a number
      (1, '1000001'), // price: above the sanity cap
      (2, '0'), // pack size: must be 1..100
      (2, '101'),
      (3, '51'), // tar: above the sanity ceiling
      (3, '-1'),
      (4, '11'), // nicotine: above the sanity ceiling
      (4, 'xyz'),
    ];
    for (final (index, bad) in cases) {
      final field = find.byType(TextField).at(index);
      final before = tester.widget<TextField>(field).controller!.text;
      await tester.enterText(field, bad);
      await tester.pump();
      expect(
        save().onPressed,
        isNull,
        reason: 'field $index with "$bad" must disable Save',
      );
      await tester.enterText(field, before);
      await tester.pump();
      expect(save().onPressed, isNotNull, reason: 'restoration re-enables');
    }
    await disposeApp(tester);
  });

  testWidgets('pack edit dialog writes the validated values', (
    tester,
  ) async {
    await pumpModuleWidget(
      tester,
      db: db,
      child: const PackSettingsSection(),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'My Brand');
    await tester.enterText(fields.at(1), '12,50'); // comma decimal
    await tester.enterText(fields.at(2), '20');
    await tester.enterText(fields.at(3), '8');
    await tester.enterText(fields.at(4), '0.8');
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    final profile = await db.profileDao.getSmokingProfile();
    expect(profile!.pricePerPack, 12.5);
    expect(profile.packSize, 20);
    expect(profile.brandName, 'My Brand');
    expect(profile.tarMgPerCigarette, 8);
    expect(profile.nicotineMgPerCigarette, 0.8);
    await disposeApp(tester);
  });

  testWidgets('body settings: garbage never reaches the profile', (
    tester,
  ) async {
    await pumpModuleWidget(
      tester,
      db: db,
      child: const ModelSettingsSection(
        preLogPauseSeconds: 0,
        riskyWindowReminder: false,
      ),
    );
    await tester.pumpAndSettle();

    final heightLabel = AppLocalizations.of(
      tester.element(find.byType(ModelSettingsSection)),
    )!.settingsHeight;

    final field = find.widgetWithText(TextField, heightLabel);

    // Garbage: write is refused and the stored value is untouched.
    await tester.enterText(field, 'abc');
    await tester.pump();
    var profile = await db.profileDao.getSmokingProfile();
    expect(profile!.heightCm, isNull);

    // Out of range: the same.
    await tester.enterText(field, '50');
    await tester.pump();
    profile = await db.profileDao.getSmokingProfile();
    expect(profile!.heightCm, isNull);

    // Valid edge: 170 stays.
    await tester.enterText(field, '170');
    await tester.pump();
    profile = await db.profileDao.getSmokingProfile();
    expect(profile!.heightCm, 170);
    await disposeApp(tester);
  });

  testWidgets('economy goal dialog blocks bad input, returns trimmed pair', (
    tester,
  ) async {
    Future<(String, double)?>? resultFuture;
    await pumpModuleWidget(
      tester,
      db: db,
      child: Builder(
        builder: (context) => FilledButton(
          onPressed: () {
            resultFuture = showEconomyGoalDialog(
              context,
              AppLocalizations.of(context)!,
            );
          },
          child: const Text('open'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Your goal'), findsWidgets);

    final fields = find.byType(TextField);
    await tester.enterText(fields.first, '  ');
    await tester.enterText(fields.last, '-5');
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
          .onPressed,
      isNull,
    );

    await tester.enterText(fields.first, '  New bike  ');
    await tester.enterText(fields.last, '1500');
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    expect(find.text('Your goal'), findsNothing);

    final result = await resultFuture;
    expect(result, isNotNull);
    expect(result!.$1, 'New bike'); // trimmed
    expect(result.$2, 1500.0);
    await disposeApp(tester);
  });

  testWidgets('purchases sheet flags invalid input instead of writing it', (
    tester,
  ) async {
    await pumpModuleWidget(
      tester,
      db: db,
      child: const PurchasesScreen(),
      scrollable: false,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'abc');
    await tester.enterText(fields.at(1), '0');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pump();

    // Error feedback must appear and no row is written.
    expect(find.byType(SnackBar), findsOneWidget);
    expect(await db.packPurchaseDao.all(), isEmpty);

    // The same sheet stays usable: a valid retry writes and closes.
    await tester.enterText(fields.at(0), '150');
    await tester.enterText(fields.at(1), '20');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    final rows = await db.packPurchaseDao.all();
    expect(rows, hasLength(1));
    expect(rows.single.pricePerPack, 150);
    await disposeApp(tester);
  });
}
