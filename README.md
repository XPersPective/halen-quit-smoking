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

- **Veri:** 13 tablo (rapor §25), `halen.db`, SQLCipher şifreli; anahtar
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
- **Nikotin modeli:** sigara başına 1,2 mg emilim varsayımı; plazma vekil
  eğrisi `C(t) = Σ d·2^(−Δt/2h)`; UI yalnızca 0–100 normalize "tahmini
  maruziyet" gösterir; her S3 göstergede "?" → şeffaflık ekranı.
- **Health timeline:** WHO metinleri (rapor §17) birebir; azaltma modunda
  bırakma günü belirlenene dek "önizleme" kilitli.
- **Craving SOS:** 2 dk sayaç + 4D kartlar + 60 sn kutu nefesi +
  "İzle ve bekle"; "Atlattım" pozitif sayaç, "İçtim" kayıt + yeniden hesap,
  utanç dili yok; sabit NRT satırı.
- **Bildirimler:** yoğunluk Sakin/Standart/Yoğun + tam kapatma; plan-saati
  hatırlatması varsayılan KAPALI; tam saat yalnız kullanıcı opt-in'i ile
  (USE_EXACT_ALARM bildirilmez); reboot sonrası yeniden planlama.
- **Widget + hızlı kayıt:** iOS 17+ interaktif widget + iOS 18 ControlWidget
  (App Intent, uygulama açılmadan App Group'a yazar), Android AppWidget + QS
  tile + bildirim aksiyonu; hepsi `source` etiketiyle kaydeder.
- **Satın alma:** tek seferlik "Halen Lifetime" (StoreKit 2 / Play Billing);
  her cold start'ta mağaza doğrulaması; pending hak vermez; iade/revocation
  hakkı düşürür. İlk açılışta kartsız 7 gün premium deneme.

## Testler

`flutter test` — plan motoru, nikotin modeli, tasarruf, tetikleyici
istatistiği (n≥10 sessizlik), streak, health timeline aritmetiği, entitlement
mantığı, veri katmanı (13 tablo, backup round-trip) ve widget testleri
(onboarding, kayıt akışı, paywall görünürlüğü, SOS, timeline).
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
