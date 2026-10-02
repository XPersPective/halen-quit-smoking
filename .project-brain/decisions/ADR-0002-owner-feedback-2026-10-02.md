# ADR-0002 — Sahip geri bildirimi (2026-10-02, gerçek cihaz testi) ve uygulama planı

Kaynak: sahibin dahili testte (Android, Play Billing test kartı) yaptığı elle deneme. Bu belge istekleri,
kök-neden analizini ve önerileri içerir. Görevler: PB-040…PB-055. Android 1.3.1 (4) Play üretim
incelemesinde; bu iş **1.4.0** olacak.

## A. Sahibin istekleri
1. Acil/destek hatları: dil değişince Türkiye'de kalıyor. Ülke arama kutulu açılır liste, kalıcı kayıt,
   cihazdan bölge okunabiliyorsa otomatik; yoksa varsayılan Türkiye OLMASIN, alfabetik liste.
2. Tam çok dillilik: Play'in desteklediği ~73 dilde ARAYÜZ + mağaza metinleri + mağaza ekran görüntüleri.
3. Geçmiş harcama: "10 yıl, günde 20 (1 paket)" → ömür boyu toplam para, son 1 yıl, hafta/ay/yıl/tüm
   zamanlar grafikleri, sigaraya harcanan süre. Ana ekrana yakın. Yerel para birimi ⇒ ülke sorulmalı
   (ülke aynı zamanda destek hattını belirler).
4. İlerleme puanı / tasarruf / vücut yükü HATALI: yeni girişte "78 güçlü", ardışık 4 sigara sonrası
   "tasarruf 78 TL", nikotin %100, CO %66 (dayanağı belirsiz). Beklenen: kullanıcının BEYAN ettiği içme
   düzenine (günlük adet + aralık) göre taban çizgisi; beyanla tutarsız girişler ölçülüp uyarlanır; ilk
   beyan ile gerçek farklı renkte; zamanla ortalama oturur.
5. Beyan tutarlılığı: 20 adet + "yarım saatte bir" ⇒ 28+ adet eder → çelişki; uygulama fark edip
   düzeltmeli/sormalı. 17 hedef varken 4 ardışık sigara hemen "güçlü" demesin.
6. Canlı yenileme: uygulama açıkken zaman akıyor mu? Grafikler kendiliğinden güncellenmeli.
7. "Psikolojik durum: sakin" — dayanağı yok; bugün içilen sigara ve bugünün parası öncelikli.
8. Bugünün grafiği + tek sigara fiyatı + bugün harcanan; hafta/ay/yıl/tüm zamanlar harcama (EN ÜSTTE
   "tüm zamanlar").
9. Çevre kartı uydurma: "1795 izmarit doğaya karışmadı", "0.0 ağaç" — girdiden türetilmeyen iddialar.
   Kaldır ya da dürüst/hesaplanabilir yap; bağış yönlendirmesi ülkeye göre (TEMA yalnız TR);
   uluslararası kabul gören kuruluşlar.
10. Kullanım kolaylığı: günlük veri girişi ana sayfada; sigara içildiği anda hemen altında hızlı takip
    (his/tetikleyici) — iç sayfalara gömme.
11. Pro: eski paketler + toplam; yeni paket alındığında anında girilebilmeli (içtim butonu gibi).
12. Ödeme: satın alma sonrası sayfa YENİLENMİYOR. Premium'dayken üstte "Halen Premium'a sahipsiniz";
    satın alma kartı kalkmalı. Otomatik yenileme.
13. Premium vaatleri denetimi: widget özelleştirme nerede? Plan/tam grafik/saatlik desen/tetikleyici/
    tam SOS gerçekten var ve 7 gün sonra kapanıyor mu? "%100 yerel gizlilik/şifreli kasa" ücretsizde de
    var → Premium vaadi DEĞİL; kaldır. Reklam kaldırma vaadi ekle.
