# -*- coding: utf-8 -*-
"""Appends new ARB keys to the three locale files, in order, idempotently.

Kept as a script rather than hand-editing three JSON files because the ARB
files are large and a hand edit that lands a key in only two of them fails
loudly at build time and silently at runtime.
"""
import collections
import io
import json
import sys

STRINGS = {}
META = {}


def add(key, en, tr, de, placeholders=None):
    STRINGS[key] = {'en': en, 'tr': tr, 'de': de}
    if placeholders:
        META[key] = {'placeholders': placeholders}


# --- Phase 2: the first sixty seconds ---------------------------------------

add('obWhyTitle', 'Why do you want to stop?',
    'Neden bırakmak istiyorsun?', 'Warum willst du aufhören?')
add('obWhyHint',
    'Pick the one that is truest today. Halen shows it back to you when a '
    'craving hits.',
    'Bugün en doğru geleni seç. Halen, istek geldiğinde bunu sana geri '
    'gösterir.',
    'Wähl das, was heute am ehesten stimmt. Halen zeigt es dir wieder, wenn '
    'das Verlangen kommt.')
add('reasonChildren', 'For my children', 'Çocuklarım için', 'Für meine Kinder')
add('reasonHealth', 'For my health', 'Sağlığım için', 'Für meine Gesundheit')
add('reasonMoney', 'For the money', 'Para için', 'Wegen des Geldes')
add('reasonFreedom', 'To not be owned by it',
    'Bana hükmetmesin diye', 'Um nicht beherrscht zu werden')
add('reasonSmell', 'For the smell', 'Koku için', 'Wegen des Geruchs')
add('reasonFitness', 'To breathe better', 'Daha iyi nefes almak için',
    'Um besser zu atmen')
add('reasonSomeoneAsked', 'Someone asked me to',
    'Biri benden istedi', 'Jemand hat mich darum gebeten')

add('resultTitle', 'This is where you are starting',
    'Başladığın yer burası', 'Hier stehst du am Anfang')
add('resultSubtitle',
    'All of it worked out from what you just told us.',
    'Hepsi az önce söylediklerinden hesaplandı.',
    'Alles daraus berechnet, was du gerade angegeben hast.')
add('resultPerYearPacks', 'Packs a year', 'Yılda paket', 'Packungen pro Jahr')
add('resultPerYearMoney', 'A year', 'Yılda', 'Pro Jahr')
add('resultPerYearTime', 'A year, smoking', 'Yılda, içerek',
    'Pro Jahr, mit Rauchen')
add('resultDependenceTitle', 'How much your body is leaning on it',
    'Vücudun buna ne kadar yaslanmış', 'Wie stark dein Körper daran hängt')
add('resultDependenceLow', 'Light', 'Hafif', 'Leicht')
add('resultDependenceModerate', 'Moderate', 'Orta', 'Mittel')
add('resultDependenceHigh', 'Strong', 'Güçlü', 'Stark')
add('resultDependenceExplain',
    'From two questions: how many a day, and how soon after waking. It sets '
    'how gently your plan starts — nothing else.',
    'İki sorudan: günde kaç tane ve uyandıktan ne kadar sonra. Yalnızca '
    'planının ne kadar yumuşak başlayacağını belirler, başka bir şeyi değil.',
    'Aus zwei Fragen: wie viele pro Tag und wie schnell nach dem Aufwachen. '
    'Das bestimmt nur, wie sanft dein Plan startet.')
add('resultFirst72Title', 'What the first 72 hours look like',
    'İlk 72 saat neye benzer', 'So sehen die ersten 72 Stunden aus')
add('resultFirst7220m', '20 minutes', '20 dakika', '20 Minuten')
add('resultFirst7220mBody', 'Heart rate and blood pressure start to fall.',
    'Nabız ve tansiyon düşmeye başlar.',
    'Puls und Blutdruck beginnen zu sinken.')
add('resultFirst7212h', '12 hours', '12 saat', '12 Stunden')
add('resultFirst7212hBody',
    'Carbon monoxide clears; more oxygen reaches your blood.',
    'Karbonmonoksit temizlenir; kana daha çok oksijen gider.',
    'Kohlenmonoxid verschwindet; mehr Sauerstoff gelangt ins Blut.')
