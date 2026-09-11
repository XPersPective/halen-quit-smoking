# -*- coding: utf-8 -*-
"""Phase 1 of the device-feedback round: items 1, 8, 9, 13, 14.

Applied as one script so a partial edit cannot leave the tree half-changed;
every replacement asserts its anchor exists before anything is written.
"""
import io
import sys


def load(p):
    return io.open(p, encoding='utf-8').read()


def save(p, s):
    io.open(p, 'w', encoding='utf-8').write(s)


PENDING = {}


def edit(path):
    if path not in PENDING:
        PENDING[path] = load(path)
    return PENDING[path]


def replace(path, old, new, count=1):
    s = edit(path)
    if old not in s:
        sys.exit('ANCHOR MISSING in %s:\n%s' % (path, old[:120]))
    PENDING[path] = s.replace(old, new, count)


def between(path, start, end, new):
    s = edit(path)
    a = s.index(start)
    b = s.index(end, a)
    PENDING[path] = s[:a] + new + s[b:]


def ensure_import(path, anchor, line):
    s = edit(path)
    if line not in s:
        replace(path, anchor, anchor + '\n' + line)


TODAY = 'lib/presentation/screens/today/today_screen.dart'

# ---------- Item 8: the two actions ----------
between(
    TODAY,
    '          // ——— Primary CTA ———',
    '          const SizedBox(height: HalenSpace.x8),\n\n          // ——— Overview ———',
    '''          // ——— The two actions ———
          // Item 8, the psychology of the pair. The win comes first: filled,
          // in the primary colour, with a growing-leaf icon. The cigarette is
          // still one tap — a log that is hard to make is a log people stop
          // making — but it is quiet: outlined, desaturated, a smoke icon,
          // and never the brightest thing on the screen. It used to be the
          // amber all-caps "I SMOKED", which made it the most inviting
          // control in the app.
          FilledButton.icon(
            onPressed: () => _logResisted(context, ref),
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              minimumSize: const Size.fromHeight(60),
              shape: const RoundedRectangleBorder(
                borderRadius: HalenRadius.mediumAll,
              ),
            ),
            icon: const Icon(Icons.spa_rounded, size: 24),
            label: Text(
              '${l10n.ctaResisted} · ${l10n.resistedTodayCount(state.resistedToday)}',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: HalenSpace.x3),
          OutlinedButton.icon(
            onPressed: state.dayCompleted
                ? null
                : () => _logCigarette(context, ref),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.onSurfaceVariant,
              backgroundColor:
                  colors.surfaceContainerHighest.withValues(alpha: 0.6),
              side: BorderSide(color: colors.outline),
              minimumSize: const Size.fromHeight(52),
              shape: const RoundedRectangleBorder(
                borderRadius: HalenRadius.mediumAll,
              ),
            ),
            icon: const Icon(Icons.smoking_rooms_rounded, size: 20),
            label: Text(l10n.ctaSmoked),
          ),
''',
)

# ---------- Item 9: what the sheet says after a cigarette ----------
replace(
    TODAY,
    '''      headline: l10n.logSmokedNeutral(
        events.length,
        baseline.toStringAsFixed(baseline % 1 == 0 ? 0 : 1),
      ),
      detail: l10n.logNotAFailure,
      footnote: state.nextSuggestion == null
          ? null
          : l10n.logNextTarget(
              TimeOfDay.fromDateTime(state.nextSuggestion!).format(context),
            ),''',
    '''      // Item 9: sad, then hope, then one concrete thing to do. The line
      // rotates so the same sentence is not read ten times a day; the plain
      // count moves to the footnote rather than leading.
      headline: _smokedHeadline(l10n, events.length),
      detail: _smokedAdvice(l10n, events.length),
      footnote: [
        l10n.logSmokedNeutral(
          events.length,
          baseline.toStringAsFixed(baseline % 1 == 0 ? 0 : 1),
        ),
        if (state.nextSuggestion != null)
          l10n.logNextTarget(
            TimeOfDay.fromDateTime(state.nextSuggestion!).format(context),
          ),
      ].join('  ·  '),''',
)
replace(
    TODAY,
    '  String _lastCigaretteText(AppLocalizations l10n, DateTime? last) {',
    '''  String _smokedHeadline(AppLocalizations l10n, int count) =>
      switch (count % 4) {
        0 => l10n.smokedHeadline0,
        1 => l10n.smokedHeadline1,
        2 => l10n.smokedHeadline2,
        _ => l10n.smokedHeadline3,
      };

  String _smokedAdvice(AppLocalizations l10n, int count) =>
      switch (count % 4) {
        0 => l10n.smokedAdvice0,
        1 => l10n.smokedAdvice1,
        2 => l10n.smokedAdvice2,
        _ => l10n.smokedAdvice3,
      };

  String _lastCigaretteText(AppLocalizations l10n, DateTime? last) {''',
)

