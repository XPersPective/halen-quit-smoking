# Halen — Premium Uygulama Planı

Kaynak yönerge: [`HALEN-PREMIUM-BRIEF.md`](HALEN-PREMIUM-BRIEF.md)
Geri dönüş noktası: `v1.1.0-modules`

Sıralama keyfi değil. **Önce tasarım sistemi** geliyor, çünkü sistem
kurulmadan yazılan her yeni ekran, sonra elle düzeltilecek borç üretir.
Sonra **klinik iskelet**, çünkü asıl eksik o. En sonda **cila**, çünkü
cilanın üzerine oturacağı yapının önce var olması gerekiyor.

Her faz kendi başına push edilebilir ve tek başına uygulamayı iyileştirir.

---

## Faz 1 — Tasarım sistemi (temel)

**Neden ilk:** yönergenin 4. sınavı ("bu sistemin parçası mı?") şu an
hiçbir yerde geçilemiyor.

| # | İş | Çıktı |
|---|----|-------|
| 1.1 | Token katmanı | `lib/core/design/tokens.dart` — boşluk ölçeği (4/8/12/16/24/32/48), köşe yarıçapları, gölge katmanları, hareket süreleri ve eğrileri |
| 1.2 | Semantik renk rolleri | `HalenPalette`: `surface`, `surfaceRaised`, `accent`, `progress`, `load`, `info`, `caution`, `neutral` — her rengin bir anlamı, ham renk adı yok |
| 1.3 | Tipografi kimliği | Gerçek bir yazı tipi ailesi (değişken font, `pubspec` üzerinden paketlenir), tam bir tip ölçeği: `display / headline / title / body / label / numeric` |
| 1.4 | Sayı tipografisi | Rakamlar için tabular figürler — sayaç her saniye zıplamamalı |
| 1.5 | Bileşen kütüphanesi | `HalenCard`, `HalenSectionHeader`, `HalenStat`, `HalenEmptyState`, `HalenPill`, `HalenListTile` |
| 1.6 | Hareket dili | `HalenMotion`: `instant/quick/standard/slow` + standart eğriler; tüm elle yazılmış süreler buraya taşınır |
| 1.7 | Tek saat | Nabız/nefes animasyonları için tek bir paylaşılan `Ticker` sağlayıcısı; kart başına controller kalkar |
| 1.8 | Karanlık tema doğrulaması | Her ekranın karanlık yakalaması, gözle kontrol |

**Kabul:** ekran dosyalarında elle yazılmış `EdgeInsets.all(18)`,
`Duration(milliseconds: 280)` veya ham `Color(0x…)` kalmayacak.

### Faz 1 durumu

| # | Durum | Not |
|---|-------|-----|
| 1.1 Token katmanı | ✅ | `lib/core/design/tokens.dart` |
| 1.2 Semantik renk rolleri | ✅ | `lib/core/design/data_palette.dart` — `DataRole` |
| 1.3 Tipografi kimliği | ✅ | Inter (değişken, SIL OFL) paketlendi; `HalenType` tüm ölçeği taşıyor |
| 1.4 Sayı tipografisi | ✅ | `.asNumber` — tabular + lining rakamlar |
| 1.5 Bileşen kütüphanesi | ✅ | `HalenCard`, `HalenSectionHeader`, `HalenStat`, `HalenEmptyState`, `HalenPill` |
| 1.6 Hareket dili | ✅ | `HalenDuration`, `HalenCurves` |
| 1.7 Tek saat | ✅ | `BodyClock` + `BodyPulse` — tembel: ekranda nabız yoksa tik atmaz |
| 1.8 Karanlık tema doğrulaması | ◐ | 3 ekran yakalandı ve düzeltildi; kalanlar sırada |

