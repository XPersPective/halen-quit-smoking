# Halen — Modül Derin Araştırma Raporu (Vücut Yükü, Ekonomi, Görselleştirme, Psikoloji, Program ve İndeksler)

**Tarih:** 8 Eylül 2026 · **Statü:** Araştırma + tasarım şartnamesi (uygulanmayı bekleyen) · **Dil:** TR (terim sözlüğü EN/TR)
**İlişkili belge:** [`sigara-birakma-app-on-arastirma-ve-urun-raporu.md`](sigara-birakma-app-on-arastirma-ve-urun-raporu.md) — pazar, rakip, monetizasyon, mimari. Bu rapor onun **§15, §16, §17, §18, §21** bölümlerini modül düzeyinde derinleştirir ve **14 modülün** bilimsel temelini, pazar emsallerini, grafik/animasyon şartnamesini ve algoritmasını verir.

**Bu raporun kapsamı ve yöntemi:** Talep edilen 14 başlığın her biri ayrı modül olarak ele alınmıştır. Her modül şu 6 bölümle yazılmıştır:

`① Bilimsel temel (kaynaklı) → ② Pazar emsali (hangi uygulama nasıl yapmış, ders ne) → ③ Bizim tasarımımız (daha iyisi) → ④ Grafik/animasyon şartnamesi → ⑤ Algoritma / veri modeli → ⑥ EN/TR metin`

Kaynak önceliği ana rapordaki Tier sistemiyle aynıdır: WHO/CDC/NCI/Cochrane/PubMed birincil; ikincil derlemeler yalnızca birincil kaynağa işaret ettiğinde; mağaza/blog kaynakları yalnızca **tasarım deseni** kanıtı olarak (bilimsel iddia için asla).

---

## 0. Çerçeve: Dürüstlük Sözleşmesi ve Kritik Uyarı

### 0.1. Talep ile ölçüm gerçekliği arasındaki fark (okumadan devam etmeyin)

"**Kandaki katran oranı şu anda ne?**" sorusunun dürüst cevabı şudur: **bir telefon kandaki nikotini, katranı veya karbonmonoksiti ölçemez.** Ölçüm ancak kan/tükürük kotinin testi, ekshale CO ölçer veya idrar biyobelirteci ile mümkündür. Ölçüyormuş gibi göstermek üç ayrı sorun üretir:

