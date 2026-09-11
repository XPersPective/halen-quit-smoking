# -*- coding: utf-8 -*-
"""New copy for the device-feedback round: items 2, 3, 4, 5, 10, 12."""
import collections
import io
import json
import sys

S = {}
META = {}


def add(key, en, tr, de, placeholders=None):
    S[key] = {'en': en, 'tr': tr, 'de': de}
    if placeholders:
        META[key] = {'placeholders': placeholders}


STR = {'type': 'String'}
INT = {'type': 'int'}

# --- Items 2 and 3: the pack, and what was bought -----------------------------
add('packTitle', 'My pack', 'Paketim', 'Meine Packung')
add('packLabelLine', 'Label: {tar} mg tar, {nicotine} mg nicotine per cigarette',
    'Etiket: sigara başına {tar} mg katran, {nicotine} mg nikotin',
    'Etikett: {tar} mg Teer, {nicotine} mg Nikotin pro Zigarette',
    {'tar': STR, 'nicotine': STR})
add('packLabelDefaulted',
    'Using the legal maximum until you enter your pack\'s own values.',
    'Kendi paketinin değerlerini girene kadar yasal üst sınır kullanılıyor.',
    'Bis du die Werte deiner Packung einträgst, gilt der gesetzliche Höchstwert.')
add('packTar', 'Tar per cigarette (mg)', 'Sigara başına katran (mg)',
    'Teer pro Zigarette (mg)')
add('packNicotine', 'Nicotine per cigarette (mg)', 'Sigara başına nikotin (mg)',
    'Nikotin pro Zigarette (mg)')
add('packLabelHint',
    'Printed on the side of the pack. Leave empty to use the legal maximum '
    '(10 mg tar, 1 mg nicotine).',
    'Paketin yan yüzünde yazar. Boş bırakırsan yasal üst sınır kullanılır '
    '(10 mg katran, 1 mg nikotin).',
    'Steht seitlich auf der Packung. Leer lassen für den gesetzlichen '
    'Höchstwert (10 mg Teer, 1 mg Nikotin).')
add('purchasesTitle', 'My pack purchases', 'Paket alımlarım',
    'Meine Packungskäufe')
add('purchasesAdd', 'Add a purchase', 'Alım ekle', 'Kauf hinzufügen')
add('purchasesEmpty',
    'No purchases yet. Add the packs you buy and you will see what the habit '
    'really costs, month by month.',
    'Henüz alım yok. Aldığın paketleri ekle; alışkanlığın gerçekte ne '
    'tuttuğunu ay ay göreceksin.',
    'Noch keine Käufe. Trag deine Packungen ein und du siehst, was die '
    'Gewohnheit wirklich kostet, Monat für Monat.')
add('purchasesThisMonth', 'Spent this month', 'Bu ay harcanan',
    'Diesen Monat ausgegeben')
add('purchasesLastMonth', 'Last month', 'Geçen ay', 'Letzten Monat')
add('purchasesEvery', 'One pack every {days} days on average',
    'Ortalama {days} günde bir paket', 'Im Schnitt alle {days} Tage eine Packung',
    {'days': STR})
add('purchasesMonthlyRate', 'At this rate, about {amount} a month',
    'Bu hızla ayda yaklaşık {amount}', 'In diesem Tempo etwa {amount} im Monat',
    {'amount': STR})
add('purchasesChartTitle', 'Spending per month', 'Aylık harcama',
    'Ausgaben pro Monat')
add('purchasesChartMeaning',
    'One bar per month: what went on cigarettes. The solid bar is this month.',
    'Her çubuk bir ay: sigaraya giden para. Koyu çubuk bu ay.',
    'Ein Balken pro Monat: was für Zigaretten ausgegeben wurde. Der volle '
    'Balken ist dieser Monat.')
