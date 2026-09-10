import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/core/design/typography.dart';

/// Whether the visual captures should be written, rather than only smoke-run.
const captureDesign = bool.fromEnvironment('CAPTURE_DESIGN');

/// The phone-shaped surface every screenshot in `screenshots/` uses.
///
/// The tour used to be 1600x900 desktop windows with the Flutter title bar in
/// frame, which is not what anyone will hold. One size for the whole tour is
/// also what makes it usable as store material.
const tourSurface = Size(420, 1000);

/// Loads the app's real fonts into the test binding.
///
/// Without this a golden capture renders every glyph as a filled box: the
/// test binding ships no font. The app draws in Inter now, so the capture
/// has to load Inter — loading the SDK's Roboto instead would produce
/// screenshots of a typeface the app never uses.
Future<void> loadDesignFonts() async {
  final inter = FontLoader(HalenType.family)
    ..addFont(rootBundle.load('assets/fonts/Inter.ttf'));
  await inter.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await icons.load();
}

/// Advances a fixed number of frames instead of settling.
///
/// Several screens breathe on purpose (the lung, the body map, the SOS ring)
/// and would never come to rest, so `pumpAndSettle` deadlocks on them.
Future<void> pumpFrames(WidgetTester tester, {int frames = 12}) async {
  await tester.pump();
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 80));
  }
}
