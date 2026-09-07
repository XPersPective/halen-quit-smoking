# Changelog

Tüm önemli değişiklikler bu dosyada belgelenir. Biçim:
[Keep a Changelog](https://keepachangelog.com/tr/1.1.0/) ·
sürümleme: [SemVer](https://semver.org/lang/tr/).

## [1.0.0] — 2026-09-07

### Eklandı (Added)
- 7 adımlı onboarding (<90 sn, hesap yok; rapor §11 ile birebir) ve 18 yaş
  altı kaynak yönlendirmesi (plan verilmez, §39).
- Tek dokunuşla kayıt: BUGÜN CTA, widget, QS tile, iOS ControlWidget ve
  bildirim aksiyonu; tümü `source` etiketli.
- Dinamik azaltma planı motoru (Adaptive Taper, §14): günlük bütçe formülü,
  TTFC duyarlı tempo, saat-histogram pencereleri, medyan-gap ±%25 aralık,
  tempo çarpanlı sonraki öneri, dinamik yeniden hesap (dağıtım, sıkışma
  mesajı, %5 haftalık yumuşatma), tempo adaptasyonu, son-hafta fazı ve
  bırakma günü onayı, aralıklı "kaç hafta" tahmini.
- BUGÜN ekranı: hedef halkası, son sigara/sonraki hedef satırları,
  normalize nikotin eğrisi (S3) + şeffaflık ekranı, tasarruf ve health
  şeritleri, ilk gün boş durumu.
- İstatistikler: günlük sayı/plan işaretli grafik, saatlik desen, birikimli
  tasarruf; grafiklerin sözel özetleri (a11y).
- WHO sağlık zaman çizelgesi (20 dk → 15 yıl), azaltma modunda bırakma
  gününe dek önizleme kilidi; bırakma günü onayı.
- Craving SOS: 2 dk sayaç, 4D kartlar, 60 sn kutu nefesi (reduce-motion
  duyarlı), "izle ve bekle"; "Atlattım"/"İçtim" sonuç kaydı, sabit NRT
  satırı.
- Bildirim sistemi: Sakin/Standart/Yoğun/tam kapalı yoğunluk; günlük özet ve
  sabah hedefi varsayılan açık, plan-saati hatırlatması kapalı; 72 saat
  bırakma desteği, sessizlik dönüşü, milestone; Android 13+ runtime izin,
  iOS provisional; tam saat kullanıcı opt-in'i (USE_EXACT_ALARM yok);
  reboot sonrası yeniden planlama.
- Home widget (Android RemoteViews + iOS 17 interaktif WidgetKit), iOS 18
  ControlWidget, Android QS tile; hızlı kayıt kuyruğu source etiketli.
- Tek seferlik "Halen Lifetime" (StoreKit 2 / Play Billing): her açılışta
  mağaza doğrulaması, restore butonu, pending'e hak verme, iade/revocation
  düşürme; ilk açılışta kartsız 7 gün premium deneme.
- JSON dışa aktarma/içe aktarma (tüm 13 tablo), tüm verileri silme.
- Gizlilik: SQLCipher şifreli `halen.db`, Keystore/Keychain anahtar,
  yedek/transfer muafiyeti; uygulama ilk açılışta ağ çağrısı yapmaz.
- EN/TR/DE tam yerelleştirme; 78+ test (domain, veri, widget) ve yasak
  iddia ifadelerini engelleyen etik lint.
- `tool/simulate.dart`: ilk açılıştan bırakma gününe 8 haftalık senaryo.

### Bilinen sınırlar
- iOS Widget extension hedefi Xcode'da tek seferlik manuel eklenir
  (bkz. `ios/HalenWidget/SETUP.md`); CI yalnız Runner hedefini derler.
- Barkod tarama (P1), tetikleyici otomatik analiz (P1) v1.1 planındadır.