add('purchasesChartAxis', 'amount spent', 'harcanan tutar', 'ausgegebener Betrag')
add('purchasesHistory', 'History', 'Geçmiş', 'Verlauf')
add('purchasesDeleted', 'Purchase removed', 'Alım silindi', 'Kauf entfernt')
add('purchasesDate', 'Date', 'Tarih', 'Datum')
add('purchasesPacks', 'Packs', 'Paket adedi', 'Packungen')
add('purchasesPrice', 'Price per pack', 'Paket fiyatı', 'Preis pro Packung')
add('purchasesPackSize', 'Cigarettes', 'Adet', 'Zigaretten')
add('purchasesBrand', 'Brand (optional)', 'Marka (isteğe bağlı)',
    'Marke (optional)')
add('purchasesUpdatesPack',
    'This becomes your current pack, so every cost figure in the app follows '
    'what you actually paid.',
    'Bu senin güncel paketin olur; uygulamadaki her maliyet hesabı gerçekten '
    'ödediğini takip eder.',
    'Das wird deine aktuelle Packung, damit jede Kostenangabe dem folgt, was '
    'du wirklich bezahlt hast.')

# --- Item 4: tar, in something you can picture -------------------------------
add('tarTitle', 'Tar you took in', 'Aldığın katran', 'Aufgenommener Teer')
add('tarThisWeek', 'This week', 'Bu hafta', 'Diese Woche')
add('tarThisMonth', 'Last 30 days', 'Son 30 gün', 'Letzte 30 Tage')
add('tarPicture', 'about {count} {measure}', 'yaklaşık {count} {measure}',
    'etwa {count} {measure}', {'count': STR, 'measure': STR})
add('measureTeaSpoon', 'tea spoons', 'çay kaşığı', 'Teelöffel')
add('measureDessertSpoon', 'dessert spoons', 'tatlı kaşığı', 'Dessertlöffel')
add('measureTableSpoon', 'table spoons', 'yemek kaşığı', 'Esslöffel')
add('measureWaterGlass', 'glasses of water', 'su bardağı', 'Wassergläser')
add('tarGrams', '{grams} g', '{grams} g', '{grams} g', {'grams': STR})
add('tarChartMeaning',
    'Tar brought into your lungs each week, from your own count and your '
    'pack label.',
    'Her hafta ciğerlerine giren katran; kendi sayından ve paket '
    'etiketinden.',
    'Teer, der jede Woche in deine Lunge kam — aus deiner Zählung und dem '
    'Packungsetikett.')
add('tarChartAxis', 'grams of tar per week', 'haftalık katran (gram)',
    'Gramm Teer pro Woche')
add('tarWeekShort', '{n} wk', '{n} hf', '{n} Wo', {'n': INT})
add('tarBasis',
    'Worked out from {tar} mg tar per cigarette on the label. This is a '
    'floor: people inhale more deeply than the test machine, so real intake '
    'is usually higher.',
    'Etiketteki sigara başına {tar} mg katran üzerinden hesaplandı. Bu bir '
    'alt sınır: insanlar test makinesinden daha derin çeker, gerçekte alınan '
    'genelde daha fazladır.',
    'Berechnet aus {tar} mg Teer pro Zigarette laut Etikett. Das ist eine '
    'Untergrenze: Menschen ziehen tiefer als die Prüfmaschine, die echte '
    'Aufnahme ist meist höher.',
    {'tar': STR})
add('tarSpoonNote',
    'Spoons by volume, taking tar at about 1 g per millilitre. A Turkish tea '
    'spoon holds about 2.5 mL.',
    'Kaşıklar hacimce; katranın mililitresi yaklaşık 1 g kabul edildi. Bir '
    'çay kaşığı yaklaşık 2,5 mL alır.',
    'Löffel nach Volumen, Teer mit etwa 1 g pro Milliliter gerechnet. Ein '
    'Teelöffel fasst etwa 2,5 mL.')

# --- Item 12: nicotine in milligrams ----------------------------------------
add('nicotineMgAxis',
    'estimated nicotine still in your body, mg — a model, not a measurement',
    'vücudunda kalan tahmini nikotin, mg — model, ölçüm değil',
    'geschätztes Nikotin noch im Körper, mg — ein Modell, keine Messung')