**Yazı tipi (1.3, çözüldü):** Inter'in değişken aslı `assets/fonts/Inter.ttf`
olarak paketlendi (SIL OFL 1.1, lisans dosyası yanında). Tek dosya dört ağırlık
altında bildiriliyor; böylece motor sahte kalın üretmek yerine `wght` eksenini
örnekliyor. Seçim sebebi: arayüz için çizilmiş olması, Türkçe ve Almancayı
kelime ortasında yedeğe düşmeden taşıması, ve **tabular rakamları** — saniyede
bir güncellenen bir sayacın rakam genişliği değiştikçe yana kaymaması için.

**Karanlık temanın ortaya çıkardığı iki gerçek kural ihlali (düzeltildi):**
- Zarar skalasının son bandı mercandı; ürünün kendi kuralı "sağlık verisinde
  kırmızı yok" diyor. Koyu kehribara çevrildi.
- İlerleme/yük grafiğinin ekseni numaralıydı ama birimi yazmıyordu. Artık
  "puan, 0-100" başlığı var.

---

## Faz 2 — İlk 60 saniye

**Neden ikinci:** en yüksek getirili tek değişiklik. Kullanıcı burada
kalmaya karar veriyor.

| # | İş | Çıktı |
|---|----|-------|
| 2.1 | Onboarding sonucu ekranı | Kendi verisinden: yılda paket, yılda para, yılda zaman, ilk 72 saat önizlemesi. Form biter bitmez açılır |
| 2.2 | "Neden bırakıyorsun?" adımı | Değer seçimi (çocuklar / sağlık / para / özgürlük / koku). Motivasyon görüşmesi tonu; sonra kriz anında geri gösterilir |
| 2.3 | Bağımlılık düzeyi geri bildirimi | HSI zaten hesaplanıyor — kullanıcıya söylenmiyor. "Bağımlılık düzeyin: orta" + bunun plan için ne anlama geldiği |
| 2.4 | Boş durum tasarımı | Her kart için: ne olacağını gösteren, boş kutu olmayan bir hâl |
| 2.5 | Ana ekran hiyerarşisi | Tek birincil blok (bugünkü durum + tek eylem), altında ikincil şerit, sonra kartlar |

---

## Faz 3 — Klinik iskelet

**Neden burada:** yönergenin en ağır eksikleri. Faz 1 ve 2'nin üstüne
oturur.

| # | İş | Kanıt dayanağı |
|---|----|----------------|
| 3.1 | **NRT / farmakoterapi rehberi** | Cochrane: NRT ~1,5–1,6 kat; kombinasyon > tekli; vareniklin ~2,2 kat. Ne olduğu, nasıl kullanıldığı, sık hatalar, hekim/eczacı yönlendirmesi. Ürün satışı yok, marka yok |
| 3.2 | **Bırakma tarihi protokolü** | Azaltma + tarih; geri sayım; tarihi seçme, taşıma ve taşımanın kaydı |
| 3.3 | **Bırakma günü ekranı** | O gün açılan özel ekran: ilk 24 saat saat saat, ne bekleneceği, ne yapılacağı |
| 3.4 | **Nüks önleme planı** | Yüksek riskli durum listesi (kullanıcının kendi tetikleyicilerinden üretilir), her biri için hazır plan, "tek nefes bile yok" kuralı |
| 3.5 | **Kayma / nüks ayrımı** | Bir sigara içildiğinde: bu bir kayma, nüks değil; şu an şunu yap. Suçlama yok, ama öğretim var |
| 3.6 | **Sosyal destek adımı** | "Kime söyleyeceksin?" — kişi seçimi, hazır mesaj taslağı, destek isteme hatırlatıcısı |
| 3.7 | **Ruh hâli taraması** | İki soruluk kısa tarama, belirlenmiş eşikte net yönlendirme; tanı koymaz |
| 3.8 | **Güvenlik ağı akışta** | Gebelik / kalp / psikiyatri işaretlenirse uygun uyarı ve yönlendirme akışın içinde |
| 3.9 | **Yardım hattı, kriz anında** | SOS ekranında görünür: TR Yeşilay 171, ABD 1-800-QUIT-NOW, UK NHS, DE BZgA |

---

## Faz 4 — Tek akışta grafikler

Kullanıcının açıkça istediği: *"ya kaydıracak ya da bakacak"*.

