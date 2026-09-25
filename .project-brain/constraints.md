## 1. GOAL

Android ve iOS'ta yayınlanabilecek premium kalitede, sigara bırakmaya yardımcı,
bilimsel kaynak ve hesap sınırlarını açık sunan Halen: Quit Smoking Tracker geliştir.
Kullanıcının bütün eleştirilerini uygula; mevcut ve yeni hataları kök nedeninde düzelt,
test/gerçek cihaz/görsel denetimle kanıtla. Açık kaynak faydasını iyi anlat; GPL seçiminin
ticari dağıtıma izin verdiğini saklama. Ödeme native App Store/Google Play, ömür boyu
reklamsız seçenek; ilk7 gün tüm uygulanmış premium özellikler ve reklamsız kullanım.
Bütün işlerin protokol/mimari/yol haritası tek bu dosyada, düşük modelin devralabileceği
açıklıkta kalır. Gereksiz bağımlılık/boilerplate yok; mevcut kullanıcı değişiklikleri korunur.

**Acceptance criteria**
- [ ] AC1 Başlangıç: ücretsiz ve isteğe bağlı gerçek bildirim durumu, geri gezinme; günlük20/paket20, boş zorunlu fiyat/marka, yaş/TTFC/ritim/boy/kilo/süre, sağlam tüm girdi sınırları.
- [ ] AC2 Güven ve veri: JSON trial yenileyemez; tam yedek/rollback/veri silme; yerel şifreleme ve dürüst gizlilik.
- [ ] AC3 Ürün UX: doğru bölge hattı/yeşil eylem, marka/ikon/premium rozeti, gerçek widget özelleştirme, açık kayıt/undo, dengeli organlar ve görünür sağlık çizelgesi.
- [ ] AC4 Bilim: bütün grafiklerde birim/dönem/formül/kaynak/sınır; his beyanı tahminden ayrı; açık plan adımı/günlük grafik; bilinmeyen gün tasarruf değil; tarihsel tahmin ayrı.
- [ ] AC5 İçerik/tasarım: üç dil, okunur alternatif teknik görselleri ve rehberler, kanıt etiketi, iğnesiz kulak rehberi; sistem tema/Inter/erişilebilirlik/reduced motion.
- [ ] AC6 Yayın: GPL tam metni/lisans uyumu, fayda odaklı Hakkında; güvenilir IAP/restore/iptal; ölçülü uyumlu reklam ve consent; doğru mağaza/hukuk beyanları.
- [ ] AC7 Teslim: tek brain, kaynak deposunda paket/sır yok, temiz build/test/lint, Android/iOS gerçek cihaz ve imzalı sürüm, bütün AC'ler kanıtlı.

**Constraints:** Flutter/Dart/Riverpod/Drift; TR/EN/DE; Ponytail ultra; hesap olmadan yerel çekirdek;
mağaza ve hukuk kurallarına uyum; klinik ölçüm/tanı/garanti uydurma yok; GPL ticari yasak değildir.
**Out of scope:** otomatik arama, sigara/paket almaya teşvik, sağlık verisiyle reklam hedefleme,
izinsiz depo görünürlüğü/yayın, test kanıtı olmadan hatasızlık iddiası.
**Open questions:** none
