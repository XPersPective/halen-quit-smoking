# Halen: Quit Smoking Tracker — Gizlilik Politikası

**Son güncelleme: 23 Kasım 2026**

## Türkçe

### Özet
Halen hesap ve analitik kullanmaz. Sağlık, sigara ve kriz destek kayıtları
yalnızca cihazınızda şifreli tutulur. Android'de 24 saatlik reklamsız
başlangıcın yeniden kurulumla sıfırlanmaması için açık onayınızdan sonra
uygulamaya özel, tek yönlü cihaz kimliği özeti ve ilk başlangıç zamanı Halen'in
Cloudflare hizmetinde saklanır. Ham cihaz kimliği ve sağlık kayıtları gönderilmez.
iOS'ta başlangıç tarihi aygıta özel Keychain'de tutulur. Tek seferlik Premium
satın alımının fiyatı, durumu ve geri yüklenmesi App Store / Google Play
tarafından yürütülür.

**Reklamlar (yalnızca ücretsiz kullanım):** Ücretsiz
kullanıcılar için uygun ekranlarda Google AdMob aracılığıyla etiketli
reklam gösterilir. AdMob, reklam sunumu için cihaz tanımlayıcılarını
işleyebilir; sağlık/nikotin verileriniz reklam hedeflemesine asla
gönderilmez. Reklamlar UMP consent akışıyla yönetilir; deneme süresince ve
Premium'da hiçbir reklam gösterilmez. Geliştirme sürümleri Google'ın test
reklam birimlerini kullanır.

**Keşfet sekmesi:** Yalnızca bu sekmeyi açtığında uygulama, aynı geliştiricinin
diğer uygulamalarının herkese açık listesini GitHub'dan
(raw.githubusercontent.com/XPersPective/napp_apps) indirir ve 24 saat
önbelleğe alır. Bu istekte kişisel veya sağlık verin gönderilmez; GitHub
isteğin IP adresini görebilir. Başka uygulamayı yüklemek için ödül verilmez.

### Halen'in işlediği veriler
- Sigara/istek kayıtları, profil cevaplarınız (yaş grubu, günlük sayı, paket
  fiyatı vb.), plan ve tasarruf hesapları **yalnızca cihazınızda** tutulur.
- Analiz ve çökme bildirimi SDK'sı yoktur. Reklam SDK'sı (Google AdMob)
  yalnızca deneme sonrası veya denemeyi etkinleştirmeyen ücretsiz kullanıcıların uygun ekranlarında etiketli banner
  için kullanılır; UMP consent akışı olmadan reklam yüklenmez. Sağlık ve
  nikotin verileri reklam SDK'sına hiç iletilmez.
- Android'de, yalnızca açık onaydan sonra, SHA-256 ile özetlenmiş uygulama
  kapsamlı Android cihaz kimliği ve 24 saatlik denemenin ilk başlangıç zamanı
  Halen'in Cloudflare D1 veritabanında saklanır. Bu kayıt yeniden kurulumda
  denemeyi baştan başlatmamak için kullanılır; sağlık, sigara, konum veya hesap
  bilgisi içermez. Ham Android kimliği sunucuya gönderilmez. Kayıt tutulduğu
  sürece aynı cihazda yeni otomatik deneme başlatılmaz. Cloudflare isteği
  iletirken IP adresini teknik olarak görebilir; uygulama IP adresini kaydetmez.
  Denemeyi başlatmak ve sonraki açılışlarda doğrulamak için internet gerekir;
  sunucuya erişilemiyorsa ücretsiz özellikler kullanılabilir, Premium deneme
  erişimi verilmez. Deneme kaydı silme talebi işlenene kadar tutulur.
- Uygulama GPS veya cihaz konumu izni istemez. Google AdMob reklamları sunarken IP
  adresinden yaklaşık bölge çıkarabilir; Cloudflare da istekleri iletirken IP
  adresini teknik olarak işler. Bu veriler reklam, ölçüm ve hizmet güvenliği için
  ilgili sağlayıcılarca işlenebilir. Kişiler, mikrofon ve kamera kullanılmaz
  (bu sürümde barkod tarama yok).

