# -*- coding: utf-8 -*-
"""Rewrites existing ARB values (and adds new ones) across all three locales.

add_strings.py only appends; plain-language rewrites of existing copy need to
replace values in place, and have to land in all three files together or the
app ships one language saying "oxygen debt" and another saying something
else.
"""
import collections
import io
import json
import sys

VALUES = {}
META = {}


def put(key, en, tr, de, placeholders=None):
    VALUES[key] = {'en': en, 'tr': tr, 'de': de}
    if placeholders is not None:
        META[key] = {'placeholders': placeholders}


# --- Item 6: jargon out ------------------------------------------------------
# "Oxygen debt", "all-day baseline" and "particle load" were the model's own
# vocabulary leaking into the interface. Nobody outside the model knows what
# a baseline is; everybody knows what carbon monoxide and tar are.
put('loadCarbonMonoxide', 'Carbon monoxide in your blood',
    'Kandaki karbonmonoksit', 'Kohlenmonoxid im Blut')
put('statusPageOxygen', 'Carbon monoxide in your blood',
    'Kandaki karbonmonoksit', 'Kohlenmonoxid im Blut')
put('bodyLoadCoDrop',
    'Carbon monoxide in your blood is {percent}% below its peak.',
    'Kandaki karbonmonoksit zirvesinin %{percent} altında.',
    'Kohlenmonoxid im Blut liegt {percent} % unter dem Höchstwert.',
    {'percent': {'type': 'int'}})
put('loadNicotineBaseline', 'Nicotine built up in your body',
    'Vücutta birikmiş nikotin', 'Im Körper angesammeltes Nikotin')
put('statusPageBaseline', 'Nicotine built up in your body',
    'Vücutta birikmiş nikotin', 'Im Körper angesammeltes Nikotin')
put('componentNicotineBaselineFall', 'Fall in built-up nicotine',
    'Birikmiş nikotinin azalması', 'Rückgang des angesammelten Nikotins')
put('loadTar', 'Tar build-up', 'Katran birikimi', 'Teeransammlung')
put('statusPageParticles', 'Tar build-up', 'Katran birikimi',
    'Teeransammlung')
put('lungsMistLabel', 'Tar build-up, compared with your usual',
    'Katran birikimi, alışık olduğun düzeye göre',
    'Teeransammlung, verglichen mit deinem Üblichen')
put('howBodyLoadBody',
    'Each curve is C(t) = sum of dose x 2^(-time since / half-life), fed '
    'only by the times you logged. Half-lives: nicotine 2 h, nicotine built '
    'up in your body 16 h (the cotinine it turns into), carbon monoxide '
    '4.5 h, tar build-up 30 days (representative).',
    'Her eğri C(t) = Σ doz × 2^(−geçen süre / yarı ömür) formülüdür ve '
    'yalnızca senin kaydettiğin saatlerden beslenir. Yarı ömürler: nikotin '
    '2 sa, vücutta birikmiş nikotin 16 sa (dönüştüğü kotinin), '
    'karbonmonoksit 4,5 sa, katran birikimi 30 gün (temsilî).',
    'Jede Kurve ist C(t) = Summe aus Dosis × 2^(−vergangene Zeit / '
    'Halbwertszeit) und speist sich nur aus deinen Einträgen. '
    'Halbwertszeiten: Nikotin 2 Std., angesammeltes Nikotin 16 Std. (das '
    'daraus entstehende Cotinin), Kohlenmonoxid 4,5 Std., Teeransammlung 30 '
    'Tage (repräsentativ).')

# --- Item 7: "İçer" read as "it contains" ------------------------------------
put('sosBreathingIn', 'Breathe in', 'Nefes al', 'Einatmen')
put('sosBreathingHold', 'Hold', 'Nefesini tut', 'Halten')
put('sosBreathingOut', 'Breathe out', 'Nefes ver', 'Ausatmen')

# --- Item 11: "x times" becomes a percentage ---------------------------------
# A risk ratio of 2.0 is "100% higher", not "2x": people read multipliers
# badly and read percentages well. The number is the same finding.
put('organImpactRelative',
    'Risk about {percent}% higher than in someone who never smoked',
    'Hiç içmemiş birine göre risk yaklaşık %{percent} daha yüksek',
    'Risiko etwa {percent} % höher als bei jemandem, der nie geraucht hat',
    {'percent': {'type': 'int'}})
put('medicinesRatioPlacebo',
    'Raises the chance of quitting by about {percent}% compared with a dummy '
    'treatment, across trials',
    'Denemelerde bırakma şansını sahte tedaviye göre yaklaşık %{percent} '
    'artırıyor',
    'Erhöht die Aufhörchance über Studien hinweg um etwa {percent} % '
    'gegenüber Scheinbehandlung',
    {'percent': {'type': 'int'}})
