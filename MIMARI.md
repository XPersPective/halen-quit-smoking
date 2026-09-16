# Halen: Quit Smoking Tracker — çalışma protokolü, mimari ve yol haritası

Son güncelleme: 2026-09-16. Tek yetkili geliştirme belgesi budur.
README.md kurulum/giriş; PRIVACY_POLICY.md kullanıcıya sunulan gizlilik politikası;
LICENSE lisans metnidir. Bunlar ayrı yol haritaları değildir.
Mağaza açıklamaları bu belgenin sonunda tutulur; STORE_LISTING ayrı bir plan değildir.

## 1. Zorunlu çalışma ve devralma protokolü

1. Önce bu belgeyi, git status/diff'i ve ilgili akışın UI → provider → repository →
   veritabanı/platform zincirini oku. Başka geliştiricinin değişikliğini silme.
2. Her işe aşağıdaki Hxx kimliğiyle başla. Durumlar: AÇIK, DEVAM, DOĞRULANDI,
   DIŞ BAĞIMLILIK. Eski bir [x], gerçek cihaz kanıtının yerine geçmez.
3. Önce mevcut yardımcıyı/native özelliği kullan (Ponytail ultra). Yeni bağımlılık,
   soyutlama veya ekran ancak bu işin somut gereksinimini karşılıyorsa eklenir.
4. Mimari/veri sözleşmesi etkileniyorsa önce bu belgenin §2 bölümünü güncelle.
   Ardından küçük, çalışır bir değişiklik yap. Yeni sorunları Hxx olarak ekle.
5. Kullanıcı girdisi, para, lisans, import ve kayıt silme yollarını özellikle test et.
   Testin neyi kanıtladığını yaz; sahte servis testi mağaza doğrulaması değildir.
6. UI değişince TR/EN/DE, açık/koyu/sistem tema, dar ekran ve büyük yazıyla kontrol
   et. Golden güncellemek tek başına görsel onay değildir; çıktıyı aç ve incele.
7. Her tamamlanan maddede dosya, çalıştırılan komut, sonuç ve kalan sınırı kaydet.
   Commit başlığı: "fix(Hxx): somut davranış" veya "docs(Hxx): ...".
   Commit açıklamasında Requirement, Implementation, Verification, Remaining yer alır.
8. Kullanıcı commit/push istedi: yalnızca incelenmiş ilgili dosyaları stage et,
   git diff --cached --check ve staged diff incelemesinden sonra commit/push yap.
   Toplu git add . kullanma; ilgisiz ve halen doğrulanmayan değişiklikleri dahil etme.
   Push sonrası git rev-parse HEAD ile git ls-remote sonucunu karşılaştır.
9. Başarısız test/derleme ve eksik gerçek cihaz testiyle DOĞRULANDI yazma.
   "Hatasız", "tam güvenli", "tüm mağaza kurallarına uygun" ifadelerini kanıtsız kullanma.
10. Devralan geliştirici §4'teki son kayıttan devam eder. Yeni master/roadmap MD açmaz.
    Bir sonraki işi bitirmeden önce durumu güncelle; dış erişim yoksa hangi hesap,
    cihaz veya yayın kararı gerektiğini ve tamamlanma kanıtını somut yaz.

### Önceki belgelerden geçiş

HALEN_MASTER_ROADMAP.md ve MD/architecture/ROADMAP.md bu belgede birleştirilir.
Önceki A.1–A.4 → H10/H11; B.1–B.4 → H04/H05/H13; C.1–C.4 → H08/H09/H12/H14;
D.1–D.2 → H15; E.1–E.4 → H01/H16/H17; F.1–F.6 → H03/H07/H20;
G.1–G.6 → H20/H23/H24/H25. Önceki bilimsel ve güvenlik iddiaları doğruluk kontrolünden
geçmeden devralınmaz. Özellikle paket mg değerleri ciğerde ölçülmüş katran değildir;
restore callback'i kriptografik receipt doğrulaması değildir; boy/kilo alanı mevcut
olması onboarding'de sorulduğunu kanıtlamaz. Referans "report §..." yorumları
tarihsel nottur, silinmiş rapora bağımlı yeni gereksinim üretilmez.

## 2. Mimari ve ürün sözleşmeleri

### 2.1 Katmanlar, kimlik, veri

Ürün adı Halen: Quit Smoking Tracker; TR Halen: Sigara Bırakma Sayacı;
DE Halen: Rauchfrei-Tracker. "Quick Smoking" kullanılmaz.
Paket kimliği com.crazypenguin.halenquitsmoking; mağaza ürünleri .lifetime,
.annual, .monthly. Mağaza adı benzersizliği ve marka hakkı ayrıca doğrulanır.

Flutter / Inter / ortak design token'ları → Riverpod uygulama controller'ları →
deterministik domain → Drift/SQLCipher ve platform servisleri.
Mevcut şema sürümü koddan okunur (app_database.dart); yeni kolon additive migration
ile eklenir. Profildeki boy/kilo/sigara yılı bilgisi SmokingProfile tarafındadır;
yeni bir paralel UserProfile şeması uydurulmaz.

Hesap ve uygulama sunucusu şu an yoktur. Kayıtlar cihazda şifreli saklanır.
StoreKit ve Play Billing ağ erişimi, kullanıcının açtığı harici kaynaklar ve gelecekteki
reklam trafiği "hiçbir ağ erişimi yok" iddiasının dışında açıkça anlatılır.
Makbuz doğrulama sunucusu eklenirse veri akışı ve politika yeniden güncellenir;
sunucusuzluğu korumak uğruna doğrulama güvenliği tamamlanmış sayılmaz.

### 2.2 Bilimsel anlam ve kullanıcıya sunum