add('resultFirst7248h', '48-72 hours', '48-72 saat', '48-72 Stunden')
add('resultFirst7248hBody',
    'The hardest stretch, and the peak of it. Taste and smell start coming '
    'back.',
    'En zor bölüm ve tepesi burada. Tat ve koku geri gelmeye başlar.',
    'Der härteste Abschnitt und sein Höhepunkt. Geschmack und Geruch kommen '
    'zurück.')
add('resultStart', 'Start', 'Başla', 'Los geht es')
add('resultSourceNote',
    'Milestones from WHO and CDC population data.',
    'Kilometre taşları WHO ve CDC popülasyon verisinden.',
    'Meilensteine aus WHO- und CDC-Bevölkerungsdaten.')

# --- Phase 3: the clinical skeleton -----------------------------------------

add('quitPlanTitle', 'Your quit plan', 'Bırakma planın', 'Dein Ausstiegsplan')
add('quitPlanSubtitle',
    'Five things that make an attempt stick. None of them are compulsory.',
    'Bir denemeyi tutturan beş şey. Hiçbiri zorunlu değil.',
    'Fünf Dinge, an denen ein Versuch hält. Keines davon ist Pflicht.')
add('quitPlanReadiness', '{done} of {total} ready',
    '{total} adımdan {done} tamam', '{done} von {total} bereit',
    placeholders={'done': {'type': 'int'}, 'total': {'type': 'int'}})

add('quitDateTitle', 'A date to stop', 'Bırakma tarihi', 'Ein Datum zum Aufhören')
add('quitDateNone', 'Not set yet', 'Henüz belirlenmedi', 'Noch nicht gesetzt')
add('quitDateSet', 'Pick a date', 'Tarih seç', 'Datum wählen')
add('quitDateChange', 'Move the date', 'Tarihi taşı', 'Datum verschieben')
add('quitDateClear', 'Remove the date', 'Tarihi kaldır', 'Datum entfernen')
add('quitDateWhy',
    'Cutting down works when it is aimed at a day. Without one, reducing '
    'tends to settle into a habit of its own.',
    'Azaltmak, bir güne nişan alındığında işe yarar. Tarih olmadan azaltma '
    'kendi başına bir alışkanlığa yerleşir.',
    'Reduzieren wirkt, wenn es auf einen Tag zielt. Ohne Datum wird daraus '
    'meist eine eigene Gewohnheit.')
add('quitDateIn', 'In {days} days', '{days} gün sonra', 'In {days} Tagen',
    placeholders={'days': {'type': 'int'}})
add('quitDateTomorrow', 'Tomorrow', 'Yarın', 'Morgen')
add('quitDateToday', 'Today', 'Bugün', 'Heute')
add('quitDatePassed', 'Day {days}', '{days}. gün', 'Tag {days}',
    placeholders={'days': {'type': 'int'}})
add('quitDateTooSoonNote',
    'Under three days leaves no room to get ready — to get medicine, tell '
    'someone, clear the house.',
    'Üç günden azı hazırlanmaya yer bırakmaz: ilaç almak, birine söylemek, '
    'evi temizlemek.',
    'Unter drei Tagen bleibt keine Zeit zur Vorbereitung — Medikament holen, '
    'jemandem sagen, die Wohnung räumen.')
add('quitDateTooFarNote',
    'Past six weeks a date stops working as a commitment. Nearer is better.',
    'Altı haftayı geçince tarih bir söz olmaktan çıkar. Yakın olan daha iyi.',
    'Jenseits von sechs Wochen wirkt ein Datum nicht mehr als Zusage. Näher '
    'ist besser.')
add('quitDateMovedNote', 'Moved {count} times so far. That is allowed.',
    'Şimdiye dek {count} kez taşındı. Bu serbest.',
    'Bisher {count} mal verschoben. Das ist erlaubt.',
    placeholders={'count': {'type': 'int'}})

add('medicinesTitle', 'Medicines that help',
    'Yardımcı ilaçlar', 'Medikamente, die helfen')
add('medicinesLead',
    'These roughly double the chance an attempt succeeds. It is the most '
    'effective help available, and most people never try it.',
    'Bunlar bir denemenin tutma ihtimalini kabaca ikiye katlar. Elde '
    'edilebilecek en etkili yardım bu ve çoğu kişi hiç denemiyor.',
    'Sie verdoppeln die Erfolgschance eines Versuchs etwa. Es ist die '
    'wirksamste verfügbare Hilfe — und die meisten probieren sie nie.')
