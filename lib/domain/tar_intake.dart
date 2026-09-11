/// What went in, in amounts a person can picture (device feedback, item 4).
///
/// Every figure here comes from two published sources and nothing else:
///
///  * **the pack label.** Cigarettes sold in the EU and Türkiye carry machine
///    yields measured under ISO 4387 / ISO 10315 / ISO 8454 — tar (NFDPM),
///    nicotine and carbon monoxide per cigarette — capped at 10 mg tar,
///    1 mg nicotine and 10 mg CO (EU Directive 2014/40/EU, Art. 3; the
///    Turkish regulation mirrors the same limits). When the user has not
///    entered their brand's values, the legal maximum is used and the screen
///    says so.
///  * **the user's own log** of how many they smoked.
///
/// Two honesty points the screens repeat:
///
///  * **it is a floor, not an estimate of the truth.** Machine yields are
///    lower than what people take in: smokers inhale deeper and block the
///    filter ventilation holes, so human intake is typically higher than the
///    label (the "compensation" finding behind the ISO method's critics).
///    The app says "at least".
///  * **the spoon is by volume, with the assumption written out.** Tar here
///    is the smoke condensate; the conversion to spoons uses a density of
///    about 1 g/mL, stated wherever a spoon appears.
library;

/// Legal maxima per cigarette (EU Directive 2014/40/EU, Art. 3(1)).
abstract final class LabelLimits {
  static const double tarMg = 10;
  static const double nicotineMg = 1;
  static const double carbonMonoxideMg = 10;
}

/// Everyday measures, largest first. Turkish household sizes: a tea spoon
/// (çay kaşığı) is about 2.5 mL, a dessert spoon 5 mL, a table spoon 15 mL,
/// a water glass (su bardağı) 200 mL.
enum Measure {
  waterGlass(200),
  tableSpoon(15),
  dessertSpoon(5),
  teaSpoon(2.5),

  /// A drop, about 0.05 mL (the pharmacopoeial standard drop). Without it,
  /// a light day came out as "about 0 tea spoons", which reads as nothing
  /// having happened at all.
  drop(0.05);

  const Measure(this.millilitres);

  final double millilitres;
}

/// Condensate density used for the spoon conversion — an approximation,
/// shown alongside every spoon figure.
const double assumedTarDensityGPerMl = 1.0;

/// An amount, and the largest household measure it fills at least once.
class Picture {
  const Picture({required this.grams, required this.measure, required this.count});

  final double grams;
  final Measure measure;

  /// How many of [measure] — at least 0.5 so "half a tea spoon" reads well.
  final double count;
}

class TarIntake {
  const TarIntake({double? tarMgPerCigarette, double? nicotineMgPerCigarette})
      : tarMgPerCigarette = tarMgPerCigarette ?? LabelLimits.tarMg,
        nicotineMgPerCigarette =
            nicotineMgPerCigarette ?? LabelLimits.nicotineMg,
        usesLegalMaximum =
            tarMgPerCigarette == null || nicotineMgPerCigarette == null;

  final double tarMgPerCigarette;
  final double nicotineMgPerCigarette;

  /// True when one of the values is the legal cap rather than the user's
  /// own pack label — the screen says so.
  final bool usesLegalMaximum;

  /// Tar taken in with [cigarettes] cigarettes, in grams (label floor).
  double tarGrams(int cigarettes) => cigarettes * tarMgPerCigarette / 1000;

  /// Nicotine delivered with [cigarettes] cigarettes, in milligrams (label).
  double nicotineMg(int cigarettes) => cigarettes * nicotineMgPerCigarette;

  /// [grams] as the largest household measure it fills at least half of.
  static Picture picture(double grams) {
    final millilitres = grams / assumedTarDensityGPerMl;
    for (final measure in Measure.values) {
      final count = millilitres / measure.millilitres;
      if (count >= 0.5) {
        return Picture(grams: grams, measure: measure, count: count);
      }
    }
    return Picture(
      grams: grams,
      measure: Measure.drop,
      count: millilitres / Measure.drop.millilitres,
    );
  }
}

/// Tar per week for the last [weeks] weeks, oldest first, from event times.
List<double> weeklyTarGrams({
  required List<DateTime> events,
  required DateTime now,
  required TarIntake intake,
  int weeks = 8,
}) {
  final result = <double>[];
  for (var w = weeks - 1; w >= 0; w--) {
    final end = now.subtract(Duration(days: 7 * w));
    final start = end.subtract(const Duration(days: 7));
    final count = events.where((e) => e.isAfter(start) && !e.isAfter(end)).length;
    result.add(intake.tarGrams(count));
  }
  return result;
}
