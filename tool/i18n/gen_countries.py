"""Generates assets/data/countries.json: localized country names (CLDR via
Babel) for every Play Store language Halen supports.

    pip install babel
    python tool/i18n/gen_countries.py

Output: {"codes": ["AD", ...], "currency": {"AD": "EUR"}, "names": {"<app locale tag>": {"AD": "..."}}}
Only ISO 3166-1 alpha-2 countries; CLDR groupings/pseudo regions removed.
"""
import json
import os
import sys

from babel import Locale
from babel.numbers import get_territory_currencies

# app locale tag (Play listing tag, normalised) -> Babel locale id
LOCALES = {
    "af": "af", "ar": "ar", "az": "az", "be": "be", "bg": "bg", "bn": "bn",
    "ca": "ca", "cs": "cs", "da": "da", "de": "de", "el": "el", "en": "en",
    "en-GB": "en_GB", "es": "es", "es-419": "es_419", "es-US": "es_US",
    "et": "et", "eu": "eu", "fa": "fa", "fi": "fi", "fil": "fil", "fr": "fr",
    "fr-CA": "fr_CA", "gl": "gl", "gu": "gu", "he": "he", "hi": "hi",
    "hr": "hr", "hu": "hu", "hy": "hy", "id": "id", "is": "is", "it": "it",
    "ja": "ja", "ka": "ka", "kk": "kk", "kn": "kn", "ko": "ko", "ky": "ky",
    "lo": "lo", "lt": "lt", "lv": "lv", "mk": "mk", "ml": "ml", "mn": "mn",
    "mr": "mr", "ms": "ms", "my": "my", "ne": "ne", "nl": "nl", "pa": "pa",
    "pl": "pl", "pt": "pt", "pt-PT": "pt_PT", "ro": "ro", "ru": "ru",
    "si": "si", "sk": "sk", "sl": "sl", "sq": "sq", "sr": "sr", "sv": "sv",
    "sw": "sw", "ta": "ta", "te": "te", "th": "th", "tr": "tr", "uk": "uk",
    "ur": "ur", "vi": "vi", "zh": "zh", "zh-TW": "zh_Hant_TW", "zu": "zu",
}
NOT_COUNTRIES = {
    "AC", "CP", "CQ", "DG", "EA", "EU", "EZ", "IC", "QO", "TA", "UN", "XA",
    "XB", "ZZ",
}

en = Locale.parse("en").territories
codes = sorted(
    c for c in en
    if len(c) == 2 and c.isalpha() and c.isupper() and c not in NOT_COUNTRIES
)
currency = {}
for c in codes:
    cur = get_territory_currencies(c, tender=True)
    if cur:
        currency[c] = cur[0]
names = {}
for tag, babel_id in LOCALES.items():
    terr = Locale.parse(babel_id).territories
    names[tag] = {c: terr.get(c, en[c]) for c in codes}
out = os.path.join(os.path.dirname(__file__), "..", "..", "assets", "data",
                   "countries.json")
with open(out, "w", encoding="utf-8", newline="\n") as f:
    json.dump({"codes": codes, "currency": currency, "names": names}, f, ensure_ascii=False,
              separators=(",", ":"))
print(len(codes), "countries,", len(names), "languages,",
      os.path.getsize(out) // 1024, "KB")
