# Halen — mağaza ASO/SEO raporu ve yerelleştirme kaydı (2026-10-16)

Kapsam: Google Play + App Store mağaza sayfaları (başlık, kısa/tam açıklama, öne çıkan görsel, ikon), rakip taraması, ana sayfa kullanıcı akışı. Her mağaza dilinde yabancı "tracker" başlığı kalktı; her dil kendi "sigarayı bırakma" ifadesiyle yazıldı.

## 1. Bulgu ve düzeltme

| # | Alan | Önce | Sonra |
|---|------|------|-------|
| 1 | tr-TR başlık (≤30) | `Halen: Quit Smoking Tracker` — İngilizce, "sigara/bırakma" yok | `Halen: Sigara Bırakma Takibi` (28) |
| 2 | tr-TR kısa (≤80) | "bırak" var, "sigara" yok (74) | `Sigarayı azalt, bırak: uyarlanan plan, nikotin takibi, SOS araçları. Hesapsız.` (78) |
| 3 | tr-TR tam (≤4000) | "sigara" 4 kez, "dinamik plan" çevirisi, ilk paragrafta anahtar kelime yok | "sigara" 6 kez, ilk paragrafta "sigara azaltma / sigara bırakma", "uyarlanabilir plan" (3326) |
| 4 | Başlıklar, diğer 72 dil | de/en dahil hepsi aynı İngilizce başlık (protokol: "tüm dillerde aynı") | Her dilde yerel başlık; 65 farklı başlık (varyantlar ortak: es-ES/es-419/es-US vb.) |
| 5 | Mağaza dili sayısı | Play: 3 · App Store: 3 | Play: 73 · App Store: 46 (Apple'ın desteklediği kümenin kesişimi) |
| 6 | Öne çıkan görsel | 3 dil, alt metinde anahtar kelime yok | 73 dil, yerel slogan + "sigara bırakma takibi" alt satırı, RTL (ar/fa/ur/he) doğru yönde, Hint/Tay/Burma/Gürcü yazıları doğru şekillendi (örnek görsellerde gözle denetlendi) |
| 7 | Ana sayfa | "Bir sigara içtim" ve "İçmedim, atlattım" | + **"Yeni paket aldım"** butonu (paket ekleme sayfasını açar; paket güncel paket olur) |
| 8 | Bugün başlığı | Deneme rozeti "Deneme: 7 gün k…" kırpılıyordu | Kısa etiket "Deneme: 7 gün" |

Ölçüm (diskten, 73 Play + 46 App Store klasörü): başlık ≤30, kısa ≤80, tam ≤4000; App Store ad ≤30, alt başlık ≤30, anahtar kelime ≤100, tanıtım ≤170 — **0 sorun**. "garanti / %100 / klinik olarak" benzeri iddia: yok.

## 2. Rakip taraması (web araması, 2026-10)

Canlı Play puanı çekilemedi; aşağıdakiler üçüncü taraf özetleri ve mağaza sayfaları (güncelliği Play'de kontrol edilmeli).

| Uygulama | Not |
|---|---|
| QuitNow (Fewlaps) | ~4,46 puan, ~67 bin yorum, 5 M indirme; Türkçe destekli |
| Quit Tracker: Stop Smoking | ~4,7 puan, ~177 bin; motivasyon takibi, aşerme koçluğu yok |
| Stop Smoking – EasyQuit | ~4,7 puan, ~106 bin |
| Quit Smoking Tracker (başka geliştirici) | ~4,8 puan, ~39 bin; ad olarak en yakın rakip |
| Kwit | BDT esinli (iOS, Türkçe) |
| Bırakabilirsin | Fagerström nikotin bağımlılığı testi |
| Sigarayı Bırak | sağlık yüzdesi + cebinde kalan para |
| Cessation Nation | topluluk odaklı |

**Farklılaşma** (mağaza metnine işlendi): kanıt derecesi etiketleri, ilaç bilgisi (marka/doz yok), açık formüller, hesapsız + cihazda, suçlamayan "kayma" dili, dürüst reklam politikası. **Açık eksik:** Fagerström testi yok (özellik kararı).

## 3. Anahtar kelimeler (tr; hacim verisi bu ortamda yok — aday listesi)

Yüksek: `sigara bırakma`, `sigara bırakma uygulaması`, `sigarayı bırakma`, `sigara azaltma` · Orta: `sigara takip`, `nikotin`, `sigara içmeyi bırakma` · Uzun kuyruk: `sigara kriz`, `nikotin replasmanı`. Diğer dillerde aynı mantık: ana terim başlıkta, "azalt+bırak" kısa açıklamada, App Store anahtar kelime alanı yerel terimlerle dolduruldu.

## 4. Açık kalanlar (yapılmadı, nedeniyle)

1. **Çeviri kalitesi:** 66 dil ilk taslak (modelle yazıldı). Geniş yayın öncesi anadili konuşanlarca gözden geçirilmeli; özellikle ml, my, lo, si, zu, mn, ky, kk.
2. **Ekran görüntüleri:** yalnız tr/en/de; arayüz yalnız bu 3 dilde olduğundan diğer dillerde varsayılan dilin görüntüleri kullanılır. Mevcut görüntüler yeni butondan önceki sürümden; gerçek cihazdan yenilenmeli (CAPTURE_DESIGN hattı). Açıklamalarda "Uygulama dilleri: Türkçe, English, Deutsch" yazıyor (yanıltıcı olmamak için).
3. **Gerçek arayüz yerelleştirmesi:** PB-041 (73 dil ARB) hâlâ planlı.
4. **Yayın:** `fastlane push_metadata` / Play Console / App Store Connect gönderimi çalıştırılmadı — sahibe ait. Sürüm kodu (pubspec 1.4.0+5) artırılmadı; yeni buton ve rozet düzeltmesi yeni bir derleme gerektirir.
5. **Ölçülemeyenler:** gerçek sıralama/gösterim/dönüşüm (Play Console verisi gerekir), gerçek cihazda UX ölçümü (dokunma hedefi, kırpılma), anahtar kelime hacmi.

## 5. Değişen dosyalar

- Uygulama: `lib/l10n/app_{tr,en,de}.arb` (`ctaNewPack`, `trialBadgeShort`), `lib/l10n/generated/*`, `lib/presentation/screens/today/today_screen.dart`, `lib/presentation/widgets/premium_badge.dart`.
- Üretici (kayıt): `tool/store_listing/{build.py,gen_feature.py,data_*.py}` — çıktı `D:\AppPublishing\apps\halen-quit-smoking\stores\{google-play,app-store}\metadata\<dil>\`; `APP_PUBLISHING_ROOT` ile değiştirilebilir.
- Kayıt: `CHANGELOG.md`, `.project-brain/tasks/PB-052.md`, `D:\AppPublishing\README.md` (Halen kaydı).
- Yedek: eski tr-TR metinleri oturum scratchpad'inde (`backup-tr-TR/`); yayın klasörü git deposu değil.
