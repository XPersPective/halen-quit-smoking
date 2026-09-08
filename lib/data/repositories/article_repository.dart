import 'package:flutter/foundation.dart';

/// Categories for evidence-based cessation articles (Report §21).
enum ArticleCategory {
  science,
  crisis,
  triggers,
  health,
  psychology,
}

/// A scientific, evidence-based smoking cessation article or guide.
@immutable
class Article {
  const Article({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.readMinutes,
    required this.sourceName,
    required this.sourceUrl,
    required this.keyTakeaways,
    required this.sections,
    this.iconKey = 'article',
  });

  final String id;
  final String title;
  final String subtitle;
  final ArticleCategory category;
  final int readMinutes;
  final String sourceName;
  final String sourceUrl;
  final List<String> keyTakeaways;
  final List<ArticleSection> sections;
  final String iconKey;
}

@immutable
class ArticleSection {
  const ArticleSection({
    required this.heading,
    required this.content,
  });

  final String heading;
  final String content;
}

/// In-memory & offline-first article repository seeded with verified Tier-1
/// evidence-based articles (WHO, CDC, Cochrane, Benowitz NEJM, Hughes 2004).
class ArticleRepository {
  const ArticleRepository();

  List<Article> getArticles({required String locale}) {
    final isTr = locale.toLowerCase().startsWith('tr');
    final isDe = locale.toLowerCase().startsWith('de');

    if (isTr) {
      return _turkishArticles;
    } else if (isDe) {
      return _germanArticles;
    }
    return _englishArticles;
  }

  Article? getArticleById(String id, {required String locale}) {
    final articles = getArticles(locale: locale);
    for (final a in articles) {
      if (a.id == id) return a;
    }
    return null;
  }