add('medicinesOtc', 'Available at a pharmacy',
    'Eczaneden alınabilir', 'In der Apotheke erhältlich')
add('medicinesPrescription', 'Ask a doctor',
    'Hekime sor', 'Ärztlich verschreiben lassen')
add('medicinesHowItWorks', 'How it works', 'Nasıl çalışır', 'Wie es wirkt')
add('medicinesTypicalUse', 'How it is used', 'Nasıl kullanılır',
    'Wie es angewendet wird')
add('medicinesCommonMistake', 'The usual mistake',
    'En sık yapılan hata', 'Der übliche Fehler')
add('medicinesRatioPlacebo',
    '{ratio}x the quit rate of a dummy treatment, across trials',
    'Denemelerde, sahte tedaviye göre bırakma oranı {ratio} kat',
    '{ratio}-fache Aufhörrate gegenüber Scheinbehandlung, über Studien hinweg',
    placeholders={'ratio': {'type': 'String'}})
add('medicinesRatioSingle',
    '{ratio}x the quit rate of one form used alone, across trials',
    'Denemelerde, tek form kullanmaya göre bırakma oranı {ratio} kat',
    '{ratio}-fache Aufhörrate gegenüber einer Einzelform, über Studien hinweg',
    placeholders={'ratio': {'type': 'String'}})
add('medicinesCombinationSuggestion',
    'Given how much you smoke, the usual starting point is a patch plus one '
    'fast form. Worth asking a pharmacist about.',
    'İçtiğin miktara göre olağan başlangıç noktası bant artı hızlı bir '
    'form. Eczacına sormaya değer.',
    'Bei deiner Menge ist der übliche Einstieg ein Pflaster plus eine '
    'schnelle Form. Frag in der Apotheke danach.')
add('medicinesDisclaimer',
    'Halen is not a prescriber and sells nothing. Doses, suitability and '
    'interactions are for a pharmacist or a doctor to judge — especially in '
    'pregnancy, heart disease or a psychiatric condition.',
    'Halen reçete yazmaz ve hiçbir şey satmaz. Doz, uygunluk ve etkileşim '
    'kararı eczacıya ya da hekime aittir — özellikle gebelikte, kalp '
    'hastalığında ve psikiyatrik durumlarda.',
    'Halen verschreibt nichts und verkauft nichts. Dosis, Eignung und '
    'Wechselwirkungen beurteilen Apotheke oder Ärztin — besonders in '
    'Schwangerschaft, bei Herzkrankheit oder psychiatrischer Erkrankung.')

add('copingTitle', 'The hard moments',
    'Zor anlar', 'Die schwierigen Momente')
add('copingLead',
    'Name what you will do instead, before you are in it. Deciding in the '
    'moment is the part that fails.',
    'İçine düşmeden önce ne yapacağını yaz. O an karar vermek, işin '
    'tutmayan kısmı.',
    'Schreib auf, was du stattdessen tust, bevor du drinsteckst. Im Moment '
    'zu entscheiden ist der Teil, der scheitert.')
add('copingHint', 'What will you do instead?',
    'Onun yerine ne yapacaksın?', 'Was tust du stattdessen?')
add('copingSaved', 'Saved', 'Kaydedildi', 'Gespeichert')
add('copingEmpty',
    'Your plan is empty. Even one line for your worst moment is worth having.',
    'Planın boş. En zor anın için tek satır bile olsa değer.',
    'Dein Plan ist leer. Schon eine Zeile für deinen schwersten Moment lohnt.')

add('notAPuffTitle', 'Not a single puff',
    'Tek bir nefes bile yok', 'Kein einziger Zug')
add('notAPuffBody',
    'The rule is not about willpower. One cigarette re-teaches the craving '
    'that smoking still works, and that is what turns one into ten.',
    'Kural irade meselesi değil. Tek bir sigara, isteğe sigaranın hâlâ işe '
    'yaradığını yeniden öğretir; biri ona dönüştüren şey budur.',
    'Die Regel ist keine Willensfrage. Eine Zigarette lehrt das Verlangen '
    'neu, dass Rauchen noch funktioniert — daraus werden zehn.')