# ---------- Item 14: the score, on the home screen ----------
replace(
    TODAY,
    '''          HalenSectionHeader(title: l10n.todaySectionState),
          const SizedBox(height: HalenSpace.x3),''',
    '''          HalenSectionHeader(title: l10n.todaySectionState),
          const SizedBox(height: HalenSpace.x3),
          // Item 14: the one number that answers "am I getting better?"
          // leads the section instead of living below the fold on Grafikler.
          const Entrance(child: ProgressScoreTile()),
          const SizedBox(height: HalenSpace.x4),''',
)
ensure_import(
    TODAY,
    "import 'package:halen/presentation/widgets/today/now_in_body_strip.dart';",
    "import 'package:halen/presentation/widgets/today/progress_score_tile.dart';",
)

# ---------- Item 9: the animation ----------
FEEDBACK = 'lib/presentation/widgets/today/log_feedback.dart'
between(
    FEEDBACK,
    '            Center(\n              child: AnimatedBuilder(',
    '            const SizedBox(height: HalenSpace.x6),\n            Text(widget.headline',
    '''            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = reduceMotion ? 1.0 : _controller.value;
                  if (smoked) {
                    // Item 9: an ember going out, and a sprout coming up where
                    // it was. Sad first, then hope — the order is the message,
                    // so it is drawn as one continuous motion.
                    return SizedBox(
                      width: 120,
                      height: 120,
                      child: CustomPaint(
                        painter: _EmberToSprout(
                          t: t,
                          ember: HalenColors.textSecondaryLight,
                          sprout: HalenColors.emerald,
                        ),
                      ),
                    );
                  }
                  // Skipped: the ring opens out — one breath in.
                  return Transform.scale(
                    scale: 0.82 + 0.22 * t,
                    child: Opacity(
                      opacity: 0.35 + 0.65 * t,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent.withValues(alpha: 0.14),
                          border: Border.all(color: accent, width: 2),
                        ),
                        child: Icon(
                          Icons.air_rounded,
                          color: accent,
                          size: 34,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
''',
)
replace(FEEDBACK, '        ? const Duration(milliseconds: 900)',
        '        ? const Duration(milliseconds: 1800)')
PENDING[FEEDBACK] = edit(FEEDBACK) + '''

/// An ember going out, then a sprout growing from the same spot.
///
/// The first half is the loss: the glow dims and its thread of smoke thins
/// away. The second half is the point: a stem draws itself upward and two
/// leaves open. No faces, no cartoon, no confetti — the brief was sad but
/// hopeful, and not childish.
class _EmberToSprout extends CustomPainter {
  _EmberToSprout({required this.t, required this.ember, required this.sprout});

  final double t;
  final Color ember;
  final Color sprout;

  @override
  void paint(Canvas canvas, Size size) {
    final base = Offset(size.width / 2, size.height * 0.78);

    // Phase 1 (0 to 0.5): the ember dims and its smoke thins.
    final fade = (1 - t / 0.5).clamp(0.0, 1.0);
    if (fade > 0) {
      canvas.drawCircle(
        base,
        9 + 5 * fade,
        Paint()
          ..color = ember.withValues(alpha: 0.18 * fade)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      canvas.drawCircle(
        base,
        6,
        Paint()..color = ember.withValues(alpha: fade),
      );
      final smoke = Path()
        ..moveTo(base.dx, base.dy - 8)
        ..cubicTo(
          base.dx - 10, base.dy - 26,
          base.dx + 10, base.dy - 40,
          base.dx - 2, base.dy - 58 - 10 * (1 - fade),
        );
      canvas.drawPath(
        smoke,
        Paint()
          ..color = ember.withValues(alpha: 0.5 * fade)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round,
      );
    }

    // Phase 2 (0.45 to 1): a stem grows and two leaves open.
    final grow = ((t - 0.45) / 0.55).clamp(0.0, 1.0);
    if (grow <= 0) {
      return;
    }
    canvas.drawLine(
      base,
      Offset(base.dx, base.dy - 58 * grow),
      Paint()
        ..color = sprout
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    final leaf = ((grow - 0.4) / 0.6).clamp(0.0, 1.0);
    if (leaf <= 0) {
      return;
    }
    final fill = Paint()..color = sprout.withValues(alpha: 0.85);
    for (final side in const [-1.0, 1.0]) {
      final anchor = Offset(base.dx, base.dy - 40 * grow);
      final tip = anchor.translate(side * 22 * leaf, -14 * leaf);
      final path = Path()
        ..moveTo(anchor.dx, anchor.dy)
        ..quadraticBezierTo(
          anchor.dx + side * 18 * leaf, anchor.dy + 4 * leaf,
          tip.dx, tip.dy,
        )
        ..quadraticBezierTo(
          anchor.dx + side * 4 * leaf, anchor.dy - 14 * leaf,
          anchor.dx, anchor.dy,
        )
        ..close();
      canvas.drawPath(path, fill);
    }
  }

  @override
  bool shouldRepaint(_EmberToSprout old) => old.t != t;
}
'''

