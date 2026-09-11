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
  /// savings would cover about N saplings"; the organisation sets the price.
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

const plantingPartners = [
  PlantingPartner(name: 'TEMA Vakfı', url: 'https://www.tema.org.tr/'),
  PlantingPartner(
    name: 'OGM — Fidan Bağışı',
    url: 'https://www.ogm.gov.tr/',
  ),
  PlantingPartner(
    name: 'One Tree Planted',
    url: 'https://onetreeplanted.org/',
  ),
];
