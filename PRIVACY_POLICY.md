# Halen: Quit Smoking Tracker — Gizlilik Politikası

**Son güncelleme: 7 Eylül 2026**

## Türkçe

### Özet
Halen hesap istemez ve kendi uygulama sunucusunu kullanmaz. Bu kaynak sürümünde
analiz/reklam SDK'sı bulunmaz. Tüm verileriniz yalnızca cihazınızda saklanır ve
şifrelidir. Uygulama kendi verilerinizi ilk açılışta ağa göndermez; Premium
ürünlerin fiyatı, satın alma durumu, abonelik yenilemesi ve restore işlemleri
App Store / Google Play tarafından yürütülür.

### Toplanan veri: hiçbiri
- Sigara/istek kayıtları, profil cevaplarınız (yaş grubu, günlük sayı, paket
  fiyatı vb.), plan ve tasarruf hesapları **yalnızca cihazınızda** tutulur.
- Analiz, çökme bildirimi ve reklam SDK'sı yoktur. Gelecekte reklam SDK'sı
  etkinleştirilirse bu politika, sağlayıcı ve consent akışı yayınlanmadan önce
  güncellenir; sağlık/nikotin verisi reklam hedeflemesine gönderilmez.
- Konum, kişiler, mikrofon, kamera (bu sürümde barkod tarama yok) kullanılmaz.

### Depolama ve şifreleme
- Veritabanı (`halen.db`) SQLCipher ile şifrelenir; anahtar Android
  Keystore / iOS Keychain'de saklanır.
- Veritabanı klasörü bulut yedeklemesinden ve cihazlar arası transferden
  hariç tutulur (iOS `isExcludedFromBackup`, Android `dataExtractionRules`).
- Verilerinizi yine de dilediğiniz an JSON olarak dışa aktarabilirsiniz
  (Ayarlar → Veriniz). Bu dosyanın kaderi tamamen size aittir; uygulama
  hiçbir yüklemeye katılmaz.

### Bildirimler
Plan hatırlatmaları, günlük özet ve kriz destek bildirimleri cihaz üzerinde
planlanır; içeriği sunucudan gelmez. Android 13+ için bildirim izni sizin
onayınıza sunulur.

### Haklarınız (GDPR / KVKK)
Veriler cihazınızda ve yalnızca sizin kontrolünüzde olduğundan: erişim,
düzeltme, silme (Ayarlar → Tüm verileri sil) ve taşınabilirlik (JSON dışa
aktarım) haklarınız uygulama içinde doğrudan kullanılabilir durumdadır.
İşleme hakkındaki sorularınız ve destek için: [GitHub Issues](https://github.com/XPersPective/halen-quit-smoking/issues)

---

## English

### Summary
Halen requires no account and has no application server. This source build
contains no analytics or ad SDKs. Your data stays on your device, encrypted.
Premium product pricing, purchase state, subscription renewal and restore are
handled by the App Store / Google Play.

### Data collected: none
- Cigarette/craving logs, your onboarding answers (age band, daily count,
  pack price, etc.), plan and savings calculations are stored **on your
  device only**.
- No analytics, crash reporting or ad SDKs. If an ad SDK is enabled in a future
  release, this policy and the consent flow are updated before publication;
  health/nicotine data is not used for ad targeting.
- No location, contacts, microphone, or camera (no barcode scanning in this
  version).

### Storage and encryption
- The database (`halen.db`) is encrypted with SQLCipher; the key is kept in
  the Android Keystore / iOS Keychain.
- The database folder is excluded from cloud backups and device transfer
  (iOS `isExcludedFromBackup`, Android `dataExtractionRules`).
- You can export your data as JSON at any time (Settings → Your data). That
  file is entirely yours; the app never uploads anything.

### Notifications
Plan reminders, the daily summary and craving-support notifications are
scheduled on-device; their content does not come from a server. On Android
13+ the notification permission is requested from you first.

### Your rights (GDPR)
Because your data lives on your device under your control: access,
rectification, erasure (Settings → Delete all data) and portability (JSON
export) are available directly in the app. Questions and support: [GitHub Issues](https://github.com/XPersPective/halen-quit-smoking/issues)

---

## Deutsch

### Zusammenfassung
Halen verlangt kein Konto und hat keinen eigenen App-Server. Diese Quellversion
enthält keine Analyse- oder Werbe-SDKs. Alle Daten bleiben verschlüsselt auf
deinem Gerät. Premium-Preise, Käufe, Verlängerungen und Wiederherstellungen
werden vom App Store bzw. Google Play abgewickelt.

### Gesammelte Daten: keine
- Klick-/Craving-Einträge, deine Antworten im Onboarding (Altersgruppe,
  Tagesmenge, Packungspreis usw.), Plan- und Sparberechnungen bleiben
  **ausschließlich auf deinem Gerät**.
- Keine Analyse-, Absturz- oder Werbe-SDKs. Wird ein Werbe-SDK in einer späteren
  Version aktiviert, werden diese Erklärung und der Consent-Ablauf vor der
  Veröffentlichung aktualisiert; Gesundheits-/Nikotinwerte werden nicht für
  Werbezielgruppen verwendet.
- Kein Standort, keine Kontakte, kein Mikrofon, keine Kamera (in dieser
  Version kein Barcode-Scanning).

### Speicherung und Verschlüsselung
- Die Datenbank (`halen.db`) ist mit SQLCipher verschlüsselt; der
  Schlüssel liegt im Android Keystore bzw. iOS Keychain.
- Der Datenbank-Ordner ist von Cloud-Backups und Geräteübertragung
  ausgeschlossen (iOS `isExcludedFromBackup`, Android `dataExtractionRules`).
- Du kannst deine Daten jederzeit als JSON exportieren (Einstellungen →
  Deine Daten). Diese Datei gehört dir allein; die App lädt nichts hoch.

### Benachrichtigungen
Planerinnerungen, Tageszusammenfassung und Craving-Unterstützung werden auf
dem Gerät geplant; ihre Inhalte kommen nicht von einem Server. Unter Android
13+ wird die Benachrichtigungsberechtigung zuerst von dir angefragt.

### Deine Rechte (DSGVO)
Da deine Daten auf deinem Gerät unter deiner Kontrolle liegen: Auskunft,
Berichtigung, Löschung (Einstellungen → Alle Daten löschen) und
Datenübertragbarkeit (JSON-Export) sind direkt in der App möglich.
Fragen und Support: [GitHub Issues](https://github.com/XPersPective/halen-quit-smoking/issues)
