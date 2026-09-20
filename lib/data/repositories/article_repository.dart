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
        'Nikotinin plazma yarılanma ömrü yaklaşık 2 saattir; birkaç yarılanma ömrü içinde düzeyi belirgin biçimde azalır.',
        'Yoksunluk belirtileri çoğu kişide ilk hafta, özellikle ilk birkaç günde daha belirgindir; zamanla hafifleme eğilimindedir.',
        'İstekler dalgalar hâlinde gelebilir; birçoğu birkaç dakika içinde hafifler, ancak süre kişiden kişiye değişir.',
      ],
      sections: [
        ArticleSection(
          heading: 'Nikotinin Kandan Temizlenme Eğrisi',
          content: 'Sigara dumanındaki nikotin akciğerler yoluyla saniyeler içinde beyne ulaşır. Plazma yarılanma ömrü yaklaşık 2 saattir; bu nedenle son sigaradan sonraki saatlerde düzeyi hızlıca düşer. 72 saat, nikotin düzeylerinin çok azaldığı bir dönüm noktasıdır; metabolitler daha uzun süre kalabilir.',
        ),
        ArticleSection(
          heading: 'Neden İlk 3 Gün Zorludur?',
          content: 'Nikotin bırakıldığında huzursuzluk, odaklanma güçlüğü ve yoğun istek gibi yoksunluk belirtileri görülebilir. Belirtiler çoğu kişide ilk günlerde daha yoğundur ve sonraki haftalarda azalır; süre ve şiddet kişiden kişiye değişir.',
        ),
        ArticleSection(
          heading: 'Pratik Baş Etme Stratejisi',
          content: 'İstekler çoğu zaman yükselip azalır; fakat herkeste aynı sürede geçmez. Birkaç dakika ertelemek, yavaş nefes almak, su içmek veya kısa bir dikkat değişikliği o anı yönetmeye yardımcı olabilir.',
        ),
      ],
    ),
    Article(
      id: '4d-craving-technique',
      title: 'Kriz Anında 4D Tekniği: Smokefree Kanıtı',
      subtitle: 'İstek geldiğinde deneyebileceğiniz dört küçük adım',
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
          content: 'Amerikan Ulusal Kanser Enstitüsü (NCI) ve CDC kaynakları; erteleme, derin nefes, su ve dikkat değiştirme gibi basit adımları önerir. "Asla içmeyeceğim" yerine "Şimdi birkaç dakika bekleyeceğim" demek, kararı küçük ve uygulanabilir bir adıma bölebilir.',
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
        'Eğer-O Zaman planı ("Kahve içersem kısa bir yürüyüş yapacağım") tetikleyici anında başka bir seçeneği hatırlamayı kolaylaştırabilir.',
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
            'Azaltma hızı tek bir doğru oran değildir; kişinin sürdürebileceği bir plan ve gerektiğinde profesyonel destek önemlidir.',
        'Günün her sigarası aynı bağlama sahip değildir; aralıkları açmak bazı kişiler için uygulanabilir bir seçenektir.',
      ],
      sections: [
        ArticleSection(
          heading: 'Kademeli Azaltma Mitleri ve Gerçekler',
          content: 'Ani bırakma ve planlı azaltmayı karşılaştıran Cochrane derlemesi, uzun vadeli bırakma oranlarında belirgin bir fark göstermedi. Bu nedenle kişi için sürdürülebilir olan yöntem; destek, plan ve gerektiğinde sağlık profesyoneliyle birlikte seçilebilir.',
        ),
        ArticleSection(
          heading: 'Halen Algoritmasının Mantığı',
          content: 'Uygulamamızdaki uyarlanabilir planlama, sigaralar arasındaki zaman pencerelerini kişinin kendi kayıtlarına göre kademeli olarak uzatmayı dener. Sonuç kişisel örüntüye bağlıdır; uygulama bunu ölçüm veya kesin sonuç olarak sunmaz.',
        ),
      ],
    ),
    Article(
      id: 'who-health-timeline',
      title: 'Sağlığın Geri Kazanımı: 20. Dakikadan 15. Yıla Zaman Çizelgesi',
      subtitle: 'Dünya Sağlık Örgütü ve CDC verileriyle sigarayı bırakma sonrası genel sağlık değişimleri',
      category: ArticleCategory.health,
      readMinutes: 4,
      sourceName: 'WHO Tobacco Fact Sheets & CDC Health Benefits',
      sourceUrl: 'https://www.who.int/news-room/questions-and-answers/item/tobacco-health-benefits-of-smoking-cessation',
      keyTakeaways: [
        '20 dakika: Nabız ve kan basıncı normale yaklaşır.',
        '12 saat: Kandaki karbonmonoksit düzeyi genel olarak normal düzeye yaklaşır.',
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
        'Birçok kişi bırakmayı birden fazla denemede başarır; tek bir kayma önceki ilerlemeyi silmez.',
        'Bir sigara içmek (lapse) sürecin bittiği anlamına gelmez (relapse değildir).',
        'Kendini suçlamak yerine ne olduğunu incelemek ve bir sonraki küçük adımı seçmek daha yapıcıdır.',
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
      subtitle: 'Yavaş nefesle o anı daha yönetilebilir kılmayı denemek',
      category: ArticleCategory.crisis,
      readMinutes: 3,
      sourceName: 'Harvard Health & Autonomic Regulation Studies',
      sourceUrl: 'https://www.health.harvard.edu/mind-and-mood/breath-control-helps-quell-errant-stress-response',
      keyTakeaways: [
        'Kutu Nefesi (4-4-4-4): 4 saniye nefes al, 4 saniye tut, 4 saniye ver, 4 saniye bekle.',
        'Yavaş nefes, bedensel uyarılmayı düzenlemeye ve o anı fark ederek geçirmeye yardımcı olabilir.',
        'SOS ekranındaki rehberli animasyonla 60 saniyede sakinleşebilirsiniz.',
      ],
      sections: [
        ArticleSection(
          heading: 'Kutu Nefesi Nasıl Çalışır?',
          content: 'Yavaş ve kontrollü nefes almak bazı kişilerde bedensel uyarılmayı düzenlemeye yardımcı olabilir. Bu egzersiz bir tedavi veya herkes için aynı sonucu veren bir yöntem değildir; rahat gelmiyorsa bırakın.',
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
        'Tasarruf, girdiğin paket fiyatı ve kaydettiğin sigara sayısına göre kişiselleştirilir; sabit bir ortalama vaat edilmez.',
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


    Article(
      id: 'sleep-after-quitting',
      title: 'Bırakma Sonrası Uyku: Ne Beklemeli?',
      subtitle: 'Nikotin yoksunluğu uykuyu geçici olarak bozabilir; bu normaldir ve geçer',
      category: ArticleCategory.health,
      readMinutes: 3,
      sourceName: 'CDC · AASM',
      sourceUrl: 'https://www.cdc.gov/tobacco/about/quitting.html',
      keyTakeaways: [
        'İlk haftalarda uyku düzeni bozulabilir; bu bilinen, geçici bir yoksunluk belirtisidir.',
        'Kafeini öğleden sonra kesmek ve sabit kalkma saati toparlanmayı kolaylaştırır.',
        'Uyku genellikle birkaç hafta içinde kendiliğinden düzelir.',
      ],
      sections: [
        ArticleSection(
          heading: 'Neden Uyku Etkilenir?',
          content: 'Nikotin uyarıcıdır. Bırakıldığında ilk birkaç hafta uykuya dalma veya kesintisiz uyuma zorlaşabilir; bilinen, geçici bir yoksunluk belirtisidir ve kişiden kişiye değişir.',
        ),
        ArticleSection(
          heading: 'Ne Yardımcı Olur?',
          content: 'Öğleden sonra kafeini azaltmak iyi bir başlangıçtır: nikotin kafeinin yarılanma ömrünü uzattığı için bırakıldığında kafein daha güçlü etki eder. Sabit bir kalkma saati ve yatmadan önce ekransız sakin bir ritüel uykuya geçişi kolaylaştırır.',
        ),
      ],
    ),
    Article(
      id: 'nrt-consult',
      title: 'NRT Danışmanlığı: Eczanede Ne Sorulmalı?',
      subtitle: 'Nikotin ikame ürünleri reçetesizdir; yine de uzmana danışın',
      category: ArticleCategory.science,
      readMinutes: 4,
      sourceName: 'Cochrane Review 2012 · WHO',
      sourceUrl: 'https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD009336.pub2/full',
      keyTakeaways: [
        'NRT (bant, sakız) yoksunluk belirtilerine karşı plasebodan daha etkilidir; Cochrane derlemeleri bunu gösterir.',
        'Doz ve süre kişiseldir; gebelik, kalp rahatsızlığı ve ilaç etkileşimleri için önce sağlık çalışanı görüşü alın.',
        'NRT, davranış desteğiyle birleştiğinde tek başına olmaktan daha başarılıdır.',
      ],
      sections: [
        ArticleSection(
          heading: 'Kanıt Ne Kadar Güçlü?',
          content: 'Cochrane derlemeleri, NRT\'ın dumansız kalma şansını anlamlı biçimde artırdığını gösterir (çalışmaya göre yaklaşık yüzde 50–70 göreli artış). Bu bir ortalamadır; kişisel sonuç plana ve desteğe de bağlıdır.',
        ),
        ArticleSection(
          heading: 'Eczacıya Üç Soru',
          content: '1) Hangi form ve doz bana uyar? 2) Kullandığım ilaçlar veya hastalıklarım için sakınca var mı? 3) Yan etki görürsem ne yapmalıyım? Bu üç soru güvenli bir başlangıç sağlar.',
        ),
      ],
    ),
    Article(
      id: 'habit-replacement',
      title: 'Alışkanlık Yerine Koyma: Kahve, Araba, Eller',
      subtitle: 'Sigaraya bağlı ipuçlarını yeniden öğrenmek',
      category: ArticleCategory.psychology,
      readMinutes: 3,
      sourceName: 'NHS · Surgeon General Report 2020',
      sourceUrl: 'https://www.hhs.gov/surgeongeneral/reports-and-publications/tobacco/index.html',
      keyTakeaways: [
        'Sigara çoğu zaman rutine bağlıdır: kahve, araba, yemek sonrası. İpucu değişirse davranış da değişebilir.',
        'Şekersiz sakız, stres topu gibi araçlar el-ağız boşluğunu doldurabilir.',
        'Kahveyi farklı yerde veya farklı kupayla içmek bile isteği azaltabilir.',
      ],
      sections: [
        ArticleSection(
          heading: 'İpucu-Davranış Bağı',
          content: 'Beyin sigarayı kahve kokusu gibi sinyallerle eşleştirir. Bağı çözmek, aynı sinyale yeni bir yanıt eklemektir: kahveyi başka bir yerde içmek, arabada sakız, yemek sonrası kısa yürüyüş.',
        ),
        ArticleSection(
          heading: 'El-Ağız Boşluğu',
          content: 'Birçok kişi sigaranın el-ağız hareketini özler. Şekersiz sakız, havuç çubuğu, stres topu veya kalem çevirmek bu boşluğu doldurabilir. Bunlar tıbbi tedavi değil, davranışsal geçiş araçlarıdır.',
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
        'Nicotine has a plasma half-life of roughly 2 hours; its level falls sharply over several half-lives.',
        'Withdrawal symptoms are often strongest during the first week, especially the first few days, and then tend to ease.',
        'Cravings often come in waves and may ease after a few minutes, but their duration varies.',
      ],
      sections: [
        ArticleSection(
          heading: 'The Clearance Curve',
          content: 'Inhaled nicotine reaches the brain within seconds. Its plasma half-life is around 2 hours, so levels fall quickly over the hours after the last cigarette. By 72 hours nicotine levels are much lower, while metabolites can remain longer.',
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
      subtitle: 'Four small steps to try when an urge arrives',
      category: ArticleCategory.crisis,
      readMinutes: 3,
      sourceName: 'CDC & NCI Smokefree Guidelines',
      sourceUrl: 'https://smokefree.gov/challenges-when-quitting/cravings-triggers/how-manage-cravings',
      keyTakeaways: [
        'Delay: Wait 2-3 minutes before acting on impulse.',
        'Deep Breath: Regulate autonomic state with slow diaphragmatic breaths.',
        'Drink Water: Sip water if keeping your mouth and hands busy helps.',
        'Distract: Change setting or engage your hands.',
      ],
      sections: [
        ArticleSection(
          heading: 'Why 4D Works',
          content: 'NCI and CDC resources recommend simple steps such as delaying, deep breathing, drinking water and changing attention. A short delay can make the next choice feel more manageable; cravings do not follow one fixed timetable.',
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
        'There is no single reduction rate that fits everyone; a sustainable plan and support matter.',
        'Widening inter-cigarette intervals builds lasting behavioral autonomy.',
      ],
      sections: [
        ArticleSection(
          heading: 'Evidence Over Dogma',
          content: 'A Cochrane review comparing gradual reduction with abrupt cessation found no clear difference in long-term quit rates. The more sustainable option can be chosen with a plan, support and clinical advice when needed.',
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
        '20 min: Heart rate and blood pressure begin to fall, in general.',
        '12 hours: Blood carbon monoxide generally returns toward normal.',
        '1 year: Coronary heart disease risk is about half that of a smoker\'s, in general.',
      ],
      sections: [
        ArticleSection(
          heading: 'Immediate Cellular Repair',
          content: 'After stopping, carbon monoxide levels generally fall and oxygen transport can improve. These are population-level findings, not a personal measurement or timetable.',
        ),
      ],
    ),

    Article(
      id: 'reprogram-triggers',
      title: 'Reprogramming Triggers: Coffee, Meals and Stress',
      subtitle: 'Breaking the smoking-behaviour link by disrupting habit loops',
      category: ArticleCategory.triggers,
      readMinutes: 5,
      sourceName: 'Gollwitzer & Sheeran, Meta-Analysis on Implementation Intentions',
      sourceUrl: 'https://www.sciencedirect.com/science/chapter/bookseries/pii/S0065260106380021',
      keyTakeaways: [
        'Smoking at trigger moments is a conditioned reflex, not a weakness of will.',
        'If-then plans ("If I have coffee, I will take a short walk") make it easier to recall an alternative at the trigger moment.',
        'Changing the place or the order of a routine breaks the brain\'s autopilot.',
      ],
      sections: [
        ArticleSection(
          heading: 'Understanding the Conditioned Reflex',
          content: 'After years of lighting up with every morning coffee or right after every meal, the brain pairs the smell of coffee or the feeling of fullness directly with a nicotine signal. The problem is not the coffee; it is the neural bridge that was built.',
        ),
        ArticleSection(
          heading: 'If-Then Plans',
          content: 'An implementation intention links a concrete cue to a concrete action: "If I finish dinner, then I will brush my teeth right away." Studies on implementation intentions show that pre-deciding the response makes it more available at the critical moment.',
        ),
      ],
    ),
    Article(
      id: 'compassionate-relapse',
      title: 'A Slip Is Not Failure; It Is Part of the Process',
      subtitle: 'Why one cigarette does not reset everything — beating the guilt loop',
      category: ArticleCategory.psychology,
      readMinutes: 4,
      sourceName: 'Hughes, Addiction 2004 · Barasch, Broken Records 2023',
      sourceUrl: 'https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1360-0443.2004.00540.x',
      keyTakeaways: [
        'Most people succeed after several attempts; a single slip does not erase prior progress.',
        'One cigarette is a lapse; it does not mean the attempt is over (not a relapse).',
        'Examining what happened and choosing the next small step is more useful than self-blame.',
      ],
      sections: [
        ArticleSection(
          heading: 'The All-or-Nothing Trap',
          content: 'Many people smoke one cigarette, conclude "all my effort is wasted, I have to start from zero" and finish the pack. That is a cognitive distortion. Someone who has avoided 100 cigarettes has not lost the previous 99 wins because of one.',
        ),
        ArticleSection(
          heading: 'What To Do After a Slip',
          content: 'Name what happened, note the trigger, and pick the very next small smoke-free choice. Self-compassion after a slip is associated with stronger subsequent attempts than harsh self-criticism.',
        ),
      ],
    ),
    Article(
      id: 'box-breathing-science',
      title: 'A 60-Second Box-Breathing Exercise for Cravings',
      subtitle: 'Trying to make the moment more manageable with slow breathing',
      category: ArticleCategory.crisis,
      readMinutes: 3,
      sourceName: 'Harvard Health & Autonomic Regulation Studies',
      sourceUrl: 'https://www.health.harvard.edu/mind-and-mood/breath-control-helps-quell-errant-stress-response',
      keyTakeaways: [
        'Box breathing (4-4-4-4): in for 4, hold 4, out 4, wait 4.',
        'Slow breathing can help regulate bodily arousal and let the moment pass mindfully.',
        'The guided animation on the SOS screen walks you through 60 seconds.',
      ],
      sections: [
        ArticleSection(
          heading: 'How Box Breathing Works',
          content: 'Slow, controlled breathing can help some people regulate bodily arousal. This exercise is not a treatment and results are not identical for everyone; if it does not feel right, stop.',
        ),
      ],
    ),
    Article(
      id: 'financial-freedom',
      title: 'The Psychology of Savings: The Power of the Money You Keep',
      subtitle: 'The concrete effect of the unspent cigarette budget on quality of life',
      category: ArticleCategory.psychology,
      readMinutes: 3,
      sourceName: 'WHO Tobacco Economics & World Bank Data',
      sourceUrl: 'https://www.who.int/news-room/fact-sheets/detail/tobacco',
      keyTakeaways: [
        'Savings are personalised from the pack price you entered and the cigarettes you logged; no fixed average is promised.',
        'Concrete rewards (a trip, a hobby, tech) beat abstract balances for motivation.',
        'Halen reflects every un-smoked cigarette in your balance to the cent.',
      ],
      sections: [
        ArticleSection(
          heading: 'The Size of Invisible Small Spending',
          content: 'A pack a day feels like a small expense, but the monthly and yearly projection is an enormous capital loss. Directing that money at a concrete goal (for example a travel fund) makes willpower tangible.',
        ),
      ],
    ),

    Article(
      id: 'sleep-after-quitting',
      title: 'Sleep After Quitting: What to Expect',
      subtitle: 'Withdrawal can disturb sleep temporarily; it is normal and it passes',
      category: ArticleCategory.health,
      readMinutes: 3,
      sourceName: 'CDC · AASM',
      sourceUrl: 'https://www.cdc.gov/tobacco/about/quitting.html',
      keyTakeaways: [
        'Sleep can get worse for the first few weeks; that is a known, temporary withdrawal symptom.',
        'Cutting caffeine after noon and keeping a fixed wake time help recovery.',
        'Sleep usually normalises on its own within a few weeks.',
      ],
      sections: [
        ArticleSection(
          heading: 'Why Sleep Is Affected',
          content: 'Nicotine is a stimulant. For the first few weeks after quitting, falling asleep or staying asleep can be harder; this is a known, temporary withdrawal symptom and varies between people.',
        ),
        ArticleSection(
          heading: 'What Helps',
          content: 'Cutting caffeine after noon is a good start: nicotine lengthens the half-life of caffeine, so after quitting caffeine hits harder. A fixed wake time and a calm, screen-free pre-bed routine make it easier to fall asleep.',
        ),
      ],
    ),
    Article(
      id: 'nrt-consult',
      title: 'NRT Consultation: What to Ask at the Pharmacy',
      subtitle: 'Nicotine replacement is sold over the counter; still talk to a professional',
      category: ArticleCategory.science,
      readMinutes: 4,
      sourceName: 'Cochrane Review 2012 · WHO',
      sourceUrl: 'https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD009336.pub2/full',
      keyTakeaways: [
        'NRT (patch, gum) reduces withdrawal better than placebo; Cochrane reviews show this.',
        'Dose and duration are individual; ask a health professional about pregnancy, heart conditions and drug interactions.',
        'NRT combined with behavioural support outperforms NRT alone.',
      ],
      sections: [
        ArticleSection(
          heading: 'How Strong Is the Evidence?',
          content: 'Cochrane reviews show NRT meaningfully increases the chance of staying smoke-free (roughly 50-70% relative, depending on the study). That is an average; your own result also depends on plan and support.',
        ),
        ArticleSection(
          heading: 'Three Questions for the Pharmacist',
          content: '1) Which form and dose suit me? 2) Any interactions with my medicines or conditions? 3) What should I do about side effects? These three questions make the start safer.',
        ),
      ],
    ),
    Article(
      id: 'habit-replacement',
      title: 'Habit Replacement: Coffee, Car, Hands',
      subtitle: 'Re-learning the cues attached to smoking',
      category: ArticleCategory.psychology,
      readMinutes: 3,
      sourceName: 'NHS · Surgeon General Report 2020',
      sourceUrl: 'https://www.hhs.gov/surgeongeneral/reports-and-publications/tobacco/index.html',
      keyTakeaways: [
        'Smoking hangs on routines: coffee, the car, after meals. Change the cue and the behaviour can change.',
        'Sugar-free gum, a stress ball and similar tools can fill the hand-mouth gap.',
        'Even drinking coffee in a different place or cup can lower the urge.',
      ],
      sections: [
        ArticleSection(
          heading: 'Cue-Behaviour Link',
          content: 'The brain pairs smoking with signals like the smell of coffee. You break the link by adding a new response to the same signal: drink coffee somewhere else, chew gum in the car, take a short walk after meals.',
        ),
        ArticleSection(
          heading: 'The Hand-Mouth Gap',
          content: 'Many people miss the hand-to-mouth motion. Sugar-free gum, carrot sticks, a stress ball or a pen can fill that gap. These are behavioural tools, not medical treatment.',
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
        'Nikotin hat eine Halbwertszeit von etwa 2 Stunden; der Spiegel fällt innerhalb mehrerer Halbwertszeiten stark ab.',
        'Entzugssymptome sind oft in der ersten Woche, besonders in den ersten Tagen, am stärksten und lassen danach tendenziell nach.',
        'Verlangen kommt häufig in Wellen und kann nach einigen Minuten nachlassen; die Dauer ist individuell.',
      ],
      sections: [
        ArticleSection(
          heading: 'Die Abbaukurve',
          content: 'Inhaliertes Nikotin erreicht innerhalb von Sekunden das Gehirn. Durch die Halbwertszeit von etwa 2 Stunden fällt der Spiegel in den Stunden nach der letzten Zigarette schnell; Metaboliten können länger vorhanden sein.',
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
          content: 'Verlangen kann in Wellen kommen. Eine kurze Verzögerung kann die nächste Entscheidung überschaubarer machen; Dauer und Stärke unterscheiden sich.',
        ),
      ],
    ),

    Article(
      id: 'sleep-after-quitting',
      title: 'Schlaf nach dem Aufhören: Was zu erwarten ist',
      subtitle: 'Entzug kann den Schlaf vorübergehend stören; das ist normal und vergeht',
      category: ArticleCategory.health,
      readMinutes: 3,
      sourceName: 'CDC · AASM',
      sourceUrl: 'https://www.cdc.gov/tobacco/about/quitting.html',
      keyTakeaways: [
        'In den ersten Wochen kann der Schlaf schlechter werden; das ist ein bekanntes, vorübergehendes Entzugssymptom.',
        'Koffein nachmittags weglassen und feste Aufstehzeiten helfen der Erholung.',
        'Der Schlaf normalisiert sich meist innerhalb weniger Wochen.',
      ],
      sections: [
        ArticleSection(
          heading: 'Warum der Schlaf leidet',
          content: 'Nikotin ist ein Stimulans. In den ersten Wochen nach dem Aufhören kann Einschlafen oder Durchschlafen schwerer sein; das ist ein bekanntes, vorübergehendes Symptom und variiert von Person zu Person.',
        ),
        ArticleSection(
          heading: 'Was hilft',
          content: 'Koffein nach dem Mittag reduzieren: Nikotin verlängert die Halbwertszeit von Koffein, nach dem Aufhören wirkt es stärker. Feste Aufstehzeiten und ein ruhiges, bildschirmfreies Abendritual erleichtern das Einschlafen.',
        ),
      ],
    ),
    Article(
      id: 'nrt-consult',
      title: 'NRT-Beratung: Was fragst du in der Apotheke?',
      subtitle: 'Nikotinersatz ist rezeptfrei; sprich trotzdem mit Fachpersonal',
      category: ArticleCategory.science,
      readMinutes: 4,
      sourceName: 'Cochrane Review 2012 · WHO',
      sourceUrl: 'https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD009336.pub2/full',
      keyTakeaways: [
        'NRT (Pflaster, Kaugummi) lindert Entzugssymptome besser als Placebo; Cochrane-Reviews zeigen das.',
        'Dosis und Dauer sind individuell; bei Schwangerschaft, Herzerkrankungen oder Wechselwirkungen vorher fragen.',
        'NRT plus Verhaltensunterstützung wirkt besser als NRT allein.',
      ],
      sections: [
        ArticleSection(
          heading: 'Wie stark ist die Evidenz?',
          content: 'Cochrane-Reviews zeigen, dass NRT die Chance, rauchfrei zu bleiben, signifikant erhöht (je nach Studie rund 50-70 % relativ). Das ist ein Durchschnitt; dein Ergebnis hängt auch von Plan und Unterstützung ab.',
        ),
        ArticleSection(
          heading: 'Drei Fragen an die Apotheke',
          content: '1) Welche Form und Dosis passt zu mir? 2) Gibt es Wechselwirkungen mit meinen Medikamenten oder Erkrankungen? 3) Was tue ich bei Nebenwirkungen? Diese drei Fragen machen den Start sicherer.',
        ),
      ],
    ),
    Article(
      id: 'habit-replacement',
      title: 'Gewohnheiten ersetzen: Kaffee, Auto, Hände',
      subtitle: 'Die an das Rauchen gekoppelten Signale neu lernen',
      category: ArticleCategory.psychology,
      readMinutes: 3,
      sourceName: 'NHS · Surgeon General Report 2020',
      sourceUrl: 'https://www.hhs.gov/surgeongeneral/reports-and-publications/tobacco/index.html',
      keyTakeaways: [
        'Rauchen hängt an Routinen: Kaffee, Auto, nach dem Essen. Ändert sich der Anker, kann sich das Verhalten ändern.',
        'Zuckerfreier Kaugummi, ein Stressball und Ähnliches können die Hand-Mund-Lücke füllen.',
        'Schon Kaffee an einem anderen Ort oder in anderem Becher kann das Verlangen senken.',
      ],
      sections: [
        ArticleSection(
          heading: 'Signal-Verhalten-Kopplung',
          content: 'Das Gehirn koppelt Rauchen an Signale wie Kaffeeduft. Die Kopplung löst du, indem du demselben Signal eine neue Antwort gibst: Kaffee woanders trinken, Kaugummi im Auto, kurzer Spaziergang nach dem Essen.',
        ),
        ArticleSection(
          heading: 'Hand-Mund-Lücke',
          content: 'Viele vermissen die Hand-Mund-Bewegung. Zuckerfreier Kaugummi, Karottensticks, ein Stressball oder ein Stift können die Lücke füllen. Das sind Verhaltenswerkzeuge, keine medizinische Behandlung.',
        ),
      ],
    ),
    Article(
      id: 'reprogram-triggers',
      title: 'Trigger neu programmieren: Kaffee, Essen und Stress',
      subtitle: 'Die Rauch-Verhalten-Kopplung lösen, indem man Gewohnheitsschleifen bricht',
      category: ArticleCategory.triggers,
      readMinutes: 5,
      sourceName: 'Gollwitzer & Sheeran, Meta-Analysis on Implementation Intentions',
      sourceUrl: 'https://www.sciencedirect.com/science/chapter/bookseries/pii/S0065260106380021',
      keyTakeaways: [
        'Rauchen in Auslösesituationen ist ein konditionierter Reflex, kein Willensschwäche.',
        ' Wenn-dann-Pläne („Wenn ich Kaffee trinke, mache ich einen kurzen Spaziergang“) machen im entscheidenden Moment eine Alternative abrufbar.',
        'Ort oder Reihenfolge einer Routine zu ändern, bricht den Autopiloten des Gehirns.',
      ],
      sections: [
        ArticleSection(
          heading: 'Den konditionierten Reflex verstehen',
          content: 'Nach Jahren, in denen du zum Morgenkaffee oder direkt nach dem Essen geraucht hast, koppelt das Gehirn den Kaffeegeruch oder das Sättigungsgefühl direkt an ein Nikotinsignal. Das Problem ist nicht der Kaffee, sondern die gebaute neuronale Brücke.',
        ),
        ArticleSection(
          heading: 'Wenn-dann-Pläne',
          content: 'Eine Implementierungsintention verknüpft einen konkreten Auslöser mit einer konkreten Handlung: „Wenn ich mit dem Essen fertig bin, putze ich mir sofort die Zähne.“ Studien zeigen, dass das Vorausentscheiden die richtige Reaktion im kritischen Moment verfügbarer macht.',
        ),
      ],
    ),
    Article(
      id: 'taper-science',
      title: 'Wissenschaftliches Runterdosieren: Funktioniert das schrittweise Reduzieren?',
      subtitle: 'Warum kleine Schritte die Entzugskurve flacher machen können',
      category: ArticleCategory.science,
      readMinutes: 4,
      sourceName: 'Benowitz, NEJM 2010 · Hughes, Addiction 2004',
      sourceUrl: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC2953858/',
      keyTakeaways: [
        'Nikotin hat eine Plasmahalbwertszeit von rund 2 Stunden; wer den Abstand vergrößert, senkt den Spipegel schrittweise.',
        'Ein schrittweiser Plan kann die Entzugsspitzen flacher machen als ein kalter Entzug.',
        'Ziel bleibt das komplette Aufhören; das Reduzieren ist die Rampe, nicht das Ziel.',
      ],
      sections: [
        ArticleSection(
          heading: 'Was im Körper passiert',
          content: 'Der Nikotinspiegel fällt nach jeder Zigarette exponentiell. Wer zwischen den Zigaretten größere Abstände einhält, erlebt weniger Überschneidungen von Entzugsspitzen — die Belastungskurve wird flacher statt sägezahn.',
        ),
        ArticleSection(
          heading: 'Grenzen und Ehrlichkeit',
          content: 'Reduzieren funktioniert nicht bei allen gleich gut; manche kommen ohne klaren Stichtag nicht aus dem Tief. Halen zeigt beide Wege und rechnet den Plan aus deinen echten Daten — ohne den Versprechen eines Erfolgs.',
        ),
      ],
    ),
    Article(
      id: 'who-health-timeline',
      title: 'Die WHO-Zeitleiste: Was nach dem letzten Rauchen passiert',
      subtitle: 'Die bekannten Meilensteine von 20 Minuten bis 15 Jahren',
      category: ArticleCategory.health,
      readMinutes: 4,
      sourceName: 'WHO · CDC',
      sourceUrl: 'https://www.who.int/news-room/questions-and-answers/item/tobacco-health-benefits-of-smoking-cessation',
      keyTakeaways: [
        'Bereits nach 20 Minuten sinken Puls und Blutdruck.',
        'Nach 1 Jahr ist das Risiko für koronare Herzkrankheit etwa halb so hoch wie bei Rauchenden.',
        'Die Zeitachse beschreibt Durchschnittswerte einer Population; sie ist keine individuelle Zusicherung.',
      ],
      sections: [
        ArticleSection(
          heading: 'Die Meilensteine',
          content: '20 Minuten: Puls und Blutdruck sinken. 12 Stunden: Das CO im Blut normalisiert sich. 2–12 Wochen: Kreislauf und Lungenfunktion verbessern sich. 1–9 Monate: Husten und Atemnot nehmen ab. 1 Jahr: Das KHK-Risiko ist etwa halbiert. 5–15 Jahre: Schlaganfallrisiko wie bei Nie-Rauchenden. 10 Jahre: Lungenkrebsrisiko etwa halbiert. 15 Jahre: KHK-Risiko wie bei Nie-Rauchenden.',
        ),
        ArticleSection(
          heading: 'Wie man das liest',
          content: 'Diese Angaben stammen aus Populationsstudien (WHO/CDC). Sie beschreiben typische Verläufe — sie sind keine Diagnose und keine Messung deiner eigenen Organe.',
        ),
      ],
    ),
    Article(
      id: 'compassionate-relapse',
      title: 'Ein Ausrutscher ist kein Scheitern; er gehört zum Prozess',
      subtitle: 'Warum eine Zigarette nicht alles zurücksetzt — die Schuldspirale durchbrechen',
      category: ArticleCategory.psychology,
      readMinutes: 4,
      sourceName: 'Hughes, Addiction 2004 · Barasch, Broken Records 2023',
      sourceUrl: 'https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1360-0443.2004.00540.x',
      keyTakeaways: [
        'Die meisten schaffen es erst nach mehreren Versuchen; ein einziger Ausrutscher löscht den bisherigen Fortschritt nicht.',
        'Eine Zigarette ist ein Ausrutscher (Lapse); das Vorhaben ist damit nicht beendet (kein Relapse).',
        'Statt sich Vorwürfe zu machen: prüfen, was passiert ist, und den nächsten kleinen Schritt wählen.',
      ],
      sections: [
        ArticleSection(
          heading: 'Die Alles-oder-nichts-Falle',
          content: 'Viele rauchen eine Zigarette, denken „alle Mühe war um, ich muss ganz von vorne anfangen“ und rauchen die Packung leer. Das ist eine kognitive Verzerrung. Wer 100 Zigaretten vermieden hat, verliert die 99 vorherigen Siege nicht durch die eine.',
        ),
        ArticleSection(
          heading: 'Was nach einem Ausrutscher zu tun ist',
          content: 'Benenne, was passiert ist, notiere den Auslöser und wähle die nächste kleine rauchfreie Entscheidung. Selbstmitgefühl nach einem Ausrutscher führt laut Studien zu stärkeren Folgeversuchen als harte Selbstkritik.',
        ),
      ],
    ),
    Article(
      id: 'box-breathing-science',
      title: '60 Sekunden Box-Breathing für den Akutmoment',
      subtitle: 'Mit langsamer Atmung den Moment besser aushalten',
      category: ArticleCategory.crisis,
      readMinutes: 3,
      sourceName: 'Harvard Health & Autonomic Regulation Studies',
      sourceUrl: 'https://www.health.harvard.edu/mind-and-mood/breath-control-helps-quell-errant-stress-response',
      keyTakeaways: [
        'Box-Breathing (4-4-4-4): 4 Sekunden ein, 4 halten, 4 aus, 4 warten.',
        'Langsame Atmung kann die körperliche Erregung regulieren und den Moment achtsam überstehen helfen.',
        'Die geführte Animation auf dem SOS-Bildschirm führt dich in 60 Sekunden hindurch.',
      ],
      sections: [
        ArticleSection(
          heading: 'Wie Box-Breathing wirkt',
          content: 'Langsame, kontrollierte Atmung kann bei manchen Menschen die körperliche Erregung regulieren. Die Übung ist keine Therapie und wirkt nicht bei allen gleich; wenn sie sich nicht richtig anfühlt, hör auf.',
        ),
      ],
    ),
    Article(
      id: 'financial-freedom',
      title: 'Psychologie des Sparens: Die Kraft des behaltenen Geldes',
      subtitle: 'Die konkrete Wirkung des nicht ausgegebenen Zigarettenbudgets',
      category: ArticleCategory.psychology,
      readMinutes: 3,
      sourceName: 'WHO Tobacco Economics & World Bank Data',
      sourceUrl: 'https://www.who.int/news-room/fact-sheets/detail/tobacco',
      keyTakeaways: [
        'Die Ersparnis wird aus deinem Packungspreis und deinen protokollierten Zigaretten berechnet; kein fester Durchschnitt wird versprochen.',
        'Konkrete Belohnungen (Reise, Hobby, Technik) motivieren besser als abstrakte Kontostände.',
        'Halen bucht jede nicht gerauchte Zigarette auf den Cent genau in deine Bilanz.',
      ],
      sections: [
        ArticleSection(
          heading: 'Die Größe unsichtbarer Kleinausgaben',
          content: 'Eine Packung pro Tag fühlt sich wie eine kleine Ausgabe an; in der Monats- und Jahresprojektion ist es ein riesiger Kapitalverlust. Dieses Geld auf ein konkretes Ziel zu richten (z. B. einen Reisefonds) macht den Willen greifbar.',
        ),
      ],
    ),

  ];
}