add('nicotineMgBasis',
    'About 1.2 mg of nicotine is absorbed per cigarette, and half of it '
    'leaves the body every 2 hours (Benowitz).',
    'Sigara başına yaklaşık 1,2 mg nikotin emilir; bunun yarısı her 2 saatte '
    'vücuttan atılır (Benowitz).',
    'Pro Zigarette werden etwa 1,2 mg Nikotin aufgenommen; die Hälfte davon '
    'verlässt den Körper alle 2 Stunden (Benowitz).')
add('mgValue', '{value} mg', '{value} mg', '{value} mg', {'value': STR})

# --- Item 5: each organ, over time ------------------------------------------
add('organExposureTitle', 'This organ, last 24 hours',
    'Bu organ, son 24 saat', 'Dieses Organ, letzte 24 Stunden')
add('organExposureNow', 'Right now: {percent}% of its peak today',
    'Şu an: bugünkü zirvesinin %{percent}\'si',
    'Gerade: {percent} % des heutigen Höchstwerts', {'percent': INT})
add('organExposureMeaning',
    'Each spike is a cigarette reaching this organ; the fall is your body '
    'clearing it. The flatter the line, the more rest the organ gets.',
    'Her tepe bu organa ulaşan bir sigara; iniş vücudunun onu temizlemesi. '
    'Çizgi ne kadar düzse organ o kadar dinlenir.',
    'Jede Spitze ist eine Zigarette, die dieses Organ erreicht; der Abfall '
    'ist dein Körper, der sie abbaut. Je flacher die Linie, desto mehr Ruhe.')
add('organExposureLoads', 'Driven by: {loads}', 'Etkileyen: {loads}',
    'Getrieben von: {loads}', {'loads': STR})
add('organSinceLast', 'Since your last cigarette: {time}',
    'Son sigaradan bu yana: {time}', 'Seit der letzten Zigarette: {time}',
    {'time': STR})
add('organAcuteHeart',
    'After a cigarette the heart beats about 10-20 times a minute faster and '
    'blood pressure rises, for roughly 20-30 minutes.',
    'Bir sigaradan sonra kalp dakikada yaklaşık 10-20 atım daha hızlı atar '
    've tansiyon yükselir; bu 20-30 dakika kadar sürer.',
    'Nach einer Zigarette schlägt das Herz etwa 10-20 Mal pro Minute '
    'schneller und der Blutdruck steigt, für rund 20-30 Minuten.')
add('organAcuteVessels',
    'Nicotine narrows blood vessels within minutes, and each cigarette keeps '
    'them narrowed for about an hour.',
    'Nikotin damarları dakikalar içinde daraltır; her sigara onları yaklaşık '
    'bir saat dar tutar.',
    'Nikotin verengt die Gefäße binnen Minuten, jede Zigarette hält sie '
    'etwa eine Stunde verengt.')
add('organAcuteLungs',
    'Smoke slows the tiny hairs that sweep the airways clean, and tar settles '
    'in the lungs with every cigarette.',
    'Duman, hava yollarını temizleyen minik tüyleri yavaşlatır; katran her '
    'sigarayla ciğerlere çöker.',
    'Rauch bremst die feinen Härchen, die die Atemwege reinigen, und Teer '
    'lagert sich mit jeder Zigarette in der Lunge ab.')
add('organAcuteBrain',
    'Nicotine reaches the brain in 10-20 seconds; as it falls over the next '
    'hours, it comes back as the next craving.',
    'Nikotin beyne 10-20 saniyede ulaşır; sonraki saatlerde düşerken bir '
    'sonraki istek olarak geri döner.',
    'Nikotin erreicht das Gehirn in 10-20 Sekunden; wenn es in den nächsten '
    'Stunden sinkt, kommt es als nächstes Verlangen zurück.')