S1 saat/tarih; S2 kişinin kaydı; S3 açıklanmış matematiksel model; S4 genel/popülasyon
kanıtı; S5 yasak kişisel ölçüm iddiası. Her kart hangi sınıfta olduğunu söyler.
Nikotin/CO yarı ömrü kaynak/varsayımla sunulur. Partikül modeli temsili olabilir;
temsili parametre klinik temizlenme süresi olarak sunulamaz.
Kilo, boy, yaş ve süre yalnızca kaynakla savunulabilir modelde kullanılır.
Girdisi olan her kişiyi zorla farklı sonuç üretmek için keyfi katsayıyla ölçekleme.
Paket üstündeki katran × adet, etiket bazlı tahmindir; akciğerde kalan mg veya yüzde
değildir. "8 saatte temizlenir", "su nikotini nötralize eder" kullanılmaz.
İlerleme 0–100 davranış puanıdır; 78/100, yüzde iyileşme değildir.
Psikolojik durum kişinin kaydettiği hislerden ayrılmış tahmindir; tanı konmaz.
Kayıttan önceki yıllar tahmini arka plandır; gerçek saatlik/günlük kayıt uydurulmaz.
Tahmin ile gözlenen dönem çizgi stili, lejant ve "Halen başlangıcı" işaretiyle ayrılır.
Her tıbbi iddiada kaynak, çalışma yılı/sürümü, incelenen tarih ve sınır tutulur.
Erişilmeyen kaynak için inceleme tarihi veya "doğrulandı" uydurulmaz.

### 2.3 Ekran hiyerarşisi ve tasarım

Bugün sırası: logo/tam ad + Premium rozeti + Ayarlar; aktif plan ve bugün yapılacak
tek adım; "Sigara içtim"/"İsteği atlattım"; gün içi kayıt grafiği ve günlük; vücut
modeli ve organ özeti; bugünkü tasarruf; bırakma tarihi/sağlık çizelgesi; SOS kısa yolu.
Ayrıntılar ilgili karta dokununca açılır. Aynı tür kartların başlık/değer/açıklama
tipografisi, birimleri, tarih aralığı, boş durum ve bilgi düğmeleri ortak olur.
Sigara kaydı belirgin koyu mercan/kırmızı tonuyla yapılabilir; başarı/fidan/konfeti
tetiklemez. Kişiyi utandırmaz; "Kaydedildi", geri al ve sonraki adım gösterir.
Olumlu kutlama sadece gerçekten atlatılan istek/uygun kilometre taşında olur.
Varsayılan tema sistemdir. Font temaya göre değişmez; büyük yazı kırpılmaz.
Hareket azaltma ayarında grafik animasyonu durur; sürekli görünürlük değişiminde
animasyon tekrar başlamaz. Ekran okuyucusuna grafik anlamı metinle verilir.

### 2.4 İzin, ülke, premium ve reklam

Bildirim özelliği ücretsizdir. İzin ekranında gerçek OS durumu okunur:
istenmedi/verildi/reddedildi/kısıtlı. Geri gezinme cevapları korur. Bildirim izni
reddedildiğinde temel kullanım engellenmez. İzin verilmişse tekrar popup açılmaz.
Apple 4.5.4 push iznini uygulamanın işlev şartı yapmayı yasaklar; aynı saygılı izin
akışı yerel bildirimlerde de kullanılır. Hatırlatmalar sigara/paket almaya teşvik etmez.

UI dili telefon ülkesinin kanıtı değildir. Seçili ülke varsa o kullanılır, yoksa cihaz
bölgesi önerilir; yalnızca dil varsa ülke seçimi sunulur (İngilizce=ABD varsayılmaz).
Yerel hizmet adı ve numarası ülke etiketiyle, açıklama uygulama dilinde gösterilir.
Arama yalnız kullanıcı dokunuşuyla sistem çeviricisine gider.

7 günlük yerel deneme ilk günden tüm uygulanmış premium özellikleri açar. Deneme
başlangıcı/mağaza hakkı kullanıcı JSON dosyasından alınamaz. Premium rozeti kalan
günü veya sahipliği gösterir. Uygulamayı silip kurma saldırısını tamamen yerel,
hesapsız depoyla kesin engellemek mümkün değildir; gizli cihaz takibi yapılmaz.
Ömür boyu ürün görünür ve adsizdir; mevcut aylık/yıllık seçenekler açık koşulla sürer.
Paywall fiyatı mağazadan gelir; "customizable widgets" yalnız çalışan düzenleme
arayüzü ve gerçek native widget desteği varsa vaat edilir.

Son kullanıcı talebi önceki banner-only planını değiştirir: ilk kurulum ve 7 günlük
deneme reklamsız; sonrasında uygun ücretsiz ekranlarda orta boy, etiketli banner.
App-open reklam ancak SDK'nın uygun yerleşiminde, yükleme sırasında, kolay kapanır
ve düşük sıklıkla değerlendirilir. İlk kurulum, onboarding, SOS, sağlık ayrıntısı,
ödeme/restore, izin ekranı ve widget'ta yoktur. Rastgele aksiyon arası interstitial
ve splash öncesi tam ekran video yoktur (Google Ads politikası).
Önerilen başlangıç sınırı: app-open en çok 24 saatte bir, aynı oturumda ikinci yok;
beklemiş reklam içerik açıldıktan sonra gösterilmez. Premium/aktif deneme sıfır reklam.
Gerçek reklam entegrasyonu sağlayıcı hesabı, birim kimliği, GPL uyumu, consent ve
mağaza beyanı ister. Test kimliği ile geliştirilir, kendi reklamına tıklanmaz.
Sağlık/ruh hali/sigara kayıtları hedeflemede kullanılmaz; izin reddi temel işlevi bozmaz.

### 2.5 Lisans, kullanıcı hakları, yayın

GPL-3.0-or-later ticari dağıtıma izin verir; "ticari kullanım yasak" ekiyle GPL denmez.
Tam lisans metni, üçüncü taraf bildirimleri, kaynak erişimi ve mağaza dağıtım uyumu
H19'da doğrulanır. Açık kaynak olmak bağımlılıkların tamamen açık veya kodun kusursuz
güvenli olduğuna kanıt değildir. Hakkında'da denetlenebilirlik ve yerel veri vurgulanır.
Gizlilik ve destek bağlantıları girişsiz erişilir; kaynak deposunun özel olması
404 verebilir. Depo görünürlüğü kullanıcı yetkisi olmadan değiştirilmez.
App Privacy, Data Safety, sağlık beyanı, yaş/çocuk hedef kitlesi ve KVKK/GDPR
yükümlülükleri gerçek veri akışına göre değerlendirilir. Beyan formu, hukuk incelemesi,
iOS imzalı archive ve mağaza sandbox testleri yapılmadan yayın hazır sayılmaz.

## 3. Ayrıntılı uygulama sırası ve kabul ölçütleri

Aşağıdaki maddelerin hepsi kapsam dahilidir; AÇIK bir satır uygulandı demek değildir.

