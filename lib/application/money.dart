import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'country_providers.dart';

/// The one place money is formatted, so every figure in the app uses the
/// currency of the country the user chose — not the currency of the app
/// language (an English-speaking user in Türkiye pays in lira, not dollars;
/// owner feedback 2026-10-02).
///
/// Until a country is chosen the number format's own default for [locale] is
/// used, as before.
class MoneyFormats {
  const MoneyFormats(this.currencyCode, this.locale);

  /// ISO 4217 code, or null when no country has been chosen yet.
  final String? currencyCode;
  final String locale;

  /// "₺1,235" — no decimals, for totals.
  NumberFormat get whole => currencyCode == null
      ? NumberFormat.simpleCurrency(locale: locale, decimalDigits: 0)
      : NumberFormat.simpleCurrency(
          locale: locale,
          name: currencyCode,
          decimalDigits: 0,
        );

  /// "₺5.00" — with the currency's usual decimals, for a single cigarette.
  NumberFormat get precise => currencyCode == null
      ? NumberFormat.simpleCurrency(locale: locale)
      : NumberFormat.simpleCurrency(locale: locale, name: currencyCode);

  /// "₺1.2K" — for chart axes.
  NumberFormat get compact => currencyCode == null
      ? NumberFormat.compactSimpleCurrency(locale: locale, decimalDigits: 0)
      : NumberFormat.compactSimpleCurrency(
          locale: locale,
          name: currencyCode,
          decimalDigits: 0,
        );
}

/// Money formats for [locale] (the UI locale string), in the user's currency.
final moneyFormatsProvider = Provider.family<MoneyFormats, String>((
  ref,
  locale,
) {
  return MoneyFormats(ref.watch(currencyCodeProvider), locale);
});
