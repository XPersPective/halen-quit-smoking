## 3. CURRENT ARCHITECTURE

- `lib/data/db/app_database.dart:71`: schemaVersion9 (v8 trialNudge, v9
  smokingProfile.declaredRhythmMinutes). Yeni paralel profil gereksiz.
- `lib/domain/onboarding.dart:OnboardingAnswers`, `lib/data/repositories/profile_repository.dart`:
  sayı/marka/ritim sınırları ve transaction öncesi guard; 9 adım (ritim 4. adım,
  bant orta noktası 20/45/90/150, "Emin değilim"=null).
  T4 geri dönüş düzeltmesi: welcome replacement ile kaldırıldığı için ilk adımda
  pop yoksa welcome yeniden açılır; aynı Riverpod cevap durumu korunur.
  PopScope sistem-geri olayını aynı _back akışına bağlar; fiyat metni adım dönüşünde korunur.
- `lib/data/backup_repository.dart`: trialStartedAt export/import kaldırıldı;5 test geçti.
  Yeni kişisel tabloların hepsi aktarılmıyor (bkz. T26: trialNudge dahil v8 alanı da
  kapsam dışında olabilir); veri silme kapsamı eksik olabilir.
- `lib/data/notification_service.dart`: isPermissionGranted OS'den okur
  (areNotificationsEnabled/checkPermissions), openSystemSettings plugin'in
  openAppNotificationSettings'i; `presentation/widgets/notification_permission_card.dart`
  splash ve Ayarlar'da ortak, resume'da yeniden okur. Day-5 trial nudge yalnız
  ayrı `trialNudge` tercihiyle (varsayılan false); premium'da iptal edilir.
- `lib/data/secure_key_store.dart`: Android resetOnError=false; db_opener dosya varlığını
  zorunlu databaseExists argümanıyla iletir. Mevcut DB için eksik/boş anahtar yeni anahtar
  yazmadan StateError verir; native okuma hatası yayılır.5 kanal testi.
- `lib/data/db_opener.dart`: dönüşten önce sqlite_master okunur; bozuk DB/yanlış key
  hatası main'e ulaşır, başarısız bağlantı kapatılır. `lib/app.dart` hata ekranında DB
  ayarlarını okumaz ve home ile / rotasını çakıştırmaz.3 gerçek SQLCipher +1 widget testi.
- `lib/presentation/widgets/quitline_card.dart`: kayıtlı bölge/cihaz bölgesi,TR/US/DE/UK
  alt bölgeleri;3 ekran ortak; numaralar yalnız çağrı düğmelerinde ve kopyalamada.
  Android16 dialer kanıtı 2026-09-18; iOS arama akışı kanıtı açık (T25).
- `lib/data/purchase_service.dart`: mevcut store entegrasyonu restore/async güvenlik denetimi
  bekliyor; callback kriptografik doğrulama kanıtı değil. Tam reklam entegrasyonu yok.
- `settings_screen.dart`: bildirim yoğunluğu Wrap/ChoiceChip; dar alanda sözcük bölmek
  yerine seçenek alt satıra geçer, aynı kaydetme/NotificationService akışı korunur.
  Seçili chip etiketi onPrimary; durum çubuğu ikonları ortak AppBarTheme
  systemOverlayStyle ile ekran parlaklığını izler (Android16 açık+koyu doğrulandı).
- 2026-09-17 güncel çalışma ağacı:331 test geçti; fatal-info analiz temiz.
  `test/widget/design_capture_test.dart` Drift çoklu-instance uyarıları var.
  Bu sonuçlar imzalı mobil build veya tüm AC'lerin kanıtı değildir.
- 2026-09-17: `flutter run -d emulator-5554 --debug --no-resident` başarılı;
  Android16/API36 x64,1080×1920 üzerinde mevcut profil silinmeden açıldı.
  Bugün/Grafikler/Plan/Rehber/SOS/Ayarlar ekranları gözlendi; SOS→Ayarlar→Android Back
  ikinci kontrollü denemede SOS sekmesini korudu. İlk turdaki beklenmeyen Grafikler dönüşü
  tekrar üretilemedi; tüm gezinme doğrulandı sayılmaz. Onboarding native turu henüz yapılmadı.
  Sonraki native doğrulama: e62194d+mevcut dirty tree aynı Android16'da user0 mevcut
  profille Bugün, izole Halen-QA/user10 temiz veride Welcome açıldı. User10'da
  Start→Step1→KEYCODE_BACK→Welcome gözlendi;8 adımlık tam tur hâlâ açık.
GAP: başlangıç beden girdileri ve giriş denetimi → T5,T6.
GAP: görsel ve kullanıcı akışı kapsamı → T7–T18.
GAP: yedek, hukuk, ödeme, reklam ve release kanıtı → T3,T19–T26.
