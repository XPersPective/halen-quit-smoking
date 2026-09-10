# Halen: Quit Smoking Tracker
# Reduce at your pace. Quit for good. — Kendi hızında azalt, kalıcı bırak.

Halen, cihaz üzerinde tamamen yerel çalışan, tek seferlik satın almaya dayalı,
"azaltarak bırakma" odaklı bir sigara bırakma yardımcısıdır. Hesap yok, sunucu
yok, reklam yok, abonelik yok; uygulama ilk açılışta hiçbir ağ çağrısı yapmaz
(tek istisna: mağazadaki tek seferlik satın alma).

## Proje belgeleri

- [`sigara-birakma-app-on-arastirma-ve-urun-raporu.md`](sigara-birakma-app-on-arastirma-ve-urun-raporu.md) — pazar, rakip, bilimsel kanıt, mimari, monetizasyon, ASO (ana rapor).
- [`halen-modul-derin-arastirma-raporu.md`](halen-modul-derin-arastirma-raporu.md) — 14 modülün derin araştırması ve tasarım şartnamesi: vücut yükü (nikotin/CO/katran modelleri), ekonomi, istek–nikotin ilişkisi, kriz kurtarma seti, akciğer ve organ görselleştirmesi, psikolojik durum, yumuşak geçiş motoru, destek/içerik motorları, kayıt animasyonları, program sistemi ve iki indeks (İlerleme Puanı / Zarar Yükü).

## Kurulum

```bash
git clone https://github.com/<you>/halen-quit-smoking.git
cd halen-quit-smoking
flutter pub get
flutter run                     # debug
flutter test                    # birim + widget testleri
flutter analyze                 # 0 issue beklenir
flutter build apk --release     # Android sürüm APK
dart run tool/simulate.dart     # 8 haftalık senaryo simülasyonu (saf Dart)
```

Gereksinim: Flutter (aşağıda geliştirme ortamı kaydı). Android derlemesi
Windows/Linux/macOS üzerinde; iOS derlemesi macOS gerektirir.

### Geliştirme ortamı (kayıt)

`flutter --version`:

```text
Flutter 3.47.2 • channel stable • https://github.com/flutter/flutter.git
Framework • revision d3b14c8769 (2026-08-26 16:07:51 -0700)
Engine • hash 1cf1c4773fb941c4c74a7f8bb144a8837596c0f4
Tools • Dart 3.13.2 • DevTools 2.60.0
```

`flutter doctor` (Windows geliştirme makinesi):

```text
[√] Flutter (Channel stable, 3.47.2, on Microsoft Windows, locale tr-TR)
[√] Windows Version (Windows 11 or higher)
[√] Android toolchain - develop for Android devices (Android SDK 36.1.0-rc1)
[√] Chrome - develop for the web
[√] Visual Studio - develop Windows apps (Visual Studio Community 2022 17.14.38)
[√] Connected device (3 available)
[√] Network resources
• No issues found!
```

## Mimari

