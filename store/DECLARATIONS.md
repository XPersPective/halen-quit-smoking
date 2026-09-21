# Store Beyan Taslağı (T24) — Halen: Quit Smoking Tracker

> Bu belge, mağaza konsol beyanlarının **koddan türetilmiş taslağıdır**
> (2026-09-20, kod envanteri). Yayın günü App Store Connect / Play Console
> formlarına bu değerler girilir; SDK değişirse bu belge güncellenmek
> ZORUNDADIR. Hukuki nihailik iddia edilmez (brain T24).

## 1. İzin / SDK Envanteri (koddan)

### Android (AndroidManifest.xml)
| İzin | Amaç | Arka plan? |
|---|---|---|
| POST_NOTIFICATIONS | Hatırlatma bildirimleri (kullanıcı tercihine bağlı) | hayır |
| RECEIVE_BOOT_COMPLETED | Cihaz yeniden başladıktan sonra hatırlatmaları yeniden kurmak | Evet (yalnız yeniden planlama) |
| SCHEDULE_EXACT_ALARM | Planlanan hatırlatma saati (kullanıcı seçimi) | — |
| VIBRATE | Bildirim titreşimi | — |

Analiz / çökme SDK'sı YOK. Reklam SDK'sı (Google Mobile Ads / AdMob) VAR —
yalnız deneme bitmiş ücretsiz kullanıcının uygun ekranlarında (Today/İstatistik/Rehber
altı, etiketli medium rectangle); UMP consent akışı olmadan hiçbir reklam
yüklenmez; deneme + Premium'da hiçbir yüzey yok (kaynak: pubspec.yaml +
AndroidManifest denetimi 2026-09-21, Google'ın test birimleri).

### iOS (PrivacyInfo.xcprivacy)
- NSPrivacyTracking: false; TrackingDomains: boş; CollectedDataTypes: boş.
- Accessed APIs: UserDefaults (CA92.1) — yalnız uygulamanın kendi ayarları.

### Veri depolama
- Tüm kişisel veri cihazda, SQLCipher ile şifreli SQLite (brain §3).
- Sunucu, hesap, analiz yok. Ağ erişimi: yalnız mağaza IAP/restore çağrıları
  (in_app_purchase eklentisi) — kullanıcı tetiklemeli veya mağaza kontrolü.

## 2. Apple App Privacy beyanı (taslak)
- Health / Location / Contact Info / Financial Info / Usage Data: toplanmıyor.
- **Identifiers → Device ID, Advertising Data:** ücretsiz kullanıcıda
  deneme sonrası reklamlar için Google AdMob işler ("Data Not Linked to
  You", Advertising Purpose); UMP consent zorunlu. Premium/deneme: toplanmıyor.
- Tracking: yok (ATT istenmez; UMP yönetiminde, profil oluşturma yok).
- Not: beyan, AdMob SDK sürümü ve birim türüne göre yayın günü yenilenir.

## 3. Google Play Data Safety (taslak)
- Data collected: yok (kendi cihazında işlenen veriler "collected" sayılmaz);
  **reklam için cihaz tanımlayıcıları AdMob tarafından işlenir** — Data
  Safety formunda "Device or other IDs → Advertising" beyan edilir.
- Data shared: yok (veriler üçüncü tarafa satılmaz; AdMob reklam sunumu
  formda ayrıca beyan edilir).
- Security practices: Data encrypted in transit → mağaza IAP hariç uygulama
  ağı kullanmaz; "users can request data deletion" → uygulama içi
  Ayarlar → Verilerin → Tüm verileri sil (backup_repository.wipe).
- Target audience: 18+ (nikotin bağımlılığı desteği; çocuklara hedeflenmez).
- Health category beyanı: uygulama klinik ölçüm/tanı sunmaz; genel eğitim ve
  davranış izleme içerir (brain §1 kısıtları).

## 4. Destek / gizlilik URL'leri
github.com/XPersPective/halen-quit-smoking (repo, LICENSE, PRIVACY_POLICY.md,
issues). **Ön koşul: T19.1 [!] — repo public olmalı** (anonim erişim 2026-09-20
itibarıyla 404).

## 5. İçerik derecelendirme notları
- Bağımlılık bırakma desteği: motivasyonel/davranışsal; tıbbi tedavi talimatı
  yok (makaleler kaynaklı ve sınırlı iddialı — brain AC4).
- Kulak akupresürü içeriği "geleneksel, kanıt düzeyi belirsiz" etiketiyle
  sunulur; iğne kullanımı öğretilmez (T16).