### H01 — Ülkeye uygun, yeşil destek hattı [DEVAM; kod ve otomatik testler geçti]
Sorun: İngilizce arayüzde Türkiye numarası öne çıkıyor. SOS, Ayarlar ve başlangıç
ekranındaki tüm çağrıları bul; tek ülke kataloğunu kullan. TR ALO171/YEDAM115,
US/UK/DE hizmetlerini resmi kaynaklarından doğrula, kaynak ve kontrol tarihini yaz.
Ülke değiştirme kısa yolu ve yerel ülke etiketi sun; bilinmeyen ülkeye yanlış telefon
atma. Yeşil, en az 48dp dokunma alanı; hata/çevirici yok durumunda numara kopyalama.
Kanıt: TR/EN/DE ve İngilizce+Türkiye/İngilizce+UK kombinasyon testi; gerçek cihazda
çevirici açılır ama otomatik arama yapılmaz.

Uygulama kararı: ortak QuitlineCard SOS/Ayarlar/18 yaş altı ekranında kullanılır.
Seçim mevcut shared_preferences içinde yalnız destek bölgesi olarak tutulur;
UI dilinden ülke türetilmez. Cihaz TR/US/DE önerilebilir, GB için İngiltere/İskoçya/
Galler ayrımı kullanıcıya bırakılır. Desteklenmeyen bölgede yerel uzman yönlendirmesi
gösterilir. 16 Eylül resmi kontrolleri: ALO171 (alo171.saglik.gov.tr), YEDAM115
(yedam.org.tr/telefon-ile-danismanlik), CDC 1-800-784-8669
(cdc.gov/tobacco/hcp/patient-care/quitlines-and-other-resources.html), BIÖG
0800 8 31 31 31 (rauchfrei-info.de/unterstuetzung/telefonberatung/), NHS İngiltere
0300 123 1044, İskoçya 0800 84 84 84, Galler 0800 085 2219
(nhs.uk/live-well/quit-smoking/nhs-stop-smoking-services-help-you-quit/).
Eski "UK NHS" tüm Birleşik Krallık için genellenmez; "Yeşilay 176" kaldırılır.

### H02 — Bildirim durumu ve geri gezilebilir karşılama [AÇIK]
Splash/onboarding geçişlerini ve NotificationService çağrılarını incele. Yetki
durumunu ilk açılış ve ayarlardan dönüşte OS'den al. İzin varsa onaylı görünüm,
ret varsa açıklama ve ayar kısa yolu; ileri/geri çalışır, girilmiş bilgiler korunur.
Ücretsiz izin isteği ve premium pazarlama birbirine bağlanmaz. Pazarlama hatırlatması
için ayrı kullanıcı tercihi gerekir; deneme bitiş bildirimi otomatik reklam izni sayılmaz.
Kanıt: izin verilmiş/reddedilmiş/sonradan kaldırılmış senaryoları; Android/iOS cihaz.

### H03 — JSON ile deneme sıfırlama açığını kapat [DEVAM]
BackupRepository settings.trialStartedAt alanını export/import'tan çıkar.
Eski yedekte varsa yok say; mevcut deneme ve store cache değişmez. Onboarding'e
JSON eylemi koyma, Ayarlar > Verilerim altında veri taşıma olarak sun.
Null/gelecek/eski trial tarihi ve sahte entitlement içeren import premium açamaz.
Yerel yeniden kurulum sınırını §2.4'te açık tut; dışa aktarmayı kaldırmak lisans
doğrulaması yerine geçmez. Kanıt: değiştirilmiş JSON ile süresi bitmiş denemenin
yenilenmediği, normal kayıtların aktarıldığı ve bozuk import'un rollback testi.

### H04 — Onboarding temel girdileri ve varsayılanlar [DEVAM]
OnboardingAnswers/controller/repository/UI zincirini beraber düzenle. Günlük adet
varsayılanı 20, paket adedi 20. Adet tam sayı; 1.2, negatif, sıfır, NaN, aşırı değer
kabul edilmez, "1.2" sessizce 12'ye dönüştürülmez. Fiyat başlangıçta boş ve pozitif
sonlu sayı zorunlu; virgül/nokta yerel yazımı destekle. Yaş aralığı, ilk sigaraya süre,
günlük ritim ve marka açık sorulur; boş/yalnız boşluk marka ileri geçirmez.
Sayfa üzerinde kısa hata göster, uygulamayı çökertme. Marka sonradan değiştirilebilir.
Kanıt: tüm adımlar geri/ileri, geçersiz klavye/yapıştırma girdisi, doğru kalıcılık testi.

Uygulama kararı: mevcut sekiz adım korunur; fiyat ve marka adımlarında Flutter Form
doğrulaması, repository sınırında aynı domain kuralları kullanılır. Günlük adet 1–60
tam sayı slider (varsayılan20), paket 1–100 tam sayı, fiyat >0 ve <=1.000.000 sonlu
yerel ondalık sayı; marka trim sonrası 1–100 karakter. Bunlar klinik sınırlar değil
girdi/ürün sınırlarıdır. Geçersiz paket girdisi sessizce20 olmaz, boş marka önceki
markayı geri getirmez. Boy/kilo/yıl ve ritim eklemesi H05 kapsamında henüz açık.

### H05 — Boy, kilo ve sigara yılı başlangıçta [AÇIK]
Mevcut nullable SmokingProfile alanlarını tekrar kullan. Onboarding'de boy(cm),
kilo(kg), sigara yılı ve kullanıldığı amaç göster. Yaşla çelişen süre, sonlu olmayan
sayı ve makul aralık dışı değer reddedilir. "Bilmiyorum/paylaşmak istemiyorum"
nullable kalır, sahte ortalama kullanıcı verisi gibi saklanmaz. Ayarlardan düzenleme
ilgili modeli yeniler. Doğum tarihi/rehber gibi gereksiz hassas veri ekleme.
Kanıt: migration, onboarding→profil→model zinciri; bilinmeyen değer ve sınır testi.

### H06 — Bütün girişleri denetle [AÇIK]
TextField/TextFormField, slider, backup, deep link, widget ve DB girişlerini envanterle.
Adet=int, para=pozitif sonlu, hedef adı=trim/uzunluk sınırı, tarih/geçmiş=anlamlı aralık.
Bütçe, paket satın alma, birikim hedefi ve model ayarları aynı domain kurallarını
kullanır. Negatif/future kayıt ve duplicate event davranışı belirlenir.
Kanıt: her güven sınırına en az bir kötü veri regresyonu; işlem rollback ve hata metni.