put('medicinesRatioSingle',
    'Raises the chance of quitting by about {percent}% compared with one '
    'form alone, across trials',
    'Denemelerde bırakma şansını tek form kullanmaya göre yaklaşık '
    '%{percent} artırıyor',
    'Erhöht die Aufhörchance über Studien hinweg um etwa {percent} % '
    'gegenüber einer Einzelform',
    {'percent': {'type': 'int'}})

# --- Item 8: the two buttons, and what they say ------------------------------
# All-caps "I SMOKED" on the brightest colour in the app was the most
# inviting control on the screen. It is still one tap — logging must stay
# easy or people stop logging — but it no longer asks to be pressed.
put('ctaSmoked', 'I smoked one', 'Bir sigara içtim', 'Ich habe eine geraucht')
put('ctaResisted', 'I resisted it', 'İçmedim, atlattım',
    'Ich habe widerstanden')

# --- Item 9: after a cigarette ----------------------------------------------
put('smokedHeadline0', 'That one is done. The next one does not have to be.',
    'Bu geçti. Bir sonrakinin olması gerekmiyor.',
    'Die ist vorbei. Die nächste muss nicht sein.')
put('smokedHeadline1', 'A little sad, and still on the way.',
    'Biraz üzücü, ama hâlâ yoldasın.',
    'Ein bisschen traurig, und trotzdem unterwegs.')
put('smokedHeadline2', 'Your body starts clearing this one right now.',
    'Vücudun bunu şu an temizlemeye başladı.',
    'Dein Körper baut diese hier ab jetzt schon ab.')
put('smokedHeadline3', 'Not a failure. The next hour is yours.',
    'Başarısızlık değil. Önümüzdeki bir saat senin.',
    'Kein Scheitern. Die nächste Stunde gehört dir.')
put('smokedAdvice0',
    'When the next urge comes, wait five minutes before deciding. Most urges '
    'pass inside that.',
    'Bir sonraki istek geldiğinde karar vermeden beş dakika bekle. Çoğu '
    'istek o süre içinde geçer.',
    'Wenn das nächste Verlangen kommt, warte fünf Minuten, bevor du '
    'entscheidest. Die meisten vergehen in dieser Zeit.')
put('smokedAdvice1',
    'Drink a glass of water now and get up for a minute. Changing what your '
    'hands and feet are doing weakens the next urge.',
    'Şimdi bir bardak su iç ve bir dakika kalk. Ellerinin ve ayaklarının ne '
    'yaptığını değiştirmek bir sonraki isteği zayıflatır.',
    'Trink jetzt ein Glas Wasser und steh kurz auf. Was Hände und Füße tun, '
    'zu ändern, schwächt das nächste Verlangen.')
put('smokedAdvice2',
    'Each cigarette you skip lets the carbon monoxide in your blood fall '
    'further. Try to make this the last one today.',
    'Atladığın her sigara kandaki karbonmonoksiti biraz daha düşürür. Bunu '
    'bugünün son sigarası yapmayı dene.',
    'Jede ausgelassene Zigarette senkt das Kohlenmonoxid im Blut weiter. '
    'Versuch, diese zur letzten heute zu machen.')
put('smokedAdvice3',
    'Stopping is the single best thing you can do for your health. You do '
    'not have to do it today, but every skipped one counts.',
    'Bırakmak sağlığın için yapabileceğin en iyi tek şey. Bugün yapmak '
    'zorunda değilsin ama atladığın her biri sayılıyor.',
    'Aufhören ist das Beste, was du für deine Gesundheit tun kannst. Nicht '
    'unbedingt heute, aber jede ausgelassene zählt.')

# --- Item 1: the welcome screen ---------------------------------------------
put('splashContinue', 'Continue', 'Devam et', 'Weiter')


def main():
    for loc in ('en', 'tr', 'de'):
        path = 'lib/l10n/app_%s.arb' % loc
        data = json.load(io.open(path, encoding='utf-8'),
                         object_pairs_hook=collections.OrderedDict)
        changed = 0
        for key, values in VALUES.items():
            if data.get(key) != values[loc]:
                data[key] = values[loc]
                changed += 1
            if loc == 'en' and key in META:
                data['@' + key] = META[key]
        io.open(path, 'w', encoding='utf-8').write(
            json.dumps(data, ensure_ascii=False, indent=2) + '\n')
        sys.stdout.write('%s: %d set\n' % (loc, changed))


if __name__ == '__main__':
    main()
