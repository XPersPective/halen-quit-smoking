import 'package:flutter/foundation.dart';

import '../../domain/evidence.dart';

/// Offline content catalogue for the module-report libraries: toxicants
/// (§2), the organ map (§7), the SOS toolkit (§5) and the daily support
/// cards (§10).
///
/// Two rules are structural rather than editorial here:
///  - every technique and every tip carries an [EvidenceLevel], including
///    the honest "traditional, evidence insufficient" grade for the herbal
///    and acupressure entries users come looking for;
///  - every organ entry carries a recovery line, because negative
///    information without an action is the one thing the evidence says does
///    not work.
///
/// Copy lives here rather than in ARB because these are long-form catalogue
/// bodies, matching the existing ArticleRepository pattern.

/// A localized string with an English fallback.
@immutable
class L10nText {
  const L10nText({required this.en, required this.tr, required this.de});

  final String en;
  final String tr;
  final String de;

  String call(String locale) {
    final code = locale.toLowerCase();
    if (code.startsWith('tr')) {
      return tr;
    }
    return code.startsWith('de') ? de : en;
  }
}

/// One known constituent of cigarette smoke (module report §2).
@immutable
class Toxicant {
  const Toxicant({
    required this.key,
    required this.name,
    required this.everydayAnalogy,
    required this.mechanism,
    required this.iarcGroup,
    required this.sourceUrl,
  });

  final String key;
  final L10nText name;

  /// Where else people meet this substance. A recognition aid, never a dose
  /// claim — the card says so in its own footer.
  final L10nText everydayAnalogy;
  final L10nText mechanism;

  /// IARC classification label, or null when not classified.
  final String? iarcGroup;
  final String sourceUrl;
}

/// How strongly smoking is tied to an organ, at POPULATION level.
///
/// Two different quantities live in the literature and mixing them up is the
/// most common popular error, so the type keeps them apart and the UI always
/// prints which one it is showing:
///  - [attributable] — the share of cases or deaths in a population that are
///    attributed to smoking ("87% of lung cancer deaths");
///  - [relativeRisk] — how many times likelier a smoker is than a
///    non-smoker ("kidney failure, about twice").
///
/// Neither is a statement about one person's organ, and the body map says so
/// on the same screen.
@immutable
class OrganImpact {
  const OrganImpact({this.attributable, this.relativeRisk});

  /// Population attributable fraction, 0..1.
  final double? attributable;

  /// Risk multiplier versus a non-smoker.
  final double? relativeRisk;

  /// 0..1 for the bar length. A relative risk is mapped onto the same bar by
  /// treating 6x as the top of the scale, which keeps organs comparable
  /// without implying the two measures are the same thing.
  double get barFraction {
    if (attributable != null) {
      return attributable!.clamp(0.0, 1.0);
    }
    if (relativeRisk != null) {
      return ((relativeRisk! - 1) / 5).clamp(0.0, 1.0);
    }
    return 0;
  }

  bool get isEmpty => attributable == null && relativeRisk == null;
}

/// One organ or system on the body map (module report §7).
@immutable
class OrganEntry {
  const OrganEntry({
    required this.key,
    required this.name,
    required this.harm,
    required this.recovery,
    required this.sourceUrl,
    this.relativeRisk,
    this.impact = const OrganImpact(),
    this.cardiovascular = false,
  });

  final String key;
  final L10nText name;

  /// What smoking does — neutral, sourced, never gory.
  final L10nText harm;

  /// What happens after quitting — always present, always the bigger card.
  final L10nText recovery;

  /// Published relative-risk label (population level), when one exists.
  final String? relativeRisk;

  /// The same fact as a number, for the body map's impact bar.
  final OrganImpact impact;
  final String sourceUrl;

  /// Cardiovascular entries are surfaced first for older, longer-exposure
  /// users — ordering changes with age, numbers never do.
  final bool cardiovascular;
}

/// One immediate craving intervention (module report §5).
@immutable
class SosTechnique {
  const SosTechnique({
    required this.key,
    required this.name,
    required this.instruction,
    required this.evidence,
    required this.evidenceNote,
    required this.durationSeconds,
    required this.sourceUrl,
  });

  final String key;
  final L10nText name;
  final L10nText instruction;
  final EvidenceLevel evidence;

  /// The honest one-liner about what the evidence does and does not show.
  final L10nText evidenceNote;
  final int durationSeconds;
  final String sourceUrl;
}

/// One daily support card (module report §10).
@immutable
class SupportCard {
  const SupportCard({
    required this.key,
    required this.channel,
    required this.evidence,
    required this.title,
    required this.body,
    required this.durationMinutes,
    required this.sourceUrl,
  });

  final String key;
  final SupportChannel channel;
  final EvidenceLevel evidence;
  final L10nText title;
  final L10nText body;
  final int durationMinutes;
  final String sourceUrl;
}

/// In-memory, offline catalogue. No network, no assets to load.
class LibraryRepository {
  const LibraryRepository();

  /// Known carcinogens in cigarette smoke, per CDC/ACS.
  static const int knownCarcinogens = 70;

  /// Known chemicals in cigarette smoke, per CDC/ACS.
  static const int knownChemicals = 7000;

