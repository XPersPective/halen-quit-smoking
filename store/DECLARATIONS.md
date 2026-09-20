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

Analiz / çökme / reklam SDK'sı YOK (kaynak: pubspec.yaml + AndroidManifest
denetimi 2026-09-20). Reklam SDK'sı gelecekte eklenirse: bu belge +
PRIVACY_POLICY.md + App Privacy beyanı yenilenmeden yayın yapılmaz (T21 [!]).

### iOS (PrivacyInfo.xcprivacy)
- NSPrivacyTracking: false; TrackingDomains: boş; CollectedDataTypes: boş.
- Accessed APIs: UserDefaults (CA92.1) — yalnız uygulamanın kendi ayarları.

### Veri depolama
- Tüm kişisel veri cihazda, SQLCipher ile şifreli SQLite (brain §3).
- Sunucu, hesap, analiz yok. Ağ erişimi: yalnız mağaza IAP/restore çağrıları
  (in_app_purchase eklentisi) — kullanıcı tetiklemeli veya mağaza kontrolü.

## 2. Apple App Privacy beyanı (taslak)
- Data Not Collected: uygulama herhangi bir veriyi sunucuya iletmez.
- Tracking: yok. (IAP, tracking değildir; mağaza işlemi kullanıcı ile mağaza
  arasındadır.)
- Contact Info / Health / Location / Identifiers / Usage Data: toplanmıyor.

## 3. Google Play Data Safety (taslak)
- Data collected: yok (kendi cihazında işlenen veriler "collected" sayılmaz).
- Data shared: yok.
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
