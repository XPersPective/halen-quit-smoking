# -*- coding: utf-8 -*-
"""Fixes found by looking at the captures after phases 2-3."""
import collections
import io
import json
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


# ---------- "about 0 tea spoons": add a drop, and stop rounding to zero ----------
TAR = 'lib/domain/tar_intake.dart'
replace(TAR, '''  tableSpoon(15),
  dessertSpoon(5),
  teaSpoon(2.5);''', '''  tableSpoon(15),
  dessertSpoon(5),
  teaSpoon(2.5),

  /// A drop, about 0.05 mL (the pharmacopoeial standard drop). Without it,
  /// a light day came out as "about 0 tea spoons", which reads as nothing
  /// having happened at all.
  drop(0.05);''')
replace(TAR, '''    return Picture(
      grams: grams,
      measure: Measure.teaSpoon,
      count: millilitres / Measure.teaSpoon.millilitres,
    );''', '''    return Picture(
      grams: grams,
      measure: Measure.drop,
      count: millilitres / Measure.drop.millilitres,
    );''')

CARD = 'lib/presentation/widgets/tar_intake_card.dart'
replace(CARD, '''      Measure.waterGlass => l10n.measureWaterGlass,
    };''', '''      Measure.waterGlass => l10n.measureWaterGlass,
      Measure.drop => l10n.measureDrop,
    };''')
replace(CARD, '''    final count = picture.count;
    // Halves read as words people use; anything else gets one decimal.
    final shown = (count * 2).roundToDouble() / 2;
    return l10n.tarPicture(
      shown == shown.roundToDouble()
          ? shown.toStringAsFixed(0)
          : shown.toStringAsFixed(1),
      measure,
    );''', '''    final count = picture.count;
    // Drops are counted whole; spoons and glasses read best in halves. Never
    // round down to zero: something was taken in, and "0" says it was not.
    final String shown;
    if (picture.measure == Measure.drop) {
      shown = count.round().clamp(1, 1 << 30).toString();
    } else {
      final halves = ((count * 2).roundToDouble() / 2).clamp(0.5, 1e9);
      shown = halves == halves.roundToDouble()
          ? halves.toStringAsFixed(0)
          : halves.toStringAsFixed(1);
    }
    return l10n.tarPicture(shown, measure);''')
replace(CARD, '''              for (var i = weekly.length - 1; i >= 1; i--) l10n.tarWeekShort(i),
              l10n.tarThisWeek,''', '''              for (var i = weekly.length - 1; i >= 1; i--) l10n.tarWeekShort(i),
              l10n.tarThisWeekShort,''')
replace(CARD, '''            yFormatter: (v) => _grams(v),''', '''            // Enough decimals for the step: a light week's axis runs in
            // hundredths, and one decimal printed 0.1, 0.1, 0.0.
            yFormatter: (v) => weekly.reduce((a, b) => a > b ? a : b) < 1
                ? v.toStringAsFixed(2)
                : _grams(v),''')

# ---------- environment: text labels, not emoji ----------
ENV = 'lib/presentation/widgets/environment_card.dart'
replace(ENV, "                  label: '🌳',", '                  label: l10n.envTreesLabel,')
replace(ENV, "                  label: '🚯',", '                  label: l10n.envFiltersLabel,')

# ---------- the gauge's delta line ran onto the arc at 132 px ----------
TILE = 'lib/presentation/widgets/today/progress_score_tile.dart'
replace(TILE, '            size: 132,', '            size: 152,')

# ---------- layout test: scroll the vertical list, drop the probe ----------
LAYOUT = 'test/widget/design_layout_test.dart'
replace(LAYOUT, '''      // ignore: avoid_print
      print('DBG navText=${find.text(l10n.navStats).evaluate().length} '
          'stats=${find.byType(StatsScreen).evaluate().length} '
          'statsAll=${find.byType(StatsScreen, skipOffstage: false).evaluate().length} '
          'today=${find.byType(TodayScreen).evaluate().length}');''', '')
replace(LAYOUT, '''      final page = find.descendant(
        of: find.byType(StatsScreen),
        matching: find.byType(Scrollable),
      ).first;''', '''      // The page's own vertical list, named by axis. "The first Scrollable
      // under Stats" is ambiguous now that the tabs are a horizontal
      // PageView: a horizontal scroller dragged at its edge hands the drag
      // to the pager and swipes the whole tab away mid-test.
      final page = find
          .descendant(
            of: find.byType(StatsScreen),
            matching: find.byWidgetPredicate(
              (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
            ),
          )
          .first;''')

for path, content in PENDING.items():
    io.open(path, 'w', encoding='utf-8').write(content)
    print('ok', path)

# ---------- strings ----------
NEW = {
    'measureDrop': ('drops', 'damla', 'Tropfen'),
    'tarThisWeekShort': ('now', 'bu hf', 'jetzt'),
    'envTreesLabel': ('Trees', 'Ağaç', 'Bäume'),
    'envFiltersLabel': ('Filters', 'İzmarit', 'Filter'),
}
for i, loc in enumerate(('en', 'tr', 'de')):
    path = 'lib/l10n/app_%s.arb' % loc
    data = json.load(io.open(path, encoding='utf-8'),
                     object_pairs_hook=collections.OrderedDict)
    for key, vals in NEW.items():
        data[key] = vals[i]
    io.open(path, 'w', encoding='utf-8').write(
        json.dumps(data, ensure_ascii=False, indent=2) + '\n')
print('strings ok')