  List<Toxicant> toxicants() => const [
        Toxicant(
          key: 'formaldehyde',
          name: L10nText(en: 'Formaldehyde', tr: 'Formaldehit', de: 'Formaldehyd'),
          everydayAnalogy: L10nText(
            en: 'Used to preserve biological specimens.',
            tr: 'Biyolojik örnekleri korumakta kullanılır.',
            de: 'Wird zur Konservierung biologischer Proben verwendet.',
          ),
          mechanism: L10nText(
            en: 'Irritates the airways and is classified as carcinogenic to humans.',
            tr: 'Solunum yollarını tahriş eder; insanda kanserojen sınıfındadır.',
            de: 'Reizt die Atemwege und gilt als krebserregend für Menschen.',
          ),
          iarcGroup: '1',
          sourceUrl: 'https://www.cancer.org/cancer/risk-prevention/tobacco/health-risks-of-smoking-tobacco.html',
        ),
        Toxicant(
          key: 'benzene',
          name: L10nText(en: 'Benzene', tr: 'Benzen', de: 'Benzol'),
          everydayAnalogy: L10nText(
            en: 'A component of petrol.',
            tr: 'Benzinin bileşenlerinden biridir.',
            de: 'Ein Bestandteil von Benzin.',
          ),
          mechanism: L10nText(
            en: 'Damages bone marrow and is linked to leukaemia.',
            tr: 'Kemik iliğine zarar verir; lösemiyle ilişkilendirilir.',
            de: 'Schädigt das Knochenmark und wird mit Leukämie in Verbindung gebracht.',
          ),
          iarcGroup: '1',
          sourceUrl: 'https://www.cdc.gov/tobacco/about/index.html',
        ),
        Toxicant(
          key: 'carbonMonoxide',
          name: L10nText(
            en: 'Carbon monoxide',
            tr: 'Karbonmonoksit',
            de: 'Kohlenmonoxid',
          ),
          everydayAnalogy: L10nText(
            en: 'The same gas car exhaust produces.',
            tr: 'Araç egzozunun ürettiği gazın aynısı.',
            de: 'Dasselbe Gas, das Autoabgase erzeugen.',
          ),
          mechanism: L10nText(
            en: 'Binds to haemoglobin and lowers how much oxygen your blood can carry. It clears within hours — the fastest win after stopping.',
            tr: 'Hemoglobine bağlanır ve kanının taşıyabildiği oksijeni düşürür. Saatler içinde temizlenir — bırakınca gelen en hızlı kazanç budur.',
            de: 'Bindet an Hämoglobin und senkt den Sauerstofftransport im Blut. Es baut sich in Stunden ab — der schnellste Gewinn nach dem Aufhören.',
          ),
          iarcGroup: null,
          sourceUrl: 'https://journals.plos.org/plosone/article?id=10.1371%2Fjournal.pone.0028864',
        ),
        Toxicant(
          key: 'tar',
          name: L10nText(en: 'Tar', tr: 'Katran', de: 'Teer'),
          everydayAnalogy: L10nText(
            en: 'The sticky particle phase left when nicotine and water are removed from smoke.',
            tr: 'Dumandan nikotin ve su çıkınca kalan yapışkan partikül fazı.',
            de: 'Die klebrige Partikelphase, die bleibt, wenn Nikotin und Wasser entfernt werden.',
          ),
          mechanism: L10nText(
            en: 'Deposits in the airways. Pack figures come from a smoking machine and understate what people actually inhale, so no app can tell you a number of milligrams.',
            tr: 'Solunum yollarında birikir. Paketteki değerler makine ölçümüdür ve gerçek maruziyeti olduğundan az gösterir; bu yüzden hiçbir uygulama sana miligram söyleyemez.',
            de: 'Lagert sich in den Atemwegen ab. Packungswerte stammen von einer Maschine und unterschätzen die reale Aufnahme — keine App kann Milligramm nennen.',
          ),
          iarcGroup: null,
          sourceUrl: 'https://aacrjournals.org/cebp/article/15/8/1495/173726/Cigarette-Yields-and-Human-Exposure-A-Comparison',
        ),
        Toxicant(
          key: 'cadmium',
          name: L10nText(en: 'Cadmium', tr: 'Kadmiyum', de: 'Cadmium'),
          everydayAnalogy: L10nText(
            en: 'A metal used in some batteries.',
            tr: 'Bazı pillerde kullanılan bir metal.',
            de: 'Ein Metall, das in manchen Batterien verwendet wird.',
          ),
          mechanism: L10nText(
            en: 'Accumulates in the kidneys over years.',
            tr: 'Yıllar içinde böbreklerde birikir.',
            de: 'Reichert sich über Jahre in den Nieren an.',
          ),
          iarcGroup: '1',
          sourceUrl: 'https://www.cdc.gov/tobacco/about/index.html',
        ),
        Toxicant(
          key: 'arsenic',
          name: L10nText(en: 'Arsenic', tr: 'Arsenik', de: 'Arsen'),
          everydayAnalogy: L10nText(
            en: 'Historically used in pesticides.',
            tr: 'Tarihsel olarak böcek ilaçlarında kullanılmıştır.',
            de: 'Historisch in Pestiziden verwendet.',
          ),
          mechanism: L10nText(
            en: 'A carcinogen affecting skin, lung and bladder.',
            tr: 'Deri, akciğer ve mesaneyi etkileyen bir kanserojen.',
            de: 'Ein Karzinogen, das Haut, Lunge und Blase betrifft.',
          ),
          iarcGroup: '1',
          sourceUrl: 'https://www.cdc.gov/tobacco/about/index.html',
        ),
        Toxicant(
          key: 'acrolein',
          name: L10nText(en: 'Acrolein', tr: 'Akrolein', de: 'Acrolein'),
          everydayAnalogy: L10nText(
            en: 'Forms when fats are burned.',
            tr: 'Yağlar yanınca oluşur.',
            de: 'Entsteht beim Verbrennen von Fetten.',
          ),
          mechanism: L10nText(
            en: 'Paralyses the cilia that sweep your airways clean.',
            tr: 'Solunum yollarını süpüren tüycükleri (siliya) felç eder.',
            de: 'Lähmt die Flimmerhärchen, die die Atemwege reinigen.',
          ),
          iarcGroup: '2A',
          sourceUrl: 'https://www.cdc.gov/tobacco/about/index.html',
        ),
        Toxicant(
          key: 'ammonia',
          name: L10nText(en: 'Ammonia', tr: 'Amonyak', de: 'Ammoniak'),
          everydayAnalogy: L10nText(
            en: 'Found in household cleaners.',
            tr: 'Ev temizlik ürünlerinde bulunur.',
            de: 'In Haushaltsreinigern enthalten.',
          ),
          mechanism: L10nText(
            en: 'Increases how fast nicotine reaches the brain.',
            tr: 'Nikotinin beyne ulaşma hızını artırır.',
            de: 'Erhöht, wie schnell Nikotin das Gehirn erreicht.',
          ),
          iarcGroup: null,
          sourceUrl: 'https://www.cdc.gov/tobacco/about/index.html',
        ),
        Toxicant(
          key: 'hydrogenCyanide',
          name: L10nText(
            en: 'Hydrogen cyanide',
            tr: 'Hidrojen siyanür',
            de: 'Blausäure',
          ),
          everydayAnalogy: L10nText(
            en: 'An industrial chemical.',
            tr: 'Endüstriyel bir kimyasal.',
            de: 'Eine Industriechemikalie.',
          ),
          mechanism: L10nText(
            en: 'Interferes with how cells use oxygen.',
            tr: 'Hücrelerin oksijeni kullanmasını bozar.',
            de: 'Stört die Sauerstoffverwertung der Zellen.',
          ),
          iarcGroup: null,
          sourceUrl: 'https://www.cdc.gov/tobacco/about/index.html',
        ),
        Toxicant(
          key: 'polonium210',
          name: L10nText(en: 'Polonium-210', tr: 'Polonyum-210', de: 'Polonium-210'),
          everydayAnalogy: L10nText(
            en: 'A radioactive element that reaches tobacco from fertilizer and soil.',
            tr: 'Gübre ve topraktan tütüne geçen radyoaktif bir element.',
            de: 'Ein radioaktives Element, das über Dünger und Boden in Tabak gelangt.',
          ),
          mechanism: L10nText(
            en: 'Delivers a small radiation dose directly to lung tissue.',
            tr: 'Akciğer dokusuna doğrudan küçük bir radyasyon dozu verir.',
            de: 'Gibt eine kleine Strahlendosis direkt an das Lungengewebe ab.',
          ),
          iarcGroup: '1',
          sourceUrl: 'https://www.cancer.org/cancer/risk-prevention/tobacco/health-risks-of-smoking-tobacco.html',
        ),
        Toxicant(
          key: 'nitrosamines',
          name: L10nText(
            en: 'Tobacco-specific nitrosamines',
            tr: 'Tütüne özgü nitrozaminler',
            de: 'Tabakspezifische Nitrosamine',
          ),
          everydayAnalogy: L10nText(
            en: 'Formed from nicotine during curing and burning.',
            tr: 'Kurutma ve yanma sırasında nikotinden oluşur.',
            de: 'Entstehen aus Nikotin beim Trocknen und Verbrennen.',
          ),
          mechanism: L10nText(
            en: 'Among the most potent carcinogens in tobacco smoke.',
            tr: 'Tütün dumanındaki en güçlü kanserojenler arasındadır.',
            de: 'Gehören zu den stärksten Karzinogenen im Tabakrauch.',
          ),
          iarcGroup: '1',
          sourceUrl: 'https://www.ncbi.nlm.nih.gov/books/NBK294317/table/ch4.t1/',
        ),
        Toxicant(
          key: 'acetone',
          name: L10nText(en: 'Acetone', tr: 'Aseton', de: 'Aceton'),
          everydayAnalogy: L10nText(
            en: 'Used in nail-polish remover.',
            tr: 'Oje çıkarıcıda kullanılır.',
            de: 'Wird in Nagellackentferner verwendet.',
          ),
          mechanism: L10nText(
            en: 'Irritates the eyes, nose and throat.',
            tr: 'Göz, burun ve boğazı tahriş eder.',
            de: 'Reizt Augen, Nase und Rachen.',
          ),
          iarcGroup: null,
          sourceUrl: 'https://www.cdc.gov/tobacco/about/index.html',
        ),
      ];