# ---------- Item 13: chart breathing room ----------
LINE = 'lib/presentation/widgets/charts/halen_line_chart.dart'
replace(
    LINE,
    '''                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),''',
    '''                  // Item 13: blank reserved lanes on the top and right
                  // edges. fl_chart has no inner padding of its own, so the
                  // line and the "today" dot ran straight into the card
                  // edge; a blank title lane is how it gets room to breathe
                  // without a wrapper that fights its layout.
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: HalenSpace.x3,
                      getTitlesWidget: _noTitle,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: HalenSpace.x4,
                      getTitlesWidget: _noTitle,
                    ),
                  ),''',
)
replace(LINE, '                        padding: const EdgeInsets.only(right: 6),',
        '                        padding: const EdgeInsets.only(right: HalenSpace.x2),')
replace(LINE, '                      reservedSize: 26,',
        '                      reservedSize: HalenSpace.x8,')
replace(LINE, '                          padding: const EdgeInsets.only(top: 6),',
        '                          padding: const EdgeInsets.only(top: HalenSpace.x2),')
PENDING[LINE] = edit(LINE) + '''

/// A blank axis title, used to reserve padding lanes on a chart's edges.
Widget _noTitle(double value, TitleMeta meta) => const SizedBox.shrink();
'''

CURVE = 'lib/presentation/widgets/charts/load_curve_chart.dart'
replace(
    CURVE,
    '''    final plot = Rect.fromLTRB(
      _labelGutter,
      6,
      size.width - 6,
      size.height - _tickLane,
    );''',
    '''    final plot = Rect.fromLTRB(
      _labelGutter,
      HalenSpace.x3,
      size.width - HalenSpace.x4,
      size.height - _tickLane,
    );''',
)

# ---------- Item 1: the welcome screen ----------
SPLASH = 'lib/presentation/screens/splash_screen.dart'
replace(
    SPLASH,
    '''class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override''',
    '''class _SplashScreenState extends ConsumerState<SplashScreen> {
  /// Null while we find out; true only on a first launch.
  bool? _firstLaunch;

  @override''',
)
replace(
    SPLASH,
    '''    final onboarded = await ref.read(hasOnboardedProvider.future);
    if (!mounted) {
      return;
    }
    Navigator.pushReplacementNamed(
      context,
      onboarded ? Routes.today : Routes.onboarding,
    );''',
    '''    final onboarded = await ref.read(hasOnboardedProvider.future);
    if (!mounted) {
      return;
    }
    if (onboarded) {
      // A returning user has read the privacy promise and the medical note
      // already, and both live in Settings. Showing them on every launch is
      // the kind of delay that makes an app feel slow, so we go straight in.
      Navigator.pushReplacementNamed(context, Routes.today);
      return;
    }
    // First launch: stay put. This screen used to route away on its own
    // first frame, so the privacy promise, the medical note and the
    // notification question flashed past unread — and its own Start button
    // was unreachable. The person moves on when they tap it.
    setState(() => _firstLaunch = true);''',
)
replace(
    SPLASH,
    '''    final theme = Theme.of(context);
    return Scaffold(''',
    '''    final theme = Theme.of(context);
    if (_firstLaunch != true) {
      // A plain frame in the app's own ground while we check. The native
      // launch window is the same colour, so this reads as one continuous
      // start rather than a flash of text.
      return const Scaffold(body: SizedBox.shrink());
    }
    return Scaffold(''',
)

# ---------- the test that assumed the old auto-route ----------
ONB = 'test/widget/onboarding_flow_test.dart'
replace(
    ONB,
    '''    // Splash auto-routes to onboarding on a fresh install.
    await tester.pumpAndSettle();
    expect(find.text('How old are you?'), findsOneWidget);''',
    '''    // First launch now waits on the welcome screen until the person taps
    // Start; it used to route away on its own first frame.
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    expect(find.text('How old are you?'), findsOneWidget);''',
)
replace(
    ONB,
    '''  testWidgets('under-18 path creates no smoking profile', (tester) async {
    await pumpHalenApp(tester, database: db);
    await tester.pumpAndSettle();''',
    '''  testWidgets('under-18 path creates no smoking profile', (tester) async {
    await pumpHalenApp(tester, database: db);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();''',
)

for path, text in PENDING.items():
    save(path, text)
    print('ok', path)
