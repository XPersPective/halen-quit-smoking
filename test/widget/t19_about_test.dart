import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/about/about_screen.dart';

void main() {
  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AboutScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('about screen lists source, license, privacy and support', (
    tester,
  ) async {
    await pump(tester);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(AboutScreen)),
    )!;
    expect(find.text(l10n.aboutSourceCode), findsOneWidget);
    expect(find.text(l10n.aboutLicense), findsOneWidget);
    expect(find.text(l10n.aboutPrivacyPolicy), findsOneWidget);
    expect(find.text(l10n.aboutSupport), findsOneWidget);
    expect(find.text(l10n.aboutThirdPartyLicenses), findsOneWidget);
  });
}