  List<OrganEntry> organs() => const [
        OrganEntry(
          key: 'lungs',
          impact: OrganImpact(attributable: 0.79),
          name: L10nText(en: 'Lungs', tr: 'Akciğerler', de: 'Lunge'),
          harm: L10nText(
            en: 'Smoking accelerates the yearly loss of lung function and causes most COPD.',
            tr: 'Sigara, akciğer fonksiyonundaki yıllık kaybı hızlandırır ve KOAH vakalarının çoğunun nedenidir.',
            de: 'Rauchen beschleunigt den jährlichen Verlust der Lungenfunktion und verursacht die meisten COPD-Fälle.',
          ),
          recovery: L10nText(
            en: 'Within 1–9 months coughing and shortness of breath decrease as the airway cilia recover. Quitting is the only thing that slows the decline.',
            tr: '1–9 ay içinde öksürük ve nefes darlığı azalır, tüycükler toparlanır. Bu düşüşü yavaşlatan tek şey bırakmaktır.',
            de: 'In 1–9 Monaten nehmen Husten und Atemnot ab, die Flimmerhärchen erholen sich. Nur Aufhören verlangsamt den Abfall.',
          ),
          relativeRisk: 'COPD: ~79% of cases attributable',
          sourceUrl: 'https://www.hhs.gov/surgeongeneral/reports-and-publications/tobacco/consequences-smoking-factsheet/index.html',
        ),
        OrganEntry(
          key: 'heart',
          impact: OrganImpact(attributable: 0.32),
          name: L10nText(en: 'Heart', tr: 'Kalp', de: 'Herz'),
          harm: L10nText(
            en: 'Smoking causes about a third of coronary heart disease deaths. Even one cigarette a day carries roughly half the risk of twenty.',
            tr: 'Koroner kalp hastalığı ölümlerinin yaklaşık üçte biri sigaraya bağlanır. Günde tek sigara bile yirmi sigaranın riskinin kabaca yarısını taşır.',
            de: 'Etwa ein Drittel der Todesfälle durch koronare Herzkrankheit geht auf Rauchen zurück. Schon eine Zigarette täglich trägt rund die Hälfte des Risikos von zwanzig.',
          ),
          recovery: L10nText(
            en: 'Heart rate and blood pressure start falling within 20 minutes; excess coronary risk drops substantially in the first year.',
            tr: 'Nabız ve tansiyon 20 dakika içinde düşmeye başlar; fazladan koroner risk ilk yılda belirgin biçimde azalır.',
            de: 'Puls und Blutdruck sinken binnen 20 Minuten; das zusätzliche Koronarrisiko fällt im ersten Jahr deutlich.',
          ),
          relativeRisk: 'CHD deaths: ~32% attributable',
          cardiovascular: true,
          sourceUrl: 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5781309/',
        ),
        OrganEntry(
          key: 'brain',
          impact: OrganImpact(relativeRisk: 2.4),
          name: L10nText(en: 'Brain', tr: 'Beyin', de: 'Gehirn'),
          harm: L10nText(
            en: 'Nicotine reshapes reward circuits, and smoking raises stroke risk.',
            tr: 'Nikotin ödül devrelerini yeniden şekillendirir; sigara inme riskini yükseltir.',
            de: 'Nikotin verändert Belohnungsschaltkreise; Rauchen erhöht das Schlaganfallrisiko.',
          ),
          recovery: L10nText(
            en: 'Stroke risk falls towards a non-smoker\'s over 5–15 years. Anxiety and depression scores fall after quitting, they do not rise.',
            tr: 'İnme riski 5–15 yılda içmeyenin düzeyine doğru iner. Bırakınca kaygı ve depresyon puanları yükselmez, düşer.',
            de: 'Das Schlaganfallrisiko nähert sich in 5–15 Jahren dem eines Nichtrauchers. Angst und Depression sinken nach dem Aufhören.',
          ),
          relativeRisk: null,
          cardiovascular: true,
          sourceUrl: 'https://pubmed.ncbi.nlm.nih.gov/24524926/',
        ),
        OrganEntry(
          key: 'bloodVessels',
          impact: OrganImpact(relativeRisk: 2.0),
          name: L10nText(en: 'Blood vessels', tr: 'Damarlar', de: 'Blutgefäße'),
          harm: L10nText(
            en: 'Smoking stiffens and narrows arteries throughout the body.',
            tr: 'Sigara, vücuttaki atardamarları sertleştirir ve daraltır.',
            de: 'Rauchen versteift und verengt Arterien im ganzen Körper.',
          ),
          recovery: L10nText(
            en: 'Circulation improves over 2–12 weeks; walking and physical effort get measurably easier.',
            tr: '2–12 hafta içinde dolaşım düzelir; yürümek ve efor gözle görülür şekilde kolaylaşır.',
            de: 'Die Durchblutung verbessert sich in 2–12 Wochen; Gehen und Belastung fallen spürbar leichter.',
          ),
          relativeRisk: null,
          cardiovascular: true,
          sourceUrl: 'https://www.hhs.gov/surgeongeneral/reports-and-publications/tobacco/consequences-smoking-factsheet/index.html',
        ),
        OrganEntry(
          key: 'mouth',
          impact: OrganImpact(relativeRisk: 5.0),
          name: L10nText(
            en: 'Mouth and throat',
            tr: 'Ağız ve boğaz',
            de: 'Mund und Rachen',
          ),
          harm: L10nText(
            en: 'Raises the risk of oral, laryngeal and oesophageal cancers, and drives gum disease.',
            tr: 'Ağız, gırtlak ve yemek borusu kanseri riskini artırır; diş eti hastalığına yol açar.',
            de: 'Erhöht das Risiko für Mund-, Kehlkopf- und Speiseröhrenkrebs und fördert Zahnfleischerkrankungen.',
          ),
          recovery: L10nText(
            en: 'Taste and smell sharpen within days — one of the first changes people actually notice.',
            tr: 'Tat ve koku günler içinde keskinleşir — insanların gerçekten fark ettiği ilk değişimlerden biri.',
            de: 'Geschmack und Geruch werden innerhalb von Tagen schärfer — eine der ersten spürbaren Veränderungen.',
          ),
          relativeRisk: null,
          sourceUrl: 'https://www.ncbi.nlm.nih.gov/books/NBK294317/table/ch4.t1/',
        ),
        OrganEntry(
          key: 'stomach',
          impact: OrganImpact(relativeRisk: 1.6),
          name: L10nText(en: 'Stomach', tr: 'Mide', de: 'Magen'),
          harm: L10nText(
            en: 'Linked to ulcers, reflux and stomach cancer.',
            tr: 'Ülser, reflü ve mide kanseriyle ilişkilidir.',
            de: 'Mit Geschwüren, Reflux und Magenkrebs verbunden.',
          ),
          recovery: L10nText(
            en: 'Reflux and ulcer healing improve after quitting.',
            tr: 'Bırakınca reflü azalır ve ülser iyileşmesi hızlanır.',
            de: 'Reflux und Geschwürheilung bessern sich nach dem Aufhören.',
          ),
          relativeRisk: null,
          sourceUrl: 'https://www.ncbi.nlm.nih.gov/books/NBK294317/table/ch4.t1/',
        ),
        OrganEntry(
          key: 'liver',
          impact: OrganImpact(relativeRisk: 1.7),
          name: L10nText(en: 'Liver', tr: 'Karaciğer', de: 'Leber'),
          harm: L10nText(
            en: 'The 2014 Surgeon General report added liver cancer to the causal list.',
            tr: '2014 Surgeon General raporu karaciğer kanserini nedensellik listesine ekledi.',
            de: 'Der Surgeon-General-Bericht 2014 nahm Leberkrebs in die Kausalliste auf.',
          ),
          recovery: L10nText(
            en: 'Risk declines steadily with years of abstinence.',
            tr: 'Risk, sigarasız geçen yıllarla birlikte düzenli olarak azalır.',
            de: 'Das Risiko sinkt stetig mit den rauchfreien Jahren.',
          ),
          relativeRisk: null,
          sourceUrl: 'https://ash.org/surgeon-general-report-links-more-diseases-health-problems-to-smoking-tobacco/',
        ),
        OrganEntry(
          key: 'kidneyBladder',
          impact: OrganImpact(relativeRisk: 2.0),
          name: L10nText(
            en: 'Kidneys and bladder',
            tr: 'Böbrekler ve mesane',
            de: 'Nieren und Blase',
          ),
          harm: L10nText(
            en: 'Carcinogens are filtered through and concentrated in the urinary tract; kidney failure risk roughly doubles.',
            tr: 'Kanserojenler idrar yollarında süzülüp yoğunlaşır; böbrek yetmezliği riski kabaca ikiye katlanır.',
            de: 'Karzinogene werden in den Harnwegen gefiltert und konzentriert; das Nierenversagensrisiko verdoppelt sich etwa.',
          ),
          recovery: L10nText(
            en: 'Bladder cancer risk falls with years since quitting.',
            tr: 'Mesane kanseri riski, bırakmadan sonra geçen yıllarla düşer.',
            de: 'Das Blasenkrebsrisiko sinkt mit den Jahren nach dem Aufhören.',
          ),
          relativeRisk: 'Renal failure RR ≈ 2.0',
          sourceUrl: 'https://www.nejm.org/doi/full/10.1056/NEJMsa1407211',
        ),
        OrganEntry(
          key: 'reproductive',
          impact: OrganImpact(relativeRisk: 1.6),
          name: L10nText(
            en: 'Reproductive system',
            tr: 'Üreme sistemi',
            de: 'Fortpflanzungssystem',
          ),
          harm: L10nText(
            en: 'Causally linked to erectile dysfunction, reduced fertility and ectopic pregnancy.',
            tr: 'Erektil disfonksiyon, doğurganlık azalması ve dış gebelikle nedensel olarak ilişkilidir.',
            de: 'Ursächlich mit erektiler Dysfunktion, verringerter Fruchtbarkeit und Eileiterschwangerschaft verbunden.',
          ),
          recovery: L10nText(
            en: 'Blood flow and fertility measures improve within months of quitting.',
            tr: 'Kan akımı ve doğurganlık ölçütleri bırakmadan sonraki aylar içinde düzelir.',
            de: 'Durchblutung und Fruchtbarkeitswerte bessern sich binnen Monaten.',
          ),
          relativeRisk: null,
          sourceUrl: 'https://ash.org/surgeon-general-report-links-more-diseases-health-problems-to-smoking-tobacco/',
        ),
        OrganEntry(
          key: 'skin',
          impact: OrganImpact(relativeRisk: 2.0),
          name: L10nText(
            en: 'Skin and healing',
            tr: 'Cilt ve yara iyileşmesi',
            de: 'Haut und Wundheilung',
          ),
          harm: L10nText(
            en: 'Reduced blood flow slows wound healing and ages the skin faster.',
            tr: 'Azalan kan akımı yara iyileşmesini yavaşlatır ve cildi daha hızlı yaşlandırır.',
            de: 'Verminderte Durchblutung verlangsamt die Wundheilung und lässt die Haut schneller altern.',
          ),
          recovery: L10nText(
            en: 'Surgical and wound healing measurably improve within weeks of quitting.',
            tr: 'Cerrahi ve yara iyileşmesi, bırakmadan sonraki haftalar içinde ölçülebilir biçimde düzelir.',
            de: 'Operations- und Wundheilung bessern sich binnen Wochen messbar.',
          ),
          relativeRisk: null,
          sourceUrl: 'https://www.hhs.gov/surgeongeneral/reports-and-publications/tobacco/consequences-smoking-factsheet/index.html',
        ),
        OrganEntry(
          key: 'eyes',
          impact: OrganImpact(relativeRisk: 2.0),
          name: L10nText(en: 'Eyes', tr: 'Gözler', de: 'Augen'),
          harm: L10nText(
            en: 'Causally linked to age-related macular degeneration and cataract.',
            tr: 'Yaşa bağlı makula dejenerasyonu ve katarakt ile nedensel olarak ilişkilidir.',
            de: 'Ursächlich mit altersbedingter Makuladegeneration und Katarakt verbunden.',
          ),
          recovery: L10nText(
            en: 'Risk of further damage falls after quitting.',
            tr: 'Bırakınca ek hasar riski azalır.',
            de: 'Das Risiko weiterer Schäden sinkt nach dem Aufhören.',
          ),
          relativeRisk: null,
          sourceUrl: 'https://ash.org/surgeon-general-report-links-more-diseases-health-problems-to-smoking-tobacco/',
        ),
        OrganEntry(
          key: 'immune',
          impact: OrganImpact(relativeRisk: 2.3),
          name: L10nText(
            en: 'Immune system',
            tr: 'Bağışıklık sistemi',
            de: 'Immunsystem',
          ),
          harm: L10nText(
            en: 'Impairs immune function; infection mortality risk is more than doubled.',
            tr: 'Bağışıklık işlevini bozar; enfeksiyona bağlı ölüm riski iki katından fazladır.',
            de: 'Beeinträchtigt die Immunfunktion; das Infektionssterberisiko ist mehr als verdoppelt.',
          ),
          recovery: L10nText(
            en: 'Immune measures recover progressively after quitting.',
            tr: 'Bağışıklık ölçütleri bırakmadan sonra kademeli olarak toparlanır.',
            de: 'Immunwerte erholen sich nach dem Aufhören schrittweise.',
          ),
          relativeRisk: 'Infections RR ≈ 2.3',
          sourceUrl: 'https://www.nejm.org/doi/full/10.1056/NEJMsa1407211',
        ),
      ];

