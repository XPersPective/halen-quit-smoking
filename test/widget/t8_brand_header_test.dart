import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/presentation/widgets/premium_badge.dart';

import '../helpers/pump_app.dart';

void main() {
  for (final lang in ['tr', 'en', 'de']) {
    testWidgets('today header: icon + Halen + subtitle at 320dp×1.6 [$lang]', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      tester.platformDispatcher.localesTestValue = [Locale(lang)];
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);

      final db = await seedOnboardedProfile();
      addTearDown(db.close);
      await pumpHalenApp(tester, database: db, extraOverrides: []);
      await tester.pumpAndSettle();

      // 1. Brand icon renders from the registered asset.
      final image = tester.widget<Image>(find.byWidgetPredicate(
        (w) =>
            w is Image &&
            w.image is AssetImage &&
            (w.image as AssetImage).assetName == 'assets/app_icon.png',
      ));
      expect(image.semanticLabel, isNotEmpty);
      expect(image.width, 36);
      expect(image.height, 36);

      // 2. Product name + smaller subtitle own the row; the settings button
      //    and premium badge still fit — no overflow exception.
      expect(find.byType(PremiumBadge), findsOneWidget);
      expect(tester.takeException(), isNull);
      await disposeApp(tester);
    });
  }
}