`presentation` (UI) → `application` (Riverpod controller'lar) → `domain`
(saf Dart: PlanEngine, NicotineModel, TriggerStats, Savings — %100 test
edilebilir) → `data` (drift DAO'ları, repository'ler, purchase/notification/
widget servisleri). DB reaktifliği drift `watch()` → Riverpod StreamProvider.

- **Veri:** 21 tablo (ana rapor §25 + modül raporu §16b + bırakma denemesi),
  şema v5, `halen.db`,
  SQLCipher şifreli; anahtar
  Android Keystore / iOS Keychain'de. iOS'ta DB klasörü
  `isExcludedFromBackup`; Android'de `dataExtractionRules` ile cloud-backup
  ve device-transfer hariç. "Veri sunucuya gitmez" iddiası bu yüzden teknik
  olarak doğrudur.
- **Plan motoru:** `lib/domain/plan_engine.dart` — günlük bütçe
  `hedef = önceki hafta ort × (1 − haftalık oran)`, saat-histogram
  pencereleri, medyan-gap ±%25 aralığı, her kayıtta dinamik yeniden hesap
  (aşım → dağıt, sıkışma → mesaj, haftalık taşma → %5 yumuşatma), tempo
  adaptasyonu (≥%85 hızlandır önerisi, ≤%55 faz uzatma), günlük bütçe ≤3'te
  son-hafta fazı ve bırakma günü onayı, aralıklı "kaç hafta" tahmini (S3).
- **Vücut yükü modeli:** sigara başına 1,2 mg emilim varsayımı; dört eğri
  `C(t) = Σ d·2^(−Δt/t½)` — nikotin 2 sa, gün boyu zemin 16 sa (kotinin
  karşılığı), karbonmonoksit 4,5 sa, partikül yükü ~30 gün (temsilî). UI
  yalnızca 0–100 normalize "tahmini maruziyet" gösterir; ng/mL veya miligram
  asla üretilmez. Her S3 göstergede "?" → şeffaflık ekranı, ve **her
  göstergenin formülü orada yayımlanmış olmalı** (bunu bir test zorunlu
  kılar).
- **İki indeks:** İlerleme Puanı (davranış; uyum 35 + tüketim eğilimi 30 +
  kriz başa çıkma 20 + kayıt tutarlılığı 10 + nikotin zemini 5, günde en fazla
  ±4 puan, asla sıfırlanmaz) ve Zarar Yükü (kümülatif maruziyet 40 + güncel
  yoğunluk 30 + bağımlılık 15 + yaş/süre 10 + vücut ölçüsü 5; vücut verisi
  isteğe bağlı, girilmezse ağırlıklar yeniden dağıtılır). Zarar Yükü bir
  hastalık riski tahmini değildir ve ekranda böyle yazar.
- **Yumuşak geçiş motoru:** adımda en fazla %15 aralık uzatma, 3 gün + %70
  uyum stabilizasyonu, geri alma yerine adım tekrarı, plan bozulunca son üç
  başarılı günün ortalamasına yumuşak iniş; en kolay saatler önce, uyanınca
  içilen sigara en sona.
- **Health timeline:** WHO metinleri (rapor §17) birebir; azaltma modunda
  bırakma günü belirlenene dek "önizleme" kilitli.
- **Craving SOS:** 2 dk sayaç + **kanıt dereceli tek araç seti** (🟢 5 dk
  yürüyüş ve 6/dk nefes, 🟡 3 dk erteleme ve su, ⚪ kulak akupresürü ve soğuk
  su), kişinin kendi verisine göre sıralanır; rehberli kulak akupresürü
  ekranı (5 NADA noktası, 12'şer saniye, iğnesiz). "Atlattım" pozitif sayaç,
  "İçtim" kayıt + yeniden hesap, utanç dili yok; sabit NRT satırı.
- **Kriz penceresi:** risk = 0,45 × nikotin çukuru + 0,35 × kendi saat
  örüntün + 0,20 × tetikleyici bağlamı; ~21 kayıttan önce sessiz kalır,
  riskli saatte ne yapılacağını söyler; opsiyonel (varsayılan kapalı) 20 dk
  önce hatırlatma.
- **Beden ekranı:** nefes alan akciğer görseli + üç tipik FEV1 senaryosu,
  12 organ kartı (her zarar kartının yanında iyileşme kartı), duman
  kütüphanesi (12 madde, IARC sınıfı ve kaynak).
- **Bildirimler:** yoğunluk Sakin/Standart/Yoğun + tam kapatma; plan-saati
  hatırlatması varsayılan KAPALI; tam saat yalnız kullanıcı opt-in'i ile
  (USE_EXACT_ALARM bildirilmez); reboot sonrası yeniden planlama.
- **Widget + hızlı kayıt:** iOS 17+ interaktif widget + iOS 18 ControlWidget
  (App Intent, uygulama açılmadan App Group'a yazar), Android AppWidget + QS
  tile + bildirim aksiyonu; hepsi `source` etiketiyle kaydeder.
- **Satın alma:** tek seferlik "Halen Lifetime" (StoreKit 2 / Play Billing);
  her cold start'ta mağaza doğrulaması; pending hak vermez; iade/revocation
  hakkı düşürür. İlk açılışta kartsız 7 gün premium deneme.

## Tasarım sistemi

[`HALEN-PREMIUM-BRIEF.md`](HALEN-PREMIUM-BRIEF.md) yönergesine göre kuruldu:

- **Token'lar** — `lib/core/design/tokens.dart`: boşluk ölçeği (4/8/12/16/20/
  24/32/48), üç köşe yarıçapı, gölge reçeteleri, dört hareket süresi. Ekran
  dosyalarında elle yazılmış boşluk sabiti bırakılmadı (`tool/snap_spacing.py`
  ile 445 sabit ölçeğe oturtuldu).
- **Semantik renk rolleri** — `DataRole`: her rengin tek bir anlamı var
  (ilerleme / nikotin / oksijen borcu / zemin / partikül / para / zaman /
  uyarı). **Sağlık verisinde kırmızı kullanılmaz.**
- **Tipografi** — Inter (değişken asıl, SIL OFL 1.1, `assets/fonts/`). Tek
  dosya dört ağırlık altında bildirilir ki motor sahte kalın üretmesin.
  Sayılar tabular rakamlarla çizilir (`.asNumber`): saniyede güncellenen bir
  sayaç yana kaymaz.
- **Tek saat** — `BodyClock` + `BodyPulse`: nefes alan her şey aynı saatten
  fazını alır. Tembel: ekranda nabız yoksa tik atmaz (sürekli çalışan bir
  ticker `pumpAndSettle`'ı kilitler).
- **Bileşenler** — `HalenCard`, `HalenSectionHeader`, `HalenStat`,
  `HalenEmptyState`, `HalenPill`.

## Bırakma programı (klinik iskelet)

- **İlaçlar** — 8 madde (5 NRT formu, kombinasyon, vareniklin, bupropion):
  nasıl çalışır, nasıl kullanılır, en sık yapılan hata, ve yayımlanmış etki
  büyüklüğü **karşılaştırıldığı şeyle birlikte**. Marka yok, doz yok, öneri
  yok; her madde eczacı/hekim yönlendirmesiyle biter.
- **Bırakma tarihi** — azaltma bir güne nişan aldığında işe yarar. Tarih
  taşınabilir (sayılır, azarlanmaz); "üç günden az" ve "altı haftadan uzak"
  notları yalnızca geçerliyken çıkar.
- **Kayma / nüks** — bir sigara kaymadır, denemenin sonu değil. Üç adlandırılmış
  durum, her biri somut bir hamleyle biter; kümelenme ve nüks ilaç önerir.
- **Nüks önleme planı** — kullanıcının kendi tetikleyicilerinden tohumlanır.
- **Destek kişisi** (yalnızca ad; rehber hiç okunmaz), **"tek nefes bile yok"
  kuralı**, **PHQ-2 ruh hâli taraması** (doğrulanmış eşik + yönlendirme, tanı
  değil), **yardım hatları kriz ekranında**.

## Ekran görüntüleri

`screenshots/` — çekirdek ekranlar (01–08), `screenshots/module/` — modül ve
klinik ekranlar, karanlık tema dahil. Hepsi **başsız** üretilir: widget
ağacından, masaüstü oturumu gerektirmeden, bir telefon yüzeyinde. Yenilemek
için:

```bash
flutter test test/widget/design_capture_test.dart --update-goldens --dart-define=CAPTURE_DESIGN=true
```

Define olmadan aynı dosya bir duman testidir: her ekran hata fırlatmadan
çizilmek zorundadır — bu tek başına değerli, çünkü bir ekranın çizilirken
patlaması testlerin geri kalanından kaçabiliyor.

Önceki 17 ekranlık masaüstü turu silindi: fare betiğiyle tek bir Windows
makinesinde alınmıştı, 1600×900 pencere çerçevesi içeriyordu ve modül
öncesi bir uygulamayı gösteriyordu. Yanıltıcı bir görsel, eksik bir
görselden kötüdür.

## Yayına hazırlık

**İkon ve açılış ekranı.** Her iki platformun ikonu `tool/make_icon.py` ile
uygulamanın kendi gösterge yayından üretiliyor (Android adaptive + monokrom,
iOS'un asset kataloğundaki her slot, 1024'lük mağaza görseli). iOS ikonları
alfa kanalsız ve köşesiz yazılır — iOS kendi maskesini uygular, kendi kendini
yuvarlayan bir ikon iki kez yuvarlanır.

**İmzalama.** `android/key.properties` varsa release derlemesi yükleme
anahtarıyla imzalanır; yoksa debug anahtarına düşer, böylece temiz bir klonda
`flutter build apk --release` çalışmaya devam eder. Debug imzalı APK test için
kurulur ama Play tarafından reddedilir — doğru hata modu bu: kazara
yayımlanamaz.

```bash
keytool -genkey -v -keystore ~/halen-upload.jks -keyalg RSA         -keysize 2048 -validity 10000 -alias halen
```

Sonra `android/key.properties` (git'e girmez):

```properties
storeFile=/mutlak/yol/halen-upload.jks
storePassword=...
keyAlias=halen
keyPassword=...
```

Bu keystore kaybolursa uygulamayı Play'de **güncelleme yeteneği kaybolur**;
yeri parola yöneticisidir, bu depo değil.

## Testler

`flutter test` — 259 test: plan motoru, nikotin modeli, tasarruf, tetikleyici
istatistiği (n≥10 sessizlik), streak, health timeline aritmetiği, entitlement
mantığı, bırakma denemesi (tarih penceresi, kayma/nüks sınıflaması, PHQ-2,
ilaç kanıt tablosu, kilometre taşı geçişleri), veri katmanı (backup
round-trip) ve widget testleri (onboarding, kayıt akışı, paywall
görünürlüğü, SOS, timeline, bırakma planı, ilaçlar).

Her push'ta GitHub Actions `flutter analyze --fatal-infos`, testler ve
**üretilmiş kodun güncelliği** (build_runner + gen-l10n sonrası `git diff`
boş olmalı) koşar.
`test/forbidden_strings_test.dart` yasak iddia ifadelerini ("tedavi eder",
"garanti", "detoks", "kanındaki gerçek", "ölçüldü" ve EN/DE eşdeğerlerini)
kaynak ve ARB dosyalarında engeller.

## Karar Günlüğü

Spesifikasyonun belirsiz kaldığı noktalarda alınan kararlar ve gerekçeleri:

1. **watchSingleOrNull kilitlenmesi (test ortamı):** drift watch
   abonelikleriyle `db.close()` fake-async bölgesinde kilitleniyor. Test
   yardımcısı `disposeApp` ağacı söker (Riverpod abonelikleri iptal) ve
   kapanış öncesi zamanlayıcıları boşaltır. Riverpod 3 scope semantiği
   nedeniyle test override'ları, bağımlılığın yaşadığı scope'a konur
   (paywall_test yorumu).
2. **Widget sayıları:** günlük sabit-zamanlı bildirimler canlı sayı
   taşıyamaz; bildirim gövdeleri genel metin kullanır, sayılar ekranda
   kalır. Widget yüzeyi app'in her kayıtta push ettiği özet metni gösterir.
3. **Health şeridi (azaltma modu):** bırakma günü girilmeden WHOmilestone'u
   "benim saatim" gibi göstermek dürüstlük kuralına (§17) aykırı; BUGÜN
   şeridi "N. günüm" gösterir, milestone sayacı timeline'da bırakma günü
   sonrası açılır.
4. **Uyanma penceresi:** günlük yeniden dağıtım için waking-day bitişi 24:00
   varsayılır (raporda spesifik saat yok); sadeleştirilmiş ve deterministik.
5. **`source=control` iOS'ta:** iOS 18 ControlWidget App Intent'i App Group
   içine kuyruk yazar; ana uygulama resume'da kuyruğu boşaltıp kaydı
   `control` kaynağıyla işaretler (Android tile → `tile`, widget → `widget`,
   bildirim → `notif`).
6. **Barkod tarama (P1) MVP dışı:** rapor §9/§13 gerekçesiyle v1'e alınmadı;
   `CigaretteProduct` tablosu ve manuel marka girişi (onboarding adım 7)
   hazır.
7. **Deneme bitiş kapısı:** gün 7'de otomatik paywall açılmaz; paywall'a
   Plan kilidi + Ayarlar girişinden ulaşılır, gün 5/7 hatırlatma
   bildirimleri NotificationService ile planlanır.

## Sürüm

v1.0.0 — bkz. [CHANGELOG.md](CHANGELOG.md),
[PRIVACY_POLICY.md](PRIVACY_POLICY.md), [STORE_LISTING.md](STORE_LISTING.md).

*Lisans: tüm hakları saklıdır.*