### Depolama ve şifreleme
- Veritabanı (`halen.db`) SQLCipher ile şifrelenir; anahtar Android
  Keystore / iOS Keychain'de saklanır.
- Veritabanı klasörü bulut yedeklemesinden ve cihazlar arası transferden
  hariç tutulur (iOS `isExcludedFromBackup`, Android `dataExtractionRules`).
- iOS'ta deneme süresinin başlangıç tarihi yalnızca aygıttaki Anahtar
  Zinciri'nde ayrıca saklanır. Kişisel kayıtlar silinse veya uygulama yeniden
  yüklense de tarih aygıtta kalabilir ve başka bir aygıtla eşzamanlanmaz.
- Android'deki deneme kaydı, yerel kayıtlar silinse veya uygulama yeniden
  yüklense de sunucuda kalır. Android fabrika ayarlarına döndürme veya işletim
  sistemi cihaz kimliğinin değiştirilmesi/sahtelemesi aynı cihazı farklı
  gösterebilir; bu yöntem root erişimine veya kimlik sahtelemesine karşı garanti vermez.
- Verilerinizi yine de dilediğiniz an JSON olarak dışa aktarabilirsiniz
  (Ayarlar → Veriniz). Bu dosyanın kaderi tamamen size aittir; uygulama
  hiçbir yüklemeye katılmaz.

### Bildirimler
Plan hatırlatmaları, günlük özet ve kriz destek bildirimleri cihaz üzerinde
planlanır; içeriği sunucudan gelmez. Android 13+ için bildirim izni sizin
onayınıza sunulur.

### Haklarınız (GDPR / KVKK)
Yerel sağlık kayıtlarına erişim, düzeltme ve silme (Ayarlar → Tüm verileri sil)
ile JSON dışa aktarımı uygulamada kullanılabilir. Bu işlem Android deneme
sunucusu kaydını silmez. Android'de Ayarlar içindeki gizlilik talebi bağlantısı,
tek yönlü destek kodunu e-posta taslağına ekler; göndermeden önce taslağı
gözden geçirin. Erişim/silme talebi: [devcrazypenguin@gmail.com](mailto:devcrazypenguin@gmail.com).
Gizli cihaz bilgilerini herkese açık GitHub konularına yazmayın.

---

## English

### Summary
Halen has no account or analytics. Health, smoking and craving-support records
stay encrypted on your device. On Android, after your explicit consent, Halen
stores an app-specific one-way device-ID hash and the first trial start time
with its Cloudflare service so reinstalling cannot restart the 24-hour ad-free
start. The raw device ID and health records are not sent. On iOS, the trial
start is kept in the device-only Keychain. Pricing, purchase state and restore
of the one-time Premium purchase are handled by the App Store / Google Play.

**Ads (free usage only):** For free users, labelled
ads are shown on eligible screens via Google AdMob. AdMob may process device
identifiers to serve the ads; your health/nicotine data is never sent for ad
targeting. Ads are governed by the UMP consent flow; nothing is shown during
the trial or with Premium. Development builds use Google's test ad units.

**Discover tab:** Only when you open this tab, the app downloads the public
list of the same developer's other apps from GitHub
(raw.githubusercontent.com/XPersPective/napp_apps) and caches it for 24 hours.
No personal or health data is sent with that request; GitHub can see the
request's IP address. Installing another app is never rewarded.

### Data Halen processes
- Cigarette/craving logs, your onboarding answers (age band, daily count,
  pack price, etc.), plan and savings calculations are stored **on your
  device only**.
- No analytics or crash-reporting SDKs. The ad SDK (Google AdMob) is used
  only for labelled banners on eligible free screens after the trial or when
  the trial is not enabled; no ad loads
  without the UMP consent flow. Health and nicotine data are never sent to
  the ad SDK.
- On Android, only after explicit consent, Halen stores a SHA-256 app-scoped
  Android device-ID hash and the 24-hour trial's first start time in its
  Cloudflare D1 database. This prevents reinstalling from restarting the trial.
  It contains no health, smoking, location or account data; the raw Android ID
  is not sent. Cloudflare can technically see the request IP while routing it;
  Halen does not store the IP address. An internet connection is required to
  start and verify the trial on later launches. If the server is unavailable,
  free features remain available but trial access is not granted. The claim is
  retained until a deletion request is processed.