  static const List<Article> _turkishArticles = [
    Article(
      id: 'nicotine-first-72h',
      title: 'Nikotin ve Beden: İlk 72 Saatte Neler Olur?',
      subtitle: 'Nikotinin vücuttan atılma hızı ve fiziksel yoksunluğun biyolojisi',
      category: ArticleCategory.science,
      readMinutes: 4,
      sourceName: 'Benowitz, NEJM 2010 · Hukkanen, Pharmacol Rev 2005',
      sourceUrl: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC2953858/',
      keyTakeaways: [
        'Nikotinin kanda yarılanma ömrü yaklaşık 2 saattir; 12 saatte neredeyse sıfırlanır.',
        'Fiziksel yoksunluk semptomları 48-72. saatler arasında zirve yapar, ardından hızla azalır.',
        'Her sigara isteği nörobiyolojik olarak 3-5 dakika içinde tepe noktasına ulaşıp söner.',
      ],
      sections: [
        ArticleSection(
          heading: 'Nikotinin Kandan Temizlenme Eğrisi',
          content: 'Sigara dumanındaki nikotin akciğerler yoluyla 10 ila 20 saniye içinde beyne ulaşır ve dopamin salgılatır. Ancak yarılanma ömrü oldukça kısadır (yaklaşık 2 saat). Son sigaranızdan 8 saat sonra kandaki nikotin seviyesi %75 oranında düşer. 72 saatin sonunda ise vücudunuz tamamen nikotinden arınmış olur.',
        ),
        ArticleSection(
          heading: 'Neden İlk 3 Gün Zorludur?',
          content: 'Beyindeki nikotinik asetilkolin reseptörleri boş kaldığında huzursuzluk, hafif baş dönmesi ve yoğun istek sinyalleri üretir. Bu durum kalıcı bir acı değil; beyninizin fabrika ayarlarına dönme sancısıdır. Reseptörlerin duyarsızlaşması ve normale dönmesi 3. günden itibaren belirgin şekilde başlar.',
        ),
        ArticleSection(
          heading: 'Pratik Baş Etme Stratejisi',
          content: 'Gelen her istek dalgasının denizdeki bir dalga gibi olduğunu unutmayın: tepeye çıkar ve mutlaka kırılır. Saate bakıp 3 dakika boyunca nefesinize veya bir bardağa su doldurup yavaşça içmeye odaklanmak, biyolojik isteğin sönmesi için yeterlidir.',
        ),
      ],
    ),
    Article(
      id: '4d-craving-technique',
      title: 'Kriz Anında 4D Tekniği: Smokefree Kanıtı',
      subtitle: 'Acil istek anında 120 saniyede uygulayabileceğiniz 4 altın adım',
      category: ArticleCategory.crisis,
      readMinutes: 3,
      sourceName: 'CDC & NCI Smokefree Guidelines',
      sourceUrl: 'https://smokefree.gov/challenges-when-quitting/cravings-triggers/how-manage-cravings',
      keyTakeaways: [
        'Delay (Geciktir): Karar vermeden önce sadece 2-3 dakika bekle.',
        'Deep Breath (Derin Nefes): Nabzı düşürmek için 4-4-4-4 kutu nefesi yap.',
        'Drink Water (Su İç): Ağız hissini değiştir ve yudum yudum su iç.',
        'Distract (Dikkat Dağıt): Zihnini başka bir eyleme veya harekete yönlendir.',
      ],
      sections: [
        ArticleSection(
          heading: '4D Kuralı Nedir?',
          content: 'Amerikan Ulusal Kanser Enstitüsü (NCI) ve CDC tarafından önerilen 4D tekniği, sigara krizlerinin kısa süreli doğasından faydalanan en pratik davranışsal müdahaledir. "Asla içmeyeceğim" demek yerine "Şimdi 3 dakika bekleyeceğim" demek irade yükünü %90 hafifletir.',
        ),
        ArticleSection(
          heading: 'Adım Adım Uygulama',
          content: '1. Geciktir: Kendinize 2 dakika süre tanıyın.\n2. Derin Nefes: Ciğerlerinizi temiz havayla doldurun. 4 saniye al, 4 saniye tut, 4 saniye ver.\n3. Su İç: Soğuk su içmek ağızdaki reseptörleri uyarır ve parasempatik sistemi tetikler.\n4. Dikkat Dağıt: Yerinizden kalkın, kısa bir yürüyüş yapın ya da bir arkadaşınızı arayın.',
        ),
      ],
    ),
    Article(
      id: 'reprogram-triggers',
      title: 'Tetikleyicileri Yeniden Programlama: Kahve, Yemek ve Stres',
      subtitle: 'Alışkanlık döngülerini bozarak sigara-davranış bağını koparmak',
      category: ArticleCategory.triggers,
      readMinutes: 5,
      sourceName: 'Gollwitzer & Sheeran, Meta-Analysis on Implementation Intentions',
      sourceUrl: 'https://www.sciencedirect.com/science/chapter/bookseries/pii/S0065260106380021',
      keyTakeaways: [
        'Tetikleyici anlarda sigara içmek bir irade zayıflığı değil, şartlanmış bir reflekstir.',
        'Eğer-O Zaman planı ("Kahve içersem yanına bir bardak soğuk su alacağım") başarıyı 2 kat artırır.',
        'Rutin mekanını veya sırasını değiştirmek beynin otomatik pilotunu kırar.',
      ],
      sections: [
        ArticleSection(
          heading: 'Şartlanmış Refleksi Anlamak',
          content: 'Yıllarca her sabah kahveyle ya da her yemekten hemen sonra sigara yaktığınızda, beyin kahvenin kokusunu veya tokluk hissini doğrudan nikotin sinyaliyle eşleştirir. Sorun kahve değil, kurulan nöronal köprüdür.',
        ),
        ArticleSection(
          heading: 'Alışkanlık Döngüsünü Değiştirmek',
          content: 'Döngü üç parçadan oluşur: Tetikleyici -> Rutin -> Ödül. Tetikleyiciyi yok edemezsiniz (yemek yemeye devam edeceksiniz), ancak rutini değiştirebilirsiniz. Yemek biter bitmez masadan kalkıp dişlerinizi fırçalamak veya nane ferahlığı almak beynin ödül beklentisini başka bir yöne kaydırır.',
        ),
      ],
    ),
    Article(
      id: 'taper-science',
      title: 'Azaltarak Bırakmanın Bilimi: Kademeli İlerleme',
      subtitle: 'Neden ani bırakmak zorunda değilsiniz? Cochrane klinik incelemeleri',
      category: ArticleCategory.science,
      readMinutes: 4,
      sourceName: 'Lindson et al., Cochrane Systematic Review 2019',
      sourceUrl: 'https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD013183.pub2/full',
      keyTakeaways: [
        'Kademeli azaltarak bırakma, ani bırakma kadar başarılıdır (Cochrane RR 1,01).',
        'Haftalık %10–20 aralığında tüketimi kısmak yoksunluk şokunu önler.',
        'Günün her sigarası eşit değildir; aralıkları açmak en etkili stratejidir.',
      ],
      sections: [
        ArticleSection(
          heading: 'Kademeli Azaltma Mitleri ve Gerçekler',
          content: 'Yıllarca "sigara ancak bir günde tamamen bırakılır" miti yayıldı. Oysa Cochrane\'in 22 klinik çalışmayı kapsayan dev meta-analizi, kontrollü ve planlı bir azaltma sürecinin ani bırakma kadar kalıcı başarı sağladığını kanıtladı.',
        ),
        ArticleSection(
          heading: 'Halen Algoritmasının Mantığı',
          content: 'Uygulamamızdaki uyarlanabilir planlama; sigara sayısını mekanik olarak kısmak yerine, sigaralar arasındaki zaman pencerelerini adım adım uzatmayı hedefler. Günde 15 sigara içen biri aralıkları 45 dakikadan 2 saate çıkardığında, günlük tüketim kendiliğinden yarıya iner.',
        ),
      ],
    ),
    Article(
      id: 'who-health-timeline',
      title: 'Sağlığın Geri Kazanımı: 20. Dakikadan 15. Yıla Zaman Çizelgesi',
      subtitle: 'Dünya Sağlık Örgütü ve CDC verileriyle vücudunuzun mucizevi onarımı',
      category: ArticleCategory.health,
      readMinutes: 4,
      sourceName: 'WHO Tobacco Fact Sheets & CDC Health Benefits',
      sourceUrl: 'https://www.who.int/news-room/questions-and-answers/item/tobacco-health-benefits-of-smoking-cessation',
      keyTakeaways: [
        '20 dakika: Nabız ve kan basıncı normale yaklaşır.',
        '12 saat: Kandaki zehirli karbonmonoksit seviyesi tamamen sıfırlanır.',
        '2-12 hafta: Akciğer kapasitesi artar, kan dolaşımı hızlanır.',
        '1 yıl: Kalp krizi geçirme riski sigara içen birine kıyasla %50 azalır.',
      ],
      sections: [
        ArticleSection(
          heading: 'İlk Saatlerin ve Günlerin Kazanımları',
          content: 'Sigarayı bıraktığınız andan itibaren vücudunuz derhal onarım moduna geçer. Yalnızca 12 saat içinde kanda oksijen taşıma kapasitesini engelleyen karbonmonoksit gazı yerini temiz oksijene bırakır. Sabahları daha dinç uyanmaya başlamanızın sebebi budur.',
        ),
        ArticleSection(
          heading: 'Haftalar ve Aylar İçinde Neler Olur?',
          content: '2 ila 12 hafta arasında kan dolaşımınız belirgin şekilde düzelir, merdiven çıkarken tıkanmalar azalır. 1 ila 9 ay arasında ise akciğerlerin kendi kendini temizleme mekanizması olan silya tüyleri yeniden canlanır.',
        ),
      ],
    ),
    Article(
      id: 'compassionate-relapse',
      title: 'Nüks Başarısızlık Değil, Sürecin Parçasıdır',
      subtitle: 'Bir sigara içtiğinizde neden her şey sıfırlanmaz? Suçluluk hissini yenmek',
      category: ArticleCategory.psychology,
      readMinutes: 4,
      sourceName: 'Hughes, Addiction 2004 · Barasch, Broken Records 2023',
      sourceUrl: 'https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1360-0443.2004.00540.x',
      keyTakeaways: [
        'Araştırmalar, başarılı bırakanların ortalama 6 ila 10 denemeden sonra başardığını gösteriyor.',
        'Bir sigara içmek (lapse) sürecin bittiği anlamına gelmez (relapse değildir).',
        'Kendini suçlamak sigaraya dönüşün bir numaralı tetikleyicisidir; şefkatli yaklaşım kazandırır.',
      ],
      sections: [
        ArticleSection(
          heading: 'Hep ya da Hiç Tuzağı',
          content: 'Çoğu insan tek bir sigara içtiğinde "Bütün çabam boşa gitti, baştan başlamak zorundayım" diye düşünerek paketi bitirir. Bu bilişsel bir çarpıtmadır. 100 sigara içmemeyi başarmış birinin 1 sigara içmesi, önceki 99 zaferi ortadan kaldırmaz.',
        ),
        ArticleSection(
          heading: 'Halen Neden Ceza Vermez?',
          content: 'Halen uygulamasında kırmızı renkle sıfırlanan sayaçlar veya suçlayıcı bildirimler yoktur. Bir sigara kaydettiğinizde sistem size "Yeniden hesapladık" der ve kalan günü optimize eder. Çünkü amaç kusursuzluk değil, sürdürülebilir ilerlemedir.',
        ),
      ],
    ),
    Article(
      id: 'box-breathing-science',
      title: 'Kriz İçin 60 Saniyelik Kutu Nefesi Egzersizi',
      subtitle: 'Vagus sinirini uyararak anksiyete ve sigara isteğini düşürmek',
      category: ArticleCategory.crisis,
      readMinutes: 3,
      sourceName: 'Harvard Health & Autonomic Regulation Studies',
      sourceUrl: 'https://www.health.harvard.edu/mind-and-mood/breath-control-helps-quell-errant-stress-response',
      keyTakeaways: [
        'Kutu Nefesi (4-4-4-4): 4 saniye nefes al, 4 saniye tut, 4 saniye ver, 4 saniye bekle.',
        'Kalp ritmini yavaşlatır ve beyne "Güvendesin" sinyali gönderir.',
        'SOS ekranındaki rehberli animasyonla 60 saniyede sakinleşebilirsiniz.',
      ],
      sections: [
        ArticleSection(
          heading: 'Kutu Nefesi Nasıl Çalışır?',
          content: 'Sigara içme eylemi genellikle derin ve yavaş nefes alıp vermeyi içerir; sigaranın rahatlatıcı sanılan etkisinin büyük bölümü aslında bu derin nefesten kaynaklanır. Kutu nefesi, duman ve zehir olmadan aynı parasempatik rahatlamayı sağlar.',
        ),
      ],
    ),
    Article(
      id: 'financial-freedom',
      title: 'Tasarruf Psikolojisi: Cebinizde Kalan Paranın Gücü',
      subtitle: 'Sigaraya harcanmayan bütçenin hayat kalitesine somut yansıması',
      category: ArticleCategory.psychology,
      readMinutes: 3,
      sourceName: 'WHO Tobacco Economics & World Bank Data',
      sourceUrl: 'https://www.who.int/news-room/fact-sheets/detail/tobacco',
      keyTakeaways: [
        'Ortalama bir kullanıcı yılda yaklaşık 15 ila 40 bin TL arasında tasarruf eder.',
        'Soyut birikim yerine somut ödüller (tatil, hobi, teknoloji) koymak motivasyonu artırır.',
        'Halen içmediğiniz her sigarayı anında kuruşu kuruşuna hesabınıza yansıtır.',
      ],
      sections: [
        ArticleSection(
          heading: 'Görünmeyen Küçük Harcamaların Büyüklüğü',
          content: 'Günlük 1 paket sigara maliyeti küçük bir harcama gibi hissedilir, ancak aylık ve yıllık projeksiyonda devasa bir sermaye kaybıdır. Bu parayı somut bir hedefe (örneğin bir seyahat fonuna) yönlendirmek iradeyi somutlaştırır.',
        ),
      ],
    ),
  ];

