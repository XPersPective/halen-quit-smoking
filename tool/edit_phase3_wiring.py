# -*- coding: utf-8 -*-
"""Phase 3 wiring: items 2, 4, 5, 10, 12, 15.

Every anchor is asserted before anything is written, so a mismatch leaves
the tree untouched.
"""
import io
import sys

PENDING = {}


def text(path):
    if path not in PENDING:
        PENDING[path] = io.open(path, encoding='utf-8').read()
    return PENDING[path]


def replace(path, old, new):
    s = text(path)
    if old not in s:
        sys.exit('ANCHOR MISSING in %s:\n---\n%s\n---' % (path, old[:200]))
    PENDING[path] = s.replace(old, new, 1)


def add_import(path, after, line):
    if line not in text(path):
        replace(path, after, after + '\n' + line)


# ---------- Item 2: the pack section in Settings ----------
SETTINGS = 'lib/presentation/screens/settings/settings_screen.dart'
replace(SETTINGS,
        '              // Module report §1/§12/§14 — the dials the models expose to the',
        '''              // Item 2: the pack is editable after onboarding at last, and
              // purchases are one tap away.
              const PackSettingsSection(),
              const SizedBox(height: HalenSpace.x4),
              // Module report §1/§12/§14 — the dials the models expose to the''')
add_import(SETTINGS,
           "import 'package:halen/presentation/widgets/model_settings_section.dart';",
           "import 'package:halen/presentation/widgets/pack_settings_section.dart';")

# ---------- Item 10: the environment card on Stats ----------
STATS = 'lib/presentation/screens/stats/stats_screen.dart'
replace(STATS,
        '            const SizedBox(height: HalenSpace.x6),\n            savings.when(',
        '''            const SizedBox(height: HalenSpace.x4),
            // Item 10: what the planet got back, and a way to plant a real
            // tree with some of the savings.
            const EnvironmentCard(),
            const SizedBox(height: HalenSpace.x6),
            savings.when(''')
add_import(STATS,
           "import 'package:halen/presentation/widgets/stats_charts.dart';",
           "import 'package:halen/presentation/widgets/environment_card.dart';\n"
           "import 'package:halen/presentation/widgets/tar_intake_card.dart';")
replace(STATS,
        '            const Entrance(index: 2, child: CravingWindowCard()),',
        '''            const Entrance(index: 2, child: CravingWindowCard()),
            const SizedBox(height: HalenSpace.x4),
            // Item 4: tar in grams and in spoons, from the pack label.
            const Entrance(index: 3, child: TarIntakeCard()),''')

# ---------- Item 5: each organ's own exposure ----------
BODY = 'lib/presentation/screens/body/body_screen.dart'
replace(BODY,
        '''    return Card(
      margin: const EdgeInsets.only(bottom: 16),''',
        '''    // Item 5: this person's own exposure leads, the population figure
    // follows. The first is about them; the second is about everyone.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OrganExposureCard(organKey: organ.key),
        const SizedBox(height: HalenSpace.x4),
        Card(
      margin: const EdgeInsets.only(bottom: 16),''')
replace(BODY,
        '''          ],
        ),
      ),
    );
  }
}

class _ToxicantsTab''',
        '''          ],
        ),
      ),
        ),
      ],
    );
  }
}

class _ToxicantsTab''')
add_import(BODY, "import '../../widgets/organ_shapes.dart';",
           "import '../../widgets/organ_exposure_card.dart';")

# ---------- Item 12: nicotine in milligrams, more time ticks ----------
CURVE = 'lib/presentation/widgets/charts/load_curve_chart.dart'
replace(CURVE, '    this.height = 168,\n  });',
        '''    this.height = 168,
    this.peakValue,
    this.unitFormatter,
  });''')
replace(CURVE, '  final double height;\n',
        '''  final double height;

  /// The real quantity at 100% of this window (item 12). With
  /// [unitFormatter], the axis prints that quantity — "0.9 mg" — instead of
  /// a percentage. Exact, because the normalised curve is linear in the raw
  /// one: 50% of the plot is half of [peakValue].
  final double? peakValue;
  final String Function(double)? unitFormatter;
''')
replace(CURVE, '''                timeLabels: timeLabels,
                locale: locale,''', '''                timeLabels: timeLabels,
                locale: locale,
                peakValue: peakValue,
                unitFormatter: unitFormatter,''')
replace(CURVE, '''    required this.locale,
    required this.labelStyle,''', '''    required this.locale,
    required this.labelStyle,
    this.peakValue,
    this.unitFormatter,''')
replace(CURVE, '''  final String locale;
  final TextStyle labelStyle;''', '''  final String locale;
  final TextStyle labelStyle;
  final double? peakValue;
  final String Function(double)? unitFormatter;''')
replace(CURVE, '        formatPercent(value, locale),',
        '''        unitFormatter != null && peakValue != null
            ? unitFormatter!(peakValue! * value / 100)
            : formatPercent(value, locale),''')
