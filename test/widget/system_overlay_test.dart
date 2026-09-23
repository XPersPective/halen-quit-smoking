import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/core/theme.dart';

void main() {
  testWidgets('selected chips use readable primary foreground in both themes', (
    tester,
  ) async {
    for (final theme in [HalenTheme.light(), HalenTheme.dark()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: ChoiceChip(
              selected: true,
              label: const Text('Standard'),
              onSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final color = DefaultTextStyle.of(tester.element(find.text('Standard')))
          .style
          .color!;
      expect(color, theme.colorScheme.onPrimary);
      final a = color.computeLuminance();
      final b = theme.colorScheme.primary.computeLuminance();
      expect(
        ((a > b ? a : b) + 0.05) / ((a < b ? a : b) + 0.05),
        greaterThanOrEqualTo(4.5),
      );
    }
  });
  testWidgets(
    'transparent app bar keeps readable status icons in both themes',
    (tester) async {
      for (final brightness in [
        Brightness.light,
        Brightness.dark,
        Brightness.light,
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: brightness == Brightness.light
                ? HalenTheme.light()
                : HalenTheme.dark(),
            home: Scaffold(appBar: AppBar(title: const Text('Halen'))),
          ),
        );
        await tester.pumpAndSettle();
        final overlay = tester
            .widget<AnnotatedRegion<SystemUiOverlayStyle>>(
              find.descendant(
                of: find.byType(AppBar),
                matching: find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
              ),
            )
            .value;
        expect(
          overlay.statusBarIconBrightness,
          brightness == Brightness.light ? Brightness.dark : Brightness.light,
        );
        expect(overlay.statusBarBrightness, brightness);
      }
    },
  );
}
