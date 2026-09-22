## 2. TARGET ARCHITECTURE

Hedef doğrudan kullanıcı akışından türetilir:
- Flutter ekranları → Riverpod controller → doğrulanmış saf domain → transaction'lı Drift/SQLCipher.
  Form kontrolü repository/girdi sınırını ikame etmez. Yerel kişisel veri ve mağaza erişim kanıtı ayrıdır.
- Onboarding verisi tek SmokingProfile'a gider; şema gerektiğinde additive migration.
  UI dili ve destek ülkesi farklıdır. Bilinmeyen ülke yanlış numarayla doldurulmaz.
- Bugün: marka/rozet/ayar, açık plan adımı, kayıt/atlatma, olay grafiği, beden/organ özeti,
  kazanım/para, bırakma çizelgesi, SOS. Ayrıntı katmanı formülü ve sınırı açıklar.
- Modeller klinik ölçüm değildir; davranış puanı 0–100 puan olarak gösterilir. Katran etiketi
  akciğerde ölçüm sayılamaz. Kişisel saatlik geçmiş türetilmez; kayıtsız gün bilinmeyendir.
- İzin OS'den okunur; ret temel işlevi engellemez. Sağlık/paket satın alma teşvik alarmı yok.
- Premium:7 gün yerel deneme, JSON erişim oluşturamaz; yeniden kurulum engeli tam yerel depoda
  garanti edilemez. Native mağaza doğrulaması/refund/expiry/retry bağımsız test edilir.
- Reklam: ilk kurulum/onboarding/trial/premium/SOS/ödeme/sağlık ayrıntısı/widget'ta yok.
  Sonra ücretsiz uygun ekranlarda etiketli orta boy banner; app-open ancak uygun yükleme
  anında ve en çok24 saatte1, geç kalan reklam gösterilmez. Sağlık hedefleme yok.
- Bütün dil/tema yüzeyleri ortak tasarım token'ları; native widget seçenekleri gerçekten
  platforma aktarılır. Kaynaklı içerik/kanıt düzeyi; besin veya akupresür tedavi yerine geçmez.
- Yayın kapısı: bağımlılık/GPL mağaza uyumu, gerçek SDK gizlilik envanteri, sandbox satın alma,
  imzalı Android/iOS build, anonim kaynak/destek URL erişimi ve hukuk değerlendirmesi.
