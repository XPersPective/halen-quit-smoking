# Halen: Quit Smoking Tracker — Gizlilik Politikası

**Son güncelleme: 7 Eylül 2026**

## Türkçe

### Özet
Halen hesap istemez, sunucu kullanmaz, analiz/reklam SDK'sı içermez. Tüm
verileriniz yalnızca cihazınızda saklanır ve şifrelidir. Uygulama ilk açılışta
hiçbir ağ çağrısı yapmaz; tek istisna, "Halen Lifetime" tek seferlik
satın almasının mağaza (App Store / Google Play) üzerinden doğrulanmasıdır.

### Toplanan veri: hiçbiri
- Sigara/istek kayıtları, profil cevaplarınız (yaş grubu, günlük sayı, paket
  fiyatı vb.), plan ve tasarruf hesapları **yalnızca cihazınızda** tutulur.
- Analiz, çökme bildirimi, reklam SDK'sı yoktur.
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
İşleme hakkındaki sorularınız için: **privacy@halenquitsmoking.com**

---

## English

### Summary
Halen requires no account, uses no server, and contains no analytics or ad
SDKs. All of your data stays on your device, encrypted. The app performs no
network calls on first launch; the single exception is verifying the one-time
"Halen Lifetime" purchase with the store (App Store / Google Play).

### Data collected: none
- Cigarette/craving logs, your onboarding answers (age band, daily count,
  pack price, etc.), plan and savings calculations are stored **on your
  device only**.
- No analytics, no crash reporting, no ad SDKs.
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
export) are available directly in the app. Questions: **privacy@halenquitsmoking.com**

---

## Deutsch

### Zusammenfassung
Halen verlangt kein Konto, nutzt keinen Server und enthält keine Analyse- oder
Werbung-SDKs. Alle Daten bleiben verschlüsselt auf deinem Gerät. Die App
macht beim ersten Start keine Netzwerkaufrufe; einzige Ausnahme ist die
Prüfung des Einmalkaufs „Halen Lifetime" über den Store (App Store /
Google Play).

### Gesammelte Daten: keine
- Klick-/Craving-Einträge, deine Antworten im Onboarding (Altersgruppe,
  Tagesmenge, Packungspreis usw.), Plan- und Sparberechnungen bleiben
  **ausschließlich auf deinem Gerät**.
- Keine Analyse-, Absturz- oder Werbe-SDKs.
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
Fragen: **privacy@halenquitsmoking.com**