- Halen does not request GPS or device-location permission. Google AdMob may
  infer an approximate region from the IP address to serve or measure ads, and
  Cloudflare technically processes IP addresses while routing requests. Those
  providers may process this data for advertising, measurement, and service
  security. Halen does not access contacts, microphone, or camera (no barcode
  scanning in this version).

### Storage and encryption
- The database (`halen.db`) is encrypted with SQLCipher; the key is kept in
  the Android Keystore / iOS Keychain.
- The database folder is excluded from cloud backups and device transfer
  (iOS `isExcludedFromBackup`, Android `dataExtractionRules`).
- On iOS, the trial start date is also stored in the device-only Keychain.
  It may remain after clearing personal records or reinstalling the app,
  and does not sync to other devices.
- On Android, the server-backed trial claim remains after local records are
  deleted or the app is reinstalled. A factory reset or OS device-ID change may
  make the device appear new; this does not protect against root access or
  deliberate identity spoofing.
- You can export your data as JSON at any time (Settings → Your data). That
  file is entirely yours; the app never uploads anything.

### Notifications
Plan reminders, the daily summary and craving-support notifications are
scheduled on-device; their content does not come from a server. On Android
13+ the notification permission is requested from you first.

### Your rights (GDPR)
Access, correction, deletion (Settings → Delete all data) and JSON export of
local health records are available in the app. This does not delete the Android
trial claim. For access, deletion or other requests about that server record,
  On Android, the privacy-request link in Settings opens an email draft with a
  one-way support code; review it before sending. Access/deletion requests:
  [devcrazypenguin@gmail.com](mailto:devcrazypenguin@gmail.com). Do not post
  private device information in a public GitHub issue. General support:
  [GitHub Issues](https://github.com/XPersPective/halen-quit-smoking/issues)

---

## Deutsch

### Zusammenfassung
Halen hat kein Konto und keine Analyse. Gesundheits-, Rauch- und Craving-Daten
bleiben verschlüsselt auf deinem Gerät. Unter Android speichert Halen nach
deiner ausdrücklichen Zustimmung einen app-spezifischen Geräte-ID-Hash und den
Startzeitpunkt mit seinem Cloudflare-Dienst, damit eine Neuinstallation die
24-stündige werbefreie Startphase nicht zurücksetzt. Die rohe Geräte-ID und
Gesundheitsdaten werden nicht gesendet. Unter iOS bleibt der Startzeitpunkt im
gerätegebundenen Schlüsselbund. Preis, Kaufstatus und Wiederherstellung des
einmaligen Premium-Kaufs werden vom App Store bzw. Google Play abgewickelt.

**Werbung (nur kostenlose Nutzung):** Für kostenlose
Nutzer werden auf geeigneten Bildschirmen gekennzeichnete Anzeigen über Google
AdMob gezeigt. AdMob kann dafür Gerätekennungen verarbeiten; Gesundheits-/
Nikotindaten werden nie für Werbung verwendet. Anzeigen laufen über den
UMP-Einwilligungsablauf; während einer aktiven Testphase und mit Premium wird nichts gezeigt.
Entwicklungsversionen nutzen Googles Test-Anzeigenblöcke.

**Entdecken-Tab:** Nur wenn du diesen Tab öffnest, lädt die App die öffentliche
Liste der anderen Apps desselben Entwicklers von GitHub
(raw.githubusercontent.com/XPersPective/napp_apps) und speichert sie 24 Stunden
zwischen. Mit dieser Anfrage werden keine persönlichen oder Gesundheitsdaten
gesendet; GitHub kann die IP-Adresse der Anfrage sehen. Fürs Installieren einer
anderen App gibt es keine Belohnung.

### Von Halen verarbeitete Daten
- Klick-/Craving-Einträge, deine Antworten im Onboarding (Altersgruppe,
  Tagesmenge, Packungspreis usw.), Plan- und Sparberechnungen bleiben
  **ausschließlich auf deinem Gerät**.
- Keine Analyse- oder Absturz-SDKs. Das Werbe-SDK (Google AdMob) wird nur für
  gekennzeichnete Banner auf geeigneten kostenlosen Bildschirmen nach der
  Testphase oder bei deaktivierter Testphase verwendet;
  ohne UMP-Einwilligungsablauf wird keine Anzeige geladen. Gesundheits- und
  Nikotindaten werden nie an das Werbe-SDK übermittelt.
- Unter Android speichert Halen nach ausdrücklicher Zustimmung einen mit
  SHA-256 gehashten, app-spezifischen Android-Gerätebezeichner und den ersten
  Startzeitpunkt der 24-Stunden-Testphase in seiner Cloudflare-D1-Datenbank.
  Dies verhindert einen Neustart der Testphase nach einer Neuinstallation.
  Gesundheits-, Rauch-, Standort- oder Kontodaten sind nicht enthalten; die
  rohe Android-ID wird nicht gesendet. Cloudflare kann die IP-Adresse während
  der Weiterleitung technisch sehen; Halen speichert sie nicht. Zum Starten
  und Prüfen der Testphase bei späteren Starts ist eine Internetverbindung
  erforderlich. Ist der Server nicht erreichbar, bleiben kostenlose
  Funktionen verfügbar, aber die Testphase wird nicht gewährt. Der Eintrag
  bleibt bis zur Bearbeitung eines Löschantrags gespeichert.
- Halen fordert keine GPS- oder Geräte-Standortberechtigung an. Google AdMob
  kann zur Bereitstellung oder Messung von Werbung eine ungefähre Region aus
  der IP-Adresse ableiten; Cloudflare verarbeitet IP-Adressen technisch beim
  Weiterleiten von Anfragen. Diese Anbieter können die Daten für Werbung,
  Messung und Dienstsicherheit verarbeiten. Halen greift nicht auf Kontakte,
  Mikrofon oder Kamera zu (in dieser Version kein Barcode-Scanning).

### Speicherung und Verschlüsselung
- Die Datenbank (`halen.db`) ist mit SQLCipher verschlüsselt; der
  Schlüssel liegt im Android Keystore bzw. iOS Keychain.
- Der Datenbank-Ordner ist von Cloud-Backups und Geräteübertragung
  ausgeschlossen (iOS `isExcludedFromBackup`, Android `dataExtractionRules`).
- Unter iOS wird das Startdatum der Testphase zusätzlich im Schlüsselbund
  dieses Geräts gespeichert. Es kann nach dem Löschen persönlicher Daten
  oder nach einer Neuinstallation erhalten bleiben und wird nicht synchronisiert.
- Unter Android bleibt der serverseitige Testphasen-Eintrag auch nach dem
  Löschen lokaler Daten oder einer Neuinstallation bestehen. Ein Zurücksetzen
  auf Werkseinstellungen oder eine geänderte/gefälschte Geräte-ID kann das
  Gerät neu erscheinen lassen; Schutz vor Root-Zugriff oder Identitätsfälschung
  wird nicht garantiert.
- Du kannst deine Daten jederzeit als JSON exportieren (Einstellungen →
  Deine Daten). Diese Datei gehört dir allein; die App lädt nichts hoch.

### Benachrichtigungen
Planerinnerungen, Tageszusammenfassung und Craving-Unterstützung werden auf
dem Gerät geplant; ihre Inhalte kommen nicht von einem Server. Unter Android
13+ wird die Benachrichtigungsberechtigung zuerst von dir angefragt.

### Deine Rechte (DSGVO)
Zugriff, Berichtigung, Löschung (Einstellungen → Alle Daten löschen) und
JSON-Export lokaler Gesundheitsdaten sind in der App möglich. Dadurch wird der
Android-Testphasen-Eintrag nicht gelöscht. Unter Android öffnet der
Datenschutz-Link in den Einstellungen einen E-Mail-Entwurf mit einem
einmaligen Support-Code; bitte vor dem Senden prüfen. Auskunfts-/Löschanfragen:
[devcrazypenguin@gmail.com](mailto:devcrazypenguin@gmail.com). Private
Geräteinformationen gehören nicht in öffentliche GitHub-Issues.
Allgemeiner Support: [GitHub Issues](https://github.com/XPersPective/halen-quit-smoking/issues)
