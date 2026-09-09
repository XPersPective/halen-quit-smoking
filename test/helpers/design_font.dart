import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Whether the visual captures should be written, rather than only smoke-run.
const captureDesign = bool.fromEnvironment('CAPTURE_DESIGN');

/// The phone-shaped surface every screenshot in `screenshots/` uses.
///
/// The tour used to be 1600x900 desktop windows with the Flutter title bar in
/// frame, which is not what anyone will hold. One size for the whole tour is
/// also what makes it usable as store material.
const tourSurface = Size(420, 1000);

/// Loads real text and icon fonts into the test binding.
///
/// Without this, a golden capture renders every glyph as a filled box: the
/// test binding ships no font. Point [DESIGN_FONT] at a TTF — the Flutter SDK
/// carries one at `bin/cache/artifacts/material_fonts/roboto-regular.ttf`.
Future<void> loadDesignFonts() async {
  const font = String.fromEnvironment('DESIGN_FONT');
  if (font.isEmpty) {
    return;
  }
  final loader = FontLoader('Roboto');
  loader.addFont(
    Future.value(ByteData.sublistView(await File(font).readAsBytes())),
  );
  await loader.load();
  final icons = FontLoader('MaterialIcons');
  icons.addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
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
