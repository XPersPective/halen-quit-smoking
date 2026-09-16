# Halen: Quit Smoking Tracker

Reduce at your pace. Quit for good. — Kendi hızında azalt, kalıcı bırak.

Halen, sigarayı azaltma ve bırakma sürecinde kayıt tutmaya yardımcı olan Flutter
uygulamasıdır. Kayıtlar cihazda saklanır; göstergeler tıbbi ölçüm veya tanı değildir.

## Belgeler ve durum

- [MIMARI.md](MIMARI.md): tek çalışma protokolü, mimari, ayrıntılı yol haritası,
  kabul ölçütleri, doğrulama kayıtları ve mağaza metni taslakları.
- [PRIVACY_POLICY.md](PRIVACY_POLICY.md): gizlilik politikası.
- [CHANGELOG.md](CHANGELOG.md): sürüm geçmişi.
- [LICENSE](LICENSE): lisans bildirimi.

Uygulama henüz Android/iOS yayınına hazır olarak onaylanmamıştır. Test, gerçek cihaz,
mağaza ödeme doğrulaması, reklam/izin entegrasyonu, imzalama ve hukuki incelemenin
açık işleri MIMARI.md'de izlenir. Bir özelliğin yol haritasında bulunması uygulanmış
veya doğrulanmış olduğu anlamına gelmez.

## Geliştirme

```bash
flutter pub get
flutter analyze --fatal-infos
flutter test
flutter run
flutter build apk --release
flutter build appbundle --release
```

Android için Flutter ve Android SDK; iOS için macOS, Xcode ve imzalama hesabı gerekir.
Uygulama bağımlılıkları pubspec.lock ile sabitlenir. Üretilen build/ çıktıları,
APK/AAB/IPA paketleri ve imza anahtarları Git'e eklenmez.

Android release imzası android/key.properties ile yapılandırılır (Git dışında).
Mevcut yapılandırmada anahtar yoksa debug imzasına düşen yerel derleme mağaza
yayınına uygun değildir. Anahtarları ve parolaları depoya koymayın.

## Mimari

Flutter sunum → Riverpod uygulama akışları → saf Dart domain hesapları →
Drift/SQLCipher veri katmanı ve native platform servisleri.
Bilimsel modellerin anlamı, sınırları ve veri sözleşmeleri MIMARI.md'de tutulur;
README ikinci bir mimari/yol haritası olarak kullanılmaz.

## Görsel kontroller

```bash
flutter test test/widget/design_capture_test.dart --update-goldens --dart-define=CAPTURE_DESIGN=true
```

screenshots/ çıktıları ayrıca görsel olarak incelenmelidir. Golden üretimi gerçek
Android/iOS cihaz kontrolünün yerine geçmez.

## Kaynak ve lisans

Projenin amacı kullanıcılara faydalı, incelenebilir bir bırakma yardımcısı sunmaktır.
Seçili lisans GNU GPLv3-or-later'dır: ticari dağıtımı yasaklamaz; kaynak kodu ve
copyleft yükümlülükleri getirir. Tam lisans, bağımlılık ve mağaza dağıtım incelemesi
MIMARI.md H19 altında izlenir. Açık kaynak olmak kusursuz güvenlik garantisi değildir.