| # | İş |
|---|-----|
| 4.1 | **Durum akışı ekranı**: kaydırmalı sayfa akışı; her sayfa tek metrik, tek grafik, tek cümle |
| 4.2 | Sayfalar: nikotin · oksijen borcu · gün boyu zemin · partikül yükü · ilerleme puanı · zarar yükü · para · zaman · akciğer · organlar |
| 4.3 | Ortak grafik anatomisi: başlık · büyük sayı · birim · grafik · tek cümlelik anlam · kaynak bağlantısı |
| 4.4 | Ana ekrandan tek dokunuşla giriş; sayfa göstergeleri |
| 4.5 | Her grafiğin ekseninde birim (yönergenin sabit kuralı) |

---

## Faz 5 — Bağlılık ve cila

| # | İş |
|---|-----|
| 5.1 | **Kilometre taşı kutlaması**: tam ekran an, animasyon, tek cümle, paylaşılabilir kart |
| 5.2 | **Bildirim tasarımı**: sabah niyet, riskli saat öncesi, akşam kapanış, kilometre taşı — hepsi opsiyonel ve sessiz varsayılan |
| 5.3 | **Seri (streak) dili**: cezalandırmayan, kırılınca yeniden başlatmayan tasarım |
| 5.4 | **Haptik dili**: kayıt, atlatma, kilometre taşı — üç farklı dokunuş |
| 5.5 | **Uygulama kimliği**: ikon, açılış ekranı, boş durum illüstrasyonları |
| 5.6 | **Gerçek cihaz koşusu**: haptik, bildirim teslimi, kare hızı, kaydırma hissi |
| 5.7 | **CI**: her push'ta analyze + test |

---

## Kapsam dışı (bilerek)

- Hesap, bulut senkronizasyonu, sosyal akış — veri cihazda kalır kuralı.
- Kişisel lojistik regresyon kalibrasyonu (≥200 kayıt) — v2'ye ertelendi.
- Ürün/marka satışı, ilaç önerisi — yalnızca bilgi ve yönlendirme.

---

## İlerleme

| Faz | Durum |
|-----|-------|
| 1 — Tasarım sistemi | ✅ tamam |
| 2 — İlk 60 saniye | ✅ tamam |
| 3 — Klinik iskelet | ✅ tamam |
| 4 — Tek akışta grafikler | ✅ tamam |
| 5 — Bağlılık ve cila | ◐ cihaz koşusu hariç tamam |

### Ne yapıldı

**Faz 2** — Onboarding artık boş bir Bugün ekranına değil, kendi verinden
üretilmiş bir sonuç ekranına çıkıyor: yılda paket, yılda para, yılda zaman,
bağımlılık düzeyin ve ilk 72 saatin ne olacağı. "Neden bırakıyorsun?" adımı
eklendi (8 adım); cevap bırakma planında saklanıyor ve bırakma gününde geri
gösteriliyor.

**Faz 3** — İlaç rehberi (8 madde, etki büyüklüğü + karşılaştırıldığı şey),
bırakma tarihi protokolü, bırakma günü ekranı, kayma/nüks öğretimi,
tetikleyicilerden tohumlanan nüks önleme planı, destek kişisi, PHQ-2 ruh
hâli taraması, kriz ekranında yardım hatları. Şema v5.

**Faz 4** — `StatusFlowScreen`: altı sayfa, kaydırmalı, her sayfada tek
metrik + tek büyük sayı + tek grafik + tek cümle. Ana ekrandan tek dokunuş.

**Faz 5** — Kilometre taşı kutlaması (konfeti yok: tek halka, tek sayı, tek
cümle; her taş yalnızca bir kez ve gösterilmeden önce kaydediliyor), üç
kademeli haptik dili, GitHub Actions CI (analyze --fatal-infos + test +
üretilmiş kodun güncelliği).

**Açık kalan tek madde:** gerçek cihaz koşusu (haptik teslimi, bildirim
teslimi, kare hızı, kaydırma hissi). Bu ancak bir telefonda doğrulanabilir.
