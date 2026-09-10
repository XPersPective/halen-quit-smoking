# Changelog

Tüm önemli değişiklikler bu dosyada belgelenir. Biçim:
[Keep a Changelog](https://keepachangelog.com/tr/1.1.0/) ·
sürümleme: [SemVer](https://semver.org/lang/tr/).

## [Yayımlanmamış] — modül raporu uygulaması

Kaynak: [`halen-modul-derin-arastirma-raporu.md`](halen-modul-derin-arastirma-raporu.md)
(14 modül). Ölçülemeyen hiçbir değer üretilmez; her gösterge modelini,
ağırlıklarını ve sınırlarını uygulama içinde yayımlar.

### Eklendi (Added)
- **Vücut Yükü (§1):** nikotin (t½ 2 sa), gün boyu zemin (kotinin karşılığı,
  t½ 16 sa), oksijen borcu/CO (t½ 4,5 sa) ve göreli partikül yükü eğrileri;
  24 saatlik testere-dişi grafiği, atlatılan krizler için "oluşmayan tepe",
  günlük yük bandı (7/30 gün) ve bırakma günü CO iyileşme kartı.
- **Zararlı Madde Kütüphanesi (§2):** 12 madde, IARC sınıfı ve kaynağıyla;
  "bugün temas ettiklerin" sayacı. Doz iddiası yok.
- **Ekonomi (§3):** kazanılan **ve** hâlâ harcanan, iki senaryolu projeksiyon,
  zaman defteri (popülasyon ortalaması etiketiyle), kullanıcının kendi hedefi
  ve yerel eşdeğerler.
- **Kriz penceresi (§4):** çukur/saat/tetikleyici ağırlıklı risk modeli,
  haftalık ısı haritası, "isteklerinin %X'i yük en düşükken geldi" bulgusu ve
  ne yapılacağını söyleyen öneri; opsiyonel (varsayılan kapalı) riskli saat
  hatırlatıcısı.
- **Kriz Kurtarma Seti (§5):** kanıt dereceli tek araç seti (🟢/🟡/⚪), kişinin
  kendi verisine göre sıralanır; rehberli kulak akupresürü (5 NADA noktası,
  iğnesiz, geleneksel etiketiyle).
- **Akciğer ve organlar (§6, §7):** nefes alan akciğer görseli, üç tipik FEV1
  senaryosu ve fark cümlesi, kilometre taşı parlaması; 12 organ kartı — her
  zarar kartının yanında iyileşme kartı.
- **Psikolojik durum (§8):** yoksunluk basıncı bandı (yüzde değil), kişisel
  ofseti kullanıcının kendi bildiriminden öğrenme, "tahminim vs hissettiğin"
  grafiği ve bırakmanın kaygıyı düşürdüğü bulgusu.
- **Yumuşak geçiş (§9):** %15 adım sınırı, 3 gün + %70 stabilizasyon, geri
  alma yerine adım tekrarı, yumuşak iniş; en kolay saatler önce.
- **Destek ve içerik (§10, §11):** günlük destek kartı ve haftalık ızgara,
  faz duyarlı günlük kart motoru, veriye bağlı motivasyon satırı, bilimsel
  kaynaklar ekranı.
- **Kayıt etkileşimi (§12):** "içtim" sessizleşmesi (geri alma + opsiyonel 20
  sn duraklama), "atladım" açılması.
- **Program sistemi (§13):** dört plan, karne, veriye dayalı öneri, 7 gün
  kuralı; geçmiş asla silinmez.
- **İki indeks (§14):** İlerleme Puanı ve Zarar Yükü, makas grafiği, tam
  bileşen dökümü; Zarar Yükü azaltınca düşer, vücut verisi isteğe bağlıdır.

### Değişti (Changed)
- SOS ekranındaki 4D kartlar, kanıt dereceli tek araç setiyle değiştirildi;
  kulak akupresürü dürüst etiketle bu sete eklendi (ana raporun "akupresür
  yok" kuralı, modül raporu §5.① kanıt değerlendirmesiyle güncellendi).
- Sigara kaydından sonra önce geri bildirim yaprağı açılır; kayıt zaten
  alınmıştır ve geri alınabilir.
- "Nasıl hesaplanıyor?" ekranı altı yeni bölümle her formülü yayımlar.

### Grafikler (yeniden yazıldı)
- Modül grafikleri elle çizilen resimlerden **fl_chart** tabanlı tek bir
  bileşene taşındı (`HalenLineChart`): her grafiğin üstünde ne anlama
  geldiğini söyleyen bir cümle, altında **adlandırılmış açıklama (legend)**,
  gerçek eksen etiketleri, dokunma ipucu ve "bugün" işareti var.
- İki indeks yeniden tasarlandı: İlerleme Puanı artık bir **yay göstergesi**
  (yüzdelik böyle okunur), Zarar Yükü ise **bantları çizilmiş bir skala**
  (yük ancak bantlarıyla anlam taşır). Otuz günlük eğilim grafiği bunların
  altında, "yeşil yukarı, gri aşağı" cümlesiyle.
- Para ekseni kısa biçime geçti (etiketler sarıp çakışıyordu), süreler iki
  günden sonra güne dönüyor ("465 sa" yerine "19 g 9 sa"), sabit eksen
  verilen grafiklerde uydurma tik değerleri (−12, 112) kalktı.
- Yeni **Sözlük** ekranı: her terim birer cümlede, jargonsuz. Kartlardaki "?"
  düğmesi önce sözlüğe, oradan formüllere götürüyor.
- `screenshots/module/` — modül ekranlarının başsız üretilen görüntüleri
  (`design_capture_test.dart`; define'sız çalıştırıldığında duman testi).

### Hareket ve organ haritası
- **Vücut haritası (§7)** kart listesinden dokunulabilir bir silüete dönüştü:
  12 organ noktası ortak bir dört saniyelik saatte, konumuna göre kaydırılmış
  fazlarla nefes alır (gövde dalgalanır, noktalar aynı anda yanıp sönmez).
  Bir noktaya dokununca o organ büyür, diğerleri geri çekilir ve detay
  altından açılır.
- **Organ etki oranları** artık görünür: her organ için popülasyon düzeyinde
  *atfedilen oran* (akciğer/KOAH %79, kalp %32) veya *göreli risk* (böbrek
  ~2 kat) sıfırdan animasyonla dolan bir çubukla gösterilir. İki büyüklük
  koda ayrı tiplerle girilmiştir ve ekranda hangisinin çizildiği yazar;
  "senin organının %X'i" iddiası hiçbir yerde üretilmez.
- **Geçişler:** iOS kendi kaydırmalı geri hareketini korur (değiştirmek bir
  uygulamayı orada yabancı hissettirmenin en hızlı yoludur); Android Material 3
  ileri-solma geçişini alır.
- **Kartlar sahneye girer:** modül kartları 8 piksellik, 280 ms'lik kademeli
  bir yükselişle belirir; hareket azaltmada tamamen atlanır.
- Ekran görüntülerinin ortaya çıkardığı gerçek hata: çip etiketleri
  uygulamanın tipografisini hiç kullanmıyordu (çıplak `TextStyle` aileyi ve
  ölçeği düşürüyordu) — düzeltildi.

### Ana ekranda "şu an vücudunda"

- **Yeni:** Bugün ekranının üstünde canlı bir durum kartı — nikotin,
  oksijen borcu ve son sigaradan bu yana geçen süre, yan yana üç büyük sayı
  olarak. Her otuz saniyede saati yeniden okur: "şu an" diyen bir sayının
  donuk kalması, hiç sayı olmamasından kötüdür.
- Model iki dokunuş ötede, Grafikler sekmesinde duruyordu. İnsanın uygulamayı
  açarken sorduğu ilk soru "ne kadarı hâlâ içimde" — cevabın indiği yerde
  olması gerekiyordu.

### Grafik eksenleri artık bir şey söylüyor

- Yük eğrisinin **Y ekseni numaralandı**: %0 / %50 / %100, üstünde birimiyle
  — *kendi zirvenin %'si*. Eskiden eksende sadece Düşük/Orta/Yüksek yazıyordu;
  anlamı olmayan bir eksen grafiği süse çevirir.
- Bu birim, modelin dürüstçe üretebileceği tek birimdir: kişinin kendi 24
  saatlik zirvesine göre normalize edilmiş değer. ng/mL, COHb% veya mg
  hiçbir yerde üretilmez — S5 sınırı bu yüzden korunur.
- **X ekseni de etiketlendi** (24 sa önce · 12 sa önce · şimdi) ve "şimdi"
  noktası artık kartın kenarında yarılanmıyor.
- Yüzde işareti dile göre yazılıyor (`%71` / `71%` / `71 %`); tek biçim
  İngilizce okura bozuk şablon gibi görünüyordu.

### Organlar çizildi

- Organ noktaları **vektör organ şekilleriyle** değişti: bronş sapıyla
  akciğerler, sivri apeksi ve iki büyük damarıyla kalp, falsiform çentiğiyle
  karaciğer, J biçimli mide, fasulye çifti böbrekler, kıvrımlarıyla beyin.
  Bir nokta organ değil, lejant maddesidir.
- **Her organ kendi ritminde hareket ediyor:** akciğer dört saniyede nefes
  alır, kalp bir saniyede lub-dub yapar, gerisi hafifçe salınır. Tek ortak
  titreşim, haritanın şema gibi durmasının sebebiydi.
- Detay panelinde organ 84 piksellik büyük bir görsel olarak açılıyor —
  şeklin gerçekten organ gibi okunduğu ilk boy.
- **Tek şekli olmayan sistemler** (damarlar, bağışıklık, cilt, gözler, üreme)
  gövdeden alınıp kendi satırına taşındı. Onlara sahte bir anatomi çizmek,
  noktanın daha iyi giyinmiş hâli olurdu.
- Silüet parça parça çizilir oldu (baş, boyun, gövde, iki kol, iki bacak);
  tek kapalı yol kolları omuza kaynatıyordu ve sonuç kardan adam gibi
  duruyordu.

### Premium çizim + iyileşme zaman çizelgesi

- **Organ çizimleri gradient dolguya geçti:** düz renk yerine üstten aydınlatmalı
  doğrusal gradyan; seçili organa yumuşak bir dış parıltı (glow) eklendi.
- Her organın detay panelinde **iyileşme zaman çizelgesi** beliriyor: literatürün
  belgelediği zaman noktaları, yeşil bir hat üzerinde dairesel işaretlerle.
  Y ekseni yok — çünkü organ başına yüzdesel bir eğri mevcut değildir;
  eksen, bırakmadan itibaren geçen süre. Her etiket, organın kendi kaynaklı
  iyileşme metninden alınmıştır.
- Şu organlar zaman çizelgesi alır (literatürün net süre verdiği yerler):
  akciğerler, kalp, beyin, damarlar, ağız/boğaz, mide, karaciğer, böbrek/mesane,
  üreme sistemi, cilt. Gözler ve bağışıklık metin bazında kalır — süre çıkarmak
  dürüst olmazdı.

### Premium yeniden tasarımı

Kaynak: [`HALEN-PREMIUM-BRIEF.md`](HALEN-PREMIUM-BRIEF.md) ·
plan: [`HALEN-PREMIUM-PLAN.md`](HALEN-PREMIUM-PLAN.md) ·
geri dönüş noktası: `v1.1.0-modules`

**Tasarım sistemi.** Token katmanı (boşluk/köşe/gölge/hareket), semantik renk
rolleri (`DataRole` — her rengin tek anlamı), Inter yazı tipi (değişken asıl,
SIL OFL) ve tabular rakamlar, tek paylaşılan animasyon saati, beş bileşenlik
kütüphane. 445 boşluk sabiti ölçeğe oturtuldu.

**İlk 60 saniye.** Onboarding artık boş bir ekrana değil, kendi verinden
üretilmiş bir sonuç ekranına çıkıyor: yılda paket, yılda para, yılda zaman,
bağımlılık düzeyin (zaten hesaplanıyordu, hiç gösterilmiyordu) ve ilk 72
saatin ne olacağı. Yeni bir adım "neden bırakıyorsun?" diye soruyor; cevap
bırakma gününde geri gösteriliyor.

**Klinik iskelet.** Uygulamanın en büyük eksiği kapandı:
- **İlaç rehberi** — NRT bırakma oranını yaklaşık 1,5 kat, vareniklin 2,2 kat
  artırıyor ve uygulama bunu hiç anmıyordu. 8 madde; her birinde etki
  büyüklüğü *karşılaştırıldığı şeyle birlikte*. Marka, doz ve öneri yok.
- **Bırakma tarihi** protokolü, geri sayımı ve bırakma günü ekranı.
- **Kayma / nüks ayrımı** — bir sigara kaymadır; kümelenme ve nüks ilaç
  öneriyor, çünkü en çok orada yardım ediyor.
- Nüks önleme planı, destek kişisi, "tek nefes bile yok" kuralı, PHQ-2 ruh
  hâli taraması, kriz ekranında yardım hatları. Şema v5 (eklemeli).

**Tek akışta grafikler.** `Durum` ekranı: altı sayfa, kaydırmalı, her
sayfada tek metrik + tek büyük sayı + tek grafik + tek cümle.

**Bağlılık.** Kilometre taşı kutlaması (konfeti yok: tek halka, tek sayı,
tek cümle; gösterilmeden önce kaydediliyor, asla tekrarlamıyor), üç kademeli
haptik dili — sigara kaydı uygulamadaki en hafif dokunuş, çünkü ağır bir
titreşim orada başka yoldan azarlamaktır.

**Karanlık tema** ilk kez gözle doğrulandı ve iki kural ihlali yakalandı:
zarar skalasının son bandı mercandı (sağlık verisinde kırmızı yasak) ve
ilerleme grafiğinin ekseni numaralıydı ama birimi yazmıyordu.

**CI** eklendi: her push'ta analyze --fatal-infos, testler ve üretilmiş kodun
güncelliği.

### Teknik
- Şema v2 → v4 (modül tabloları, taper işaretçisi, riskli saat tercihi);
  tüm geçişler eklemeli, mevcut kullanıcı verisine dokunulmaz.
- Grafik lejantı 360 dp'lik bir telefonda Türkçe seri adıyla taşıyordu;
  başlıksız kalmaktansa alt satıra iniyor (ekran görüntüsü testinin
  yakaladığı gerçek bir hata).
- 259 test: alan modeli altın-değerleri, içerik yapısal kuralları (her organ
  kartının iyileşme metni, her tekniğin kanıt notu, korku kartının eylem
  satırı), etik lint'e eklenen S5 iddia kalıpları ve "her göstergenin
  formülü yayımlanmış olmalı" kabul testi.

## [1.0.0] — 2026-09-07

### Eklandı (Added)
- 7 adımlı onboarding (<90 sn, hesap yok; rapor §11 ile birebir) ve 18 yaş
  altı kaynak yönlendirmesi (plan verilmez, §39).
- Tek dokunuşla kayıt: BUGÜN CTA, widget, QS tile, iOS ControlWidget ve
  bildirim aksiyonu; tümü `source` etiketli.
- Dinamik azaltma planı motoru (Adaptive Taper, §14): günlük bütçe formülü,
  TTFC duyarlı tempo, saat-histogram pencereleri, medyan-gap ±%25 aralık,
  tempo çarpanlı sonraki öneri, dinamik yeniden hesap (dağıtım, sıkışma
  mesajı, %5 haftalık yumuşatma), tempo adaptasyonu, son-hafta fazı ve
  bırakma günü onayı, aralıklı "kaç hafta" tahmini.
- BUGÜN ekranı: hedef halkası, son sigara/sonraki hedef satırları,
  normalize nikotin eğrisi (S3) + şeffaflık ekranı, tasarruf ve health
  şeritleri, ilk gün boş durumu.
- İstatistikler: günlük sayı/plan işaretli grafik, saatlik desen, birikimli
  tasarruf; grafiklerin sözel özetleri (a11y).
- WHO sağlık zaman çizelgesi (20 dk → 15 yıl), azaltma modunda bırakma
  gününe dek önizleme kilidi; bırakma günü onayı.
- Craving SOS: 2 dk sayaç, 4D kartlar, 60 sn kutu nefesi (reduce-motion
  duyarlı), "izle ve bekle"; "Atlattım"/"İçtim" sonuç kaydı, sabit NRT
  satırı.
- Bildirim sistemi: Sakin/Standart/Yoğun/tam kapalı yoğunluk; günlük özet ve
  sabah hedefi varsayılan açık, plan-saati hatırlatması kapalı; 72 saat
  bırakma desteği, sessizlik dönüşü, milestone; Android 13+ runtime izin,
  iOS provisional; tam saat kullanıcı opt-in'i (USE_EXACT_ALARM yok);
  reboot sonrası yeniden planlama.
- Home widget (Android RemoteViews + iOS 17 interaktif WidgetKit), iOS 18
  ControlWidget, Android QS tile; hızlı kayıt kuyruğu source etiketli.
- Tek seferlik "Halen Lifetime" (StoreKit 2 / Play Billing): her açılışta
  mağaza doğrulaması, restore butonu, pending'e hak verme, iade/revocation
  düşürme; ilk açılışta kartsız 7 gün premium deneme.
- JSON dışa aktarma/içe aktarma (tüm 13 tablo), tüm verileri silme.
- Gizlilik: SQLCipher şifreli `halen.db`, Keystore/Keychain anahtar,
  yedek/transfer muafiyeti; uygulama ilk açılışta ağ çağrısı yapmaz.
- EN/TR/DE tam yerelleştirme; 78+ test (domain, veri, widget) ve yasak
  iddia ifadelerini engelleyen etik lint.
- `tool/simulate.dart`: ilk açılıştan bırakma gününe 8 haftalık senaryo.

### Bilinen sınırlar
- iOS Widget extension hedefi Xcode'da tek seferlik manuel eklenir
  (bkz. `ios/HalenWidget/SETUP.md`); CI yalnız Runner hedefini derler.
- Barkod tarama (P1), tetikleyici otomatik analiz (P1) v1.1 planındadır.