### H07 — Premium rozeti ve gerçek widget özelleştirmesi [AÇIK]
Bugün üst barında Ayarlar yanında tıklanabilir Premium/Deneme rozeti; kalan gün,
7 gün sonrasında hangi özelliklerin değişeceği ve ömür boyu adsiz seçenek görünür.
Widget için Ayarlar > Widget'lar: ekleme yönergesi, mevcut native boyut önizlemesi,
desteklenen gösterge/tema seçimleri ve kaydet; ilk günden denemede kullanılabilir.
Android provider ve iOS WidgetKit/App Group'a aynı ayar yazılır; desteklenmeyen seçenek
pazarlanmaz. Kanıt: seçim kalıcılığı/deneme kapısı, gerçek launcher/WidgetKit görüntüsü.

### H08 — Marka ve ana başlık [AÇIK]
Mevcut uygulama ikonunu ortak vektör/asset ile tam ürün adının soluna getir.
Halen okunur büyüklükte, alt açıklama daha küçük; "Today" marka başlığını bastırmaz.
320dp ve büyük fontta rozet/ayar/başlık taşmaz. Paket kimliğini pazarlama adına göre
yeniden değiştirme. Kanıt: EN/TR/DE üst bar açık/koyu görüntüleri ve tap hedefleri.

### H09 — Sigara kayıt düğmesi ve geri bildirim [AÇIK]
Bugün ve SOS kayıt yollarını izle. Kontrastlı mercan düğme; sigara kaydında fidan,
başarı rengi veya kutlama yok. Kayıt/geri al/tek sonraki adım net; art arda dokunuş
duplicate kayıt üretmez. Olumsuz renk kullanıcıyı suçlayan içerik gerektirmez.
Kanıt: kayıt/undo/SOS/çift tıklama; yalnız olumlu başarının kutlama tetiklediği test.

### H10 — Organ haritasının boşluğunu gider [AÇIK]
Önce mevcut organ kataloğu ve ana ekran filtrelerini say; veri varsa yeniden ekleme.
Ana ekrana dengeli 2×4 veya yatay kayar organ özeti, erişilebilir isimler ve tümü
bağlantısı. Büyük ekranda boş sütun bırakma; küçükte taşma olmadan kaydır.
Akciğer/kalp/damar/beyin/cilt vb. yalnız kaynaklı organları göster, seçince adı üstte.
Kanıt: 320/390/420dp, landscape, büyük yazı, seçilen organ ayrıntısı ekran görüntüsü.

### H11 — Organ içerikleri ve sağlık çizelgesinin konumu [AÇIK]
Sağlık çizelgesini Bugün ve vücut ayrıntısından görünür aç; Hakkında altında saklama.
Bırakma zamanından otomatik geçen süre olduğunu, kutuların tamamlanma checkbox'ı
olmadığını anlat. Henüz bırakma tarihi yoksa tarih seçimi ve genel bilgi önizlemesi.
Genel iyileşme bilgisi kişisel organ sonucu değildir. Kanıt: tarihi yok/gelecek/geçmiş,
kayıt sonrası değişim, erişilebilir zaman noktası etiketleri.

### H12 — Psikolojik durum ve his günlüğü [AÇIK]
Kartın amacı bir cümle: kendi kaydettiğin hisleri izlemek ve zor saatleri görmek.
"Nasıl hissediyorsun?" kayıt eylemi, kayıt sonrası onay ve geçmiş çizgisi bulunur.
Sakin/zorlayıcı bantların anlamı ve tahmin girdileri açıklanır; tahmin ve beyan
ayrı stil/etiketle çizilir. Veri yokken kesin durum veya tanı üretme.
Kanıt: his kaydı kalıcı, yeniden açınca görünür; sıfır kayıt, hata ve büyük yazı.

### H13 — Grafik standardı, puan ve yük açıklaması [AÇIK]
Her grafikte başlık, metrik, birim, dönem, kaynak türü, veri yok durumu, nasıl hesaplandı
ve ayrıntı eylemi denetlenir. İlerleme=plan davranışı (78/100); yük=göreli model indeksi.
Siyah kalın küçük başlık ile dev alt değer tutarsızlığını ortak tokens ile gider.
Katran ana özetten erişilir; ciğerde ölçülen oran vaat edilmez.
Kanıt: chart/semantics testleri; aynı başlık/ölçek standardı TR/EN/DE ve iki tema.

### H14 — Bugün ne yapmalı, günlük grafik ve kazanımlar [AÇIK]
"17/3" gibi değeri "Bugün 17 kayıt / hedef 3" olarak açık etiketle. Planın azaltma
adımı ve bir sonraki öneri anlatılır; "şimdi sigara içmelisin" alarmı oluşturulmaz.
"Bugün sana kalanlar" yerine "Bugünkü ilerlemen": atlatılan istek, kayıtlı tasarruf,
sigarasız süre. 24 saat sigara olay grafiği günlük yanında; saat/kaç adet/boş veri net.
Kanıt: sıfır/kota altı/kota üstü, gün sınırı, geçmiş kayıt silme sonrası hesap.

### H15 — Para, tarihsel tahmin ve plan başlangıcı [AÇIK]
Harcama, tasarruf, hedef ve geçmiş tahmini ayrı isim/birimle göster. 1 ay/1 yıl/tümü,
bugünden geriye aralık. Kayıttan önceki dönem maliyeti güncel fiyatla yaklaşık olduğu
etiketiyle; enflasyona göre gerçek tarihsel ödeme diye sunma. Eksik gün=bilinmiyor.
Başlangıç tarihine çizgi/etiket; önceki dönem tahmini çizgi, kayıt sonrası gerçek veri.
Kanıt: ilk gün sıfır sahte kazanç, eksik günler, fiyat değişimi, geleceğe taşan kayıt,
yıl/ay/gün sınırı ve tasarruf hedefi doğrulaması.

### H16 — Kriz araçları ve görsel kulak rehberi [AÇIK]
SOS içinde erteleme, nefes, yürüyüş, el/ağız oyalama ve mevcut kulak akupresürü
görünür; "Nasıl geçti?/İçtim/Atlattım" erişimi kolay. Noktalar okunur kulak görselinde
dokunulabilir ve metinle eşleşir. İğne kullanımı öğretme; akupresürün bırakma
etkinliği belirsizse açıkça belirt. Organ tedavisi/nikotin temizleme etkisi uydurma.
Kanıt: nokta seçimi, büyük yazı/koyu tema, süreyi durdurma, SOS reklam/paywall yok.