1. **Bilimsel olarak yanlıştır.** Nikotin metabolizma hızı CYP2A6 genotipine göre kişiler arasında ~1–4 saat aralığında değişir ([Benowitz, *Pharmacology of Nicotine*, PMC2946180](https://pmc.ncbi.nlm.nih.gov/articles/PMC2946180/)); tek bir mutlak sayı üretmek kişiselleştirilmiş bir yalandır.
2. **Mağaza kuralına takılır.** App Store Review Guideline 1.4.1 ve Play Health politikası, cihazın ölçemeyeceği sağlık verisini ölçülmüş gibi sunan uygulamaları reddeder (ana rapor §30).
3. **Ürünün tek gerçek farkını yok eder.** Halen'in konumu: "sahte biyolojik kesinlik satmayan uygulama".

**Talep reddedilmiyor — doğru biçimde veriliyor.** Kullanıcının gerçekte istediği şey "vücudumda şu an ne kadar zehir var, ne zaman temizlenecek?" sorusunun görünür cevabıdır. Bunu vermenin bilimsel ve yasal olarak doğru yolu, **farmakokinetik model tabanlı tahmin (S3)** sunmak ve her ekranda etiketlemektir:

> ❌ "Kanındaki nikotin: **12 ng/mL**" ← S5, üretilmez
> ✅ "**Tahmini nikotin yükü: 68 / 100**" + *"Bu bir ölçüm değil, kendi kayıtlarından hesaplanan bilimsel tahmindir."* + "Nasıl hesaplanıyor?" linki ← S3, serbest

Bu rapordaki **bütün** göstergeler bu kurala göre tasarlanmıştır. Ana rapordaki S1–S5 sınıflandırması aynen geçerlidir; her modülde her gösterge etiketlidir.

### 0.2. Rakiplerin yapamadığı şey: formülü açmak

Tüketici sağlık cihazlarındaki bileşik skorların (Whoop Recovery, Oura Readiness, Garmin Body Battery) bağımsız değerlendirmesi şunu buldu: **incelenen 14 bileşik skorun hiçbiri hakemli literatürde bağımsız doğrulanmamış ve hiçbir üretici skorunun nasıl hesaplandığını açıklamıyor** ([*Readiness, recovery, and strain: an evaluation of composite health scores in consumer wearables*, 2025](https://www.researchgate.net/publication/390665585_Readiness_recovery_and_strain_an_evaluation_of_composite_health_scores_in_consumer_wearables)). Sigara bırakma uygulamalarında durum daha kötü: popüler uygulamaların kanıta dayalı kılavuz uyum skoru 42 üzerinden ortalama **12,9** ve *kılavuzlara en az uyan uygulamalar çoğu zaman en popüler olanlar* ([*Adherence of popular smoking cessation mobile applications to evidence-based guidelines*, PMC6567534](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6567534/)).

**Halen'in stratejik hamlesi:** her indeksin formülünü, katsayısını ve kaynağını uygulama içinde açmak. Mevcut `how_calculated_screen.dart` bir yasal zorunluluk değil, **ürünün ana pazarlama argümanı** olarak konumlanır: *"Gördüğün her sayının formülü burada."* Rakiplerin hiçbiri bunu yapamaz, çünkü formülleri yoktur.

### 0.3. Modül haritası

| # | Modül (TR) | Modül (EN) | Ana gösterge | Sınıf |
|---|---|---|---|---|
| 1 | Vücut Yükü | Body Load | Nikotin / CO / katran maruziyet eğrileri | S3 |
| 2 | Zararlı Madde Kütüphanesi | Toxicant Library | 7.000 bileşik, 70+ kanserojen | S4 |
| 3 | Ekonomi | Economy | Tasarruf, kayıp, projeksiyon, zaman defteri | S2+S3 |
| 4 | İstek–Nikotin İlişkisi | Craving ↔ Nicotine | Kriz penceresi tahmini | S3 |
| 5 | Kriz Kurtarma Seti | SOS Toolkit | 30 sn – 5 dk müdahaleler | S4 |
| 6 | Akciğer | Lungs | Akciğer yaşı + yük/temizlenme animasyonu | S3+S4 |
| 7 | Organ Haritası | Organ Map | Organ bazlı göreli risk | S4 |
| 8 | Psikolojik Durum | Mind State | Tahmini huzursuzluk/kaygı eğrisi | S3 |
| 9 | Yumuşak Geçiş Motoru | Soft Taper Engine | Aralık artış hızı limiti | S3 |
| 10 | Destek Programı | Support Program | Bitki / beslenme / egzersiz kartları | S4 |
| 11 | İçerik Motoru | Content Engine | Günlük kart, makale, motivasyon | S4 |
| 12 | Kayıt Etkileşimi | Log Interaction | "İçtim" / "Atladım" animasyonları | — |
| 13 | Program Sistemi | Plan System | Plan seçimi ve değiştirme kuralları | S2+S3 |
| 14 | İki İndeks | Two Indices | İlerleme İndeksi + Zarar Yükü İndeksi | S3 |

---

## 1. MODÜL: Vücut Yükü (Body Load) — "Şu anda vücudumda ne var?"

### ① Bilimsel temel

**Nikotin.** Sigara başına sistemik dolaşıma geçen nikotin **1–1,5 mg**'dır; plazma yarı ömrü ortalama **~2 saat**, kişiler arası aralık **~1–4 saat** (CYP2A6 hızına bağlı). Plazma nikotini bifaziktir: hızlı dağılım fazı ~1,35 saat, ardından yavaş terminal eliminasyon. Ana metabolit **kotininin** yarı ömrü **~16–20 saat** olduğu için gün içinde neredeyse sabittir ve maruziyetin gerçek biyobelirtecidir ([Benowitz, PMC2946180](https://pmc.ncbi.nlm.nih.gov/articles/PMC2946180/); [*Nicotine Chemistry, Metabolism, Kinetics and Biomarkers*, Springer](https://link.springer.com/chapter/10.1007/978-3-540-69248-5_2)).

→ **Ürün sonucu:** İki ayrı eğri modellenmelidir, çünkü kullanıcı ikisini de yaşar:
- **Akut eğri (t½ = 2 sa):** tepe/çukur ritmi — kriz tahmininin temeli (Modül 4).
- **Zemin eğrisi (t½ ≈ 16 sa, kotinin proxy):** "kaç gündür gerçekten düşüyorum" — bırakma sonrası ilk 3–4 günün anlatısı.

Mevcut `lib/domain/nicotine_model.dart` yalnızca akut eğriyi üretiyor. **Eksik: kotinin zemin eğrisi** (bkz. §1.⑤).

**Karbonmonoksit (CO).** Dumandaki CO hemoglobine bağlanıp karboksihemoglobin (COHb) oluşturur ve oksijen taşımayı düşürür. Sigara içenlerde ekshale CO'nun ölçülen ortalama yarı ömrü **~4,5–4,6 saat**, mono-eksponansiyel düşüş ([*Assessing Recent Smoking Status by Measuring Exhaled CO*, PLOS One](https://journals.plos.org/plosone/article?id=10.1371%2Fjournal.pone.0028864)); COHb yarı ömrü oda havasında **~5–6 saat**, maruziyet süresine göre bifazik ([PubMed 10912868](https://pubmed.ncbi.nlm.nih.gov/10912868/)). 12–24 saatte tipik olarak içmeyen aralığına iner — WHO/CDC zaman çizelgesindeki "12 saat" kilometre taşının dayanağı budur.

→ **Ürün sonucu:** CO, **ilk 24 saatin kahramanıdır.** Nikotin eğrisi kullanıcıya kriz anlatır; CO eğrisi ise "kanım şu anda daha fazla oksijen taşıyor" gibi **pozitif** ve hızlı geri bildirim verir. Bırakma gününde ana ekranın merkezine nikotin değil, **CO iyileşme eğrisi** konur. Rakiplerin hiçbirinde bu ayrım yok.

**Katran (tar).** Burada dürüst olmak zorunludur: **"kandaki katran oranı" diye bir büyüklük yoktur.** Katran, dumanın nikotin ve su çıkarıldıktan sonra kalan partikül fazıdır; kanda taşınan tek bir "katran konsantrasyonu" değildir — solunum yollarında birikir, bir kısmı mukosiliyer klirensle temizlenir. Üstelik paketteki katran değerleri ISO makine ölçümüdür ve insan maruziyetini **sistematik olarak olduğundan az gösterir**: ISO rejimi dakikada bir, 2 saniyelik, 35 ml'lik nefes alır; gerçek içiciler daha sık, daha derin ve daha hızlı çeker, düşük katranlı sigarada havalandırma deliklerini kapatır ("kompanzasyon") ([*Cigarette Yields and Human Exposure*, AACR CEBP](https://aacrjournals.org/cebp/article/15/8/1495/173726/Cigarette-Yields-and-Human-Exposure-A-Comparison); [*Dependence of tar, nicotine and CO yields on physical parameters*, PMC2598502](https://pmc.ncbi.nlm.nih.gov/articles/PMC2598502/)). Makine değerleri sigaraları *karşılaştırmak* için vardır, bireysel maruziyeti *öngörmek* için değil.

→ **Ürün sonucu (kritik karar):** **Katran asla mg cinsinden gösterilmez.** Yerine birimsiz bir **Kümülatif Partikül Yükü (Katran Yükü) 0–100** indeksi üretilir; referansı kullanıcının kendi taban çizgisidir. Kullanıcı "azaldı mı arttı mı" sorusunun doğru cevabını alır, sahte bir miligram görmez. Kalıcı dipnot: *"Katran miktarı vücutta ölçülemez; bu, kendi kayıtlarına göre göreli maruziyet göstergendir."*

### ② Pazar emsali

| Uygulama | Ne yapmış | Ders |
|---|---|---|
| **Smoke Free** | "Nikotin vücuttan temizlendi", "CO seviyesi normale döndü" tipi sağlık ilerleme kartları; kategorinin en zengin istatistik seti | **İyi:** WHO çizelgesine sadık, çok metrikli. **Kötü:** her kart upsell duvarı arkasında |
| **QuitNow!** | 80 kilometre taşı, "vücudun temizleniyor" dili | **Kötü:** tamamen zamana bağlı; günde 40 içen ile 5 içen aynı ekranı görüyor — kişisel veri hiç kullanılmıyor |
| **Kwit** | Ayrı bir bilimsel dayanak sayfası + oyunlaştırılmış seviyeler | **İyi:** bilimsel şeffaflık girişimi. **Kötü:** model/eğri yok; seviye anlatısı bilimin önüne geçiyor |
| **Flamy** | Taper modu + Craving SOS | **İyi:** azaltma odaklı. **Kötü:** maruziyet modeli yok |
| Kategori dışı: **Whoop / Oura / Garmin** | 0–100 bileşik skor + renk bölgesi (yeşil 67–100 / sarı 34–66 / kırmızı 0–33) + "skoru oluşturan faktörler" dökümü | **Devralınacak:** tek büyük sayı + hemen altında "bunu ne oluşturdu" dökümü. **Devralınmayacak:** formülü gizlemek (§0.2) |

**Boşluk:** Hiçbir sigara uygulaması kullanıcının **gerçek zaman damgalı kayıtlarından** farmakokinetik eğri üretmiyor; hepsi "bırakma tarihinden bu yana geçen süre" aritmetiği yapıyor. Kayıt-tabanlı gerçek eğri, Halen'in savunulabilir teknik farkıdır ve zaten toplanan veriyle (`records` tablosu) ek maliyetsiz gelir.

### ③ Bizim tasarımımız

**Dört yük göstergesi, tek kart.**

| Gösterge | Model | Yarı ömür | Anlatı | Renk |
|---|---|---|---|---|
| **Nikotin (akut)** | Σ 1,2 mg · 2^(−Δt/2sa) | 2 sa | "Şu an" / kriz penceresi | Amber |
| **Nikotin zemini** (kotinin proxy) | Σ 1,2 mg · 2^(−Δt/16sa) | 16 sa | "Kaç gündür gerçekten düşüyor" | Turuncu |
| **Oksijen borcu (CO)** | Σ birim · 2^(−Δt/4,5sa) | 4,5 sa | "Kanının oksijen taşıması" — pozitif çerçeve | Mavi-yeşil |
| **Katran (kümülatif)** | Σ adet · klirens t½ ≈ 30 gün | ~30 gün | "Uzun vadeli birikim" — yavaş, sabırlı | Kömür grisi |

Katran klirensi için tek bir bilimsel sayı yoktur; bu yüzden **açıkça temsilî (S4)** etiketlenir, "aylar–yıllar ölçeğinde yavaş temizlenen birikim" olarak sunulur; **asla "%X temizlendi" denmez.**

**"Şu anda" cevabı** ekranın en üstünde tek cümledir:

> **Son sigaradan bu yana 6 sa 20 dk.** Tahmini nikotin yükün tepe değerinin **%12'sine** indi. Oksijen borcun **%38** azaldı.
> *Bu tahminler kendi kayıtlarından hesaplanır; ölçüm değildir.*

### ④ Grafik şartnamesi

**Ana grafik: 24 saatlik testere-dişi eğrisi (sawtooth).** Üründeki en imzasal görsel.
- **X:** son 24 saat, 15 dk çözünürlük (mevcut `proxyCurve(stepMinutes: 15)` ile birebir uyumlu).
- **Y:** 0–100 normalize (mutlak ng/mL **asla**). Eksen etiketleri sayı değil bant adı: `Düşük / Orta / Yüksek`.
- **Eğri karakteri:** her sigara dik yükseliş + üstel düşüş üretir. Bu şekil kullanıcıya *kendi ritmini* gösterir — pazarda olmayan "aha" anı budur.
- **Olay işaretleri:** her sigara alt eksende tik; **atlatılan kriz yeşil tik**. Atlanan krizler eğride "oluşmamış tepe" olarak kesikli hayalet çizgiyle gösterilir → *"bu tepe senin sayende oluşmadı."*
- **Şu an çizgisi:** dikey, sağ kenarda büyük mevcut değer rozeti.
- **Erişilebilirlik:** renk tek başına anlam taşımaz (bant adı + şekil); kontrast ≥ 4.5:1; her nokta için `Semantics` (VoiceOver: "14:30, tahmini yük 62, yüksek bant").
- **Okunabilirlik:** grid çizgisi en fazla 3; nokta işaretleyici yok (96 nokta gürültü olur); dolgu gradyanı %8→%0 opaklık.

**İkincil grafik:** 7/30 günlük yük bandı — günlük ortalama ve tepe yük mini alan grafiği + trend oku (`▼ %18, son 7 gün`).

**Kütüphane kararı:** mevcut `lib/presentation/widgets/charts` korunur; harici paket yerine `CustomPainter` (bağımlılık ve APK boyutu disiplini + testere-dişi zaten özel çizim ister).

### ⑤ Algoritma / veri modeli

`lib/domain/nicotine_model.dart` → `lib/domain/body_load_model.dart` olarak genişletilir:

```dart
enum LoadKind { nicotineAcute, nicotineBaseline, carbonMonoxide, tarCumulative }

const halfLivesHours = <LoadKind, double>{
  LoadKind.nicotineAcute:    2.0,    // Benowitz / Hukkanen
  LoadKind.nicotineBaseline: 16.0,   // kotinin proxy
  LoadKind.carbonMonoxide:   4.5,    // ekshale CO
  LoadKind.tarCumulative:    720.0,  // ~30 gün, S4 temsilî
};
// C(t) = Σ doz · 2^(−Δt / t½);  UI yalnızca normalize(0..100) görür.
```

**Kişiselleştirme (opsiyonel, S3):** "metabolizma hızı" ayarı `yavaş / normal / hızlı` (t½ = 3 / 2 / 1,3 sa). Ölçüm değildir; "kendi hissettiğin ritme göre eğriyi kalibre et" olarak sunulur, varsayılan **normal**. Dayanak: CYP2A6 kaynaklı 1–4 saat aralığı.

**Marka doğruluğu:** paket markasına göre katran/nikotin mg değeri **hesaba katılmaz** (ISO yanıltıcılığı, §1.①). Marka sorulursa yalnızca istatistik için saklanır ve bu ekranda yazılır.

### ⑥ EN/TR metin

| EN | TR |
|---|---|
| Body Load | Vücut Yükü |
| Estimated nicotine load | Tahmini nikotin yükü |
| All-day nicotine baseline | Gün boyu nikotin zemini |
| Oxygen debt (carbon monoxide) | Oksijen borcu (karbonmonoksit) |
| Cumulative particle load (tar) | Kümülatif partikül yükü (katran) |
| This is a model, not a measurement. | Bu bir ölçüm değil, tahmindir. |
| Since your last cigarette | Son sigaranın üzerinden |
| A peak that never happened | Oluşmayan tepe |

---

## 2. MODÜL: Zararlı Madde Kütüphanesi (Toxicant Library)

### ① Bilimsel temel

Sigara dumanı **7.000'den fazla kimyasal** içerir; bunların **70'ten fazlası kanserojendir** ([CDC, *Cigarette Smoking*](https://www.cdc.gov/tobacco/about/index.html); [American Cancer Society, *Health Risks of Smoking Tobacco*](https://www.cancer.org/cancer/risk-prevention/tobacco/health-risks-of-smoking-tobacco.html)). Modül bunların bir alt kümesini (12–20 madde) tanınabilir günlük eşdeğerleriyle anlatır: formaldehit, benzen, amonyak, kadmiyum, arsenik, polonyum-210, akrolein, aseton, hidrojen siyanür, katran, nitrozaminler (TSNA), karbonmonoksit.

**Etik sınır:** Bu eşdeğerler resmî kurumların da kullandığı bir iletişim aracıdır ama **doz anlamı taşımaz.** "Sigarada pil metali var" cümlesi "bir pili yalamakla aynı" demek değildir; kart arkasında bu her zaman yazar. Abartılmış korku, ürünün dürüstlük konumunu kırar (bkz. §11.① fear appeal kanıtı).

### ② Pazar emsali

Çoğu uygulama bu içeriği ya hiç vermiyor ya da statik "biliyor muydunuz" listesi olarak veriyor. **Boşluk:** maddeyi kullanıcının *kendi kaydına* bağlamak.

### ③ Bizim tasarımımız

**"Bugün temas ettiklerin" kartı (S4).** Kullanıcı bugün 9 sigara kaydettiyse: dokuz noktalı ızgara + "bugünkü dumanla temas ettiğin bilinen kanserojenlerden 6'sı". Sayısal doz üretilmez; **madde adı, mekanizma ve kaynak** gösterilir. Her kart: madde → başka nerede bulunur → vücutta ne yapar → IARC sınıfı → kaynak linki.

### ④ Grafik
- **70+ kanserojen nokta matrisi:** 7×10 ızgara; dokunulan nokta adı/kaynağı açar. Düz listeden çarpıcı ve tarama maliyeti düşük.
- Madde kartı: tek renkli piktogram (fotoğraf değil — telif riski + tiksinti dozu kontrolü).

### ⑤ Veri modeli
Mevcut `content` tablosu ve `content_dao.dart` yeniden kullanılır; `toxicant` tipi eklenir: `key, name_en, name_tr, everyday_analogy, mechanism, iarc_group, source_url`. Tamamen yerel JSON seed, ağ çağrısı yok.

---

## 3. MODÜL: Ekonomi (Economy) — kâr / zarar

### ① Bilimsel / veri temeli

Bu modül tamamen **S2 (kullanıcı girdisi) + aritmetiktir**; dolayısıyla üründeki **en kesin** modüldür ve bu üstünlük vurgulanmalıdır: *"Bu ekrandaki hiçbir şey tahmin değil — kendi verinle birebir hesap."*

Girdi: paket fiyatı, paketteki adet, gerçek kayıt, para birimi. TR'de 2026 itibarıyla ana akım paket ~₺100–150 (ana rapor §2); ABD ort. $10,15; UK ~£16,5–17,8. Sigara fiyatının enflasyon üstü artışı bu modülü her yıl güçlendirir.

**Zaman boyutu (S4, kaynaklı):** 2024 UCL / *Addiction* çalışması sigara başına **~20 dakika** yaşam kaybı hesaplıyor (erkek 17 dk, kadın 22 dk); bu, 2000 tarihli 11 dakika tahmininin güncellenmiş halidir ([CNN özeti](https://www.cnn.com/2025/01/01/health/cigarette-smoking-life-expectancy-study-wellness); [RCP açıklaması](https://www.rcp.ac.uk/news-and-media/news-and-opinion/rcp-responds-to-ucl-research-showing-a-single-cigarette-can-take-20-minutes-off-life-expectancy/)). Aynı çalışmanın pozitif çerçevesi doğrudan ürün metnine geçer: *1 Ocak'ta bırakan biri 8 Ocak'ta bir gün, şubat ortasında bir hafta, yıl sonunda ~50 gün kazanır.*

**Uyarı:** "20 dakika" popülasyon ortalamasıdır, kişisel vaat değildir — S4 etiketi ve "ortalama" kelimesi metinden çıkarılamaz.

### ② Pazar emsali

| Uygulama | Ne yapmış | Ders |
|---|---|---|
| **Quit Tracker** (4,8 / 180K) | Para ve "geri kazanılan yaşam" en sevilen iki metrik — reklam toleransını bile aşmış | **Para metriği kategorinin en güçlü duygusal kancasıdır**; ana ekranda olmalı |
| **QuitNow / Kwit / Smoke Free** | Kümülatif tasarruf sayacı | Hepsinde var, hepsi *yalnızca toplam* gösteriyor; projeksiyon ve "neye denk" yok |
| Kategori dışı: **YNAB / Copilot Money** | Tasarrufu somut hedefe eşleme, yıllıklandırma, "run rate" | **Devralınacak:** hedefe bağlama + gelecek projeksiyonu |
| Kategori dışı: **Strava** | Kümülatif mesafeyi eşdeğerle anlatma ("X kez maraton") | **Devralınacak:** eşdeğer çevirisi soyut sayıyı bedene bağlar |

### ③ Bizim tasarımımız — dört katman

1. **Gerçekleşen tasarruf (S2).** İçilmemiş sigaraların parasal karşılığı. *Taban çizgisi dürüstlüğü:* taban = onboarding beyanı değil, **ilk 7 günün ölçülen ortalaması** (beyan sistematik olarak düşük raporlanır; tasarrufu şişirmemek için kritik).
2. **Süregelen kayıp (S2).** Bugüne kadar hâlâ içilenlerin maliyeti. Rakiplerde yok — kimse kötü haberi göstermeye cesaret edemiyor. "Kâr/zarar" talebinin *zarar* tarafı budur ve suçlayıcı olmayan dille verilir: nötr gri, büyütülmemiş tipografi, yorum cümlesi yok.
3. **Projeksiyon (S3).** Mevcut hızla 1 / 5 / 10 yıl. İki senaryo çizgisi: **"şimdiki hızın"** vs **"planı tamamlarsan"**; aradaki alan taranır ve etiketlenir: *"Bu taralı alan senin kararın."* Tek başına bütün modülün özeti olan görsel budur.
4. **Eşdeğer motoru (S2).** Tutar yerel para biriminde somut nesnelere çevrilir; **kullanıcı kendi hedefini yazabilir** (TR varsayılanları: aylık market, tam depo yakıt, spor salonu üyeliği, uçak bileti — EN listesi farklı). Kullanıcının kendi hedefi bizim önerimizden güçlüdür; hedef girildiğinde ilerleme çubuğu ana ekrana çıkar.

**Zaman kâr/zararı** aynı kartın ikinci sekmesi: kazanılan/kaybedilen saat (20 dk/sigara, S4).

### ④ Grafik şartnamesi
- **Ana görsel: iki senaryolu alan grafiği.** X: bugün → 12 ay; Y: kümülatif tutar; iki çizgi + taralı fark alanı + fark tutarı rozeti.
- **İkincil: haftalık sütun** — tasarruf (yeşil) ve harcama (nötr gri) yan yana. **Kırmızı kullanılmaz** (suçlama tonu yasak).
- **Hedef ilerleme çubuğu:** kullanıcının kendi hedefi, % ve kalan gün.
- **Yerelleştirme:** para biçimi ve binlik ayırıcı yerelden (`₺1.250` / `$1,250`); eksende 4+ hane kısaltılır (`1,2B` / `1.2K`).

### ⑤ Algoritma
Mevcut `lib/domain/savings.dart` genişletilir: `baselineFromFirstWeek()`, `ongoingCost()`, `projection(scenario, horizon)`, `equivalents(locale, amount)`, `timeLedger()`. Tümü saf fonksiyon + altın-değer birim testleri.

### ⑥ EN/TR
| EN | TR |
|---|---|
| Money saved / Money still spent | Kazanılan / Hâlâ harcanan |
| If you keep this pace vs. if you finish your plan | Bu hızla devam edersen vs. planı tamamlarsan |
| This shaded area is your decision. | Bu taralı alan senin kararın. |
| Time ledger | Zaman defteri |
| Your goal | Senin hedefin |

---

## 4. MODÜL: İstek–Nikotin İlişkisi (Craving ↔ Nicotine)

> Talep: *"Bağımlılıkla kandaki nikotin arasını gösteren bir şey de olması lazım — nikotin oranı arttıkça istek artıyor mu, grafikleri, ne yapması gerektiği."*

### ① Bilimsel temel

İlişki sanıldığı gibi "nikotin arttıkça istek artar" değildir; **tersidir ve daha ilginçtir.**

1. **İstek, düşüşle gelir.** Nikotin düzeyi düştükçe (çukur), yoksunluk belirtileri ve istek yükselir; nikotin verildiğinde istek bastırılır. NRT çalışmalarında bu ilişki doz-yanıtlıdır: transdermal nikotin dozu arttıkça istek ve "içme dürtüsü" maddelerindeki baskılanma artar ([*Reduction of abstinence-induced withdrawal and craving using high-dose NRT*, Psychopharmacology](https://link.springer.com/article/10.1007/s00213-005-0184-3)). Dört farklı NRT formülasyonunda 1.077 katılımcı ve 39.802 anlık istek gözlemiyle kurulan popülasyon PK/PD modeli, **plazma nikotin konsantrasyonu ile anlık isteği akut tolerans içeren bir Emax modeliyle** ilişkilendirmiştir ([*Relating Nicotine Plasma Concentration to Momentary Craving*, PubMed 31355455](https://pubmed.ncbi.nlm.nih.gov/31355455/)).
2. **Ama yüksek taban = yüksek yoksunluk.** Bırakma öncesi plazma nikotin düzeyi, sonraki yoksunluk şiddetini öngörür: istek, açlık, huzursuzluk, konsantrasyon güçlüğü ve genel yoksunluk şiddeti ile ilişkilidir ([PubMed 3936089](https://pubmed.ncbi.nlm.nih.gov/3936089/)). Yani **"nikotin oranı arttıkça istek artar" ifadesi kısa vadede yanlış, uzun vadede doğrudur:** günlük maruziyeti yüksek olan kişinin *taban ihtiyacı* ve dolayısıyla düşüş anlarındaki isteği daha büyüktür.
3. **İstek sadece nikotinle açıklanmaz.** Duman-dışı, koşullanmış uyaranlar (kahve, araba, telefon konuşması, alkol, sosyal ortam) isteği bağımsız olarak modüle eder ([*Nicotine and Non-Nicotine Smoking Factors Differentially Modulate Craving*, Neuropsychopharmacology](https://www.nature.com/articles/npp2014108)). Bu, **tetikleyici modülünü** (mevcut `trigger_stats.dart`) modelin eşit ortağı yapar.

**Bağımlılık ölçümü (S2, doğrulanmış araç).** Fagerström Testi (FTND/FTCD, 0–10) ve onun iki maddelik kısaltması **Heaviness of Smoking Index (HSI, 0–6)** — "günde kaç adet" + "uyandıktan sonra ilk sigaraya kadar geçen süre". HSI, FTND ile anlamlı uyum gösterir ve bırakma başarısını öngörmede FTCD kadar iyidir, ama kullanıcıya çok daha az yük bindirir ([*Comparing the FTCD and HSI in Predicting Smoking Abstinence*, Nicotine & Tobacco Research](https://academic.oup.com/ntr/article/26/11/1576/7681677); [HSI protokolü, PhenX](https://www.phenxtoolkit.org/protocols/view/330201)).

→ **Ürün kararı:** Onboarding'e **HSI'ın 2 sorusu** eklenir (10 saniye). Bu, üründeki tek doğrulanmış psikometrik ölçektir ve her yerde kaynağıyla anılır. FTND'nin 6 sorusu onboarding'i şişireceği için v1'de yer almaz; ayarlar altında opsiyonel "detaylı bağımlılık testi" olarak sunulabilir.

### ② Pazar emsali

- **Smoke Free** istek kaydı ve tetikleyici analizi yapıyor (kategorinin en iyisi) ama nikotin modeliyle birleştirmiyor.
- **Kwit** "istek geldi" kaydını oyunlaştırmaya bağlıyor; zamanlama analizi yok.
- **Flamy** "Craving SOS" ile ana ekrandan tek dokunuş kriz akışı sunuyor — **devralınacak desen.**
- Kategori dışı **Whoop "Strain Coach"** ve **Oura "ideal bedtime"**: veriden **öngörü + eylem önerisi** üretme deseni. Sadece grafik göstermek yerine *"bugün 15:00–16:00 senin riskli pencerendı"* demek — kategoride kimse yapmıyor.

### ③ Bizim tasarımımız — "Kriz Penceresi Tahmini"

Üç sinyalden risk skoru (S3, 0–100):

| Sinyal | Kaynak | Ağırlık (v1) |
|---|---|---|
| **Nikotin çukuru derinliği** | Body Load akut eğrisi; son doz üzerinden geçen süre / kişisel ortalama aralık | 0,45 |
| **Saat-günü örüntüsü** | Kullanıcının kendi kayıt histogramı (28 günlük hareketli) | 0,35 |
| **Tetikleyici bağlamı** | Kayıtlı tetikleyici etiketlerinin o saatteki sıklığı | 0,20 |

Ağırlıklar v1'de sabittir ve **"Nasıl hesaplanıyor?" ekranında açıkça yayımlanır.** v2'de kullanıcının kendi verisiyle lojistik regresyon kalibrasyonu (yerel, cihazda) yapılabilir — ancak yalnızca ≥ 200 kayıt varsa; altında istatistiksel olarak anlamsızdır ve bunu yazmak zorundayız.

**Ne yapması gerektiği (talebin ikinci yarısı).** Risk skoru bir uyarı değil, **bir kapı**dır: yüksek pencere yaklaşırken uygulama tek bir eylem önerir (Modül 5 SOS setinden, o saatte daha önce işe yaramış olanı önceliklendirerek). Öneri metni asla "sigara içme" değil, **yapılabilir bir şey**dir: *"15:40'ta genelde kahve molasında içiyorsun. Bugün kahveyi ayakta ve dışarıda içmeyi dene — 4 dakika."*

### ④ Grafik şartnamesi

**Ana görsel: çift eksenli "istek vs yük" grafiği.**
- Alt katman: nikotin yükü eğrisi (Modül 1, soluk amber dolgu).
- Üst katman: kullanıcının kaydettiği **istek şiddeti** noktaları (1–10; SOS ekranında kayıtlı) — dolu daireler.
- Sağ üstte tek cümlelik okuma: *"Son 30 günde isteklerinin %71'i, yükün en düşük üçte birindeyken geldi."* — **Bu cümle, tüm modülün ürünleşmiş halidir.** Kullanıcı "istek nikotin bitince geliyormuş" gerçeğini kendi verisinde görür.
- **Isı haritası (heatmap):** 7 gün × 24 saat ızgara; hücre rengi o saatteki içme yoğunluğu. Kişinin haftalık ritmini tek bakışta verir; HabitKit/GitHub katkı ızgarası deseninin kanıtlanmış okunabilirliği.

**Okunabilirlik kuralları:** ısı haritası en fazla 5 renk basamağı; sıfır değeri renk değil kenarlık; hücre boyutu ≥ 24 px dokunma hedefi; renk körlüğü için tek tonlu (monokromatik) skala + sayısal etiket seçeneği.

### ⑤ Algoritma
Yeni `lib/domain/craving_risk.dart`: `riskAt(DateTime)`, `riskCurveToday()`, `topRiskWindows(n)`. Girdi: `record_dao` (kayıtlar), `craving_dao` (istek kayıtları), `trigger_stats.dart`. Çıktı 0–100 + bant (`sakin / dikkat / yüksek`).

### ⑥ EN/TR
| EN | TR |
|---|---|
| Craving window | Kriz penceresi |
| Your risky hours | Riskli saatlerin |
| Craving usually arrives when nicotine is falling. | İstek genellikle nikotin düşerken gelir. |
| Dependence score (HSI) | Bağımlılık düzeyi (HSI) |
| Time to first cigarette | İlk sigaraya kadar geçen süre |

---

## 5. MODÜL: Kriz Kurtarma Seti (SOS Toolkit) — "şu anda ne yapabilirim?"

> Talep: *"O anda hemen uygulanabilecek, onu atlatabilecek teknikler... akupunktur bölgeleri olabilir... bir bardak su içmek vesaire."*

### ① Bilimsel temel — kanıt derecesiyle birlikte

Bu modülün ürün açısından en kritik özelliği, her tekniğin **kanıt seviyesinin kullanıcıya gösterilmesidir.** Bu, hem etik zorunluluk hem de rakiplerden ayrışma noktasıdır. Üç seviye kullanılır:

| Rozet | Anlam |
|---|---|
| 🟢 **Kanıtlı** | Randomize çalışma / meta-analiz desteği var |
| 🟡 **Umut verici** | Sınırlı veya kısa vadeli kanıt |
| ⚪ **Geleneksel** | Bilimsel kanıtı yetersiz; zararsız, isteyen dener |

**🟢 Kısa egzersiz (en güçlü kanıt).** Tek seferlik kısa fiziksel aktivite isteği akut olarak azaltır: bireysel katılımcı verisiyle yapılan meta-analizde etki büyüklüğü **SMD −0,52 ile −0,88** arasında, etki egzersizden sonra **30 dakikaya kadar** sürüyor ([*The acute effects of physical activity on cigarette cravings: IPD meta-analysis*, PubMed 22861822](https://pubmed.ncbi.nlm.nih.gov/22861822/); [Taylor et al., *Addiction* 2007](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1360-0443.2006.01739.x)). Pasif kontrolle karşılaştıran 12 çalışmanın **hepsi** olumlu etki bildirmiştir; etkiler egzersiz sonrası 50 dakikaya kadar sürebilmektedir. → **Ürün sonucu: "5 dakika yürü" üründeki en kanıtlı tek müdahaledir ve SOS ekranının ilk sırasında olmalıdır.** Kategoride hiçbir uygulama bunu bu ağırlıkla öne çıkarmıyor.

**🟢 Yavaş tempolu nefes.** ~6 nefes/dakika (rezonans frekansı) kardiyak vagal aktiviteyi artırır, HF gücünü yükseltir ve tek seansta bile durumluk kaygıyı düşürür ([*Benefits from one session of deep and slow breathing on vagal tone and anxiety*, Scientific Reports](https://www.nature.com/articles/s41598-021-98736-9); [*Single Slow-Paced Breathing Session at Six Cycles per Minute*, PMC8656666](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8656666/); [*The effect of slow breathing in regulating anxiety*, Scientific Reports 2025](https://www.nature.com/articles/s41598-025-92017-5)). İstek üzerindeki doğrudan kanıt karışıktır (gıda isteğinde HRV-biofeedback olumlu). → **Mevcut `breathing_screen.dart` bilimsel olarak doğru temele oturuyor; tek gereken tempoyu 6/dk'ya (≈ 4 sn iç, 6 sn dış) sabitlemek ve kaynağı ekranda göstermektir.**

**🟡 İsteği "sörf etme" (urge surfing) / gecikme.** İstekler epizodiktir: başlar, tepe yapar, söner. Uygulamada 2–5 dakikalık pencerelerle çalışılır; karşılanmayan isteklerin tipik olarak 20–30 dakikayı aşmadığı bildirilir. **Dürüstlük notu:** "her istek 3 dakikada geçer" iddiasının kesin kanıtı yoktur ve uygulama bunu vaat etmez; söylenecek doğru cümle *"istekler dalga gibidir: yükselir ve düşer"*dir ([*Urge Surfing*, PositivePsychology derlemesi](https://positivepsychology.com/urge-surfing/); [Moffitt Cancer Center, *Smoking Urges* hasta broşürü](https://www.moffitt.org/contentassets/54211e9f225e4a899bafb41bcf571959/booklet-2-smoking-urges.pdf)).

**🟡 4D (Delay–Deep breathe–Drink water–Do something else).** NCI/NHS bırakma hizmetlerinin standart hasta materyalinde yer alan davranışsal set. Bileşenlerinden ikisi (nefes, aktivite) bağımsız kanıtlı; "su içmek" için doğrudan RKÇ kanıtı yoktur ama zararsız, sıfır maliyetli ve oral ikame işlevi görür → ⚪/🟡 sınırında, dürüstçe "destekleyici alışkanlık" olarak etiketlenir.

**⚪/🟡 Kulak akupunkturu ve akupresür (talep edilen "akupunktur bölgeleri").** NADA protokolü beş kulak noktası kullanır: **Shen Men, Sempatik (Otonom), Böbrek, Karaciğer, Akciğer** ([NADA protokolü, PMC5485467](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5485467/); [*Effect of self-administered auricular acupressure on smoking cessation*, PMC3328240](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3328240/)). Kanıt durumu **dürüstçe şudur:** güncel Cochrane değerlendirmesi akupunkturu sahte akupunktura karşı **kısa vadede** üstün bulmuştur (RR 1,22; %95 GA 1,08–1,38) ancak **uzun vadeli etki gösterilememiştir** (RR 1,10; %95 GA 0,86–1,40) ([*Acupuncture and related acupoint therapies for smoking cessation: umbrella review*, Tobacco Induced Diseases](https://www.tobaccoinduceddiseases.org/Acupuncture-and-related-acupoint-therapies-for-smoking-cessation-An-umbrella-review,186147,0,2.html)). Aralık 2024'e kadar taranan 9 RKÇ / 1.032 hastalık meta-analiz, kulak akupunktur temelli tedavinin **Minnesota Nikotin Yoksunluk Ölçeği skorunu** NRT'ye kıyasla anlamlı düşürdüğünü bildirmektedir ([PMC11808481](https://pmc.ncbi.nlm.nih.gov/articles/PMC11808481/)).

→ **Ürün kararı:** Kulak akupresürü **⚪ "Geleneksel / umut verici" rozetiyle, kendi kendine uygulanan bası (akupresür) biçiminde** sunulur; iğne asla önerilmez. Metin şu şekilde kurulur: *"Kanıt karışık: kısa vadede yoksunluk belirtilerine yardımcı olduğuna dair veri var, kalıcı bırakma üstünlüğü gösterilememiş. Zararsız; denemek istersen 60 saniyelik rehber."* Bu dürüstlük, özelliği çıkarmaktan **daha** iyi bir ürün kararıdır: kullanıcı istediğini bulur, uygulama güvenilirliğini korur.

### ② Pazar emsali

| Kaynak | Desen | Ders |
|---|---|---|
| **Flamy** | Ana ekranda "Craving SOS" tek dokunuş | Kriz aracı **menü içinde olmaz**; ana ekranda ve kilit ekranı widget'ında olmalı |
| **Smoke Free** | Craving kaydı + tetikleyici sorusu | İyi veri toplar ama kriz anında **soru sormak** yanlış — önce müdahale, sonra (isteğe bağlı) soru |
| **Headspace / Calm** | Nefes animasyonu: genişleyen halka + haptik nabız | **Devralınacak:** görsel + haptik senkron; ekrana bakmadan da takip edilebilir olmalı |
| **One Sec** | Uygulamayı açmadan önce zorunlu nefes/gecikme sürtünmesi | **Devralınacak (Modül 12):** eylemden önce bilinçli duraklama |
| **quitSTART (NCI)** | Bilim temelli içerik, ücretsiz | Ders: içerik doğru olsa da UX hatası puanı yıkar (4,6 → 1,0) |

### ③ Bizim tasarımımız — "60 saniye kuralı"

SOS ekranı açıldığında kullanıcı **hiçbir seçim yapmadan** bir şey yapıyor olmalıdır: ekran açılır açılmaz nefes animasyonu başlar (6/dk). Alt kısımda 4 alternatif kart yatay kaydırmalı: *Yürü (5 dk) · Su · Kulak akupresürü (60 sn) · Ertele (3 dk sayaç)*.

**Kişiselleştirme:** "senin için işe yarayan" — kullanıcı krizden sonra "atlattım / içtim" der; uygulama hangi tekniğin hangi saatte işe yaradığını yerel olarak biriktirir ve sıralamayı ona göre yapar. Bu, kategoride hiç uygulanmamış ve tamamen yerel veriyle mümkün bir farktır.

**Kriz sonrası mikro-anket (opsiyonel, 1 dokunuş):** şiddet 1–10. Bu veri Modül 4'ün grafiğini besler. Atlanabilir olmalı; zorunlu anket kategorinin bilinen ölüm nedenidir.

### ④ Animasyon şartnamesi
- **Nefes halkası:** 4 sn genişleme / 6 sn daralma (6 nefes/dk); ölçek 0,72 → 1,0; `Curves.easeInOutSine`; renk sıcak nötr; arka plan koyulaşır (odak). Haptik: genişlemede yumuşak `HapticFeedback.selectionClick` her saniye, daralmada sessiz.
- **Kulak akupresür rehberi:** stilize kulak vektörü; 5 nokta sırayla vurgulanır (12 sn/nokta), her nokta adı + "yumuşak, dairesel bası" talimatı; **anatomik fotoğraf kullanılmaz** (telif + tıbbi görünüm riski).
- **Ertele sayacı:** dairesel geri sayım; bitince "başardın" mikro-kutlaması (Modül 12 diliyle aynı).
- **Performans bütçesi:** SOS ekranı ≤ 16 ms kare; animasyonlar `AnimationController` + `RepaintBoundary`; düşük güç modunda hareket azaltma (`MediaQuery.disableAnimations`) desteklenir.

### ⑤ Veri modeli
Mevcut `craving_dao.dart` genişletilir: `technique_used`, `outcome (skipped|smoked)`, `intensity`, `hour_bucket`. Öneri sıralaması: `techniqueScore = başarı oranı (o saat bandında) · 0,7 + genel başarı · 0,3`, en az 3 gözlem yoksa varsayılan sıra.

### ⑥ EN/TR
| EN | TR |
|---|---|
| Ride it out | Dalgayı geç |
| Breathe with me | Benimle nefes al |
| Walk it off (5 min) | Yürüyerek at (5 dk) |
| Ear acupressure — traditional | Kulak akupresürü — geleneksel |
| Evidence: strong / promising / traditional | Kanıt: güçlü / umut verici / geleneksel |
| What worked for you before | Sende daha önce işe yarayan |

---

## 6. MODÜL: Akciğer (Lungs) — talep edilen "ciğer görseli ve animasyonu"

### ① Bilimsel temel

**Akciğer fonksiyonunun gerçek büyüklüğü FEV1'dir ve düşüş hızı sigarayla artar.** Fletcher ve Peto'nun klasik çalışması ex-içicilerde **37 ± 8 mL/yıl**, günde 15+ içen ağır içicilerde **80 ± 6 mL/yıl** düşüş bildirmiştir. Güncel havuzlanmış kohortlar daha ılımlı ama aynı yönde: medyan 57 yaşta hiç içmeyen **31,0 mL/yıl**, eski içici **35,0 mL/yıl**, hâlen içen **39,9 mL/yıl**; sürdürülen bırakıcılarda **28 mL/yıl**, aralıklı bırakanlarda 48, devam edenlerde 62 mL/yıl ([*Cigarette smoking and lung function decline beyond quitting*, Ann Transl Med](https://atm.amegroups.org/article/view/44426/html); [NHLBI Pooled Cohorts, PMC7261004](https://pmc.ncbi.nlm.nih.gov/articles/PMC7261004/)).

**Kritik dürüstlük notu:** Fletcher–Peto'nun "bırakınca hasar birkaç yıl içinde durur" sonucu **tartışmalıdır**; güncel kanıt, bırakmadan on yıllar sonra bile hiç içmeyene kıyasla hızlanmış düşüşün sürebildiğini gösteriyor. → **Uygulama asla "akciğerin tamamen iyileşti" demez.** Doğru cümle: *"Bırakmak, düşüş hızını yavaşlatan tek müdahaledir."*

**"Akciğer yaşı" (lung age)** klinik olarak kullanılan, kişinin FEV1'inin hangi yaştaki ortalamaya denk düştüğünü söyleyen iletişim aracıdır ve bırakma motivasyonunu artırdığına dair kullanım geçmişi vardır. **Ancak spirometre gerektirir.** Halen bunu ölçemez.

→ **Ürün kararı (S3/S4 sınırı):** Uygulama **"Tahmini Akciğer Yükü Yaşı"** üretmez. Bunun yerine **popülasyon eğrileri üzerinde iki senaryo** gösterir: "senin yaşın ve içim geçmişinle *tipik* düşüş eğrisi" vs "bugün bıraksan tipik eğri" — grafiğin başlığında **"tipik"** kelimesi zorunludur ve altında *"Bu senin akciğerinin ölçümü değildir; yaş grubun için bilimsel ortalamalardır"* satırı kaldırılamaz. Bu, hem talebi karşılar hem S5'e düşmez.

### ② Pazar emsali

- Kategoride **hiçbir ciddi uygulama akciğer görselleştirmesi yapmıyor** — çünkü "ciğerinin %62'si temiz" demeden yapmak zor ve o cümle yalan. Bu, cesur ama dürüst bir tasarımla **doldurulabilir boşluk**.
- Kötü emsal: web'de yaygın "siyah ciğer / temiz ciğer" öncesi-sonrası görselleri — tıbbi olarak yanıltıcı, korku pornografisi, telifli fotoğraflar. **Kullanılmayacak.**
- İyi emsal (kategori dışı): **Apple Fitness kapanan halkalar** (durum tek bakışta), **Zero** oruç halkası (zaman içinde dolan yay), **Flo/Clue** vücut şeması (stilize, anatomik ama tıbbi olmayan çizim), **Complete Anatomy** (katmanlı vektör anatomi).

### ③ Bizim tasarımımız — "Nefes alan akciğer"

Tek bir stilize vektör akciğer, üç bilgi katmanı taşır:

1. **Yük dolgusu (S3):** Modül 1'in kümülatif partikül yükü, akciğerin alt kısmından yukarı doğru **yarı saydam bir sis** olarak gösterilir. Doluluk = kişinin kendi tabanına göre göreli yük. Kullanıcı azalttıkça sis çekilir. **Yüzde yazılmaz**, "daha az / daha çok" bandı yazılır.
2. **Nefes ritmi:** Akciğer sürekli, çok yavaş nefes alır (4 sn/6 sn — SOS ile aynı tempo). Yük yüksekken hareket genliği daha küçük ve ritim daha "sıkışık"; yük düştükçe genlik açılır. Bu, sayı kullanmadan durumu hissettiren tek öğedir ve tüm ürünün duygusal imzası olabilir.
3. **Kilometre taşı parlaması:** WHO zaman çizelgesindeki bir eşik geçildiğinde (12 sa CO, 2–12 hafta dolaşım, 1–9 ay siliyer fonksiyon/öksürük) akciğer bir kez yumuşakça parlar ve altta o kilometre taşının kaynaklı açıklaması açılır (mevcut `health_timeline.dart` bu içeriği zaten tutuyor).

**İkinci ekran: FEV1 senaryo grafiği** (yukarıdaki ② kararı). X: yaş (şimdiki yaş → 80). Y: tipik FEV1 (% beklenen). Üç çizgi: *hiç içmeyen tipik* (gri kesikli), *bu hızla devam* (amber), *bugün bıraksan* (yeşil). Aradaki alan taranır. Ekonomi modülündeki "taralı alan senin kararın" görsel dili burada tekrar eder — **ürün genelinde tek bir görsel gramer.**

**"Her içtiğinde ne kadar azalacağı" talebi:** Bu, akciğer sisinin *kayıt anında* küçük bir miktar koyulaşmasıyla verilir (Modül 12'deki "içtim" animasyonunun akciğerdeki karşılığı). Sayısal "0,3 mL kaybettin" gibi ifade **üretilmez** — tek bir sigaranın bireysel FEV1 etkisi ölçülebilir bir büyüklük değildir.

### ④ Animasyon şartnamesi
- Akciğer: tek `Path`, 2 lob + trakea; `CustomPainter`; nefes döngüsü ölçek 0,98 → 1,02 + hafif opaklık salınımı (yanıp sönme değil).
- Sis: `SweepGradient` değil, alttan üste `LinearGradient` maskesi; doluluk animasyonu 800 ms `Curves.easeOutCubic`.
- Kilometre taşı parlaması: 1.200 ms, tek sefer, `BlendMode.plus` ile dış hat parlaması; hareket azaltma açıksa yalnızca renk geçişi.
- **Ton kuralı:** akciğer asla siyah/hastalıklı çizilmez ve asla kanlı/korkutucu doku dokusu kullanılmaz; yük "duman/sis" metaforuyla temsil edilir. Gerekçe: fear appeal etkisi ancak öz-yeterlik mesajıyla birlikte işe yarar (§11.①); saf korku, kullanıcıyı uygulamadan uzaklaştırır.
- Karanlık/aydınlık temada iki ayrı palet; hareket azaltma (`disableAnimations`) tüm animasyonları statik kareye indirir.

### ⑤ Veri modeli
Yeni `lib/domain/lung_model.dart`: `typicalFev1Curve(age, sex, packYears, quitAge?)` — popülasyon katsayıları sabit tablo (yukarıdaki mL/yıl değerleri), çıktı **"tipik" etiketli**; `mistLevel()` Body Load'dan türetilir. `health_timeline.dart` ile eşleşme: `milestoneGlowTrigger`.

### ⑥ EN/TR
| EN | TR |
|---|---|
| Your lungs today | Bugün akciğerlerin |
| Typical decline for your age | Yaşın için tipik düşüş |
| If you quit today | Bugün bırakırsan |
| This is not a scan of your lungs. | Bu, akciğerinin görüntüsü değildir. |
| Quitting is the only thing that slows this line. | Bu çizgiyi yavaşlatan tek şey bırakmaktır. |

---

## 7. MODÜL: Organ Haritası (Organ Map)

> Talep: *"Diğer organların sigaradan etkilendiği, hangi organ yüzde kaç oranda etkileniyor, güzel görseller."*

### ① Bilimsel temel ve bir uyarı

"Hangi organ yüzde kaç etkilenir" sorusunun tek bir doğru sayısal cevabı **yoktur**; literatürde iki farklı büyüklük vardır ve karıştırılmaları en sık görülen popüler hatadır:

1. **Atfedilen risk (attributable fraction):** *"ABD'de akciğer kanseri ölümlerinin %87'si, koroner kalp hastalığı ölümlerinin %32'si, KOAH vakalarının %79'u sigaraya bağlanıyor"* ([HHS Surgeon General fact sheet](https://www.hhs.gov/surgeongeneral/reports-and-publications/tobacco/consequences-smoking-factsheet/index.html)) — bu **popülasyon** düzeyinde bir orandır, "senin akciğerinin %87'si etkilendi" demek değildir.
2. **Göreli risk (relative risk):** içenin içmeyene göre kaç kat riskli olduğu. Örnek büyük kohort verileri: böbrek yetmezliği RR 2,0; hipertansif kalp hastalığı RR 2,4; enfeksiyonlar RR 2,3; çeşitli solunum hastalıkları RR 2,0; meme kanseri RR 1,3; prostat kanseri RR 1,4 ([*Smoking and Mortality — Beyond Established Causes*, NEJM](https://www.nejm.org/doi/full/10.1056/NEJMsa1407211)).

Ayrıca 2014 Surgeon General raporu ile nedensellik listesi genişlemiştir: yaşa bağlı makula dejenerasyonu, diyabet, kolorektal kanser, karaciğer kanseri, tüberküloz, **erektil disfonksiyon**, dış gebelik, romatoid artrit, bağışıklık baskılanması ([ASH özeti](https://ash.org/surgeon-general-report-links-more-diseases-health-problems-to-smoking-tobacco/); [2014 SGR](https://www.ncbi.nlm.nih.gov/books/NBK294317/table/ch4.t1/)). Düşük tüketimin bile güvenli olmadığı ayrıca gösterilmiştir: günde 1 sigara, günde 20 sigaranın koroner kalp hastalığı ve inme riskinin yaklaşık **yarısını** taşır ([*Low cigarette consumption and risk of CHD and stroke: meta-analysis of 141 cohort studies*, PMC5781309](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5781309/)) — **bu bulgu "azaltma" modumuz için hayati dürüstlük notudur ve azaltma ekranlarında görünmek zorundadır** (bkz. §13).

→ **Ürün kararı:** Organ haritasında **kişiselleştirilmiş yüzde gösterilmez** (S5). Gösterilen: organ → nedensel bağlantı listesi → göreli risk aralığı (varsa) → **bırakınca ne oluyor** (asıl mesaj) → kaynak. Yüzdeler yalnızca *popülasyon* etiketiyle ve kaynak cümlesiyle birlikte kullanılır.

### ② Pazar emsali
Kategoride yalnızca metin listeleri var. Kategori dışı iyi emsaller: **Flo / Clue** vücut şeması, **Headspace** organ animasyonları, tıbbi eğitim uygulamalarındaki katmanlı vektör anatomi. Ders: **anatomik doğruluk + tıbbi olmayan estetik** birlikte mümkün.

### ③ Bizim tasarımımız
İnsan silueti üzerinde 12 dokunulabilir bölge: beyin, göz, ağız/diş, boğaz/gırtlak, akciğer, kalp, damarlar, mide, karaciğer, böbrek/mesane, üreme sistemi, cilt/yara iyileşmesi, kemik. Her bölge: **çift kart** — "sigara ne yapıyor" (nötr, kaynaklı) ve "bırakınca ne oluyor" (zaman çizelgesiyle). İkinci kart her zaman **daha büyük ve daha renkli**dir; tasarım kararı olarak umut, korkudan daha çok yer kaplar.

**Kişiselleştirme (dürüst):** kullanıcının yaşı ve içim süresine göre yalnızca **sıralama** değişir (ör. 45+ ve 20+ yıl içimde kardiyovasküler kartlar öne çıkar), sayılar değişmez.

### ④ Grafik
- Siluet: tek renkli, cinsiyet-nötr varsayılan (ayarlardan değiştirilebilir); etkilenen bölgeler nabız gibi çok yavaş parlar (döngü ≥ 4 sn, dikkat çalmayan).
- Organ kartı açıldığında siluet küçülür ve organın vektör detayı büyür (paylaşılan eleman geçişi, 300 ms).
- **Renk yasağı:** kırmızı/kanlı doku, gerçek patoloji fotoğrafı, ameliyat görseli yok.

### ⑤ Veri modeli
`content` tablosunda `organ` tipi: `key, name_en, name_tr, harm_text, recovery_text, rr_range, source_url, sort_weight`.

---

## 8. MODÜL: Psikolojik Durum (Mind State)

> Talep: *"Sigaranın psikolojik etkileri... 'şu kadar içmedin, sinirli olabilirsin', anlık kaygı düzeyi, yüzde kaç daha sinirli/kaygılı/huzursuz."*

### ① Bilimsel temel

**Yoksunluk zaman çizelgesi.** Belirtiler saatler içinde başlar, **1.–3. günlerde tepe yapar**, ortalama **3–4 hafta** sürer; duygulanım belirtileri (kaygı, anhedoni, disfori, irritabilite) ile somatik belirtiler (iştah artışı, uyku bozukluğu, konsantrasyon güçlüğü) ayrı seyreder ([*Nicotine Withdrawal*, PMC4542051](https://pmc.ncbi.nlm.nih.gov/articles/PMC4542051/)). Bırakma öncesi maruziyet düzeyi, sonraki yoksunluk şiddetini öngörür (§4.①).

**Çok önemli karşı-anlatı (ürünün en güçlü mesajlarından biri).** Sigara "stresi azaltıyor" hissi, büyük ölçüde **yoksunluğun geçici olarak giderilmesidir**; bırakanlarda ruh sağlığı **iyileşir**: Taylor ve ark. BMJ 2014 meta-analizi (26 çalışma), bırakanlarda devam edenlere kıyasla kaygı, depresyon, karışık kaygı-depresyon ve stresin anlamlı azaldığını, pozitif duygulanım ve psikolojik yaşam kalitesinin arttığını; etki büyüklüğünün psikiyatrik tanısı olanlarda da benzer olduğunu ve **mood/anksiyete bozukluklarında antidepresan tedavi etkisine eşit veya ondan büyük** olduğunu bildirmektedir ([PubMed 24524926](https://pubmed.ncbi.nlm.nih.gov/24524926/); [Cochrane 2021, Taylor GMJ](https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD013522.pub2/full)).

→ **Ürün sonucu:** Uygulama, 2.–4. haftada (yoksunluğun psikolojik olarak en yorucu ve nüksün en yaygın olduğu dönem) bu bulguyu bir kilometre taşı kartı olarak sunar: *"Şu an kendini kötü hissediyor olabilirsin — bu geçici. Bırakanlarda kaygı ve depresyon ortalamada düşüyor, artmıyor."* Kaynaklı, tarihli, tek ekran.

### ② Pazar emsali
- **Kwit** duygu durumu kaydı yapıyor ama tahmin/öngörü üretmiyor.
- **I Am Sober** günlük "pledge" + duygu notu; topluluk desteği güçlü.
- Kategori dışı **Daylio / How We Feel:** düşük sürtünmeli duygu kaydı (tek dokunuş yüz/renk seçimi) — **devralınacak desen.**
- Kategori dışı **Whoop "Stress Monitor" / Garmin "Body Battery":** tahmini bir iç durumu 0–100 sunma cesareti. **Devralınacak:** tahmini durumun görselleştirilmesi. **Devralınmayacak:** ölçüm gibi sunma.

### ③ Bizim tasarımımız — "Tahmini Huzursuzluk Eğrisi" (S3)

Kullanıcıya **"şu an %38 daha sinirlisin"** gibi bir sayı verilmez — bu ölçülemez ve S5'tir. Bunun yerine **bant** verilir:

> **Şu an muhtemel yoksunluk basıncı: Orta–Yüksek.**
> Son sigarandan 4 sa 10 dk geçti; senin normal aralığın 1 sa 40 dk. Bu saatlerde genelde gerginlik bildiriyorsun.
> *Bu bir tahmin; nasıl hissettiğini yalnızca sen bilirsin →* [Nasıl hissediyorsun? ▸]

Model girdileri: (a) nikotin çukuru derinliği (Modül 1), (b) bırakma/azaltma gününden bu yana geçen süre — 1–3. gün tepe eğrisi (yukarıdaki kaynak), (c) kullanıcının kendi geçmiş duygu kayıtları. Çıktı 3 bant: `sakin / basınç altında / zorlu`.

**Kalibrasyon döngüsü (ürünün zarif kısmı):** kullanıcı tek dokunuşla gerçek halini söyler; uygulama tahminini onunla karşılaştırır ve *"tahminim tuttu / tutmadı"* geri bildirimiyle kişisel ofset öğrenir. Bu, "ölçüyorum" demeden kişiselleştirmenin dürüst yoludur ve kullanıcıya kontrolü verir.

### ④ Grafik şartnamesi
- **Yoksunluk basıncı eğrisi:** bırakma günü + 28 gün; tepe 1.–3. gün, sonra üstel sönüm; kullanıcının bulunduğu nokta işaretli. Başlık: *"Tipik seyir"* + kişisel işaret.
- **Duygu kaydı ızgarası:** 28 gün × 4 zaman dilimi, renk = bildirilen hal. Duygu için **kırmızı-yeşil değil**, soğuk-sıcak skala (renk körlüğü + değer yargısı yükünü azaltmak için).
- **"Beklenen vs yaşanan" örtüşme grafiği:** iki çizgi; kullanıcı kendi öngörülebilirliğini görür. Bu, kategoride hiç yok ve içgörü değeri çok yüksek.

### ⑤ Veri modeli
Yeni `mood` tablosu: `ts, band(0..2), note?, source(manual|prompted)`. Yeni `lib/domain/withdrawal_model.dart`: `pressureAt(now)`, `typicalCurve(daysSinceQuit)`, `personalOffset()`.

### ⑥ EN/TR
| EN | TR |
|---|---|
| Likely withdrawal pressure | Muhtemel yoksunluk basıncı |
| Calm / Under pressure / Tough | Sakin / Basınç altında / Zorlu |
| This is a guess. Only you know how you feel. | Bu bir tahmin. Nasıl hissettiğini yalnızca sen bilirsin. |
| Quitting lowers anxiety on average — it doesn't raise it. | Bırakmak ortalamada kaygıyı düşürür, yükseltmez. |

---

## 9. MODÜL: Yumuşak Geçiş Motoru (Soft Taper Engine)

> Talep: *"Birer saat arayla içiyorsa onu birden yarım saate indirdiğimizde agresif/huzursuz olması... bunları yumuşak geçişle bitirebilmesi gerekiyor."*

*(Not: talepte "yarım saate indirmek" denilmiş; azaltma yönü aralığı **uzatmaktır** — 1 saatten 1,5 saate. Bu modül aralık uzatma hızını yönetir.)*

### ① Bilimsel temel

**Programlı azaltma (scheduled smoking / nicotine fading)** sigaralar arası aralığı önceden belirlenmiş bir programa göre kademeli uzatır. En büyük RKÇ'de (916 katılımcı, Houston) programlı azaltma grupları ile kontrol arasında **genel** bırakma farkı bulunmamıştır; **ancak programa uyum güçlü etki göstermiştir:** uyum, 6. ayda abstinans ile ilişkilidir (OR 2,01; %95 GA 1,31–3,07), en güçlü fark bırakma sonrası 2. ve 4. haftalarda ([*The Effects of Scheduled Smoking Reduction and Precessation NRT*, JMIR Formative Research 2023](https://formative.jmir.org/2023/1/e39487)).

→ **Ürünün en önemli algoritmik sonucu:** Başarıyı belirleyen şey azaltmanın kendisi değil, **programa uyulabilmesidir.** Dolayısıyla motorun hedefi "en hızlı azaltma" değil, **"uyulabilirliği maksimize eden en hızlı azaltma"**dır. Bu cümle, tüm plan motorunun tasarım ilkesi olarak yazılır.

**Ayrıca dürüstlük:** kademeli vs ani bırakma karşılaştırmasında Cochrane, **farmakolojik destekle** ikisini eşdeğer buluyor (ana rapor §14: RR 1,01); buna karşılık *Annals of Internal Medicine* 2016 noninferiority RKÇ'sinde kademeli bırakma, ani bırakmaya **non-inferior çıkmamıştır** ([Annals 2016](https://annals.org/aim/fullarticle/2501853/gradual-versus-abrupt-smoking-cessation-randomized-controlled-noninferiority-trial)). Halen bu yüzden azaltmayı **"bırakmaya köprü"** olarak konumlar, "azaltmak yeterlidir" demez — ve §7.① düşük tüketim bulgusu (günde 1 sigara bile riskin ~yarısı) bu konumu bilimsel olarak zorunlu kılar.

**Yoksunluk yükü kısıtı.** Yoksunluk 1.–3. günde tepe yaptığından (§8.①) ve aralık uzatmanın her adımı mini bir yoksunluk uyarımı olduğundan, adımlar arasında **stabilizasyon süresi** gerekir.

### ② Pazar emsali
- **EasyQuit "Slow Mode"** ve **Flamy taper:** kategoride azaltma sunan tek iki ciddi örnek; ikisi de **sabit yüzdeli** (ör. haftada %10) düşüş uyguluyor, kullanıcının uyum verisini geri beslemiyor. Plan bozulunca kullanıcı planın dışında kalıyor.
- Kategori dışı **Gentler Streak:** "bugün nazik ol" — performansı düşünce kullanıcıyı cezalandırmak yerine hedefi düşüren nadir uygulama. **Devralınacak temel felsefe.**
- Kategori dışı **koşu planları (Nike Run Club / Runna):** kaçırılan antrenmandan sonra planı otomatik yeniden hesaplama. **Devralınacak mekanik.**

### ③ Bizim tasarımımız — üç kurallı motor

Mevcut `lib/domain/plan_engine.dart` şu üç kurala göre genişletilir:

1. **Adım büyüklüğü kısıtı.** Sigaralar arası hedef aralık, bir adımda **mevcut aralığın %15'inden fazla** uzatılmaz (ör. 60 dk → en fazla 69 dk). Gerekçe: uyulabilirlik önceliği (§9.①). Kullanıcı isterse "hızlı mod" (%25) seçebilir ama uyarı gösterilir.
2. **Stabilizasyon penceresi.** Yeni adıma geçmeden önce mevcut adımda **en az 3 gün** ve **%70 uyum** şartı. Uyum düşükse adım tekrarlanır; **geri alınmaz** (geri alma başarısızlık hissi üretir), yalnızca "aynı adımda bir gün daha" denir.
3. **Yumuşak iniş (asla sıfırlama yok).** Kullanıcı planı bozarsa hedef otomatik olarak son **başarılı** 3 günün ortalamasına oturur ve mesaj şudur: *"Plan sana göre yeniden ayarlandı. Kaybettiğin hiçbir şey yok."* Streak sıfırlama yasağı ana raporda zaten karar altına alınmıştır; bu motor onun matematiksel karşılığıdır.

**Zamanlama zekâsı:** aralık uzatma, kullanıcının **en kolay** saatlerinden başlar (Modül 4 ısı haritasındaki düşük yoğunluklu saatler), en zor saatler (sabah ilk sigara, akşam sonrası) **en sona** bırakılır. Uyandıktan sonraki ilk sigara HSI'ın en güçlü bağımlılık göstergesidir; onu erken hedef almak plan çökmesinin bilinen sebebidir.

### ④ Grafik
- **Merdiven grafiği:** haftalara göre hedef aralık (dk) basamakları + gerçekleşen ortalama aralık çizgisi üstüne bindirilir. Kullanıcı "planın önünde/gerisinde" olduğunu tek bakışta görür.
- **Bugünün şeridi:** 24 saatlik yatay şerit; izin verilen sonraki sigara saati işaretli, kalan süre canlı sayaç. Kilit ekranı widget'ının ana içeriği budur.
- **Uyum halkası:** son 7 günün uyum yüzdesi (Apple halkası deseni), %70 eşiği görünür işaretle.

### ⑤ Algoritma (özet sözde kod)
```
nextInterval(current, adherence7d):
  if adherence7d < 0.70 or daysAtStep < 3: return current      // stabilize
  step = current * (fastMode ? 0.25 : 0.15)
  return min(current + step, targetInterval)

onPlanBreak(): target = mean(interval of last 3 successful days)  // yumuşak iniş, sıfırlama yok
```

### ⑥ EN/TR
| EN | TR |
|---|---|
| Soft taper | Yumuşak geçiş |
| Next cigarette allowed at | Sonraki sigara saati |
| Hold this step one more day | Bu adımda bir gün daha kal |
| Your plan was re-tuned to you. Nothing is lost. | Plan sana göre yeniden ayarlandı. Kaybettiğin hiçbir şey yok. |
| Adherence | Uyum |

---

## 10. MODÜL: Destek Programı (Support Program) — bitkiler, beslenme, egzersiz

> Talep: *"Sigarayı bırakmaya yardımcı olacak bitkiler, sağlıklı beslenme, koşu, egzersiz... günlük tavsiye kartları veya programlar."*

### ① Bilimsel temel — burada dürüst olmak ürünü kurtarır

**Bitkisel ürünler: kanıt yok, ve bunu söylemek zorundayız.** NCCIH'in derlemesi açıktır: **SAMe, lobelin (Lobelia inflata), St. John's Wort'un sigara bırakmaya yardım ettiğine dair kanıt yoktur** ([NCCIH, *Quitting Smoking With Complementary Health Approaches*](https://www.nccih.nih.gov/health/quitting-smoking); [*6 Things To Know About Complementary Approaches for Quitting Smoking*](https://www.nccih.nih.gov/health/tips/things-to-know-about-complementary-health-approaches-for-quitting-smoking)). Cochrane, St. John's Wort için güvenilir uzun vadeli yarar bulmamıştır. Genel derlemeler akupunktur, hipnoz ve gümüş asetat pastilinin etkinliğini desteklememekte; vitamin/takviye ürünleri için çalışma sayısı değerlendirme yapmaya yetmemektedir.

**Tek gerçek "doğal" istisna: sitizin (cytisine/cytisinicline)** — Laburnum bitkisinden gelen, Orta ve Doğu Avrupa'da yıllardır bırakma ilacı olarak kullanılan ve etkinliği çalışmalarla desteklenen bir **ilaçtır**, bitkisel takviye değildir. → Uygulama bunu bir "bitki tavsiyesi" olarak sunamaz; **yalnızca "doktoruna sorabileceğin ilaç seçenekleri" bilgi kartında**, NRT/vareniklin/bupropion ile birlikte, "biz ilaç önermiyoruz, hekimine danış" çerçevesiyle anılır.

→ **Ürün kararı:** "Bitkiler" kategorisi **silinmez** (kullanıcı arıyor ve rakipler yanlış bilgiyle dolduruyor) ama **⚪ Geleneksel** rozetiyle ve şu üst başlıkla sunulur: *"Bunların bırakmaya yardım ettiğine dair bilimsel kanıt yok. Zararsız ritüeller olarak, elini ve ağzını meşgul etmek için işe yarayabilir."* Bu, kullanıcıya yalan söylemeden onun aradığı içeriği verir — ve etiket sistemi (🟢/🟡/⚪) sayesinde uygulamanın genel güvenilirliğini **artırır**. İçerik: bitki çayları (ıhlamur, papatya, nane — sıcak içecek ritüeli olarak), tarçın çubuğu/meyan kökü çubuğu (oral ikame), zencefil.

**Egzersiz: kategorinin en kanıtlı desteği.** Akut etki §5.①'de verildi (SMD −0,52…−0,88, 30 dk'ya kadar). Egzersiz temelli müdahalelerin bırakma üzerindeki uzun vadeli etkisi için kanıt daha karışıktır ([*Exercise interventions for smoking cessation*, PMC6819982](https://pmc.ncbi.nlm.nih.gov/articles/PMC6819982/); [*Effects of exercise intervention on tobacco dependence: meta-analysis*, Frontiers 2025](https://www.frontiersin.org/journals/public-health/articles/10.3389/fpubh.2025.1538833/full)). → Uygulama egzersizi **"krizi geçirmenin en kanıtlı yolu"** olarak konumlar, "egzersiz yaparsan bırakırsın" demez.

**Beslenme ve kilo — kaçınılmaz konu.** Bırakma sonrası 12. ayda ortalama **~4,7 kg** artış olur; artışın çoğu **ilk 3 ayda**dır (1., 2., 3., 6. ve 12. ayda sırasıyla ~1,1 / 2,3 / 2,9 / 4,2 / 4,7 kg); %13–14 kişi 10 kg'dan fazla alır. Mekanizma büyük ölçüde nikotinin iştah baskılayıcı ve termojenik etkisinin ortadan kalkmasıdır; kalori alımı ortalama **+227 kcal/gün** artar ve bu 3. aydaki artışın %69'unu açıklar ([*Metabolic effects of smoking cessation*, PMC5021526](https://pmc.ncbi.nlm.nih.gov/articles/PMC5021526/); [*The Effect of Smoking Cessation on Body Weight...*, PMC9603007](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9603007/)). Meyve-sebze tüketimi yüksek olanlar daha az kilo alıyor; Akdeniz tipi/bütün gıda ağırlıklı örüntüler artmış iştahı hafifletebiliyor.

→ **Ürün kararı:** Kilo konusu **saklanmaz** — kullanıcıların bırakmama gerekçelerinin başında gelir ve sürprize dönüşürse nüks sebebidir. 2.–4. haftada bir kart: beklenen aralık, zamanlaması, mekanizması ve pratik öneriler; ve mutlaka şu çerçeve: *"~5 kg'ın sağlık riski, sigaranın riskinin yanında çok küçüktür."* Uygulama kalori saydırmaz, diyet vermez (kapsam dışı ve tıbbi risk).

### ② Pazar emsali
- **Smoke Free / Kwit:** genel "ipucu" kartları; kanıt etiketi yok, kaynak yok.
- Sağlık dışı emsal: **Yuka / Open Food Facts** — her iddianın yanında kaynak ve derece. **Devralınacak:** derecelendirme rozeti deseni.
- **Streaks / Finch:** günlük küçük görev kartı, tamamlanınca yumuşak kutlama. **Devralınacak:** günde tek görev, seçilebilir, atlanabilir.

### ③ Bizim tasarımımız
**Günde tek kart, üç kanaldan biri:** *Hareket* (5–15 dk yürüyüş/merdiven/esneme), *Beslenme* (su, öğün ritmi, oral ikame: havuç/sakız/tarçın), *Ritüel* (bitki çayı, nefes, kısa yazma). Kart 15 saniyede okunur, tek dokunuşla "yaptım" işaretlenir, atlanabilir ve **atlanması hiçbir cezaya yol açmaz.**

Her kartta kanıt rozeti ve dokunulduğunda kaynak. **Kişiselleştirme:** kullanıcının en riskli saatinden 20 dk önce hatırlatma (opsiyonel, varsayılan kapalı).

### ④ Grafik
Haftalık destek ızgarası (3 kanal × 7 gün) — dolu/boş hücre; hedef "hepsini doldurmak" değil, örüntüyü görmek. Üstte açıklama: *"Bu bir sınav değil."*

### ⑤ Veri modeli
`content` tipi `support_card`: `channel, evidence_level, title_en/tr, body_en/tr, duration_min, source_url`. Yeni `support_log` tablosu: `date, card_key, done`.

---

## 11. MODÜL: İçerik Motoru (Content Engine) — makaleler, olumsuz/olumlu içerik, motivasyon

> Talep: *"Kanser vesaire içindeki maddeler, derin araştırma isteyenler için güncel bilimsel makaleler... hem kişiyi sigaradan uzak tutacak olumsuz şeyler hem olumlu şeyler... görsel olarak güzel, günlük olarak verilebilir."*

### ① Bilimsel temel — korku ne zaman işe yarar?

Bu, modülün tasarımını belirleyen tek bulgudur. Tannenbaum ve ark. 2015 meta-analizi (127 makale, 248 bağımsız örneklem, N=27.372): **korku çağrıları tutum, niyet ve davranışı olumlu yönde etkiler; işe yaramadığı durum çok azdır ve geri tepmeye yol açtığı belirlenmiş bir koşul yoktur.** Etki, mesaj **öz-yeterlik ve yanıt-yeterliği ifadeleri içerdiğinde**, yüksek duyarlılık ve ciddiyet aktardığında ve **tek seferlik** (tekrarlayan değil) davranış önerdiğinde artar ([Tannenbaum et al., 2015, PDF](https://socialactionlab.org/wp-content/uploads/2024/01/Tannenbaum_Appealing-to-Fear-A-Meta-Analysis-of-Fear-Appeal-Effectiveness-and-Theories_2015.pdf)). Grafik uyarı etiketleri literatürü de aynı yöne işaret eder: tehdit, ancak öz-yeterlik yüksekken davranış değişimiyle ilişkilidir ([PMC4964038](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4964038/)).

→ **Ürün kuralı (mutlak):** **Hiçbir olumsuz içerik kartı, "ne yapabilirsin" bölümü olmadan yayımlanamaz.** Korku + eylem = etkili; yalnız korku = kaygı ve kaçınma. Bu kural içerik şemasına *zorunlu alan* olarak kodlanır (`action_text` boş olamaz) ve mevcut etik lint aracına (`tool/` altındaki kontrol) kural olarak eklenir.

### ② Pazar emsali
- **quitSTART (NCI):** bilim doğru, sunum zayıf.
- **Kwit:** "kart" formatı ve tipografik alıntılar iyi; kaynak zayıf.
- Kategori dışı **Blinkist / Headway** (kart tabanlı bilgi tüketimi), **Apple News** (okuma süresi etiketi), **Wikipedia** (kaynak disiplini). **Devralınacak:** okuma süresi rozeti, "kaynak" satırı, seri (dizi) yapısı.

### ③ Bizim tasarımımız — dört içerik ailesi

| Aile | Ton | Örnek | Sıklık |
|---|---|---|---|
| **Bilgi** (nötr) | Açıklayıcı | "Nikotin nasıl bağımlılık yapar?" | Haftada 2 |
| **Gerçek** (olumsuz, eylem zorunlu) | Ciddi, abartısız | "Dumandaki 70+ kanserojen" + "Bugün ne yapabilirsin" | Haftada 1 |
| **Kazanç** (olumlu) | Sıcak | "2 hafta–3 ay: dolaşım ve akciğer fonksiyonu" | Haftada 2 |
| **Motivasyon** (kısa) | Kişisel | Tek cümle + kullanıcının kendi verisi | Günlük |

**Günlük kart algoritması:** kullanıcının fazına göre seçim — ilk 3 gün ağırlıklı *Kazanç* ve *Bilgi* (yoksunluk tepesinde korku yüklemek zararlı), 2.–4. hafta psikolojik kart (§8.①) ve kilo kartı (§10.①), sonrasında dengeli döngü. Aynı kart 90 gün içinde tekrar etmez.

**"Derin araştırma isteyenler" için:** her kartın altında **kaynak listesi ve DOI/PubMed linki**; ayrıca ayrı bir "Bilimsel Kaynaklar" ekranı — kategoride hiçbir uygulamada yok, "bilgi seven kullanıcı" segmentinin (ana rapor §5) doğrudan hedefi.

**Motivasyon cümleleri, jenerik olmayacak.** Kural: her motivasyon metni ya kullanıcının verisine (`{savedAmount}`, `{skippedCount}`, `{daysSinceQuit}`) ya da o günün faz bilgisine bağlanır. "Sen yapabilirsin" tipi boş cümle üretilmez — mevcut `lib/domain/motivation.dart` bu kurala göre denetlenmelidir.

### ④ Grafik/tipografi
- Kart: tek büyük başlık (24–28 pt), 40–60 kelime gövde, isteğe bağlı tek görsel/piktogram, kaynak satırı 12 pt, okuma süresi rozeti.
- Görsel dil: fotoğraf yok (telif + ton kontrolü); tek renkli geometrik piktogramlar + tipografi.
- **Olumsuz kartlarda renk:** kömür grisi/koyu lacivert; **kırmızı yalnızca vurgu**; asla tam kırmızı zemin.

### ⑤ Veri modeli
Mevcut `article_repository.dart` + `content_dao.dart` genişletilir: `family, phase_min_day, phase_max_day, action_text (NOT NULL for family='gercek'), sources[], read_minutes, last_shown_at`.

---

## 12. MODÜL: Kayıt Etkileşimi (Log Interaction) — "İçtim" ve "Atladım"

> Talep: *"Sigarayı içtim butonuna güzel bir animasyon... tıklayınca olumsuz olduğunu hissetsin, çocuksu olmasın... atladım dediğinde ferahlık ve motivasyon."*

### ① Davranışsal temel

Üç kanıtlı ilke:

1. **Sürtünme, bilinçli tercihi artırır.** "One Sec" tipi uygulamalar, eylemden önce zorunlu kısa duraklama ekleyerek otomatik davranışı bilinçli seçime çevirir; aynı mantık kayıt butonunda uygulanabilir. Ama **sürtünme kaydı öldürmemelidir**: ana raporun P0 ilkesi "1 dokunuş kayıt". Çözüm §12.③'te.
2. **Kayıp korkusu güçlü ama tehlikeli.** Duolingo streak'i kayıp kaçınması üzerine kuruludur; **Streak Freeze** özelliği, streak'i kırılmak üzere olan kullanıcılarda churn'ü **%21** azaltmıştır — yani kurtarma vanası, cezadan daha çok tutar ([Apptitude, *How Duolingo's Streak Mechanic Actually Works*](https://apptitude.io/blog/how-duolingos-streak-mechanic-actually-works/)). Aynı kaynaklar, saf kayıp baskısının kullanıcıyı "öğrenmeden" oynamaya ittiğini de bildiriyor. → Halen'de streak **kırılmaz**, "koruma" mekaniği yerine "yumuşak iniş" (§9) kullanılır.
3. **Ceza değil, gerçeklik.** Suçlandığını hisseden kullanıcı kaydı bırakır, kayıt biterse ürün ölür. Bu, kategorinin bir numaralı ölüm sebebidir (ana rapor §38).

### ② Pazar emsali
- **Kwit:** olumlu olayda konfeti/seviye atlama — enerjik ama kategoriye göre biraz çocuksu; **kullanıcı talebi açıkça "çocuksu olmasın".**
- **Forest:** olumlu davranışta ağaç büyür, olumsuzda **ağaç kurur** — ceza değil, doğal sonuç metaforu. **Devralınacak metafor mantığı** (bizde: akciğer sisi / nefes ritmi, §6).
- **Apple Fitness:** halka kapanınca kısa, ciddi, gösterişsiz kutlama + haptik. **Devralınacak ton.**
- **Gentler Streak:** kötü günde bile nötr-destekleyici dil. **Devralınacak dil.**

### ③ Bizim tasarımımız

**"İçtim" akışı (olumsuz ama suçlamayan):**
1. Butona basılır → **kayıt anında ve koşulsuz düşer** (veri kaybı yok, geri alınabilir).
2. Ekran 900 ms boyunca **sakinleşir**: renkler doygunluğunu kaybeder, arka plan bir tık koyulaşır, akciğer sisi biraz koyulaşır, nefes animasyonunun genliği daralır. Ses yok. Konfeti yok. Kızgın kırmızı yok. **Sessizlik ve ağırlık** duygusu — "çocuksu olmama" talebinin karşılığı budur.
3. Tek satır nötr gerçek, kullanıcının kendi verisiyle: *"Bugün 7. Ortalaman 9. Bu bir başarısızlık değil, bir veri."*
4. **İsteğe bağlı ve atlanabilir** tek soru: tetikleyici (5 çip). 3 saniyede geçilebilir.
5. Kapanış her zaman ileriye bakar: *"Sonraki hedef aralık 14:50."*

**Gecikmeli sürtünme (opsiyonel, ayarlarda):** "Önce 20 saniye" modu — kayıt yine anında düşer, ancak ekranda 20 saniyelik nefes çemberi görünür ve kullanıcı isterse kaydı "vazgeçtim"e çevirebilir. Bu, sürtünmeyi kayıt bütünlüğünü bozmadan verir. Varsayılan **kapalı**, onboarding'de tanıtılır.

**"Atladım" akışı (olumlu, ferahlatıcı):**
1. Butona basılır → **haptik: tek, net, tatmin edici** (`HapticFeedback.mediumImpact`).
2. 1.200 ms **açılma** animasyonu: arka plan bir nefes alır (yumuşak ölçek + parlaklık), akciğer sisi görünür biçimde bir tık çekilir, ve Modül 1'deki grafikte **"oluşmayan tepe"** kesikli olarak çizilir — kullanıcı kendi kararının grafiğe düştüğünü **görür**. Bu, kategoride hiç kimsenin yapmadığı, tamamen veriye bağlı ve gerçek olan bir ödüldür.
3. Tek satır motivasyon, kullanıcının verisiyle: *"Bu ay 23. atlatışın. Yaklaşık ₺… ve bu ay ~7,6 saat."*
4. Kutlama yoğunluğu **kademeli**: normal atlatış sessiz ve zarif; 10/25/50/100 gibi eşiklerde biraz daha görünür ama asla konfeti fırtınası değil.

**Ton kuralı (kodda yorum olarak da yer alacak):** *İçtim = sessizleşme. Atladım = açılma.* İki animasyon aynı görsel dilin (nefes/sis) iki yönüdür; bu, ürünün bütünlük hissini yaratır.

### ④ Animasyon şartnamesi
| Öğe | Süre | Eğri | Haptik |
|---|---|---|---|
| İçtim — doygunluk kaybı | 900 ms | `easeOutQuad` | yok (veya çok hafif `selectionClick`) |
| İçtim — sis koyulaşması | 900 ms | `easeInOut` | — |
| Atladım — nefes/açılma | 1.200 ms | `easeOutBack` (hafif, overshoot ≤ %3) | `mediumImpact` |
| Atladım — hayalet tepe çizimi | 600 ms, gecikmeli 300 ms | `easeOutCubic` | — |
| Eşik kutlaması | 1.500 ms | — | `heavyImpact` (yalnız eşikte) |

Hareket azaltma açıkken tüm animasyonlar 150 ms'lik renk geçişine indirgenir; anlam kaybolmaz (metin her zaman aynı bilgiyi taşır).

### ⑤ Uygulama notu
Mevcut `quick_log_controller.dart` ve `quick_log_queue.dart` korunur; animasyon tamamen sunum katmanında (`widgets/today/`) kalır, kaydın kalıcılığını **bloklamaz**. Widget/kilit ekranından yapılan kayıtlarda animasyon yoktur; uygulama açıldığında özet gösterilir.

### ⑥ EN/TR
| EN | TR |
|---|---|
| I smoked | İçtim |
| I skipped it | Atladım |
| Not a failure. A data point. | Başarısızlık değil. Bir veri. |
| A peak that never happened | Oluşmayan tepe |
| Next target time | Sonraki hedef saat |

---

## 13. MODÜL: Program Sistemi (Plan System) ve plan değiştirme

> Talep: *"Belli bir plan olması, kişinin hangi planda olduğunu bilmesi... random içici ise plan değiştirebilmeli ama kolay değişmemeli."*

### ① İlkeler
Programlı azaltmanın etkisi **uyuma** bağlıdır (§9.①). Yanlış plan seçimi ve sık plan değişimi, uyum verisini anlamsızlaştırır ve "hiçbir planı bitirmeme" örüntüsü üretir. Öte yandan kullanıcıyı yanlış planda tutmak da nüksü hızlandırır. Çözüm: **değiştirmeyi mümkün ama bilinçli kılmak.**

### ② Bizim tasarımımız — 4 plan
| Plan (TR / EN) | Kime | Mekanik |
|---|---|---|
| **Kademeli Azaltma** / Gradual Taper | Düzenli içici, aralık tutarlı | Aralık uzatma (§9) |
| **Günlük Kota** / Daily Quota | Düzensiz ("random") içici | Günlük adet tavanı; saat kısıtı yok |
| **Bırakma Günü** / Quit Day | Ani bırakmayı seçen | Tarih + yoksunluk desteği + timeline açılır |
| **Yalnızca Takip** / Track Only | Henüz hazır olmayan | Hedef yok, yargı yok, sadece veri |

**"Random içici" özellikle önemlidir** ve kategoride ihmal edilmiştir: aralık temelli plan bu kişide sürekli başarısız olur ve uygulamayı sildirir. Günlük Kota planı bu segmentin ürünü terk etmesini engeller.

**Plan değiştirme kuralları (kolay değil, ama kapalı da değil):**
1. Bir planda **en az 7 gün** kalınır (Yalnızca Takip'ten çıkış hariç — o her zaman serbesttir).
2. Değişiklik ekranı, mevcut planın **karnesini gösterir**: uyum %, en zorlanılan saat, atlatılan kriz sayısı. Kullanıcı kararını veriyle verir.
3. Sistem, veriye dayalı bir **öneri** sunar (ör. kayıt saatlerinin varyansı yüksekse: *"Senin ritmin düzensiz; Günlük Kota planı sana daha uygun olabilir"*). Öneri dayatma değildir.
4. Değişiklik **geçmişi silmez**; tüm indeksler ve grafikler süreklidir. Plan değişimi zaman çizelgesine bir işaret olarak düşer.
5. 30 gün içinde 3'ten fazla değişiklik yapılırsa yumuşak uyarı: *"Plan değiştirmek başarısızlık değil ama her plan kendini göstermek için birkaç haftaya ihtiyaç duyar."*

### ③ Grafik
- **Plan şeridi:** ana ekranın üstünde ince bir şerit — plan adı, kaçıncı hafta, bu haftanın hedefi. Kullanıcı "hangi plandayım" sorusunu hiç sormamalı.
- **Plan karnesi:** değiştirme ekranında 4 metrikli özet kart + mevcut planla geçen süre.

### ④ Uygulama
Mevcut `plan_controller.dart` / `plan_dao.dart` genişletilir: `PlanKind` enum, `planChangedAt`, `minDaysInPlan = 7`, `planReportCard()`.

---

## 14. MODÜL: İki İndeks — İlerleme ve Zarar Yükü

> Talep: *"Sigara bırakma indeksi gibi bir şey — iyiye mi kötüye mi gidiyor, bu ayrı. Bir de kişinin kilo ve yaşına bağlı ne kadar zarar gördüğüne dair bir skala, sigarayı azalttıkça düşmesi gerekiyor. İsimleri en basit kullanıcının bile anlayabileceği terimler olmalı."*

Bu iki indeks **bilinçli olarak farklı hızlarda hareket eder** ve bu fark kullanıcıya açıkça anlatılır:

> **İlerleme İndeksi hızlı hareket eder — davranışını ölçer. Zarar Yükü yavaş hareket eder — geçmişini taşır.** İkisi birden aynı yöne dönerse, gerçekten değişiyorsun demektir.

### 14.1. İlerleme İndeksi (Progress Index) — "iyiye mi gidiyorum?"

**Adlandırma kararı (basit terim şartı):** `Halen Skoru` / `Halen Score` **değil** — anlamsız marka jargonu. Seçilen: **"İlerleme Puanı" / "Progress Score"**, alt başlık *"Son 14 gün"*. Kullanıcı ne olduğunu açıklamasız anlar.

**Bileşenler (0–100, ağırlıklar yayımlanır):**

| Bileşen | Ağırlık | Neden | Sınıf |
|---|---|---|---|
| **Plan uyumu** (son 14 gün) | 35 | Uyum, sonucu öngören tek doğrulanmış davranış (§9.①, OR 2,01) | S2 |
| **Tüketim eğilimi** (14 gün eğimi, kendi tabanına göre) | 30 | Asıl hedef | S2 |
| **Kriz başa çıkma oranı** (atlatılan / toplam istek) | 20 | Beceri gelişimi; kullanıcının kontrol edebildiği şey | S2 |
| **Kayıt tutarlılığı** | 10 | Veri kalitesi olmadan diğerleri anlamsız | S2 |
| **Nikotin zemin düşüşü** (Modül 1) | 5 | Fizyolojik yön | S3 |

**Tasarım kuralları:**
- **Trend, mutlak değerden önemlidir.** Ekranda önce ok ve değişim (`▲ 6 puan, son 7 gün`), sonra sayı.
- **Puan asla sıfırlanmaz** ve tek bir kötü gün büyük düşüş yaratmaz (14 günlük pencere + max günlük değişim ±4 puan sınırı).
- **Bantlar:** 0–39 `Başlangıç`, 40–69 `Yolda`, 70–89 `Güçlü`, 90–100 `Çok güçlü`. Wearable'ların yeşil/sarı/kırmızı deseninden alınan **anlaşılırlık**, ama kırmızı yerine nötr ton — kullanıcı damgalanmaz.
- **Formül açık.** Dokununca bileşen dökümü + ağırlıklar + "bu puan sağlık durumunu değil, davranışını ölçer" uyarısı.

**Neden bu ağırlıklar?** Çünkü ölçebildiğimiz ve kullanıcının kontrol edebildiği şeyler bunlar. Sonuç değil süreç ödüllendirilir — ana raporun temel tezi (§1) ve kanıt durumunun (§9.①) gereği.

### 14.2. Zarar Yükü (Harm Load) — "ne kadar zarar görüyorum?"

**Adlandırma:** "Kanser Riski" **asla** kullanılmaz (S5: kişisel hastalık riski yüzdesi üretilemez). Seçilen: **"Zarar Yükü" / "Harm Load"** — 0–100, *"Yaşına, vücut ölçülerine ve içim geçmişine göre maruziyet yükün."*

**Bilimsel dayanak.** Doğrulanmış risk modelleri hangi değişkenlerin gerçekten önemli olduğunu söyler: PLCOm2012, 6 yıllık akciğer kanseri riskini **11 değişkenle** öngörür (yaş, eğitim, **BMI**, KOAH, kişisel kanser öyküsü, ailede akciğer kanseri, etnisite, içicilik durumu, **yoğunluk**, **süre**, bırakmadan bu yana geçen süre) ve AUC ~0,80 ile iyi ayrım gösterir ([NEJM 2013](https://www.nejm.org/doi/full/10.1056/NEJMoa1211776); [bağımsız validasyon, PubMed 28249359](https://pubmed.ncbi.nlm.nih.gov/28249359/)). Klasik kümülatif maruziyet ölçüsü **paket-yılı**dır (günde 20 adet × 1 yıl = 1 paket-yılı). Bağımlılık için **HSI** (§4.①).

→ **Kritik ürün kararı:** PLCOm2012'yi **hesaplamak için değil, hangi değişkenleri kullanacağımızı seçmek için** referans alıyoruz. Uygulama kişisel kanser olasılığı **üretmez**; bunun yerine bu değişkenlerden birimsiz bir **maruziyet yükü indeksi** kurar ve bunu açıkça yazar: *"Bu bir hastalık riski tahmini değildir. Maruziyetinin büyüklüğünü tek sayıda özetler."*

**Bileşenler (0–100):**

| Bileşen | Girdi | Ağırlık | Not |
|---|---|---|---|
| **Kümülatif maruziyet** | paket-yılı (log ölçekli) | 40 | Geçmiş; asla azalmaz, yalnız yavaşlar |
| **Güncel yoğunluk** | son 30 günün günlük ortalaması | 30 | **Azaltınca düşen ana bileşen** |
| **Bağımlılık derinliği** | HSI 0–6 | 15 | Zamanla düşebilir |
| **Yaş ve süre** | yaş, içim süresi | 10 | Sabit/artan |
| **Vücut ölçüsü (BMI)** | boy/kilo (opsiyonel) | 5 | PLCOm2012'de anlamlı değişken; **girilmezse bileşen düşer, ağırlık yeniden normalize edilir** |

**Cinsiyet** yalnızca zaman hesabında kullanılır (20 dk/sigara; erkek 17 / kadın 22 dk — §3.①) ve isteğe bağlıdır.

**"Azalttıkça düşmeli" talebinin karşılığı:** Güncel yoğunluk (30 puan) + bağımlılık (15 puan) = **45 puanlık hareketli kısım**; kümülatif kısım (40) düşmez ama **büyüme hızı yavaşlar**. Bırakma sonrasında ise "bırakmadan bu yana geçen süre" bir **iyileşme kredisi** olarak kümülatif bileşeni yavaşça (yıllar ölçeğinde, WHO/CDC risk-azalma çizelgesine sadık) aşağı çeker. Bu, hem bilimsel olarak dürüst hem motive edicidir: *"Geçmişini silemezsin ama bugünden itibaren yükünü hafifletmeye başlıyorsun."*

**Kilo/yaş girişi etiği:** boy/kilo **zorunlu değildir**, girilmemesi hiçbir özelliği kapatmaz, "ideal kilo" veya beden yorumu **asla** yapılmaz. Bu, yeme bozukluğu hassasiyeti ve mağaza sağlık politikaları açısından gereklidir.

### ③ Grafik şartnamesi (iki indeks birlikte)
- **İkiz gösterge kartı:** solda İlerleme (yükselmeli), sağda Zarar Yükü (düşmeli); ok yönleri zıt ve bu görsel olarak vurgulanır.
- **Çift eksenli tarih grafiği:** 90 gün; İlerleme (yeşil, üstte) ve Zarar Yükü (kömür, altta). İdeal görüntü bir "makas"tır ve kullanıcıya bu açıkça öğretilir: *"Makas açıldıkça iyiye gidiyorsun."* — Bu tek metafor, tüm indeks sisteminin kullanıcı zihnindeki karşılığıdır.
- Her iki gösterge de dokunulduğunda **tam formül dökümü** açar (§0.2).
- Erişilebilirlik: her indeks için metinsel özet (`Semantics`), yalnız renk/konum ile anlam taşınmaz.

### ⑤ Uygulama
Yeni `lib/domain/progress_index.dart` ve `lib/domain/harm_load.dart`; ikisi de saf fonksiyon, tamamen yerel, altın-değer testli. `how_calculated_screen.dart` bu iki dosyadan ağırlık tablolarını **doğrudan** okuyacak biçimde yazılır ki formül ile ekran birbirinden ayrışamasın (dokümantasyon çürümesine karşı yapısal önlem).

### ⑥ EN/TR
| EN | TR |
|---|---|
| Progress Score (last 14 days) | İlerleme Puanı (son 14 gün) |
| Harm Load | Zarar Yükü |
| Starting / On track / Strong / Very strong | Başlangıç / Yolda / Güçlü / Çok güçlü |
| This measures your behavior, not your health. | Bu, sağlığını değil davranışını ölçer. |
| This is not a disease risk estimate. | Bu, hastalık riski tahmini değildir. |
| The wider the gap, the better you're doing. | Makas açıldıkça iyiye gidiyorsun. |

---

## 15. Ortak Görsel Sistem — bütün grafikler için bağlayıcı kurallar

Talep edilen "grafikler okunaklı ve güzel olmalı" maddesi, modül modül değil **sistem olarak** çözülür. Aşağıdakiler tüm ekranlarda bağlayıcıdır.

1. **Tek grafik = tek cümle.** Her grafiğin üstünde, grafiğin söylediği şeyi söyleyen bir cümle bulunur (*"İsteklerinin %71'i yük düşükken geldi"*). Kullanıcı grafiği okuyamazsa bile bilgiyi alır. Kategorideki en büyük UX kazancı budur.
2. **Sayı hiyerarşisi:** her kartta tam olarak **bir** büyük sayı. İkinci sayı ondan en az %40 küçük. Üç eşit büyüklükte sayı = okunmayan kart.
3. **Trend > mutlak.** Ok + değişim, mutlak değerden önce gelir.
4. **Renk sözlüğü (sabit, ürün genelinde):** amber = nikotin/maruziyet · mavi-yeşil = oksijen/iyileşme · yeşil = kullanıcının kazanımı · kömür = birikim/geçmiş · nötr gri = maliyet. **Kırmızı yalnızca hata durumları için; sağlık verisinde kullanılmaz.**
5. **Renk asla tek başına anlam taşımaz** (bant adı, şekil veya etiket eşlik eder). Kontrast ≥ 4.5:1; karanlık/aydınlık iki tam palet.
6. **Boş durum tasarımı zorunlu.** Yeni kullanıcıda hiçbir grafik boş kutu göstermez; "3 kayıttan sonra burada ritmin görünecek" gibi ilerleme mesajı verir. Kategoride en sık görülen ilk-gün terk sebebi boş ekranlardır.
7. **Yetersiz veri = grafik yok.** İstatistiksel olarak anlamsız çıkarımlar (ör. 5 kayıtla "riskli saatin") **üretilmez**; eşikler modül başına tanımlıdır (ısı haritası ≥ 21 kayıt, kriz penceresi ≥ 30, kişisel kalibrasyon ≥ 200).
8. **Hareket azaltma ve VoiceOver** her grafik için zorunlu; her seri için metinsel özet.
9. **Yerelleştirme:** sayı, para, tarih ve saat biçimi yerelden; TR'de ondalık virgül, binlik nokta.
10. **Performans:** grafik başına ≤ 300 çizim noktası; 60 fps hedefi; `RepaintBoundary` zorunlu.

---

## 16. Terim Sözlüğü (EN/TR) — l10n anahtarlarıyla

Kullanıcı talebi gereği isimler **en basit kullanıcının anlayacağı** düzeydedir; tıbbi jargon yalnızca parantez içinde ve açıklamalı geçer.

| Kavram | EN (görünen) | TR (görünen) | l10n anahtarı |
|---|---|---|---|
| Vücut yükü | Body Load | Vücut Yükü | `bodyLoadTitle` |
| Tahmini nikotin | Estimated nicotine | Tahmini nikotin | `nicotineEstimate` |
| Oksijen borcu | Oxygen debt | Oksijen borcu | `coDebt` |
| Katran yükü | Particle load | Partikül yükü | `tarLoad` |
| Kriz penceresi | Craving window | Kriz penceresi | `cravingWindow` |
| Yoksunluk basıncı | Withdrawal pressure | Yoksunluk basıncı | `withdrawalPressure` |
| Yumuşak geçiş | Soft taper | Yumuşak geçiş | `softTaper` |
| Uyum | Adherence | Uyum | `adherence` |
| İlerleme puanı | Progress Score | İlerleme Puanı | `progressScore` |
| Zarar yükü | Harm Load | Zarar Yükü | `harmLoad` |
| Kanıt düzeyi | Evidence level | Kanıt düzeyi | `evidenceLevel` |
| Oluşmayan tepe | A peak that never happened | Oluşmayan tepe | `ghostPeak` |
| Nasıl hesaplanıyor? | How is this calculated? | Nasıl hesaplanıyor? | `howCalculated` |

**Çeviri ilkesi:** TR metin İngilizceden çeviri değil, **TR'de doğal** yazılır; iki dilde ayrı yazılıp anlam eşitliği kontrol edilir. "Craving" için TR'de *istek* (klinik "aşerme" değil) tercih edilir; "relapse" için *nüks* yerine **"tekrar başlama"**.

---

## 17. Uygulama Yol Haritası (mevcut kod tabanına oturtulmuş)

| Sıra | Modül | Yeni/değişen dosyalar | Bağımlılık | Efor |
|---|---|---|---|---|
| 1 | Vücut Yükü (§1) | `domain/body_load_model.dart` (nicotine_model'den), `widgets/charts/load_curve.dart` | — | M |
| 2 | Kayıt etkileşimi (§12) | `widgets/today/log_feedback.dart`, `quick_log_controller` | 1 | S |
| 3 | İki indeks (§14) | `domain/progress_index.dart`, `domain/harm_load.dart`, `how_calculated_screen` | 1 | M |
| 4 | Yumuşak geçiş (§9) | `domain/plan_engine.dart`, `plan_controller` | 3 | M |
| 5 | Kriz penceresi (§4) | `domain/craving_risk.dart`, `stats_providers` | 1,4 | M |
| 6 | SOS seti (§5) | `screens/sos/*`, `craving_dao` | 5 | M |
| 7 | Ekonomi (§3) | `domain/savings.dart`, `widgets/charts/projection.dart` | — | S |
| 8 | Psikolojik durum (§8) | `domain/withdrawal_model.dart`, `mood` tablosu | 1 | M |
| 9 | Akciğer (§6) | `domain/lung_model.dart`, `widgets/lung_painter.dart` | 1 | L |
| 10 | Organ haritası (§7) | `screens/body/organ_map.dart`, content seed | — | L |
| 11 | İçerik + destek (§10,§11) | `article_repository`, content seed, etik lint kuralı | — | M |
| 12 | Program sistemi (§13) | `plan_dao`, `plan_screen` | 4 | S |

**Kabul kriterleri (her modül için ortak):** (a) tüm hesaplar saf fonksiyon + birim test; (b) hiçbir ekranda S5 gösterge yok — `tool/` altındaki etik lint bunu CI'da kontrol eder; (c) her yeni gösterge `how_calculated_screen`'de karşılığı olmadan yayına giremez; (d) EN ve TR ARB anahtarları eksiksiz; (e) hareket azaltma ve VoiceOver desteği.

---

## 18. Kaynaklar (bu rapordaki iddialar için)

**Farmakokinetik ve maruziyet:** [Benowitz, *Pharmacology of Nicotine*, PMC2946180](https://pmc.ncbi.nlm.nih.gov/articles/PMC2946180/) · [*Nicotine Chemistry, Metabolism, Kinetics and Biomarkers*, Springer](https://link.springer.com/chapter/10.1007/978-3-540-69248-5_2) · [Ekshale CO, PLOS One](https://journals.plos.org/plosone/article?id=10.1371%2Fjournal.pone.0028864) · [COHb yarı ömrü, PubMed 10912868](https://pubmed.ncbi.nlm.nih.gov/10912868/) · [ISO katran vs insan maruziyeti, AACR CEBP](https://aacrjournals.org/cebp/article/15/8/1495/173726/Cigarette-Yields-and-Human-Exposure-A-Comparison) · [PMC2598502](https://pmc.ncbi.nlm.nih.gov/articles/PMC2598502/)

**İstek, bağımlılık, yoksunluk:** [PK/PD ve anlık istek, PubMed 31355455](https://pubmed.ncbi.nlm.nih.gov/31355455/) · [Yüksek doz NRT ve istek, Psychopharmacology](https://link.springer.com/article/10.1007/s00213-005-0184-3) · [Ön-abstinans maruziyet ve yoksunluk şiddeti, PubMed 3936089](https://pubmed.ncbi.nlm.nih.gov/3936089/) · [Nikotin-dışı faktörler, Neuropsychopharmacology](https://www.nature.com/articles/npp2014108) · [*Nicotine Withdrawal*, PMC4542051](https://pmc.ncbi.nlm.nih.gov/articles/PMC4542051/) · [FTCD vs HSI, NTR](https://academic.oup.com/ntr/article/26/11/1576/7681677) · [HSI protokolü, PhenX](https://www.phenxtoolkit.org/protocols/view/330201)

**Müdahaleler:** [Egzersiz ve akut istek, IPD meta-analiz, PubMed 22861822](https://pubmed.ncbi.nlm.nih.gov/22861822/) · [Taylor 2007, *Addiction*](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1360-0443.2006.01739.x) · [Egzersiz müdahaleleri, PMC6819982](https://pmc.ncbi.nlm.nih.gov/articles/PMC6819982/) · [Yavaş nefes ve vagal ton, Scientific Reports](https://www.nature.com/articles/s41598-021-98736-9) · [6/dk doz-yanıt, PMC8656666](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8656666/) · [Akupunktur umbrella review, TID](https://www.tobaccoinduceddiseases.org/Acupuncture-and-related-acupoint-therapies-for-smoking-cessation-An-umbrella-review,186147,0,2.html) · [Kulak akupunkturu meta-analizi, PMC11808481](https://pmc.ncbi.nlm.nih.gov/articles/PMC11808481/) · [NADA protokolü, PMC5485467](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5485467/) · [Kendi kendine kulak akupresürü, PMC3328240](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3328240/) · [NCCIH, tamamlayıcı yaklaşımlar](https://www.nccih.nih.gov/health/quitting-smoking)

**Program ve azaltma:** [Programlı azaltma RKÇ, JMIR Formative Research 2023](https://formative.jmir.org/2023/1/e39487) · [Kademeli vs ani, Annals 2016](https://annals.org/aim/fullarticle/2501853/gradual-versus-abrupt-smoking-cessation-randomized-controlled-noninferiority-trial) · [Düşük tüketim ve KKH/inme, PMC5781309](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5781309/)

**Sonuçlar ve organ etkileri:** [Surgeon General fact sheet, HHS](https://www.hhs.gov/surgeongeneral/reports-and-publications/tobacco/consequences-smoking-factsheet/index.html) · [2014 SGR Tablo 4.1](https://www.ncbi.nlm.nih.gov/books/NBK294317/table/ch4.t1/) · [*Smoking and Mortality — Beyond Established Causes*, NEJM](https://www.nejm.org/doi/full/10.1056/NEJMsa1407211) · [CDC](https://www.cdc.gov/tobacco/about/index.html) · [ACS](https://www.cancer.org/cancer/risk-prevention/tobacco/health-risks-of-smoking-tobacco.html) · [FEV1 düşüşü, Ann Transl Med](https://atm.amegroups.org/article/view/44426/html) · [NHLBI Pooled Cohorts, PMC7261004](https://pmc.ncbi.nlm.nih.gov/articles/PMC7261004/) · [PLCOm2012, NEJM 2013](https://www.nejm.org/doi/full/10.1056/NEJMoa1211776) · [PLCOm2012 validasyon, PubMed 28249359](https://pubmed.ncbi.nlm.nih.gov/28249359/) · [Yaşam kaybı 20 dk, UCL/Addiction (CNN)](https://www.cnn.com/2025/01/01/health/cigarette-smoking-life-expectancy-study-wellness) · [RCP](https://www.rcp.ac.uk/news-and-media/news-and-opinion/rcp-responds-to-ucl-research-showing-a-single-cigarette-can-take-20-minutes-off-life-expectancy/)

**Psikoloji, kilo, iletişim:** [Taylor 2014 BMJ, bırakma ve ruh sağlığı, PubMed 24524926](https://pubmed.ncbi.nlm.nih.gov/24524926/) · [Cochrane 2021](https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD013522.pub2/full) · [Bırakma sonrası metabolik etkiler, PMC5021526](https://pmc.ncbi.nlm.nih.gov/articles/PMC5021526/) · [Kilo ve metabolik parametreler, PMC9603007](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9603007/) · [Tannenbaum 2015 korku çağrıları meta-analizi](https://socialactionlab.org/wp-content/uploads/2024/01/Tannenbaum_Appealing-to-Fear-A-Meta-Analysis-of-Fear-Appeal-Effectiveness-and-Theories_2015.pdf) · [Grafik uyarı etiketleri ve öz-yeterlik, PMC4964038](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4964038/)

**Ürün/tasarım emsalleri (Tier-3, yalnızca desen kanıtı):** [Uygulama kılavuz uyumu, PMC6567534](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6567534/) · [Bırakma uygulamaları sistematik değerlendirme, PMC10375280](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10375280/) · [Giyilebilir bileşik skorların değerlendirmesi, 2025](https://www.researchgate.net/publication/390665585_Readiness_recovery_and_strain_an_evaluation_of_composite_health_scores_in_consumer_wearables) · [Duolingo streak mekaniği](https://apptitude.io/blog/how-duolingos-streak-mechanic-actually-works/) · [Kwit bilim sayfası](https://kwit.app/en/science)

---

## 19. Kapanış: bu rapordan çıkan 10 karar

1. **Ölçüm iddia edilmez; model açıkça model olarak sunulur** — ama gizlenmez, tam tersine merkeze konur (§0.1).
2. **Her formül uygulama içinde yayımlanır.** Bu, pazardaki hiçbir rakibin ve hiçbir giyilebilirin yapmadığı şeydir (§0.2).
3. **Katran mg cinsinden asla gösterilmez**; göreli partikül yükü indeksi kullanılır (§1).
4. **CO, ilk 24 saatin kahramanıdır** — bırakma gününün ana görseli nikotin değil oksijen borcudur (§1).
5. **İstek, nikotin düşerken gelir** — ürün bunu kullanıcının kendi verisinde gösterir; kategoride kimse yapmıyor (§4).
6. **"5 dakika yürü" üründeki en kanıtlı müdahaledir** ve SOS ekranının başında durur (§5).
7. **Kulak akupresürü ve bitkiler dışlanmaz, dürüstçe etiketlenir** (🟢/🟡/⚪) — bu, güveni artıran bir tasarım kararıdır (§5, §10).
8. **"İçtim" sessizleşmedir, "Atladım" açılmadır**; ceza yok, konfeti yok, gerçek veri var (§12).
9. **İki indeks, iki hız:** İlerleme davranışı ölçer ve hızlı hareket eder; Zarar Yükü geçmişi taşır ve yavaş düşer. Makas metaforu kullanıcıya öğretilir (§14).
10. **Hiçbir olumsuz içerik, "ne yapabilirsin" olmadan yayımlanamaz** — korku ancak öz-yeterlikle birlikte işe yarar ve bu kural kodda zorunlu alan olarak yaşar (§11).