14. Reklam: alt gezinme çubuğunun hemen üstünde küçük banner; ilk 7 gün YOK; Premium'da yok.
15. Şablon: GitHub'daki napp_app_template'ten "Diğer uygulamalarım" (JSON'dan), puanla/paylaş/lisans.
    Alt çubuğa yeni sekme. Play linki yerel dil/ülkeye uygun açılmalı (hl/gl).
16. Açık kaynak olduğu vurgulansın (Hakkında'da var; Pro/Premium sayfasından erişilebilirlik kontrol).
17. Eleştirel görsel inceleme → yapılacaklar → uygula. Çıktı "üretim düzeyi, harika arayüz".

## B. Analiz — kök nedenler (kodda DOĞRULANDI)
- `record_repository.dart: recomputeDailySummary`: `avoided = expected − count` GÜN BİTMEDEN hesaplanıyor
  (expected = o günün plan hedefi veya onboarding cpd). 17 hedefle 4 sigaradan sonra avoided=13 →
  "13 sigara parası kazandın" (78 TL). Doğrusu: yalnız TAMAMLANMIŞ günler; bugün için pro-rata
  (uyanık süre oranı) ya da "devam ediyor" etiketi. Kıyas ölçüsü plan hedefi değil BASELINE olmalı
  (tasarruf = baseline − gerçek).
- `module_providers.dart: indicesProvider` + `progress_index.dart`:
  * adherence: count<=hedef ⇒ 1.0 — gün yarıda iken 4/17 "mükemmel uyum".
  * trend = 1 − recentCpd/baselineCpd; recentCpd bugünün KISMİ sayısını da ortalamaya katıyor
    (1. gün: 4/20 ⇒ %80 düşüş ⇒ 24 puan).
  * cravingCoping kayıt yoksa 0.5 (10 bedava puan); loggingConsistency payda=summaries.length (1 gün ⇒
    %100 ⇒ 10 bedava puan); nicotineBaselineFall ilk günde yüksek.
  ÇÖZÜM: puan ancak ≥3 tamamlanmış günde; öncesinde "Kalibrasyon N/3" göster.
- Burst (ardışık/hızlı) giriş modellenmiyor: 1 dakikada 4 sigara = kısa sürede 4× doz. Nikotin yükü
  (`nicotine_model.dart`, `body_load_model.dart`) t½ ile birikiyor; yüzde normalizasyonunun referansı
  ("%100") ve CO "%66" etiketinin ölçeği/kaynağı açık değil → incele; referans = kullanıcının beyan ettiği
  düzenin steady-state tepe değeri olmalı, tavan değil.
- Beyan tutarlılığı: onboarding günlük adet ve aralık ayrı soruyor; çapraz doğrulama yok. Uyanık süre ≈ 16 sa
  ⇒ ortalama aralık = 960/adet dk. Beyan edilen aralık bunun ±%40'ı dışında ise sor/uyar.
- Çevre: `environment_impact.dart` sabit katsayı × `avoided` (yanlış) ⇒ anlamsız; "izmarit doğaya
  karışmadı" dayanaksız.
- Ülke: `quitline_card.dart` yalnız TR/US/DE/GB; cihaz bölgesi dışında arama yok; para birimi/ülke
  onboarding'de sorulmuyor (yalnız dil).
- Paywall: `paywall_screen.dart` satın alma sonrası yalnız invalidate; sonuç `purchaseStream` ile
  geliyor ⇒ UI DB/akış değişimini dinlemeli (watch) ve sahip durumunu göstermeli.
- Premium listesi (`paywallFeature*`): son madde ("%100 yerel gizlilik") ücretsizde de geçerli ⇒ kaldır.
  Her vaat için gating matrisi testi.

## C. Önerilerim
1. **Kalibrasyon ilkesi**: türetilmiş hiçbir sayı ilk 3 tamamlanmış günden önce "başarı" izlenimi vermesin;
   beyana dayalı tahminler "beyanına göre" etiketli.
2. **Ana ekran**: (a) bugün: içilen, harcanan, son sigaradan geçen süre, sonraki hedef; (b) "tüm zamanlar"
   harcama + "bırakırsam 1 yılda"; (c) bugünün 24-saat grafiği (beyan gri, gerçek renkli);
   (d) "içtim" sonrası altta takip kartı; (e) paket aldım butonu.
3. **Beyan çelişkisi diyaloğu**: "20 adet ve yarım saatte bir tutmuyor — hangisi doğru?"
4. **Ülke onboarding'de** (cihazdan ön-seçili, değiştirilebilir): para birimi, hatlar, bağış önerileri,
   fiyat biçimi tek kaynaktan.
5. **Tarihsel maliyet**: yıl × adet × güncel fiyat, "yaklaşık" etiketi; yıllara bölünmüş grafik; zaman =
   adet × ~5 dk (kaynaklı sabit) ⇒ gün/saat.
6. **Çevre kartı**: kaldır ya da yalnız tamamlanmış günlerin `kaçınılan` adedi × yayımlanmış katsayı
   (kaynaklı); "doğaya kazandırma" dilini bırak. Bağış: ülkeye göre kuruluşlar, yalnız link.
7. **Çeviri stratejisi**: 73 dil × ~1.1 bin anahtar. `tool/i18n/` altında kaynak=en ARB + sözlük + yer
   tutucu/ICU doğrulayıcı betik; kademeli yayın (önce en büyük ~25 dil, sonra kalan); sağlık iddiası
   metinlerinde çeviri uyarısı; RTL (ar, he, fa, ur) ayrı görsel denetim; CJK/Arapça/Hint yazı
   tipi yedekleri (boyut etkisi ölçülmeli); mağaza görselleri aynı hat (`STORE_LOCALE`).
8. **Premium gating matrisi** + 7. gün sonrası "kilitli önizleme".
9. **Diğer uygulamalar sekmesi**: ağ yalnız bu sekmede, kullanıcı tetiklemeli, önbellekli;
   gizlilik politikası + Data Safety güncellemesi (GitHub raw JSON isteği).
10. **Reklam**: alt çubuğun üstünde sabit adaptive banner (≤50dp); SOS/ödeme/ilk 7 gün/premium'da yok.

## D. Uygulama sırası
1. PB-044 hesap/istatistik düzeltmeleri → PB-046 canlı yenileme
2. PB-043 tarihsel harcama + ana ekran → PB-048 ana ekran/anlık takip → PB-053 paketler
3. PB-049 paywall + PB-050 reklam yerleşimi
4. PB-042 ülke → PB-040 hatlar → PB-047 çevre/bağış
5. PB-051 şablon sekmesi
6. PB-041 çok dillilik + PB-052 mağaza dilleri/görselleri
7. PB-054 eleştirel görsel tur → düzeltmeler → PB-055 1.4.0 yayın