replace(CURVE, '''    for (var i = 0; i < timeLabels.length && i < 3; i++) {
      final align = [0.0, 0.5, 1.0][i];
      final width = 64.0;''', '''    // Evenly spaced, any count: five ticks (24, 18, 12, 6 hours, now) say
    // far more about when than the old three did.
    for (var i = 0; i < timeLabels.length; i++) {
      final align = timeLabels.length == 1 ? 1.0 : i / (timeLabels.length - 1);
      final width = timeLabels.length > 3 ? 46.0 : 64.0;''')

STRIP = 'lib/presentation/widgets/today/now_in_body_strip.dart'
replace(STRIP, "import 'dart:async';", "import 'dart:async';\nimport 'dart:math' as math;")
replace(STRIP, '''    final ghosts = [''', '''    // Item 12: the nicotine axis in milligrams. The model's raw curve is in
    // mg of absorbed nicotine still in the body, so the peak of this window
    // gives the axis its real scale.
    final rawNicotine = model.rawCurve(
      LoadKind.nicotineAcute,
      windowStart,
      _now,
      past,
    );
    final peakMg = rawNicotine.isEmpty ? 0.0 : rawNicotine.reduce(math.max);
    final nowMg = model.rawAt(LoadKind.nicotineAcute, _now, past);
    String mg(double v) =>
        l10n.mgValue(v < 10 ? v.toStringAsFixed(1) : v.toStringAsFixed(0));

    final ghosts = [''')
replace(STRIP, '''                  value: formatPercent(snapshot.nicotinePercentOfPeak, locale),''',
        '''                  value: mg(nowMg),''')
replace(STRIP, '''            axisCaption: l10n.loadAxisCaption,
            timeLabels: [
              l10n.loadAxisHoursAgo(24),
              l10n.loadAxisHoursAgo(12),
              l10n.loadAxisNow,
            ],
            height: 132,''', '''            axisCaption: l10n.nicotineMgAxis,
            peakValue: peakMg,
            unitFormatter: mg,
            timeLabels: [
              l10n.loadAxisHoursAgo(24),
              l10n.loadAxisHoursAgo(18),
              l10n.loadAxisHoursAgo(12),
              l10n.loadAxisHoursAgo(6),
              l10n.loadAxisNow,
            ],
            height: 150,''')
replace(STRIP, '''          Text(l10n.bodyLoadMeaning, style: theme.textTheme.bodySmall),''',
        '''          Text(l10n.bodyLoadMeaning, style: theme.textTheme.bodySmall),
          const SizedBox(height: HalenSpace.x1),
          Text(l10n.nicotineMgBasis, style: theme.textTheme.bodySmall),''')

# ---------- Item 4: tar as a page in the status flow ----------
FLOW = 'lib/presentation/screens/status/status_flow_screen.dart'
replace(FLOW, '''        _IndexPage(harm: true),
      ];''', '''        _IndexPage(harm: true),
        _CardPage(child: TarIntakeCard()),
      ];''')
add_import(FLOW, "import '../../widgets/design/halen_components.dart';",
           "import '../../widgets/tar_intake_card.dart';")
PENDING[FLOW] = text(FLOW) + '''

/// A page that is a whole card on its own (item 4, the tar page).
class _CardPage extends StatelessWidget {
  const _CardPage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
'''

# ---------- Item 15: swipe between the five tabs ----------
SHELL = 'lib/presentation/screens/shell_screen.dart'
replace(SHELL, '''class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;
''', '''class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;

  // Item 15: the tabs are pages, so a horizontal swipe moves between them as
  // well as the bar does. The bar and the pages drive each other.
  final PageController _pages = PageController();

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _go(int index) {
    setState(() => _index = index);
    if (MediaQuery.of(context).disableAnimations) {
      _pages.jumpToPage(index);
    } else {
      _pages.animateToPage(
        index,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }
''')
replace(SHELL, '''          child: IndexedStack(
            index: _index,
            children: const [
              TodayScreen(),
              StatsScreen(),
              PlanScreen(),
              ArticlesScreen(),
              SosScreen(),
            ],
          ),''', '''          child: PageView(
            controller: _pages,
            onPageChanged: (i) => setState(() => _index = i),
            // Each tab keeps its scroll position and state when swiped away,
            // the way IndexedStack did.
            children: const [
              _KeepAlive(child: TodayScreen()),
              _KeepAlive(child: StatsScreen()),
              _KeepAlive(child: PlanScreen()),
              _KeepAlive(child: ArticlesScreen()),
              _KeepAlive(child: SosScreen()),
            ],
          ),''')
replace(SHELL, '        onDestinationSelected: (i) => setState(() => _index = i),',
        '        onDestinationSelected: _go,')
PENDING[SHELL] = text(SHELL) + '''

class _KeepAlive extends StatefulWidget {
  const _KeepAlive({required this.child});

  final Widget child;

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
'''

for path, content in PENDING.items():
    io.open(path, 'w', encoding='utf-8').write(content)
    print('ok', path)