### H17 — Rehber, beslenme ve makale çeşitliliği [AÇIK]
Mevcut TR/EN/DE kataloglarını karşılaştır (dil başına içerik kaybı var mı).
Tetikleyiciler, kayma sonrası dönüş, uyku, stres, destek kişisi, NRT danışmanlığı,
alışkanlık yerine koyma, kahve/alkol ve ağız-el oyalama konularını kaynakla genişlet.
Her yazı ne yapmalı, kanıt gücü, sınır, kaynak ve kısa okunur bölümler içerir.
Alternatifler "geleneksel/sınırlı kanıt" etiketiyle; besin/akupresür tedavi yerine geçmez.
Kanıt: üç dilde kategori/erişim, okunabilirlik, kaynak URL/kapsam ve iddia incelemesi.

### H18 — Tema, animasyon ve erişilebilirlik [AÇIK]
Sistem tema varsayılanını doğrula; tüm ekranlarda Inter/tokens aynı. Kontrast,
ikon+metin (yalnız renge bağımlı değil), en az 48dp etkileşim ve screen reader.
Grafik ilk görünümde kısa çizilsin, reduceMotion'da son durum; kaydırmada baştan
tekrar tekrar çizilmesin. Kanıt: layout/golden, 1.0/1.6/2.0 yazı, düşük hareket.

### H19 — Hakkında, açık kaynak ve lisans [AÇIK]
Topluma fayda, kaynak inceleme/katkı, yerel şifreli veri anlatılır. "Gizli kod yok"
yerine incelenebilir kaynak ve kullanılan bağımlılık/izinler somut gösterilir.
Tam GPL metnini ve üçüncü taraf lisans ekranını ekle; mevcut LICENSE yalnız bağlantı.
GitHub kaynak/gizlilik/destek erişimini oturumsuz doğrula. Yanlış destek numarası
(ör. eski store taslağındaki Yeşilay176) yayımlanmaz. GPL ticari kullanım yasağı değildir.
Kanıt: link/açılmama durumu, üç dil, lisans listesi ve repo görünürlüğü kanıtı.

### H20 — Gerçek üretim ödemesi ve restore [AÇIK]
PurchaseService.start, stream, refresh, DB cache ve Riverpod UI zincirini birlikte
incele. Stream async sonuçlarından önce restore tamamlandı sayılmaz; boş restore
tek başına doğrulanmış iade sayılmaz. iOS SK1/SK2 semantiği ve expiration/revocation
alanları resmi native kaynaklarla incelenir. Yerel satıra "owned" yazmak receipt
doğrulaması değildir. Android token/iOS signed transaction doğrulanır.
Eşzamanlı restore, hata sonrası tekrar, pending, refund, abonelik sonu ve reinstall
test edilir. Sahte servis testleri ayrı, gerçek sandbox matrisi ayrı kaydedilir.
Hesap/anahtar/API erişimi DIŞ BAĞIMLILIK; bu yüzden kod tamamlandı kutusu atılmaz.

### H21 — Banner, app-open ve deneme sonrası reklamsız satın alma [AÇIK]
§2.4 kurallarıyla önce saf eligibility/frequency politikası; ardından gerçek SDK
lisans incelemesi, consent, test birimleri, kullanıcı reklam ayarları ve raporlama.
Ağ yok/reklam yok durumu içerikte boş dev alan bırakmaz. Reklamdan dönünce kayıt
kaybolmaz. Deneme/premium sırasında istek bile atılmaz.
Kanıt: gün0/gün6/gün7, OS dönüşü, günlük cap, arka plan, SOS ve premium negatif testleri;
gerçek SDK incelemesi ve hesap kimlikleri yayın öncesi gereklidir.

### H22 — Belgeler ve üretim çıktısı temizliği [DEVAM]
Kökte tek MIMARI.md; eski iki planın gereksinimleri bu dosyada karşılanınca sil.
README linklerini düzelt. Store açıklamaları ekte; gizlilik kullanıcı belgesi kalır.
Kökteki APK'yı yalnız hedefi doğrulayarak kaldır; build/ normal üretim klasörü kalır,
Git'e girmez. *.apk/*.aab/*.ipa, imza sırları ve geçici çıktılar ignore edilir.
Pubspec.lock uygulamanın tekrarlanabilir derlemesi için takip edilir.
Kanıt: git status/check-ignore/ls-files; eski belge yollarına kırık link yok.

### H23 — Debug konsolu, cihaz ve derleme [AÇIK]
Gerçek emulator logunu al: Flutter exception, overflow, plugin/method channel,
DB çoklu instance ve zamanlayıcı problemlerini tek tek kök nedenle düzelt.
Drift uyarısını global susturma; testlerin DB/executor yaşam döngüsünü incele.
SDK warning'i crash ile karıştırma. home_widget Kotlin uyarısını uyumlu sürüm/native
geçişle değerlendir; sırf uyarı için kırıcı yükseltme yapma.
Kanıt: temiz analyze, tam test, debug smoke, APK/AAB; iOS macOS/Xcode archive ayrı.

### H24 — Store beyanları, gizlilik ve hukuk [AÇIK]
Gerçek SDK/native izin ağ envanteriyle App Privacy/Data Safety/Health declaration
taslağı hazırla; ülke/yaş hedefi, destek/gizlilik URL'si, KVKK/GDPR veri işleme ve reklam
consent kararını eşleştir. İzin reddi/premium/free veri akışı açıklanır.
Apple/Google kurallarını yayın günü yeniden oku; hukuk uygunluğunu test geçti diye
ilan etme. Hesap formları ve hukuki kararlar DIŞ BAĞIMLILIK.
Kanıt: konsol kayıtları, anonim URL erişimi, imzalı sürüm gerçek SDK envanteri.

### H25 — Mağaza metinleri, final turu ve teslim [AÇIK]
Ekteki taslakları gerçek özelliklerle yeniden yaz; 30 karakter sınırı ve anahtar
kelime limitleri kontrol edilir. Kilit ekranı/özelleştirme gibi cihazda doğrulanmamış
özelliği mevcutmuş gibi pazarlama. Üç dilde gerçek ekran görüntüleri üret.
H01–H24 gereksinimlerini tek tek kanıtla, yeni kullanıcı→trial→free→purchase→restore
ve ret/offline/reset/import akışlarını Android/iOS'ta gez. Her açık dış kapıyı raporla.
İmzalı paketlerin hash/sürümü, test kanıtı, commit/push hash'i ve eksikleri §4'e yaz.