  static const List<Article> _englishArticles = [
    Article(
      id: 'nicotine-first-72h',
      title: 'Nicotine and the Body: What Happens in the First 72 Hours?',
      subtitle: 'Pharmacokinetics of clearance and the biology of physical withdrawal',
      category: ArticleCategory.science,
      readMinutes: 4,
      sourceName: 'Benowitz, NEJM 2010 · Hukkanen, Pharmacol Rev 2005',
      sourceUrl: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC2953858/',
      keyTakeaways: [
        'Nicotine has a plasma half-life of roughly 2 hours; it clears by 72 hours.',
        'Physical cravings peak between hours 48 and 72, then decline sharply.',
        'Cravings peak and fade within 3–5 minutes naturally.',
      ],
      sections: [
        ArticleSection(
          heading: 'The Clearance Curve',
          content: 'Inhaled nicotine reaches the brain in 10–20 seconds. However, its plasma half-life is around 2 hours. By hour 8, 75% is metabolized. Within 72 hours, systemic nicotine is completely cleared.',
        ),
        ArticleSection(
          heading: 'Why the First 3 Days Feel Tough',
          content: 'Unoccupied nicotinic receptors trigger brief dopamine deficits, felt as restlessness. This is not permanent damage—it is neurobiology re-calibrating toward homeostasis.',
        ),
      ],
    ),
    Article(
      id: '4d-craving-technique',
      title: 'The 4D Strategy: Evidence-Based Craving Relief',
      subtitle: 'Four actionable steps to surf any urge in under 120 seconds',
      category: ArticleCategory.crisis,
      readMinutes: 3,
      sourceName: 'CDC & NCI Smokefree Guidelines',
      sourceUrl: 'https://smokefree.gov/challenges-when-quitting/cravings-triggers/how-manage-cravings',
      keyTakeaways: [
        'Delay: Wait 2-3 minutes before acting on impulse.',
        'Deep Breath: Regulate autonomic state with slow diaphragmatic breaths.',
        'Drink Water: Cold water triggers oral sensory relief.',
        'Distract: Change setting or engage your hands.',
      ],
      sections: [
        ArticleSection(
          heading: 'Why 4D Works',
          content: 'Recommended by the NCI and CDC, the 4D technique leverages the transient nature of cravings. Cravings peak and dissipate within minutes if delayed.',
        ),
      ],
    ),
    Article(
      id: 'taper-science',
      title: 'The Science of Gradual Reduction',
      subtitle: 'Why cold-turkey is not the only way: Cochrane review findings',
      category: ArticleCategory.science,
      readMinutes: 4,
      sourceName: 'Lindson et al., Cochrane Systematic Review 2019',
      sourceUrl: 'https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD013183.pub2/full',
      keyTakeaways: [
        'Gradual reduction achieves comparable quit rates to abrupt cessation (RR 1.01).',
        'Tapering 10–20% weekly reduces withdrawal shock.',
        'Widening inter-cigarette intervals builds lasting behavioral autonomy.',
      ],
      sections: [
        ArticleSection(
          heading: 'Evidence Over Dogma',
          content: 'A comprehensive Cochrane meta-analysis of 22 trials confirmed that scheduled tapering is just as effective as quitting abruptly for long-term cessation.',
        ),
      ],
    ),
    Article(
      id: 'who-health-timeline',
      title: 'Health Recovery: From 20 Minutes to 15 Years',
      subtitle: 'WHO and CDC evidence on rapid cardiovascular and pulmonary recovery',
      category: ArticleCategory.health,
      readMinutes: 4,
      sourceName: 'WHO Tobacco Fact Sheets & CDC Health Benefits',
      sourceUrl: 'https://www.who.int/news-room/questions-and-answers/item/tobacco-health-benefits-of-smoking-cessation',
      keyTakeaways: [
        '20 min: Heart rate and blood pressure normalize.',
        '12 hours: Blood carbon monoxide drops to healthy baseline.',
        '1 year: Coronary heart disease risk drops by 50%.',
      ],
      sections: [
        ArticleSection(
          heading: 'Immediate Cellular Repair',
          content: 'Within hours of cessation, oxygen transport dramatically improves as carbon monoxide vacates hemoglobin binding sites.',
        ),
      ],
    ),
  ];

