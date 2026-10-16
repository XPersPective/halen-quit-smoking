"""Builds Play + App Store listing files for every locale from loc/data_*.py.

Each data module defines L = {lang_key: {...}} with keys:
  t        Play title / App Store name (<=30)
  s        Play short description (<=80); also App Store promotional text
  ios_sub  App Store subtitle (<=30)
  kw       App Store keywords, comma separated (<=100)
  slogan   feature graphic headline (<=40)
  sub      feature graphic sub line (<=60)
  intro    first paragraph
  b        list of 9 bullets
  ads      free/premium/ads paragraph
  med      medical disclaimer
  ui       app UI languages note
tr/en/de keep their hand-written full descriptions (full=...).

Run:  python tool/store_listing/build.py   (then gen_feature.py for the images)
Output goes to $APP_PUBLISHING_ROOT/apps/halen-quit-smoking/stores (default D:/AppPublishing).
Translations are first drafts: have a native speaker review before a wide rollout.
"""
import importlib, os, pathlib, sys

HERE = pathlib.Path(__file__).parent
ROOT = pathlib.Path(os.environ.get("APP_PUBLISHING_ROOT", "D:/AppPublishing")) / "apps/halen-quit-smoking/stores"
PLAY = ROOT / "google-play" / "metadata"
APPLE = ROOT / "app-store" / "metadata"

# Play locale -> data key
PLAY_LOCALES = {
    "af": "af", "ar": "ar", "az-AZ": "az", "be": "be", "bg": "bg", "bn-BD": "bn",
    "ca": "ca", "cs-CZ": "cs", "da-DK": "da", "de-DE": "de", "el-GR": "el",
    "en-GB": "en", "en-US": "en", "es-419": "es", "es-ES": "es", "es-US": "es",
    "et": "et", "eu-ES": "eu", "fa": "fa", "fi-FI": "fi", "fil": "fil",
    "fr-CA": "fr", "fr-FR": "fr", "gl-ES": "gl", "gu": "gu", "hi-IN": "hi",
    "hr": "hr", "hu-HU": "hu", "hy-AM": "hy", "id": "id", "is-IS": "is",
    "it-IT": "it", "iw-IL": "he", "ja-JP": "ja", "ka-GE": "ka", "kk": "kk",
    "kn-IN": "kn", "ko-KR": "ko", "ky-KG": "ky", "lo-LA": "lo", "lt": "lt",
    "lv": "lv", "mk-MK": "mk", "ml-IN": "ml", "mn-MN": "mn", "mr-IN": "mr",
    "ms": "ms", "my-MM": "my", "ne-NP": "ne", "nl-NL": "nl", "pa": "pa",
    "pl-PL": "pl", "pt-BR": "pt-BR", "pt-PT": "pt-PT", "ro": "ro", "ru-RU": "ru",
    "si-LK": "si", "sk": "sk", "sl": "sl", "sq": "sq", "sr": "sr", "sv-SE": "sv",
    "sw": "sw", "ta-IN": "ta", "te-IN": "te", "th": "th", "tr-TR": "tr",
    "uk": "uk", "ur": "ur", "vi": "vi", "zh-CN": "zh-CN", "zh-TW": "zh-TW",
    "zu": "zu",
}

# App Store locales Apple supports -> data key
APPLE_LOCALES = {
    "ar-SA": "ar", "bn-BD": "bn", "ca": "ca", "cs": "cs", "da": "da",
    "de-DE": "de", "el": "el", "en-GB": "en", "en-US": "en", "es-ES": "es",
    "es-MX": "es", "fi": "fi", "fr-CA": "fr", "fr-FR": "fr", "gu-IN": "gu",
    "he": "he", "hi": "hi", "hr": "hr", "hu": "hu", "id": "id", "it": "it",
    "ja": "ja", "kn-IN": "kn", "ko": "ko", "ml-IN": "ml", "mr-IN": "mr",
    "ms": "ms", "nl-NL": "nl", "pa-IN": "pa", "pl": "pl", "pt-BR": "pt-BR",
    "pt-PT": "pt-PT", "ro": "ro", "ru": "ru", "sk": "sk", "sl-SI": "sl",
    "sv": "sv", "ta-IN": "ta", "te-IN": "te", "th": "th", "tr": "tr",
    "uk": "uk", "ur-PK": "ur", "vi": "vi", "zh-Hans": "zh-CN", "zh-Hant": "zh-TW",
}

SUPPORT = "devcrazypenguin@gmail.com"
PRIVACY = "https://github.com/XPersPective/halen-quit-smoking/blob/master/PRIVACY_POLICY.md"
MARKETING = "https://github.com/XPersPective/halen-quit-smoking"


def load():
    sys.path.insert(0, str(HERE))
    data = {}
    for p in sorted(HERE.glob("data_*.py")):
        mod = importlib.import_module(p.stem)
        dup = set(data) & set(mod.L)
        assert not dup, f"duplicate keys {dup} in {p.name}"
        data.update(mod.L)
    return data


def full(d):
    if "full" in d:
        return d["full"].strip() + "\n"
    bullets = "\n".join("• " + x for x in d["b"])
    return f'{d["intro"]}\n\n{bullets}\n\n{d["ads"]}\n\n{d["med"]}\n{d["ui"]}\n'


def check(data):
    bad = []
    keys = set(PLAY_LOCALES.values()) | set(APPLE_LOCALES.values())
    for k in sorted(keys):
        if k not in data:
            bad.append(f"{k}: missing language data")
            continue
        d = data[k]
        f = full(d)
        for field, lim, val in [
            ("title", 30, d["t"]), ("short", 80, d["s"]), ("full", 4000, f),
            ("ios_sub", 30, d["ios_sub"]), ("keywords", 100, d["kw"]),
            ("promo", 170, d["s"]), ("slogan", 42, d["slogan"]), ("sub", 64, d["sub"]),
        ]:
            if len(val) > lim:
                bad.append(f"{k}: {field} {len(val)}>{lim}: {val[:50]}")
        if "full" not in d and len(d.get("b", [])) != 9:
            bad.append(f"{k}: bullets={len(d.get('b', []))}")
    return bad


def write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8", newline="\n")


def main():
    data = load()
    bad = check(data)
    if bad:
        print("\n".join(bad))
        sys.exit(1)
    for loc, key in PLAY_LOCALES.items():
        d = data[key]
        base = PLAY / loc
        write(base / "title.txt", d["t"])
        write(base / "short_description.txt", d["s"])
        write(base / "full_description.txt", full(d))
    for loc, key in APPLE_LOCALES.items():
        d = data[key]
        base = APPLE / loc
        write(base / "name.txt", d["t"])
        write(base / "subtitle.txt", d["ios_sub"])
        write(base / "keywords.txt", d["kw"])
        write(base / "promotional_text.txt", d["s"])
        write(base / "description.txt", full(d))
        write(base / "support_url.txt", MARKETING)
        write(base / "marketing_url.txt", MARKETING)
        write(base / "privacy_url.txt", PRIVACY)
    print(f"ok: {len(PLAY_LOCALES)} play, {len(APPLE_LOCALES)} app-store locales")


if __name__ == "__main__":
    main()
