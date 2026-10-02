/// Verified national quit lines.
///
/// Sources: WHO, "Toll-free quitlines" (World No Tobacco Day 2021 quitting
/// toolkit) plus national services checked on the dates below: Ireland HSE
/// QUIT 1800 201 203 (hse.ie, 2026-10); England/Scotland/Wales (nhs.uk and
/// national services, 2026-09-16); Türkiye (alo171.saglik.gov.tr and
/// yedam.org.tr). Costa Rica and Peru are left out: WHO's entries for them
/// repeat the US Spanish-language line. A country that is not listed has no
/// verified line on file — the UI says so and links the WHO directory
/// instead of guessing a number.
library;

class QuitLine {
  const QuitLine(this.display, {this.dial, this.label});

  /// Number as people write it.
  final String display;

  /// What to dial when [display] carries words. Defaults to [display].
  final String? dial;

  /// Service name; null = show the generic "Quitline" wording.
  final String? label;

  /// Digits (and a leading +) only, for the dialer.
  String get number => (dial ?? display).replaceAll(RegExp(r'[^0-9+]'), '');
}

const whoQuitlineDirectoryUrl =
    'https://www.who.int/campaigns/world-no-tobacco-day/2021/quitting-toolkit/toll-free-quitlines';

const Map<String, List<QuitLine>> quitlinesByCountry = {
  'AM': [QuitLine('+374 60 440001')],
  'AT': [QuitLine('0800 810 013')],
  'AU': [QuitLine('13 7848', label: 'Quitline (13 QUIT)')],
  'BE': [QuitLine('0800 111 00')],
  'BG': [QuitLine('0700 10 323')],
  'BR': [QuitLine('0800 61 1997')],
  'BY': [QuitLine('8-017-289-80-34')],
  'CA': [QuitLine('1-866-366-3667')],
  'CH': [QuitLine('0848 000 181')],
  'CN': [QuitLine('12320')],
  'CZ': [QuitLine('800 350 000')],
  'DE': [QuitLine('0800 8 31 31 31', label: 'BIÖG rauchfrei')],
  'EC': [QuitLine('171, option 2', dial: '171')],
  'FI': [QuitLine('0800 148 484')],
  'FR': [QuitLine('3989', label: 'Tabac Info Service')],
  'GB': [
    QuitLine('0300 123 1044', label: 'NHS Smokefree (England)'),
    QuitLine('0800 84 84 84', label: 'Quit Your Way (Scotland)'),
    QuitLine('0800 085 2219', label: 'Help Me Quit (Wales)'),
  ],
  'GE': [QuitLine('116 001')],
  'HK': [QuitLine('1833 183')],
  'HR': [QuitLine('0800 7999')],
  'HU': [QuitLine('+36 80 442 044')],
  'ID': [QuitLine('0800 177 6565')],
  'IE': [QuitLine('1800 201 203', label: 'HSE QUIT')],
  'IN': [QuitLine('1800 112 356')],
  'IS': [QuitLine('800 6030')],
  'IT': [QuitLine('800 554 088')],
  'JO': [QuitLine('06 500 4546')],
  'KG': [QuitLine('2103')],
  'KR': [QuitLine('1544-9030')],
  'LU': [QuitLine('8002 6767')],
  'LV': [QuitLine('6703 7333')],
  'MD': [QuitLine('0800 10001')],
  'MT': [QuitLine('8007 3333')],
  'MX': [QuitLine('01800 911 2000', label: 'Línea de la Vida')],
  'MY': [QuitLine('04 653 5999')],
  'NL': [QuitLine('0800 1995')],
  'NZ': [QuitLine('0800 778 778', label: 'Quitline')],
  'PH': [QuitLine('165364')],
  'PL': [QuitLine('801 108 108')],
  'RO': [QuitLine('0800 878 673')],
  'RU': [QuitLine('8-800-200-0-200')],
  'SA': [QuitLine('937')],
  'SE': [QuitLine('020-84 00 00')],
  'SG': [QuitLine('1800 438 2000', label: 'QuitLine')],
  'SI': [QuitLine('080 27 77')],
  'SK': [QuitLine('0850 111 682')],
  'TH': [QuitLine('1600')],
  'TM': [QuitLine('76-75-59')],
  'TO': [QuitLine('0800 333')],
  'TR': [
    QuitLine('171', label: 'ALO 171'),
    QuitLine('115', label: 'YEDAM'),
  ],
  'UA': [QuitLine('0-800-50-55-60')],
  'US': [QuitLine('1-800-784-8669', label: '1-800-QUIT-NOW')],
  'VN': [QuitLine('1800 6606')],
  'ZA': [QuitLine('011 720 3145')],
};