  static const List<Article> _germanArticles = [
    Article(
      id: 'nicotine-first-72h',
      title: 'Nikotin und der Körper: Die ersten 72 Stunden',
      subtitle: 'Physiologie des Nikotinabbaus und Verlauf des Entzugs',
      category: ArticleCategory.science,
      readMinutes: 4,
      sourceName: 'Benowitz, NEJM 2010 · Hukkanen, Pharmacol Rev 2005',
      sourceUrl: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC2953858/',
      keyTakeaways: [
        'Nikotin hat eine Halbwertszeit von ca. 2 Stunden; nach 72 Stunden ist der Körper nikotinfrei.',
        'Körperliche Entzugserscheinungen erreichen nach 48–72 Stunden ihren Höhepunkt.',
        'Suchtdruck dauert im Schnitt nur 3–5 Minuten pro Welle.',
      ],
      sections: [
        ArticleSection(
          heading: 'Die Abbaukurve',
          content: 'Inhaliertes Nikotin erreicht in 10–20 Sekunden das Gehirn. Durch die Halbwertszeit von etwa 2 Stunden ist nach 72 Stunden kein Nikotin mehr im Blut nachweisbar.',
        ),
      ],
    ),
    Article(
      id: '4d-craving-technique',
      title: 'Die 4A-Methode gegen Verlangen',
      subtitle: 'Vier evidenzbasierte Schritte zur Überwindung von Schmacht',
      category: ArticleCategory.crisis,
      readMinutes: 3,
      sourceName: 'CDC & NCI Smokefree Richtlinien',
      sourceUrl: 'https://smokefree.gov/challenges-when-quitting/cravings-triggers/how-manage-cravings',
      keyTakeaways: [
        'Aufschieben: 2-3 Minuten warten.',
        'Atmen: Ruhige tiefe Bauchatmung.',
        'Ausweichen: Aus der Situation gehen.',
        'Ablenken: Aktivität starten.',
      ],
      sections: [
        ArticleSection(
          heading: 'Warum die 4A-Methode hilft',
          content: 'Verlangen kommt in Wellen. Wer den Impuls um wenige Minuten verzögert, erlebt, wie der Suchtdruck von allein nachlässt.',
        ),
      ],
    ),
  ];
}
