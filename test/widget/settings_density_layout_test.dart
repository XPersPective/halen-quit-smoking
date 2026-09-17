import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/application/settings_screen_controller.dart';
import 'package:halen/data/notification_service.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/settings/settings_screen.dart';

import '../helpers/pump_app.dart';

class _Notifications extends NotificationService {
  NotificationDensity? applied;
  @override
  Future<void> applyDensity(
    NotificationDensity density, {
    required NotificationTexts texts,
  }) async {
    applied = density;
  }
}

void main() {
  for (final language in ['tr', 'en', 'de']) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('density labels fit 320dp $language scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(320, 1000);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final db = await seedOnboardedProfile();
        addTearDown(db.close);
        final notifications = _Notifications();
        await pumpModuleWidget(
          tester,
          db: db,
          locale: Locale(language),
          scrollable: false,
          child: const SettingsScreen(),
          extraOverrides: [
            notificationServiceProvider.overrideWithValue(notifications),
          ],
        );
        await tester.pumpAndSettle();
        final l10n = AppLocalizations.of(
          tester.element(find.byType(SettingsScreen)),
        )!;
        for (final label in [
          l10n.notifDensityCalm,
          l10n.notifDensityStandard,
          l10n.notifDensityIntense,
          l10n.notifDensityOff,
        ]) {
          final text = find.descendant(
            of: find.byType(ChoiceChip),
            matching: find.text(label),
          );
          expect(text, findsOneWidget);
          final paragraph = tester.renderObject<RenderParagraph>(text);
          expect(
            paragraph.getBoxesForSelection(
              TextSelection(baseOffset: 0, extentOffset: label.length),
            ),
            hasLength(1),
          );
        }
        await tester.tap(find.widgetWithText(ChoiceChip, l10n.notifDensityOff));
        await tester.pumpAndSettle();
        expect(
          (await db.settingsDao.getSettings()).notifLevel,
          NotificationDensity.off,
        );
        expect(notifications.applied, NotificationDensity.off);
        expect(tester.takeException(), isNull);
        await disposeApp(tester);
      });
    }
  }
}