add('organAcuteBlood',
    'Carbon monoxide takes the place of oxygen in the blood; half of it '
    'clears in about 4-5 hours.',
    'Karbonmonoksit kanda oksijenin yerini alır; yarısı yaklaşık 4-5 saatte '
    'temizlenir.',
    'Kohlenmonoxid verdrängt den Sauerstoff im Blut; die Hälfte ist nach '
    'etwa 4-5 Stunden abgebaut.')
add('organAcuteGeneral',
    'The harmful substances in smoke travel in the blood to every organ; '
    'exposure grows with every cigarette.',
    'Dumandaki zararlı maddeler kanla her organa taşınır; maruziyet her '
    'sigarayla artar.',
    'Die Schadstoffe im Rauch gelangen mit dem Blut in jedes Organ; die '
    'Belastung wächst mit jeder Zigarette.')

# --- Item 10: the environment -------------------------------------------------
add('envTitle', 'What your planet got back', 'Doğaya kazandırdığın',
    'Was die Umwelt zurückbekommt')
add('envTrees', '{count} trees not cut down', '{count} ağaç kesilmekten kurtuldu',
    '{count} Bäume nicht gefällt', {'count': STR})
add('envButts', '{count} filters kept out of nature',
    '{count} izmarit doğaya karışmadı', '{count} Filter nicht in der Natur',
    {'count': INT})
add('envBasis',
    'WHO estimates about one tree is lost for every 300 cigarettes made, '
    'mostly to dry tobacco leaves and make paper. Cigarette filters are plastic '
    '(cellulose acetate) and are the most littered item on Earth.',
    'DSÖ\'ye göre üretilen her 300 sigara için yaklaşık bir ağaç kaybediliyor; '
    'çoğu tütün kurutmak ve kâğıt yapmak için. Sigara filtreleri plastiktir '
    '(selüloz asetat) ve dünyada en çok atılan çöptür.',
    'Laut WHO geht für etwa 300 hergestellte Zigaretten ein Baum verloren, '
    'meist für das Trocknen von Tabak und für Papier. Filter sind Plastik '
    '(Celluloseacetat) und der häufigste Abfall der Welt.')
add('envPlantTitle', 'Plant a real tree', 'Gerçek bir fidan dik',
    'Einen echten Baum pflanzen')
add('envPlantBody',
    'A small part of what you have saved can plant a real sapling. Halen '
    'takes no money and earns nothing from this; the buttons open the '
    'organisations directly.',
    'Biriktirdiğin paranın küçük bir kısmıyla gerçek bir fidan diktirebilirsin. '
    'Halen bundan para almaz ve kazanç sağlamaz; butonlar doğrudan kuruluşu '
    'açar.',
    'Ein kleiner Teil des Gesparten kann einen echten Setzling pflanzen. '
    'Halen nimmt dafür kein Geld und verdient nichts; die Knöpfe öffnen die '
    'Organisationen direkt.')
add('envSavedCovers', 'What you saved so far would plant about {count} saplings.',
    'Şimdiye kadar biriktirdiğinle yaklaşık {count} fidan dikilebilir.',
    'Mit dem bisher Gesparten ließen sich etwa {count} Setzlinge pflanzen.',
    {'count': INT})
add('envOpenFailed', 'Could not open the link.', 'Bağlantı açılamadı.',
    'Link konnte nicht geöffnet werden.')


def main():
    for loc in ('en', 'tr', 'de'):
        path = 'lib/l10n/app_%s.arb' % loc
        data = json.load(io.open(path, encoding='utf-8'),
                         object_pairs_hook=collections.OrderedDict)
        n = 0
        for key, vals in S.items():
            if data.get(key) != vals[loc]:
                data[key] = vals[loc]
                n += 1
            if loc == 'en' and key in META:
                data['@' + key] = META[key]
        io.open(path, 'w', encoding='utf-8').write(
            json.dumps(data, ensure_ascii=False, indent=2) + '\n')
        sys.stdout.write('%s: %d\n' % (loc, n))


if __name__ == '__main__':
    main()