### H26 — Yedek kapsamı ve veri silme bütünlüğü [AÇIK; bu denetimde bulundu]
BackupRepository eski tabloları aktarırken yeni mood/support/cessation/pack/settings
alanlarını kapsamıyor; wipe de tüm kişisel tabloları silmiyor olabilir. Şema ile
export/import/delete listesini satır satır eşleştir. Format migration/geri uyumluluk,
referans bütünlüğü ve tüm kişisel verinin silinmesini kanıtla. Satın alma/trial yedek
dışında kalır. Bozuk dosyada kısmi silme olmaz; backup'ın düz metin olduğu açıklanır.
Kanıt: bütün yeni alanlarda round-trip, tüm kişisel tablo temizliği, rollback.

## 4. Kanıt, güncel durum ve devralma

2026-09-16 incelemesi: çalışma ağacı kirli; daha önce yapılmış kullanıcı/ajan
değişiklikleri korunur. Bu tur başlamadan güncellenmiş notification, entitlement,
economy, SOS, today_log dosyaları yeniden okunmadan toplu commit edilmez.
Önceki 291 test ve APK/AAB başarıları mevcut son ağacın sertifikası değildir.
Önceki restore değişikliği yalnız DAO/widget testleriyle doğrulanmış; H20 kapsamında
asenkron native tamamlanma, güvenilirlik ve sıra hataları hâlâ incelenecek.
Anonim web kontrolünde GitHub kaynağı 404 döndü; git ls-remote erişimi var.
Bu gözlem URL'lerin kullanıcıya açık olduğunu kanıtlamaz; H19/H24 açık.
Sonraki sıra: H22 belge/çıktı → H03 trial import → H01 hat → H02/H04/H05 onboarding
→ H08/H09/H10/H12/H13/H14/H15 tasarım → H07/H16/H17/H18 → H20/H21/H23/H24/H25.
H26 veri kaybı riski nedeniyle onboarding genişlemesiyle birlikte önceliklendirilir.
Bir maddeyi kısmen uygulayan geliştirici kalan kabul ölçütlerini burada not eder.

### H22/H03 uygulama kaydı — 2026-09-16

H22: README sadeleştirildi; eski HALEN_MASTER_ROADMAP.md, MD/README.md,
MD/architecture/ROADMAP.md ve STORE_LISTING.md kaldırıldı. Mağaza metinleri aşağıda
korundu. APK/AAB/IPA ignore kontrolü geçti; pubspec.lock artık izlenebilir.
Kökteki halen-release.apk silme komutu araç politikasıyla reddedildi: dosya diskte
duruyor fakat Git dışında. Bu nedenle H22'nin fiziksel APK temizliği tamamlanmadı.
Silinen takipli belgeler Git geçmişinden geri alınabilir; takip edilmemiş MD içeriğinin
gereksinimleri bu belgede korunur. Boş MD dizinleri Git'te içerik oluşturmaz.

H03 kodu: lib/data/backup_repository.dart deneme tarihini JSON'a yazmıyor ve eski/
değiştirilmiş yedekten okumuyor. Satın alma tablosu import'a dahil edilmiyor.
test/data/backup_repository_test.dart: 5 test geçti; null/2099/eski/sayı trial
alanları süresi bitmiş denemeyi açmıyor, sahte entitlement yok sayılıyor; bozuk kayıt
import'u transaction içinde geri alınıyor. Önce yeni regresyon testi eski kodda
başarısız oldu, düzeltmeden sonra geçti. İki test DB'si ardışık kapatılıp açılarak
bu dosyadaki Drift çoklu-instance uyarısı giderildi; global uyarı kapatılmadı.
H03 UI yerleşimi ve gerçek cihaz import turu henüz doğrulanmadığından DEVAM.

H01 kodu: ortak QuitlineCard, SOS/Ayarlar/18 yaş altı ekranlarında; dil ve ülke
ayrı, kaydedilmiş bölge cihaz bölgesinden öncelikli, bilinmeyen bölge telefon
uydurmuyor. Destek düğmeleri yeşil/48dp; tel başarısızsa numara ve kopyala korunur.
H01'e ait 13 test: TR/EN/DE, US/DE/TR bölgesi, bölgesiz İngilizce, UK bölge seçimi,
kalıcılık ve 320dp/%150 yazı/açık-koyu tema. Genel test turu: **310 test geçti**;
flutter analyze --fatal-infos temiz. Diğer görsel test dosyalarında Drift çoklu
instance uyarıları sürüyor (H23); test başarısı bunları çözmüş sayılmaz.
Görsel yakalamada bazı düğme metinleri raster çıktıda aralıklı görünmedi; aynı test
ayrı süreçte bazen doğru çıktı, ek frame ilerletmek de tüm çıktıları düzeltmedi.
Bu nedenle screenshots/quitline-* dosyaları tanı amaçlıdır, onaylı golden/store
görseli olarak commit edilmez. Widget ağaç/layout kontrolleri geçse de raster/native
inceleme AÇIK; gerçek cihaz hatası veya tamamen çözüldü diye etiketlenmez.
Gerçek Android/iOS çevirici testi henüz yok; H01 bu nedenle DOĞRULANDI değildir.
H03/H22 önceki commit/push: b1c256634fd71c2966bbbbd1bdb77046fd61d189;
HEAD ve origin/master hash'leri eşleşti. H01 yalnız kendi localization/index
hunk'larıyla commit edilir; önceki About/metin değişiklikleri bu commit'e alınmaz.

## 5. Resmi kaynaklar

16 Eylül 2026 tarihinde kontrol edilen politika sayfaları:
- Apple App Review: https://developer.apple.com/app-store/review/guidelines/
  (4.5.4 bildirim izni; 3.1.1 IAP; 2.5.18 reklam; 1.4 sağlık)
- Google Ads: https://support.google.com/googleplay/android-developer/answer/9857753
  (beklenmedik tam ekran reklam ve splash öncesi video sınırı)

