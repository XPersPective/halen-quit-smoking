/// S3-class money-savings calculator (report §4/§8).
///
/// All inputs are user data (S2): pack price, pack size; outputs are derived
/// (S3) and must carry the honesty tag in the UI.
library;

class Savings {
  const Savings({required this.pricePerPack, required this.packSize});

  final double pricePerPack;
  final int packSize;

  double get perCigarette =>
      packSize <= 0 ? 0 : pricePerPack / packSize;

  /// Money not spent on [avoidedCount] cigarettes.
  double forAvoided(int avoidedCount) => avoidedCount * perCigarette;

  /// Packs' worth of money saved — "n paket sigara parası" framing.
  double packsEquivalent(double saved) =>
      pricePerPack <= 0 ? 0 : saved / pricePerPack;
}
