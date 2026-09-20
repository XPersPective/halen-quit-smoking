import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/presentation/widgets/entrance.dart';

void main() {
  testWidgets('reduce-motion: entrance starts at its final state', (
    tester,
  ) async {
    double? opacityAtStart;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: const Scaffold(
                body: Entrance(child: FlutterLogo()),
              ),
            );
          },
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 16));
    final fade = tester.widget<FadeTransition>(
      find.ancestor(
        of: find.byType(FlutterLogo),
        matching: find.byType(FadeTransition),
      ).first,
    );
    opacityAtStart = fade.opacity.value;
    expect(
      opacityAtStart,
      1.0,
      reason: 'with reduce-motion the card is fully visible immediately; '
          'the animation carries no information worth waiting for',
    );
  });

  testWidgets('normal motion: entrance settles fully visible', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: const Scaffold(body: Entrance(child: FlutterLogo()))),
    );
    await tester.pumpAndSettle();
    final settled = tester.widget<FadeTransition>(
      find.ancestor(
        of: find.byType(FlutterLogo),
        matching: find.byType(FadeTransition),
      ).first,
    );
    expect(settled.opacity.value, 1.0);
  });
}
