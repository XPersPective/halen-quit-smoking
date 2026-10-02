/// What stopping gives back to the planet (device feedback, item 10).
///
/// Two sourced figures, and nothing extrapolated beyond them:
///
///  * **trees** — WHO's overview of tobacco's environmental impact puts
///    deforestation at roughly one tree for every 300 cigarettes produced,
///    mostly wood burnt to dry tobacco leaf and pulp for paper (WHO,
///    "Tobacco and its environmental impact: an overview", 2017).
///  * **filters** — every cigarette not smoked is one filter, a cellulose
///    acetate plastic, that does not end up as litter; cigarette butts are
///    the most commonly collected litter item worldwide (WHO, "Tobacco:
///    poisoning our planet", 2022).
///
/// The sapling count is simple arithmetic on the user's own savings and a
/// typical sapling donation price; the organisations themselves set the real
/// price, and the app sends the person to them rather than taking money.
library;

abstract final class EnvironmentFigures {
  /// Cigarettes per tree lost (WHO 2017).
  static const int cigarettesPerTree = 300;

  /// A typical sapling donation in Türkiye, in lira. Only used to say "your
  /// savings would cover about N saplings" — and only for a user in Türkiye,
  /// where the price is in lira. Elsewhere no price is invented.
  static const double typicalSaplingPriceTry = 50;
}

class EnvironmentImpact {
  const EnvironmentImpact({required this.cigarettesAvoided});

  final int cigarettesAvoided;

  /// Trees not cut down, as a decimal — small numbers matter here, and
  /// "0.4 of a tree" after a few days is the honest answer.
  double get trees =>
      cigarettesAvoided / EnvironmentFigures.cigarettesPerTree;

  /// Filters that did not become litter: one per cigarette not smoked.
  int get filters => cigarettesAvoided;

  /// Saplings the given savings would pay for at a typical donation price.
  static int saplingsFor(double savings, {double? pricePerSapling}) {
    final price = pricePerSapling ?? EnvironmentFigures.typicalSaplingPriceTry;
    if (price <= 0 || savings <= 0) {
      return 0;
    }
    return (savings / price).floor();
  }
}

/// A verified tree-planting organisation the app links out to. The app is
/// not a party to the donation.
class PlantingPartner {
  const PlantingPartner({required this.name, required this.url});

  final String name;
  final String url;
}

const _oneTree = PlantingPartner(
  name: 'One Tree Planted',
  url: 'https://onetreeplanted.org/',
);
const _arborDay = PlantingPartner(
  name: 'Arbor Day Foundation',
  url: 'https://www.arborday.org/',
);
const _plantForPlanet = PlantingPartner(
  name: 'Plant-for-the-Planet',
  url: 'https://www.plant-for-the-planet.org/',
);

/// Planting organisations suited to the user's country. Only widely known,
/// long-standing organisations; the app links out and takes no part in the
/// donation. Unknown countries get the international set.
List<PlantingPartner> plantingPartnersFor(String? countryCode) {
  switch (countryCode?.toUpperCase()) {
    case 'TR':
      return const [
        PlantingPartner(name: 'TEMA Vakfı', url: 'https://www.tema.org.tr/'),
        PlantingPartner(
          name: 'OGM — Fidan Bağışı',
          url: 'https://www.ogm.gov.tr/',
        ),
        _oneTree,
      ];
    case 'DE' || 'AT' || 'CH':
      return const [_plantForPlanet, _oneTree];
    case 'GB' || 'IE':
      return const [
        PlantingPartner(
          name: 'Woodland Trust',
          url: 'https://www.woodlandtrust.org.uk/',
        ),
        _oneTree,
      ];
    case 'US' || 'CA':
      return const [_arborDay, _oneTree];
    default:
      return const [_oneTree, _arborDay, _plantForPlanet];
  }
}

/// Kept for callers that predate country awareness.
const plantingPartners = [_oneTree, _arborDay, _plantForPlanet];