add('notAPuffAccept', 'I take the rule', 'Kuralı kabul ediyorum',
    'Ich nehme die Regel an')
add('notAPuffTaken', 'Rule taken', 'Kural alındı', 'Regel angenommen')

add('supportPersonTitle', 'Someone who knows',
    'Bilen biri', 'Jemand, der Bescheid weiß')
add('supportPersonBody',
    'Telling one person raises the odds. First name is enough — Halen never '
    'reads your contacts and stores nothing else.',
    'Bir kişiye söylemek şansı artırır. Sadece ad yeter — Halen rehberini '
    'hiç okumaz ve başka bir şey saklamaz.',
    'Einer Person Bescheid zu sagen erhöht die Chancen. Der Vorname reicht — '
    'Halen liest keine Kontakte und speichert nichts weiter.')
add('supportPersonHint', 'First name', 'Ad', 'Vorname')
add('supportPersonDraft',
    'Something you could send: "I am stopping smoking on {date}. If I get '
    'unbearable, that is why. Ask me how it is going."',
    'Gönderebileceğin bir şey: "{date} tarihinde sigarayı bırakıyorum. '
    'Çekilmez olursam sebebi bu. Ara sıra nasıl gittiğini sor."',
    'Etwas, das du senden könntest: „Ich höre am {date} mit dem Rauchen auf. '
    'Wenn ich unausstehlich werde, liegt es daran. Frag mich, wie es läuft."',
    placeholders={'date': {'type': 'String'}})
add('supportPersonCopy', 'Copy the message', 'Mesajı kopyala',
    'Nachricht kopieren')
add('supportPersonCopied', 'Copied', 'Kopyalandı', 'Kopiert')

add('moodCheckTitle', 'Two questions about your mood',
    'Ruh hâlin hakkında iki soru', 'Zwei Fragen zu deiner Stimmung')
add('moodCheckLead',
    'Over the last two weeks, how often have you been bothered by...',
    'Son iki haftada şunlar seni ne sıklıkta rahatsız etti...',
    'Wie oft hat dich in den letzten zwei Wochen Folgendes belastet...')
add('moodCheckQ1', 'Little interest or pleasure in doing things',
    'Bir şeyleri yapmaya karşı ilgisizlik veya keyifsizlik',
    'Wenig Interesse oder Freude an Dingen')
add('moodCheckQ2', 'Feeling down, depressed or hopeless',
    'Kendini kötü, çökmüş veya umutsuz hissetmek',
    'Niedergeschlagenheit, Schwermut oder Hoffnungslosigkeit')
add('moodCheckNever', 'Not at all', 'Hiç', 'Überhaupt nicht')
add('moodCheckSomeDays', 'Several days', 'Birkaç gün', 'An einzelnen Tagen')
add('moodCheckMostDays', 'More than half the days', 'Günlerin yarısından fazla',
    'An mehr als der Hälfte der Tage')
add('moodCheckEveryDay', 'Nearly every day', 'Neredeyse her gün',
    'Beinahe jeden Tag')
add('moodCheckWhy',
    'Stopping can bring low mood to the surface in people prone to it. This '
    'is a screen, not a diagnosis, and nothing here leaves your phone.',
    'Bırakmak, yatkın kişilerde çökkünlüğü yüzeye çıkarabilir. Bu bir '
    'tarama, tanı değil; buradaki hiçbir şey telefonundan çıkmaz.',
    'Aufhören kann bei anfälligen Menschen gedrückte Stimmung hervorholen. '
    'Das ist ein Screening, keine Diagnose, und nichts verlässt dein Handy.')
add('moodCheckResultClear',
    'Nothing here suggests you need to change course. Ask again whenever you '
    'want.',
    'Burada rotanı değiştirmen gerektiğini gösteren bir şey yok. İstediğin '
    'zaman yeniden sorabilirsin.',
    'Nichts deutet darauf hin, dass du etwas ändern musst. Frag jederzeit '
    'erneut.')
add('moodCheckResultTalk',
    'This score is at the level where talking to a doctor is worth doing — '
    'not because stopping is wrong for you, but because low mood is treatable '
    'and easier to carry when it is treated.',
    'Bu puan, bir hekimle konuşmaya değer düzeyde — bırakmak sana yanlış '
    'geldiği için değil, çökkünlük tedavi edilebilir olduğu ve tedavi '
    'edildiğinde taşıması kolaylaştığı için.',
    'Dieser Wert liegt in dem Bereich, in dem ein Arztgespräch sinnvoll ist — '
    'nicht weil Aufhören falsch für dich wäre, sondern weil gedrückte '
    'Stimmung behandelbar ist.')
