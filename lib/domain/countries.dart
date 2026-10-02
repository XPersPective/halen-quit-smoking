import 'dart:convert';

/// Localized country names and currencies, from `assets/data/countries.json`
/// (generated from CLDR by `tool/i18n/gen_countries.py`; 250 countries, 73
/// app languages).
class Country {
  const Country({required this.code, required this.name, this.currency});

  /// ISO 3166-1 alpha-2.
  final String code;
  final String name;

  /// ISO 4217 currency code of the country's legal tender, when known.
  final String? currency;
}

class CountryDirectory {
  CountryDirectory._(this._codes, this._currency, this._names);

  factory CountryDirectory.fromJson(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return CountryDirectory._(
      [for (final c in json['codes'] as List<dynamic>) c as String],
      (json['currency'] as Map<String, dynamic>).cast<String, String>(),
      {
        for (final e in (json['names'] as Map<String, dynamic>).entries)
          e.key: (e.value as Map<String, dynamic>).cast<String, String>(),
      },
    );
  }

  final List<String> _codes;
  final Map<String, String> _currency;
  final Map<String, Map<String, String>> _names;

  bool contains(String? code) =>
      code != null && _codes.contains(code.toUpperCase());

  String? currencyOf(String? code) => code == null ? null : _currency[code];

  /// Name tables to try for [languageCode] / [scriptCode] / [countryCode],
  /// most specific first, always ending in English.
  static List<String> tagChain(
    String languageCode, {
    String? scriptCode,
    String? countryCode,
  }) {
    final lang = languageCode == 'iw' ? 'he' : languageCode;
    final chain = <String>[];
    if (lang == 'zh') {
      final traditional = scriptCode == 'Hant' ||
          const {'TW', 'HK', 'MO'}.contains(countryCode);
      if (traditional) chain.add('zh-TW');
    }
    if (countryCode != null) chain.add('$lang-$countryCode');
    chain
      ..add(lang)
      ..add('en');
    return chain;
  }

  String nameOf(String code, List<String> chain) {
    for (final tag in chain) {
      final name = _names[tag]?[code];
      if (name != null) return name;
    }
    return code;
  }

  /// Countries whose name (in the user's language or English) or code
  /// contains [query], alphabetical in the user's language.
  List<Country> search(String query, List<String> chain) {
    final q = fold(query.trim());
    final english = _names['en'] ?? const <String, String>{};
    final result = <Country>[
      for (final code in _codes)
        if (q.isEmpty ||
            fold(nameOf(code, chain)).contains(q) ||
            fold(english[code] ?? '').contains(q) ||
            code.toLowerCase() == q)
          Country(
            code: code,
            name: nameOf(code, chain),
            currency: _currency[code],
          ),
    ]..sort((a, b) => fold(a.name).compareTo(fold(b.name)));
    return result;
  }

  /// Lower-cases and strips the accents that matter for matching, including
  /// the Turkish dotted/dotless i.
  static String fold(String input) {
    const from = 'àáâãäåāçćčďèéêëēěìíîïıłñńòóôõöøřśšşťùúûüůýÿžźżğ';
    const to = 'aaaaaaacccdeeeeeeiiiiilnnooooooorsssstuuuuuyyzzzg';
    final buffer = StringBuffer();
    for (final rune in input.replaceAll('İ', 'i').toLowerCase().runes) {
      final ch = String.fromCharCode(rune);
      final i = from.indexOf(ch);
      buffer.write(i >= 0 ? to[i] : ch);
    }
    return buffer.toString();
  }
}