Yayın aşamasında yeniden incelenecek diğer kaynaklar:
- Play ödeme güvenliği: https://developer.android.com/google/play/billing/security
- Health declaration: https://support.google.com/googleplay/android-developer/answer/14738291
- App privacy: https://developer.apple.com/app-store/app-privacy-details/
- GPL tam metin: https://www.gnu.org/licenses/gpl-3.0.html
- WHO bırakma: https://www.who.int/news-room/questions-and-answers/item/tobacco-health-benefits-of-smoking-cessation
- NCI yoksunluk: https://www.cancer.gov/about-cancer/causes-prevention/risk/tobacco/withdrawal-fact-sheet

## 6. Mağaza metinlerinin taşınan taslağı

Aşağıdaki metin önceki STORE_LISTING.md içeriğidir; H25 tamamlanmadan YAYINLANMAZ.
Eski yaş dereceleri, telefonlar, kanıt düzeyleri, widget ve abonelik iddiaları doğrulanmış
kabul edilmez. Bu ek yalnız mevcut metni kaybetmeden tek belgeye taşımak içindir.

# Halen — Store Listing Copy (EN / TR / DE)

Kategori: Health & Fitness · Apple yaş derecesi: 12+ · Google: Teen 13+
Fiyat: ücretsiz indirme; Premium ürünleri mağaza konsolunda yapılandırılır:
aylık, yıllık (deneme varsa mağaza koşullarıyla) ve ömür boyu seçenekleri.
Hesap yok. Bu sürümde reklam SDK'sı yok;
reklamlı ücretsiz yüzey ancak ayrıca izin/consent ve mağaza beyanları tamamlandıktan
sonra açılabilir.

---

## English (US/UK)

**Title:** Halen: Quit Smoking Tracker
**Subtitle (30):** Reduce at your pace. Quit for good.

**Description:**

Quit smoking by cutting down first — with a plan that recalculates itself
instead of punishing you.

Halen is a private, on-device quit-smoking companion:

• ONE-TAP LOGGING — a single big button, home widget, quick-settings tile or
  lock-screen control. Logging takes a second, so you keep doing it.
• ADAPTIVE REDUCTION PLAN — the daily budget shrinks step by step. Went over
  today? Halen just says "we recalculated" and spreads the rest of the day.
  No red. No guilt.
• HONEST NUMBERS — modelled nicotine, carbon monoxide and particle load
  curves built from your own timestamps, always labelled as models. Every
  formula is published inside the app: "How is this calculated?"
• TWO SIMPLE SCORES — a Progress Score for what you are doing, and a Harm
  Load for what your body is carrying. Both show their full workings; the
  load falls as you cut down.
• CRAVING WINDOW — Halen learns the hours you usually reach for one, tells
  you what has actually worked for you before, and can give you a heads-up
  twenty minutes ahead (off by default).
• HEALTH TIMELINE — WHO-based milestones, from 20 minutes to 15 years, plus
  a body map where every harm card ships a recovery card.
• MEDICINES THAT WORK — the thing most quit apps leave out. What nicotine
  replacement, varenicline and bupropion actually do, how they are used, the
  mistake that wastes them, and their published effect sizes. No brands, no
  doses, no sales — just what to ask a pharmacist.
• A DATE, AND A PLAN FOR IT — set a quit date, count down to it, and get the
  first day hour by hour. A plan for your own high-risk moments, written
  before you are in one.
• ONE SLIP IS NOT THE END — Halen names what happened and tells you the next
  move. No blame, but no silence either.
• CRAVING SOS — one toolkit, every technique graded by evidence: a
  five-minute walk and paced breathing (strong), delay and water
  (promising), ear acupressure (traditional, needle-free, and we say plainly
  that the long-term evidence is not there). "I resisted" counts your wins;
  "I smoked" logs and adapts — no shame.
• YOUR DATA STAYS YOURS — no account, no server, no analytics. Encrypted on
  device, excluded from backups, export anytime.
• FREE FOREVER TIER — unlimited logging, savings, day counter, 7-day chart
  and export. Premium (monthly, annual or one-time lifetime) unlocks the
  adaptive plan, full charts, trigger patterns, the complete timeline and SOS
  toolkit.

This app is not medical advice. For the treatment of nicotine dependence,
consult a health professional. If you are pregnant, or have a heart condition
or a psychiatric condition, seek expert advice first.

Support lines: US 1-800-QUIT-NOW · UK NHS smokefree · TR Yeşilay 176 ·
DE BZgA.

**Keywords (100):** quit smoking,stop smoking,smoking cessation,quit
nicotine,cigarette tracker,smoking reduction,taper,days since,no
subscription,money saved,quit meter,craving,health timeline

---

## Türkçe (TR)

**Başlık:** Halen: Sigara Bırakma Sayacı
**Alt başlık (30):** Kendi hızında azalt, kalıcı bırak.

**Açıklama:**

Önce azaltarak bırak — seni cezalandırmayan, kendini yeniden hesaplayan bir
planla.

Halen tamamen cihazında çalışan, özel bir sigara bırakma yardımcısı:

• TEK DOKUNUŞLA KAYIT — tek büyük buton, ana ekran widget'ı, hızlı ayarlar
  kutusu ya da kilit ekranı. Kayıt bir saniye sürer, o yüzden devam eder.
• KENDİNİ YENİDEN HESAPLAYAN AZALTMA PLANI — günlük bütçe adım adım azalır.
  Bugün aştın mı? Halen sadece "yeniden hesapladık" der ve kalanını güne
  dağıtır. Kırmızı yok, suçlama yok.
• DÜRÜST SAYILAR — kendi kayıtlarından hesaplanan nikotin, karbonmonoksit
  ve partikül yükü eğrileri; hepsi "model" etiketiyle. Her formül uygulama
  içinde yayımlanır: "Bu nasıl hesaplandı?"
• İKİ BASİT PUAN — ne yaptığını gösteren İlerleme Puanı, vücudunun ne
  taşıdığını gösteren Zarar Yükü. İkisi de hesabını açar; azalttıkça yük
  düşer.
• KRİZ PENCERESİ — Halen genelde hangi saatlerde sigaraya uzandığını öğrenir,
  sende daha önce neyin işe yaradığını söyler ve istersen yirmi dakika önce
  haber verir (varsayılan kapalı).
• SAĞLIK ZAMAN ÇİZELGESİ — WHO kaynaklı dönüm noktaları (20 dakikadan 15
  yıla) ve her zarar kartının yanında iyileşme kartı olan organ haritası.