add('moodCheckDone', 'Done', 'Bitti', 'Fertig')

add('slipTitle', 'That was one cigarette',
    'Bu bir sigaraydı', 'Das war eine Zigarette')
add('slipBody',
    'One is a slip, not the end of the attempt. What decides the next week '
    'is what you do in the next hour.',
    'Bir tane kaymadır, denemenin sonu değil. Önümüzdeki haftayı belirleyen '
    'şey, önümüzdeki bir saatte yaptığın.',
    'Eine ist ein Ausrutscher, nicht das Ende. Was die nächste Woche '
    'entscheidet, ist die nächste Stunde.')
add('slipAction', 'Throw the rest away, and go back to the plan now — not '
    'tomorrow, not Monday.',
    'Kalanı at ve şimdi plana dön — yarın değil, pazartesi değil.',
    'Wirf den Rest weg und geh jetzt zum Plan zurück — nicht morgen, nicht '
    'am Montag.')
add('slipClusteringTitle', 'This is getting harder',
    'Bu zorlaşıyor', 'Es wird schwerer')
add('slipClusteringBody',
    'Several in a week usually means the situation is stronger than the '
    'plan, not that you are weak. This is the moment medicine helps most.',
    'Bir haftada birkaç tane, genelde durumun plandan güçlü olduğu anlamına '
    'gelir; zayıf olduğun değil. İlacın en çok yardım ettiği an tam burası.',
    'Mehrere in einer Woche heißt meist, die Situation ist stärker als der '
    'Plan — nicht, dass du schwach bist. Jetzt hilft Medikation am meisten.')
add('slipRelapseTitle', 'The attempt has slipped back',
    'Deneme geri kaydı', 'Der Versuch ist zurückgerutscht')
add('slipRelapseBody',
    'Most people who stop for good have done this several times first. The '
    'attempt that works is usually not the first one.',
    'Kalıcı bırakanların çoğu bunu birkaç kez yaşadı. Tutan deneme, genelde '
    'ilk deneme değildir.',
    'Die meisten, die dauerhaft aufhören, haben das mehrfach erlebt. Der '
    'Versuch, der hält, ist selten der erste.')
add('slipSetNewDate', 'Set a new date', 'Yeni tarih belirle',
    'Neues Datum setzen')
add('slipSeeMedicines', 'See what medicine could do',
    'İlacın ne yapabileceğine bak', 'Sieh, was Medikamente können')

add('quitDayTitle', 'Today is the day', 'Bugün o gün', 'Heute ist der Tag')
add('quitDayLead',
    'The first day is mostly logistics. Here is the whole of it.',
    'İlk gün çoğunlukla lojistik. Tamamı burada.',
    'Der erste Tag ist vor allem Logistik. Hier ist das Ganze.')
add('quitDayMorning', 'This morning', 'Bu sabah', 'Heute Morgen')
add('quitDayMorningBody',
    'Throw away every cigarette, lighter and ashtray you own. Not hidden — '
    'gone.',
    'Sahip olduğun her sigarayı, çakmağı ve küllüğü at. Saklama — yok et.',
    'Wirf jede Zigarette, jedes Feuerzeug und jeden Aschenbecher weg. Nicht '
    'verstecken — weg.')
add('quitDayAfternoon', 'This afternoon', 'Bu öğleden sonra',
    'Heute Nachmittag')
add('quitDayAfternoonBody',
    'The first cravings come in waves of a few minutes. Walk, water, breathe '
    '— they pass whether or not you smoke.',
    'İlk istekler birkaç dakikalık dalgalar hâlinde gelir. Yürü, su iç, nefes '
    'al — içsen de içmesen de geçerler.',
    'Die ersten Schübe kommen in Wellen von wenigen Minuten. Geh, trink '
    'Wasser, atme — sie gehen vorbei, ob du rauchst oder nicht.')
