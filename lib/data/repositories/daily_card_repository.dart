import 'package:flutter/foundation.dart';

import '../../domain/evidence.dart';
import 'library_repository.dart';

/// The daily card engine (module report §11).
///
/// One structural rule dominates this file: **a [ContentFamily.reality] card
/// cannot exist without an action line.** The evidence on fear appeals is
/// that threat changes behaviour only when it is paired with efficacy — so
/// "what you can do" is a required constructor argument, not an editorial
/// habit, and the assertion below makes a bad card impossible to ship.
///
/// Selection is phase-aware for the same reason: the first three days are
/// the withdrawal peak, and loading fear onto someone in that window is the
/// documented way to lose them.
@immutable
class DailyCard {
  const DailyCard({
    required this.key,
    required this.family,
    required this.title,
    required this.body,
    required this.sourceLabel,
    required this.sourceUrl,
    this.action,
    this.minDay = 0,
    this.maxDay = 100000,
    this.readMinutes = 1,
  }) : assert(
          family != ContentFamily.reality || action != null,
          'A reality card must ship an action line (module report §11.①): '
          'fear without efficacy does not change behaviour.',
        );

  final String key;
  final ContentFamily family;
  final L10nText title;
  final L10nText body;

  /// "What you can do" — mandatory on reality cards, optional elsewhere.
  final L10nText? action;

  final String sourceLabel;
  final String sourceUrl;

  /// Inclusive day window (days since the plan or quit started) in which this
  /// card is eligible.
  final int minDay;
  final int maxDay;

  final int readMinutes;
}

class DailyCardRepository {
  const DailyCardRepository();