  /// SOS techniques, ordered by evidence strength — the walk comes first
  /// because it is the single best-supported acute intervention.
  List<SosTechnique> sosTechniques() => const [
        SosTechnique(
          key: 'walk5',
          name: L10nText(
            en: 'Walk it off (5 min)',
            tr: 'Yürüyerek at (5 dk)',
            de: 'Lauf es ab (5 Min.)',
          ),
          instruction: L10nText(
            en: 'Get up and walk at your own pace for five minutes. Outside is better, but a corridor works.',
            tr: 'Kalk ve beş dakika kendi temponda yürü. Dışarısı daha iyi ama koridor da işe yarar.',
            de: 'Steh auf und geh fünf Minuten in deinem Tempo. Draußen ist besser, ein Flur reicht auch.',
          ),
          evidence: EvidenceLevel.strong,
          evidenceNote: L10nText(
            en: 'Meta-analysis of trials: a short bout of activity reduces craving immediately and for up to 30 minutes afterwards.',
            tr: 'Meta-analiz: kısa süreli aktivite isteği anında ve sonrasında 30 dakikaya kadar azaltıyor.',
            de: 'Meta-Analyse: kurze Aktivität senkt das Verlangen sofort und bis zu 30 Minuten danach.',
          ),
          durationSeconds: 300,
          sourceUrl: 'https://pubmed.ncbi.nlm.nih.gov/22861822/',
        ),
        SosTechnique(
          key: 'breathe',
          name: L10nText(
            en: 'Breathe with me',
            tr: 'Benimle nefes al',
            de: 'Atme mit mir',
          ),
          instruction: L10nText(
            en: 'Follow the ring: in for 4 seconds, out for 6. That is six breaths a minute.',
            tr: 'Halkayı takip et: 4 saniye içeri, 6 saniye dışarı. Dakikada altı nefes.',
            de: 'Folge dem Ring: 4 Sekunden ein, 6 Sekunden aus. Das sind sechs Atemzüge pro Minute.',
          ),
          evidence: EvidenceLevel.strong,
          evidenceNote: L10nText(
            en: 'Slow breathing near six breaths a minute raises vagal tone and lowers state anxiety in a single session.',
            tr: 'Dakikada altıya yakın yavaş nefes, tek seansta bile vagal tonusu artırıp anlık kaygıyı düşürüyor.',
            de: 'Langsames Atmen nahe sechs Atemzügen pro Minute hebt den Vagustonus und senkt akute Angst.',
          ),
          durationSeconds: 60,
          sourceUrl: 'https://www.nature.com/articles/s41598-021-98736-9',
        ),
        SosTechnique(
          key: 'delay',
          name: L10nText(en: 'Delay 3 minutes', tr: '3 dakika ertele', de: '3 Minuten warten'),
          instruction: L10nText(
            en: 'Start the timer and do nothing about the urge. Watch it rise and fall.',
            tr: 'Sayacı başlat ve isteğe hiçbir şey yapma. Yükselip düşüşünü izle.',
            de: 'Starte den Timer und tu nichts gegen den Drang. Beobachte, wie er steigt und fällt.',
          ),
          evidence: EvidenceLevel.promising,
          evidenceNote: L10nText(
            en: 'Urges are episodic — they rise and fall. We cannot promise every urge passes in three minutes, but waiting costs nothing.',
            tr: 'İstekler dalga gibidir: yükselir ve düşer. Her isteğin üç dakikada geçeceğini vaat edemeyiz ama beklemenin bedeli yok.',
            de: 'Verlangen ist episodisch — es steigt und fällt. Wir versprechen nicht, dass jeder Drang in drei Minuten vergeht.',
          ),
          durationSeconds: 180,
          sourceUrl: 'https://www.moffitt.org/contentassets/54211e9f225e4a899bafb41bcf571959/booklet-2-smoking-urges.pdf',
        ),
        SosTechnique(
          key: 'water',
          name: L10nText(
            en: 'A glass of water',
            tr: 'Bir bardak su',
            de: 'Ein Glas Wasser',
          ),
          instruction: L10nText(
            en: 'Drink a full glass slowly. It occupies your hands and mouth for about a minute.',
            tr: 'Bir bardak suyu yavaşça iç. Yaklaşık bir dakika elini ve ağzını meşgul eder.',
            de: 'Trink ein Glas langsam aus. Es beschäftigt Hände und Mund etwa eine Minute.',
          ),
          evidence: EvidenceLevel.promising,
          evidenceNote: L10nText(
            en: 'Part of the standard 4D advice. No trial evidence on its own — but harmless, free and it fills the gap.',
            tr: 'Standart 4D önerisinin parçası. Tek başına çalışma kanıtı yok; ama zararsız, bedava ve boşluğu dolduruyor.',
            de: 'Teil des üblichen 4D-Rats. Allein keine Studienevidenz — aber harmlos, kostenlos und überbrückend.',
          ),
          durationSeconds: 60,
          sourceUrl: 'https://www.moffitt.org/contentassets/54211e9f225e4a899bafb41bcf571959/booklet-2-smoking-urges.pdf',
        ),
        SosTechnique(
          key: 'earAcupressure',
          name: L10nText(
            en: 'Ear acupressure (60 s)',
            tr: 'Kulak akupresürü (60 sn)',
            de: 'Ohr-Akupressur (60 Sek.)',
          ),
          instruction: L10nText(
            en: 'Press gently in small circles on five points of the outer ear — Shen Men, Autonomic, Kidney, Liver, Lung — about 12 seconds each. Fingers only, never needles.',
            tr: 'Dış kulaktaki beş noktaya — Shen Men, Otonom, Böbrek, Karaciğer, Akciğer — yaklaşık 12’şer saniye yumuşak, dairesel bası uygula. Sadece parmakla; asla iğne değil.',
            de: 'Drücke sanft in kleinen Kreisen auf fünf Punkte der Ohrmuschel — Shen Men, Vegetativum, Niere, Leber, Lunge — je etwa 12 Sekunden. Nur mit den Fingern, nie Nadeln.',
          ),
          evidence: EvidenceLevel.traditional,
          evidenceNote: L10nText(
            en: 'Mixed evidence: some short-term benefit for withdrawal symptoms, no proven long-term advantage for quitting. Harmless — try it if you want to.',
            tr: 'Kanıt karışık: kısa vadede yoksunluk belirtilerine yardımcı olduğuna dair veri var, kalıcı bırakma üstünlüğü gösterilmemiş. Zararsız — istersen dene.',
            de: 'Gemischte Evidenz: kurzfristig etwas Nutzen bei Entzugssymptomen, kein belegter Langzeitvorteil. Harmlos — probier es, wenn du magst.',
          ),
          durationSeconds: 60,
          sourceUrl: 'https://www.tobaccoinduceddiseases.org/Acupuncture-and-related-acupoint-therapies-for-smoking-cessation-An-umbrella-review,186147,0,2.html',
        ),
        SosTechnique(
          key: 'coldWater',
          name: L10nText(
            en: 'Cold water on your wrists',
            tr: 'Bileklerine soğuk su',
            de: 'Kaltes Wasser auf die Handgelenke',
          ),
          instruction: L10nText(
            en: 'Run cold water over your wrists and face for thirty seconds.',
            tr: 'Otuz saniye bileklerine ve yüzüne soğuk su tut.',
            de: 'Lass 30 Sekunden kaltes Wasser über Handgelenke und Gesicht laufen.',
          ),
          evidence: EvidenceLevel.traditional,
          evidenceNote: L10nText(
            en: 'A common self-help step with no trial evidence for craving. Costs nothing and interrupts the routine.',
            tr: 'Yaygın bir öz-yardım adımı; istek için çalışma kanıtı yok. Bedeli yok ve rutini kırar.',
            de: 'Ein verbreiteter Selbsthilfeschritt ohne Studienevidenz. Kostet nichts und unterbricht die Routine.',
          ),
          durationSeconds: 30,
          sourceUrl: 'https://www.nccih.nih.gov/health/quitting-smoking',
        ),
      ];