add('quitDayEvening', 'Tonight', 'Bu akşam', 'Heute Abend')
add('quitDayEveningBody',
    'Evening is the hardest hour of day one. Change what you do at that hour, '
    'not just what you hold.',
    'Akşam, birinci günün en zor saatidir. O saatte sadece elinde tuttuğunu '
    'değil, ne yaptığını da değiştir.',
    'Der Abend ist die härteste Stunde von Tag eins. Ändere, was du in dieser '
    'Stunde tust — nicht nur, was du in der Hand hältst.')
add('quitDayReasonReminder', 'You said you were doing this {reason}.',
    'Bunu şu sebeple yaptığını söylemiştin: {reason}.',
    'Du hast gesagt, du tust das: {reason}.',
    placeholders={'reason': {'type': 'String'}})

add('helplineTitle', 'A person on the phone',
    'Telefonda bir insan', 'Ein Mensch am Telefon')
add('helplineBody',
    'Quitlines work — talking to a trained counsellor raises the odds on its '
    'own.',
    'Bırakma hatları işe yarar — eğitimli bir danışmanla konuşmak tek başına '
    'şansı artırır.',
    'Beratungstelefone wirken — ein Gespräch mit geschulten Beratenden '
    'erhöht die Chancen für sich genommen.')

# --- Phase 4: one flow for the numbers --------------------------------------

add('statusTitle', 'Where you are', 'Neredesin', 'Wo du stehst')
add('statusSwipeHint', 'Swipe for the next one',
    'Sonraki için kaydır', 'Für das Nächste wischen')
add('statusOpen', 'See all your numbers', 'Bütün sayılarına bak',
    'Alle deine Zahlen ansehen')
add('statusPageNicotine', 'Nicotine', 'Nikotin', 'Nikotin')
add('statusPageOxygen', 'Oxygen debt', 'Oksijen borcu', 'Sauerstoffschuld')
add('statusPageBaseline', 'All-day baseline', 'Gün boyu zemin',
    'Grundpegel über den Tag')
add('statusPageParticles', 'Particle load', 'Partikül yükü', 'Partikellast')
add('statusPageProgress', 'Progress score', 'İlerleme puanı',
    'Fortschrittswert')
add('statusPageHarm', 'Harm load', 'Zarar yükü', 'Schadenslast')
add('statusPageMoney', 'Money', 'Para', 'Geld')
add('statusPageTime', 'Time', 'Zaman', 'Zeit')
add('statusNeedsData',
    'A few more records and this one draws itself.',
    'Birkaç kayıt daha, bu kendi kendine çizilir.',
    'Noch ein paar Einträge, dann zeichnet sich das von selbst.')

# --- Phase 5: the moments that keep people ----------------------------------

add('celebrateTitle', 'That is a real one',
    'Bu gerçek bir tane', 'Das ist ein echter')
add('celebrateClose', 'Keep going', 'Devam', 'Weiter')
add('celebrateDay1', 'One full day', 'Tam bir gün', 'Ein ganzer Tag')
add('celebrateDay3', 'Three days — past the peak',
    'Üç gün — tepeyi geçtin', 'Drei Tage — über den Höhepunkt')
add('celebrateWeek1', 'One week', 'Bir hafta', 'Eine Woche')
add('celebrateMonth1', 'One month', 'Bir ay', 'Ein Monat')
add('celebrateResisted100', '100 cravings ridden out',
    '100 istek atlatıldı', '100 Verlangen ausgehalten')

# --- Shared -----------------------------------------------------------------

add('commonNotNow', 'Not now', 'Şimdi değil', 'Jetzt nicht')
add('commonSave', 'Save', 'Kaydet', 'Speichern')
add('commonOpen', 'Open', 'Aç', 'Öffnen')


def main():
    for loc in ('en', 'tr', 'de'):
        path = 'lib/l10n/app_%s.arb' % loc
        data = json.load(io.open(path, encoding='utf-8'),
                         object_pairs_hook=collections.OrderedDict)
        added = 0
        for key, values in STRINGS.items():
            if key in data:
                continue
            data[key] = values[loc]
            if loc == 'en' and key in META:
                data['@' + key] = META[key]
            added += 1
        io.open(path, 'w', encoding='utf-8').write(
            json.dumps(data, ensure_ascii=False, indent=2) + '\n')
        sys.stdout.write('%s: +%d\n' % (loc, added))


if __name__ == '__main__':
    main()