• İŞE YARAYAN İLAÇLAR — çoğu bırakma uygulamasının atladığı şey. Nikotin
  replasmanı, vareniklin ve bupropion gerçekte ne yapar, nasıl kullanılır, en
  sık hangi hata boşa harcar ve yayımlanmış etki büyüklükleri nedir. Marka
  yok, doz yok, satış yok — eczacına ne soracağın var.
• BİR TARİH VE ONA GÖRE PLAN — bırakma tarihi belirle, geri sayımını gör,
  ilk günü saat saat al. Kendi zor anların için, içine düşmeden önce
  yazılmış bir plan.
• BİR KAYMA SONUN DEĞİL — Halen ne olduğunu adlandırır ve bir sonraki hamleyi
  söyler. Suçlama yok, ama sessizlik de yok.
• İSTEK SOS — tek araç seti, her tekniğin kanıt derecesiyle: 5 dakikalık
  yürüyüş ve tempolu nefes (güçlü), erteleme ve su (umut verici), kulak
  akupresürü (geleneksel, iğnesiz — ve uzun vadeli kanıtının olmadığını
  açıkça söyleriz). "Atlattım" kazanç sayar; "İçtim" kaydeder ve plan
  uyarlanır — utanç yok.
• VERİN SENDE KALIR — hesap yok, sunucu yok, analiz yok. Cihazda şifreli,
  yedeklerden hariç, istediğinde dışa aktar.
• SONSUZA DEK ÜCRETSİZ — sınırsız kayıt, tasarruf, gün sayacı, 7 günlük
  grafik ve dışa aktarma ücretsiz. Premium (aylık, yıllık veya tek seferlik
  ömür boyu) dinamik planı, tam grafikleri, tetikleyici desenlerini, tam
  çizelgeyi ve SOS setini açar.

Bu uygulama tıbbi tavsiye değildir; nikotin bağımlılığının tedavisi için bir
sağlık profesyoneline başvurun. Hamilelik, kalp rahatsızlığı ve psikiyatrik
durumlarda önce uzman görüşü alın.

Destek hattı: Yeşilay 176

**Anahtar kelimeler:** sigara bırakma,sigara sayacı,sigara azaltma,bırakma
yardımcısı,sigara tasarruf,istek atlatma,sağlık takip,tek seferlik

---

## Deutsch (DE/AT)

**Titel:** Halen: Rauchfrei-Tracker
**Untertitel (30):** Reduziere im Tempo. Hör für immer auf.

**Beschreibung:**

Mit dem Rauchen aufhören, indem du zuerst reduzierst — mit einem Plan, der
sich neu berechnet, statt dich zu bestrafen.

Halen ist ein privater Begleiter, komplett auf deinem Gerät:

• EIN-TIPP-EINTRAG — ein großer Button, Home-Screen-Widget, Schnelleinstellungen
  oder Sperrbildschirm-Steuerung. Eintragen dauert eine Sekunde.
• ADAPTIVER REDUKTIONSPLAN — das Tagesbudget sinkt Schritt für Schritt. Heute
  drüber? Halen sagt nur „Wir haben neu berechnet" und verteilt den Rest des
  Tages. Kein Rot. Kein schlechtes Gewissen.
• EHRLICHE ZAHLEN — Kurven für Nikotin, Kohlenmonoxid und Partikellast, aus
  deinen eigenen Einträgen berechnet und immer als Modell gekennzeichnet.
  Jede Formel steht in der App: „Wie wird das berechnet?"
• ZWEI EINFACHE WERTE — ein Fortschrittswert für dein Verhalten und eine
  Schadenslast für das, was dein Körper trägt. Beide zeigen ihre Rechnung;
  die Last sinkt, wenn du reduzierst.
• VERLANGENSFENSTER — Halen lernt deine typischen Stunden, nennt dir, was
  bei dir schon funktioniert hat, und meldet sich auf Wunsch zwanzig Minuten
  vorher (standardmäßig aus).
• GESUNDHEITS-ZEITSTRAHL — WHO-basierte Meilensteine von 20 Minuten bis
  15 Jahre, dazu eine Körperkarte, auf der zu jedem Schaden die Erholung steht.
• MEDIKAMENTE, DIE WIRKEN — das, was die meisten Apps weglassen. Was
  Nikotinersatz, Vareniclin und Bupropion tatsächlich tun, wie sie angewendet
  werden, welcher Fehler sie verschenkt, und ihre publizierten Effektstärken.
  Keine Marken, keine Dosierungen, kein Verkauf.
• EIN DATUM UND EIN PLAN DAFÜR — Rauchstopp-Datum setzen, herunterzählen,
  den ersten Tag Stunde für Stunde. Ein Plan für deine eigenen Risikomomente.
• EIN AUSRUTSCHER IST NICHT DAS ENDE — Halen benennt, was passiert ist, und
  nennt den nächsten Schritt. Kein Vorwurf, aber auch kein Schweigen.
• CRAVING-SOS — ein Werkzeugkasten, jede Technik mit Evidenzgrad: fünf
  Minuten gehen und langsames Atmen (stark), warten und Wasser
  (vielversprechend), Ohr-Akupressur (traditionell, ohne Nadeln — und wir
  sagen klar, dass der Langzeitnutzen nicht belegt ist). „Widerstanden" zählt
  deine Erfolge; „Geraucht" trägt ein und passt sich an — ohne Scham.
• DEINE DATEN BLEIBEN DEINE — kein Konto, kein Server, keine Analyse.
  Verschlüsselt auf dem Gerät, von Backups ausgeschlossen, jederzeit
  exportierbar.
• FÜR IMMER KOSTENLOS — unbegrenzte Einträge, Ersparnis, Tageszähler,
  7-Tage-Chart und Export. Premium (monatlich, jährlich oder einmalig auf
  Lebenszeit) schaltet Plan, alle Charts, Trigger-Muster, die volle Zeitachse
  und das SOS-Set frei.

Diese App ist keine medizinische Beratung. Zur Behandlung der
Nikotinabhängigkeit sprich mit einer Fachkraft. Bei Schwangerschaft,
Herzerkrankung oder psychiatrischen Erkrankungen zuerst fachlich beraten
lassen.

**Keywords:** rauchstopfen,mit dem rauchen aufhören,rauchen aufhören
app,nikotin verzichten,raucher entwöhnung,zigaretten tracker,sparen
rauchen,premium plan,lebenslanger zugang