  List<SupportCard> supportCards() => const [
        SupportCard(
          key: 'stairs',
          channel: SupportChannel.movement,
          evidence: EvidenceLevel.strong,
          title: L10nText(
            en: 'Two flights of stairs',
            tr: 'İki kat merdiven',
            de: 'Zwei Stockwerke Treppe',
          ),
          body: L10nText(
            en: 'Short bursts of activity cut craving for up to half an hour. Two flights is enough to count.',
            tr: 'Kısa hareket atakları isteği yarım saate kadar azaltıyor. İki kat merdiven yeterli.',
            de: 'Kurze Aktivität senkt das Verlangen bis zu einer halben Stunde. Zwei Stockwerke genügen.',
          ),
          durationMinutes: 3,
          sourceUrl: 'https://pubmed.ncbi.nlm.nih.gov/22861822/',
        ),
        SupportCard(
          key: 'walk15',
          channel: SupportChannel.movement,
          evidence: EvidenceLevel.strong,
          title: L10nText(
            en: 'A 15-minute walk',
            tr: '15 dakikalık yürüyüş',
            de: 'Ein 15-Minuten-Spaziergang',
          ),
          body: L10nText(
            en: 'Put it where your hardest hour usually is. The effect on craving is immediate, not something you have to wait weeks for.',
            tr: 'Onu en zorlandığın saate koy. İstek üzerindeki etkisi anında; haftalarca beklemen gerekmiyor.',
            de: 'Leg ihn in deine schwerste Stunde. Die Wirkung auf das Verlangen ist sofort spürbar.',
          ),
          durationMinutes: 15,
          sourceUrl: 'https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1360-0443.2006.01739.x',
        ),
        SupportCard(
          key: 'fruitVeg',
          channel: SupportChannel.nutrition,
          evidence: EvidenceLevel.promising,
          title: L10nText(
            en: 'Something crunchy',
            tr: 'Çıtır bir şey',
            de: 'Etwas Knackiges',
          ),
          body: L10nText(
            en: 'Appetite rises by roughly 200 kcal a day after quitting. People who eat more fruit and vegetables gain less weight.',
            tr: 'Bırakınca iştah günde kabaca 200 kcal artıyor. Daha çok meyve-sebze yiyenler daha az kilo alıyor.',
            de: 'Nach dem Aufhören steigt der Appetit um rund 200 kcal täglich. Wer mehr Obst und Gemüse isst, nimmt weniger zu.',
          ),
          durationMinutes: 5,
          sourceUrl: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC5021526/',
        ),
        SupportCard(
          key: 'mealRhythm',
          channel: SupportChannel.nutrition,
          evidence: EvidenceLevel.promising,
          title: L10nText(
            en: 'Keep your meal rhythm',
            tr: 'Öğün ritmini koru',
            de: 'Halte deinen Essrhythmus',
          ),
          body: L10nText(
            en: 'Most post-quit weight change happens in the first three months. Regular meals blunt the swing without any dieting.',
            tr: 'Bırakma sonrası kilo değişiminin çoğu ilk üç ayda olur. Düzenli öğünler, diyet yapmadan bu dalgayı yumuşatır.',
            de: 'Die meiste Gewichtsänderung passiert in den ersten drei Monaten. Regelmäßige Mahlzeiten dämpfen sie ohne Diät.',
          ),
          durationMinutes: 5,
          sourceUrl: 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9603007/',
        ),
        SupportCard(
          key: 'herbalTea',
          channel: SupportChannel.ritual,
          evidence: EvidenceLevel.traditional,
          title: L10nText(
            en: 'A hot herbal tea',
            tr: 'Sıcak bir bitki çayı',
            de: 'Ein heißer Kräutertee',
          ),
          body: L10nText(
            en: 'There is no evidence that herbal remedies help people quit. As a ritual that occupies your hands and replaces the break, it can still be useful.',
            tr: 'Bitkisel ürünlerin bırakmaya yardım ettiğine dair kanıt yok. Elini meşgul eden ve molanın yerini alan bir ritüel olarak yine de işe yarayabilir.',
            de: 'Es gibt keine Belege, dass Kräutermittel beim Aufhören helfen. Als Ritual, das die Hände beschäftigt, kann es dennoch nützen.',
          ),
          durationMinutes: 5,
          sourceUrl: 'https://www.nccih.nih.gov/health/quitting-smoking',
        ),
        SupportCard(
          key: 'cinnamonStick',
          channel: SupportChannel.ritual,
          evidence: EvidenceLevel.traditional,
          title: L10nText(
            en: 'Something to hold',
            tr: 'Tutacak bir şey',
            de: 'Etwas zum Festhalten',
          ),
          body: L10nText(
            en: 'A cinnamon stick, a straw, sugar-free gum. No trial evidence — but the hand-to-mouth habit is real and worth replacing.',
            tr: 'Tarçın çubuğu, pipet, şekersiz sakız. Çalışma kanıtı yok; ama el-ağız alışkanlığı gerçek ve yerine bir şey koymaya değer.',
            de: 'Eine Zimtstange, ein Halm, zuckerfreier Kaugummi. Keine Studienevidenz — aber die Hand-zu-Mund-Gewohnheit ist real.',
          ),
          durationMinutes: 1,
          sourceUrl: 'https://www.nccih.nih.gov/health/quitting-smoking',
        ),
        SupportCard(
          key: 'sleepWindow',
          channel: SupportChannel.ritual,
          evidence: EvidenceLevel.promising,
          title: L10nText(
            en: 'Protect the first week of sleep',
            tr: 'İlk haftanın uykusunu koru',
            de: 'Schütze den Schlaf der ersten Woche',
          ),
          body: L10nText(
            en: 'Sleep disruption is a documented withdrawal symptom in the first days. It passes — plan an easier week rather than fighting it.',
            tr: 'Uyku bozukluğu ilk günlerin bilinen bir yoksunluk belirtisi. Geçiyor — onunla savaşmak yerine haftanı hafiflet.',
            de: 'Schlafstörungen sind ein bekanntes Entzugssymptom der ersten Tage. Es geht vorbei — plane eine leichtere Woche.',
          ),
          durationMinutes: 5,
          sourceUrl: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC4542051/',
        ),
      ];

  /// The support card for a given day — rotates through the channels so the
  /// user never gets the same channel two days running.
  SupportCard supportCardForDay(int dayIndex) {
    final cards = supportCards();
    return cards[dayIndex % cards.length];
  }
}