  /// The catalogue. Every claim carries the source it came from.
  List<DailyCard> cards() => [
        DailyCard(
          key: 'howNicotineHooks',
          family: ContentFamily.knowledge,
          title: const L10nText(
            en: 'How nicotine gets its grip',
            tr: 'Nikotin nasıl tutunuyor',
            de: 'Wie Nikotin dich packt',
          ),
          body: const L10nText(
            en: 'Nicotine reaches the brain in seconds and clears with a half-life of about two hours. That fast rise and fall is the loop: the relief you feel is mostly the end of a small withdrawal.',
            tr: 'Nikotin beyne saniyeler içinde ulaşır ve yaklaşık iki saatlik yarı ömürle temizlenir. Bu hızlı iniş çıkış döngünün kendisidir: hissettiğin rahatlama çoğunlukla küçük bir yoksunluğun bitmesidir.',
            de: 'Nikotin erreicht das Gehirn in Sekunden und baut sich mit rund zwei Stunden Halbwertszeit ab. Dieses schnelle Auf und Ab ist die Schleife.',
          ),
          sourceLabel: 'Benowitz, Pharmacology of Nicotine',
          sourceUrl: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC2946180/',
        ),
        DailyCard(
          key: 'firstDayCo',
          family: ContentFamily.gain,
          title: const L10nText(
            en: 'The fastest win is already happening',
            tr: 'En hızlı kazanç şimdiden başlıyor',
            de: 'Der schnellste Gewinn läuft bereits',
          ),
          body: const L10nText(
            en: 'Carbon monoxide leaves the blood with a half-life of about four and a half hours. Within a day your blood carries oxygen the way a non-smoker\'s does.',
            tr: 'Karbonmonoksit kandan yaklaşık dört buçuk saatlik yarı ömürle ayrılır. Bir gün içinde kanın, içmeyen birininki gibi oksijen taşır.',
            de: 'Kohlenmonoxid verlässt das Blut mit rund viereinhalb Stunden Halbwertszeit. Binnen eines Tages transportiert dein Blut Sauerstoff wie das eines Nichtrauchers.',
          ),
          maxDay: 3,
          sourceLabel: 'Exhaled CO, PLOS One',
          sourceUrl:
              'https://journals.plos.org/plosone/article?id=10.1371%2Fjournal.pone.0028864',
        ),
        DailyCard(
          key: 'peakDays',
          family: ContentFamily.knowledge,
          title: const L10nText(
            en: 'Days one to three are the peak',
            tr: '1.–3. günler tepe noktası',
            de: 'Tag eins bis drei ist der Gipfel',
          ),
          body: const L10nText(
            en: 'Withdrawal peaks in the first three days and eases over three to four weeks. Knowing the shape of the curve does not make it easy, but it does tell you that today is not the new normal.',
            tr: 'Yoksunluk ilk üç günde tepe yapar ve üç-dört haftada hafifler. Eğrinin şeklini bilmek bir çözüm değildir ama bugünün yeni normal olmadığını söyler.',
            de: 'Der Entzug gipfelt in den ersten drei Tagen und lässt über drei bis vier Wochen nach. Heute ist nicht das neue Normal.',
          ),
          maxDay: 7,
          sourceLabel: 'Nicotine Withdrawal, PMC4542051',
          sourceUrl: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC4542051/',
        ),
        DailyCard(
          key: 'moodImproves',
          family: ContentFamily.gain,
          title: const L10nText(
            en: 'Quitting does not cost you your mood',
            tr: 'Bırakmak ruh hâlini almıyor',
            de: 'Aufhören kostet dich nicht deine Stimmung',
          ),
          body: const L10nText(
            en: 'Across 26 studies, people who stopped smoking ended up with less anxiety, less depression and less stress than those who carried on — with an effect comparable to antidepressant treatment.',
            tr: '26 çalışmanın toplamında, sigarayı bırakanlarda devam edenlere kıyasla kaygı, depresyon ve stres azaldı — etki, antidepresan tedavisiyle karşılaştırılabilir düzeyde.',
            de: 'Über 26 Studien hinweg hatten Menschen, die aufhörten, weniger Angst, Depression und Stress als jene, die weitermachten.',
          ),
          minDay: 10,
          sourceLabel: 'Taylor et al., BMJ 2014',
          sourceUrl: 'https://pubmed.ncbi.nlm.nih.gov/24524926/',
        ),
        DailyCard(
          key: 'weightHonest',
          family: ContentFamily.knowledge,
          title: const L10nText(
            en: 'About the weight question',
            tr: 'Kilo meselesi',
            de: 'Zur Gewichtsfrage',
          ),
          body: const L10nText(
            en: 'Appetite rises by roughly 200 kcal a day and most of the change lands in the first three months — on average four to five kilos in a year. Next to what smoking costs, that trade is not close.',
            tr: 'İştah günde kabaca 200 kcal artar ve değişimin çoğu ilk üç ayda olur — yılda ortalama dört-beş kilo. Sigaranın bedelinin yanında bu takas yarışmıyor bile.',
            de: 'Der Appetit steigt um rund 200 kcal täglich, die meiste Veränderung in den ersten drei Monaten — im Schnitt vier bis fünf Kilo im Jahr.',
          ),
          minDay: 14,
          maxDay: 60,
          action: const L10nText(
            en: 'Keep your usual meal times this week and put something crunchy where the cigarette used to be.',
            tr: 'Bu hafta öğün saatlerini koru ve sigaranın yerine çıtır bir şey koy.',
            de: 'Halte diese Woche deine Essenszeiten und ersetze die Zigarette durch etwas Knackiges.',
          ),
          sourceLabel: 'Metabolic effects of smoking cessation, PMC5021526',
          sourceUrl: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC5021526/',
        ),
        DailyCard(
          key: 'sevenThousand',
          family: ContentFamily.reality,
          title: const L10nText(
            en: 'What is actually in the smoke',
            tr: 'Dumanın içinde gerçekte ne var',
            de: 'Was wirklich im Rauch steckt',
          ),
          body: const L10nText(
            en: 'Cigarette smoke carries more than 7,000 chemicals, over 70 of them known carcinogens — formaldehyde, benzene, cadmium, polonium-210 among them.',
            tr: 'Sigara dumanı 7.000’den fazla kimyasal taşır; bunların 70’ten fazlası bilinen kanserojendir — formaldehit, benzen, kadmiyum, polonyum-210 bunlardan bazıları.',
            de: 'Zigarettenrauch enthält über 7.000 Chemikalien, mehr als 70 davon bekannte Karzinogene.',
          ),
          action: const L10nText(
            en: 'Open the smoke library and read one entry. Knowing what one of them does is worth more than fearing all seventy.',
            tr: 'Duman kütüphanesini aç ve tek bir maddeyi oku. Birinin ne yaptığını bilmek, yetmişinden korkmaktan daha değerlidir.',
            de: 'Öffne die Rauch-Bibliothek und lies einen Eintrag. Eines zu verstehen ist mehr wert, als siebzig zu fürchten.',
          ),
          minDay: 5,
          sourceLabel: 'CDC / American Cancer Society',
          sourceUrl: 'https://www.cdc.gov/tobacco/about/index.html',
        ),
        DailyCard(
          key: 'oneADay',
          family: ContentFamily.reality,
          title: const L10nText(
            en: 'One a day is not a safe dose',
            tr: 'Günde bir tane güvenli doz değil',
            de: 'Eine am Tag ist keine sichere Dosis',
          ),
          body: const L10nText(
            en: 'Across 141 cohort studies, smoking one cigarette a day carried about half the excess risk of heart disease and stroke of smoking twenty. Cutting down is a bridge, not a destination.',
            tr: '141 kohort çalışmasının toplamında, günde bir sigara, yirmi sigaranın kalp hastalığı ve inme riskinin yaklaşık yarısını taşıyordu. Azaltmak bir köprüdür, varış noktası değil.',
            de: 'Über 141 Kohortenstudien trug eine Zigarette täglich etwa die Hälfte des Zusatzrisikos von zwanzig. Reduzieren ist eine Brücke, kein Ziel.',
          ),
          action: const L10nText(
            en: 'Look at your plan and pick the quit date. Reduction is how you get there — it is not the finish line.',
            tr: 'Planına bak ve bırakma gününü seç. Azaltmak oraya gidiş yolun — bitiş çizgin değil.',
            de: 'Sieh dir deinen Plan an und wähle den Rauchstopp-Tag. Reduktion ist der Weg, nicht das Ziel.',
          ),
          minDay: 21,
          sourceLabel: 'Low cigarette consumption, PMC5781309',
          sourceUrl: 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5781309/',
        ),
        DailyCard(
          key: 'twentyMinutes',
          family: ContentFamily.reality,
          title: const L10nText(
            en: 'What a cigarette costs in time',
            tr: 'Bir sigaranın zaman bedeli',
            de: 'Was eine Zigarette an Zeit kostet',
          ),
          body: const L10nText(
            en: 'A 2024 analysis put the average cost of one cigarette at about 20 minutes of life expectancy — 17 for men, 22 for women. It is an average across populations, not a countdown for you.',
            tr: '2024 tarihli bir analiz, bir sigaranın ortalama bedelini yaklaşık 20 dakikalık yaşam beklentisi olarak hesapladı — erkeklerde 17, kadınlarda 22. Bu bir popülasyon ortalamasıdır, sana ait bir geri sayım değil.',
            de: 'Eine Analyse von 2024 beziffert die Kosten einer Zigarette auf rund 20 Minuten Lebenserwartung — 17 bei Männern, 22 bei Frauen.',
          ),
          action: const L10nText(
            en: 'Open your time ledger and look at the other column: the hours your rides-out have already put back.',
            tr: 'Zaman defterini aç ve diğer sütuna bak: atlattığın krizlerin şimdiden geri koyduğu saatlere.',
            de: 'Öffne dein Zeitkonto und sieh in die andere Spalte: die Stunden, die deine überstandenen Momente zurückgegeben haben.',
          ),
          minDay: 3,
          sourceLabel: 'UCL / Addiction, 2024',
          sourceUrl:
              'https://www.rcp.ac.uk/news-and-media/news-and-opinion/rcp-responds-to-ucl-research-showing-a-single-cigarette-can-take-20-minutes-off-life-expectancy/',
        ),
        DailyCard(
          key: 'walkWorks',
          family: ContentFamily.knowledge,
          title: const L10nText(
            en: 'Five minutes of walking, measured',
            tr: 'Beş dakikalık yürüyüş, ölçülmüş hâliyle',
            de: 'Fünf Minuten Gehen, in Zahlen',
          ),
          body: const L10nText(
            en: 'Pooling the individual data from experimental trials, a short bout of activity cut craving immediately and kept it down for up to half an hour. It is the best-supported thing you can do in the moment.',
            tr: 'Deneysel çalışmaların bireysel verileri birleştirildiğinde, kısa süreli aktivite isteği anında düşürdü ve yarım saate kadar düşük tuttu. O anda yapabileceğin en kanıtlı şey budur.',
            de: 'In gepoolten Einzeldaten senkte kurze Aktivität das Verlangen sofort und hielt es bis zu einer halben Stunde niedrig.',
          ),
          sourceLabel: 'IPD meta-analysis, PubMed 22861822',
          sourceUrl: 'https://pubmed.ncbi.nlm.nih.gov/22861822/',
        ),
        DailyCard(
          key: 'adherenceMatters',
          family: ContentFamily.knowledge,
          title: const L10nText(
            en: 'Keeping the schedule may matter',
            tr: 'Programa uymak fark yaratabilir',
            de: 'Das Einhalten kann einen Unterschied machen',
          ),
          body: const L10nText(
            en: 'In the largest scheduled-reduction trial, reduction alone changed little. People who kept to their schedule were about twice as likely to be abstinent six months later, but that association does not prove the schedule caused the difference.',
            tr: 'En büyük programlı azaltma çalışmasında yalnızca azaltmak az fark yarattı. Programa uyanların altı ay sonra bırakmış olma olasılığı yaklaşık iki katıydı; ancak bu ilişki, farkın nedeninin kesin olarak program olduğunu kanıtlamaz.',
            de: 'In der größten Studie zur geplanten Reduktion änderte Reduktion allein wenig. Wer den Plan einhielt, war sechs Monate später etwa doppelt so häufig abstinent; dieser Zusammenhang beweist jedoch keine Ursache.',
          ),
          minDay: 7,
          sourceLabel: 'JMIR Formative Research, 2023',
          sourceUrl: 'https://formative.jmir.org/2023/1/e39487',
        ),
      ];

  /// The card for a given day of the journey.
  ///
  /// Rules from §11.③: in the first three days only knowledge and gain
  /// (loading fear onto the withdrawal peak is how you lose people); after
  /// that the four families rotate. The rotation is deterministic, so the
  /// same day always shows the same card and nothing repeats until the
  /// eligible set has been exhausted.
  DailyCard cardForDay(int dayIndex) {
    final all = cards();
    final eligible = [
      for (final card in all)
        if (dayIndex >= card.minDay &&
            dayIndex <= card.maxDay &&
            !(dayIndex < 3 &&
                (card.family == ContentFamily.reality ||
                    card.family == ContentFamily.motivation)))
          card,
    ];
    final pool = eligible.isEmpty ? all : eligible;
    return pool[dayIndex % pool.length];
  }

  /// Every source in the catalogue, for the "Scientific sources" screen —
  /// the segment that wants to check the claims can check all of them.
  List<({String label, String url})> allSources() {
    final seen = <String>{};
    return [
      for (final card in cards())
        if (seen.add(card.sourceUrl))
          (label: card.sourceLabel, url: card.sourceUrl),
    ];
  }
}
