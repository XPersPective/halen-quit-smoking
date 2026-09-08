# Sigara Azaltma & Bırakma Uygulaması — Ön Araştırma ve Ürün Tasarım Raporu

**Tarih:** 6 Eylül 2026 · **Kapsam:** Pazar, rakip, bilimsel kanıt, ürün stratejisi, teknik mimari, monetizasyon, isim/ASO, risk
**Yöntem:** Güncel web araştırması (5 uzman araştırma dosyası: rakipler ~30 uygulama; bilimsel kanıt; mağaza kuralları/monetizasyon/hukuk; teknik stack; isim/pazar/ürün verisi). Tier-1 kaynaklar (WHO, CDC, NCI/Smokefree, Cochrane, PubMed, FDA, Apple/Google resmi dokümanları) önceliklendirildi; her önemli iddia kaynaklıdır. Mağaza yorumları yalnızca kullanıcı deneyimi verisi (Tier-3) olarak kullanıldı.
**Resmi ürün adı (karar):** **Halen: Quit Smoking Tracker** · TR mağaza adı: **Halen: Sigara Bırakma Sayacı** · kısa ad: **Halen** · GitHub repo: `halen-quit-smoking` · domain: **`halenquitsmoking.com`**

**Bu raporun temel dürüstlük ilkesi — Veri Sınıflandırma Tablosu.** Uygulamadaki her sayının hangi sınıfta olduğu tüm bölümlerde bu etiketlerle anılacaktır:

| Sınıf | Tanım | Uygulamadaki örnekler |
|---|---|---|
| **S1 — Doğrudan ölçülen** | Cihaz/sensörle gerçek ölçüm | **Yok.** Uygulamanın hiçbir biyolojik değeri ölçme yeteneği yoktur ve olmayacaktır. |
| **S2 — Kullanıcı girdisi** | Kullanıcının kaydettiği veri | Sigara olayları (zaman/sayı), tetikleyici etiketi, paket fiyatı, hedef |
| **S3 — Bilimsel modelleme** | Doğrulanmış farmakokinetik/istatistik modelden hesap | Tahmini nikotin maruziyet eğrisi (t½≈2h modeli), kaçınılan sigara, para tasarrufu, "yaklaşık X–Y hafta" tahmini |
| **S4 — Temsilî gösterim** | Popülasyon düzeyi genel bilgi, bireyselleştirilmiş gibi sunulamaz | WHO sağlık geri kazanım zaman çizelgesi, "sigara başına ~20 dk yaşam" |
| **S5 — Sunulması YASAK** | Ölçülmüş gibi gösterilirse yanıltıcı/etik dışı | "Kanındaki gerçek nikotin", "vücudundaki CO/katran miktarı", "akciğerin %X'i temizlendi", garanti bırakma tarihi, kişisel kanser riski % |

---

## 1. Executive Summary

**Ürün:** *Halen: Quit Smoking Tracker* (kısa ad: *Halen*) — cihaz üzerinde tamamen yerel çalışan, tek seferlik satın almaya dayalı, "azaltarak bırakma" odaklı premium bir sigara bırakma yardımcısı. Ana mekanizma: kullanıcının gerçek içme ritminden beslenen, bozulduğunda cezalandırmayan ve kendini otomatik yeniden optimize eden **dinamik azaltma planı**.

**Pazarın durumu (Eylül 2026):** Pazar büyük ve büyümede (küresel ~1,2 milyar tütün kullanıcısı — [WHO, Haz 2026](https://www.who.int/news-room/fact-sheets/detail/tobacco)); ancak kategori monetizasyon tarafında abonelik yorgunluğu yaşıyor: lider uygulamalar haftalık $6,49 (Kwit) ile aylık $19,99 (Quit Vaping) arası abonelik satıyor, kullanıcılar 1–2 yıldız yorumlarında bunu açıkça kızgınlıkla anlatıyor. Samimi tek seferlik fiyatlı rakipler yalnızca $4,99–5,99 bandında ve zayıf (EasyQuit Pro, Streaks). **$10–30 bandında "aboneliksiz, tam özellikli, gizlilik-öncelikli" bir ürün doğrudan açık bir boşluktur.** İkinci boşluk "azaltarak bırakma": kullanıcılar istiyor, pazar neredeyse boş (EasyQuit "Slow Mode", Flamy taper dışında ciddi uygulama yok). Üçüncü boşluk Türk pazarı: Yeşilay'ın resmi uygulaması 1,7–2,0 puan; yerli uygulamalar zayıf; küresel rakiplerin TR fiyatı (QuitNow PRO ₺1.989,99) pazar dışı.

**Bilimsel konum (dürüst):** Azaltarak bırakma, farmakolojik destekle beraber ani bırakma kadar etkilidir (Cochrane RR 1,01) ancak **desteksiz azaltmanın bırakma üstünlüğü kanıtlanmamıştır** — bu yüzden ürünümüz azaltmayı "bırakmaya köprü" olarak konumlandırır ve bunu kullanıcıya dürüstçe anlatır. Mobil uygulama kanıtı 2019 sonrası iyileşti ama kesinlik hâlâ düşük: iddialı vaat yerine süreç ödüllendirme (kayıt disiplini, plan uyumu, kriz atlattım sayısı) tasarlanır. Tüm biyolojik gösterimler S3/S4 etiketli; S5 kategorisindeki hiçbir gösterim üretilmez.

**Teknik:** Flutter 3.47 + drift (SQLite/SQLCipher) + Riverpod; StoreKit 2 ve Play Billing 8 ile **backend'siz** ömür boyu entitlement (mağaza kendisi entitlement'ı tutar, restore mağaza hesabından gelir); hiçbir analytics SDK, hiçbir reklam SDK, hiçbir hesap. "Verileriniz sunucuya gitmez" iddiası teknik olarak doğru kılınır (OS yedeklemeleri hariç tutulur ve metin buna göre yazılır).

**İş:** Free tier (sınırsız kayıt + temel sayaçlar) + ilk 7 gün tam premium + tek seferlik lifetime unlock. Fiyat: ABD $14,99 (lansman $9,99), TR ₺199,99, DE €14,99, UK £12,99, JP ¥2.200. İlk diller EN+TR+DE (v1), +JA/ES/FR (v1.x). İlk pazarlar: ABD, UK, TR, DE, JP.

**En büyük risk:** Bırakma/azaltma uygulamalarında kalıcılık — kullanıcı çoğunlukla ilk 1–2 haftada kayıt etmeyi bırakır. Buna karşı tasarım: minimum-effort kayıt (1 dokunuş, widget/kilit ekranı), günlük yeniden başlatma ("yeniden devam et"), streak kırılma cezasının olmaması.

---

## 2. Pazar Fırsatı

**Boyut.** WHO'nun Haziran 2026 güncellemesine göre dünyada ~1,2 milyar tütün kullanıcısı var ve tütün her yıl 7 milyon+ insanın ölümüne yol açıyor (1,6 milyonu ikinci el duman) — **not: 2025 öncesi kaynaklardaki "8 milyon/1,3 milyon" rakamları revize edildi, tüm kopya metinlerinde güncel rakam kullanılmalı** ([WHO fact sheet](https://www.who.int/news-room/fact-sheets/detail/tobacco)). Akciğer kanseri ölümlerinin ~%80–90'ı sigaraya bağlanıyor ([CDC](https://www.cdc.gov/lung-cancer/risk-factors/index.html)).

**Talep tarafı:** Sigara bırakma isteği döngüsel ve kalıcı bir ihtiyaç; tipik bir kullanıcı 6–30 deneme yapar ("30 deneme" viral rakamı model üst sınırıdır, gözlenen ortalama 6–10'dur — [Chaiton 2016, BMJ Open](https://bmjopen.bmj.com/content/6/6/e011045)). Her yıl milyonlarca yeni bırakma niyeti = kalıcı edinme kanalı. Sigara fiyatları enflasyonun üzerinde artıyor (TR: 2026'da ana akım paket ~₺100–150 — [fiyat listeleri](https://www.antalyahurses.com/guncel-zamli-sigara-fiyatlari/530457); ABD ort. $10,15; UK ~£16,5–17,8) → "ne kadar kazandım" frame'i her yıl daha güçlü.

**Ödeme tarafı:** Küresel tüketici uygulama harcaması 2024'te $127B; App Store $91,6B vs Google Play $35,7B ([Sensor Tower/TechCrunch](https://techcrunch.com/2024/12/18/app-downloads-decline-2-3-in-2024-but-consumer-spending-grows-to-127b/)) → iOS ağırlıklı pazarlara öncelik sağlık uygulamalarında gelir verimliliğini ikiye katlar.

**Pazar boşlukları (rakip analizi §4'ten):**
1. **Adil tek seferlik fiyat** ($10–30 lifetime, tam özellik) — neredeyse boş.
2. **Azaltma-first mod** — talep var (EasyQuit "Slow Mode" yorumları), ciddi uygulama yok.
3. **Veri güvenliği/portability** — "telefon değişince her şeyi kaybettim" #1 şikâyet kaynaklarından (EasyQuit); export/backup hediye bir farklılaştırıcı.
4. **Hesapsız, reklamsız, spam bildirimsiz premium UX** — EasyQuit/HabitKit yerel-yaklaşımının talep kanıtı.
5. **TR pazarı:** resmi Yeşilay uygulaması 1,7–2,0 puan; TR yerelleştirmesi iyi olan tek büyük oyuncu QuitNow ve TR fiyatı pazar dışı.

---

## 3. Kullanıcı Problemi

Kullanıcının gerçekte yaşadığı problem, "sigara içiyorum" değil, şu zincirdir:

1. **Niyet–eylem boşluğu:** "Azaltarak bırakacağım" der ama ne kadar azaltacağını, ne zaman bırakacağını bilmez; soğuk türkiye uygulaması başarısız olunca suçluluk duyar.
2. **Çaba/asimetrisi:** Mevcut uygulamalar günde sorular sorar, anket ister, "günlük kontrol" zorunluluğu koyar (quitSTART'ın kullanıcıyı yanlışlıkla "sıkıntıya girdin" olarak işaretleyen bug'ı mağaza puanını 4,6'dan 1,0'a düşürdü — [Play](https://play.google.com/store/apps/details?id=com.mmgct.quitstart)). Kullanıcı istatistik tutmak için değil bırakmak için gelir.
3. **Kriz anında destek yok:** İstek geldiğinde uygulamanın açılıp 3 menü gezdirilmesi gerçekçi değil; 30 saniyelik, tek dokunuşluk müdahale gerekir.
4. **Güven bunalımı:** Haftalık $6,49 abonelik + reklam + veri toplama + "sizde şu anda akciğerleriniz temizleniyor" gibi sahte biyolojik kesinlik. Kullanıcı hem parasından hem yalanından yoruldu.
5. **Nüks = ölüm hissi:** Çoğu uygulama "bırakma tarihiniz sıfırlandı" der; kullanıcı uygulamayı siler. Oysa relaps riski ilk haftalarda en yüksek ve zamanla hızla düşer ([Hughes 2004, Addiction](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1360-0443.2004.00540.x)); başarısızlık değil sürecin parçasıdır.

**Ürün tezi:** Kullanıcıya günde en fazla 5 saniye efor (1 dokunuş) maliyetiyle, planı bozsa bile kendini yeniden kuran bir sistem, dürüst geri bildirim ve kriz anında 30 saniyelik araç ver.

---

## 4. Rakip Analizi

~30 uygulama incelendi (App Store + Google Play, Eylül 2026). Özet tablo (puanlar/yorumlar mağaza sayfalarından; "est." = doğrulanamayan tahmin):

| Uygulama | Geliştirici (ülke) | iOS / Android puan | Monetizasyon | Notlar |
|---|---|---|---|---|
| **QuitNow!** | Fewlaps (ES) | 4,69 (13,6K) / 4,4 (68,8K) | Ücretsiz+reklam; PRO abonelik $2,99–34,99; ayrı tek seferlik PRO ₺1.989,99 | 80 milestone, topluluk sohbet; TR fiyatı pazar dışı; reklam/veri şikâyeti |
| **Kwit** | Kwit SAS (FR) | 4,66 (2,8K) / 4,3 (19,3K) | Ücretsiz+reklamsız; $6,49/**hafta**, $127,99/yıl, lifetime $169,99 | Seviye-gamification; "shady" deneme akışı şikâyeti |
| **Smoke Free** | 23 Ltd (UK) | 4,77 (57,3K) / 4,5 (60,2K) | Ücretsiz+reklam(Play); 7+ IAP SKU ($0,99–$209,99), uzman aboneliği $9,99/ay | En zengin özellik; upsell duvarı + Android reklam şikâyeti |
| **I Am Sober** | I Am Sober LLC (US) | 4,88 (186K) / 4,5 (141K) | Ücretsiz; Sober Plus $9,99/ay, $39,99/yıl | Genel bağımlılık; topluluk güçlü; "off-topic" akış şikâyeti |
| **Quit Tracker** | despDev | — / 4,8 (180K) | Ücretsiz+reklam+IAP | Para/"geri kazanılan yaşam" seviliyor; reklam toleranslı |
| **Flamy** | Offlinefirst (CY) | 4,93 (57) / 4,6 (19,4K) | Ücretsiz+reklam+IAP (tek seferlik, est.) | Taper modu, Craving SOS, Wear OS; iOS'ta zayıf |
| **EasyQuit** | Easy Health Apps (DE) | 4,67 (1,1K) / 4,6 (~106K) | Ücretsiz+reklam; **Pro $4,99 tek seferlik** | "No login, no collection" — en iyi gizlilik pozu; **veri kaybı** #1 şikâyet |
| **quitSTART** | NCI (US gov) | 4,57 (2,4K) / 1,0 (bug sonrası) | Tamamen ücretsiz | Bilim-temelli; temel UX hataları puanı yıktı — kalite dersi |
| **Quit Vaping** | J. Kopp (US) | 4,9 (12K) / — | $19,99/**ay** abonelik | Buddy System (eşli bırakma) benzersiz; fiyat sert |
| **Streaks** | Crunchy Bagel (AU) | 4,81 (27,4K) | **$5,99 tek seferlik** | Apple tasarım standardı; genel alışkanlık uygulaması |
| **HabitKit** | S. Röhl (DE) | 4,85 (2,4K) / 4,4 (11,7K) | Freemium; local-first | "Hesapsız, reklamsız" talep kanıtı |
| **QuitSure** | Rapidkart (IN) | 4,79 (1,6K) / 4,2 (12,1K) | 6 günlük ücretli program | Allen-Carr-tarzı "zihinsel" program |
| **My QuitBuddy** | Avustralya Hükümeti | 4,78 / 5,0 | Ücretsiz | Güçlü içerik; tarihî tasarım |
| **Unwinding (Dr. Jud)** | Sharecare (US) | 4,84 (4,9K) | Abonelik | Mindfulness; RCT'si (Craving-to-Quit) anlamlı bulunamadı — bkz. §15 |
| **Pelago (Quit Genius)** | Pelago (US) | — / 3,4 (2,5K) | İşveren/sağlık planı kapılı ~$20/ay | Klinik segment; tüketici değil |
| **Allen Carr Easyway** | Allen Carr (UK) | yeni (2025) | Program IAP $99–274 | Yöntem markası; eğitim kategorisi |
| **Bırakabilirsin** | Yeşilay (TR) | 1,74 (250) / 2,0 | Ücretsiz | TR'de resmi uygulama; puan çok düşük |
| **Sigara Savar / Sigarametre / NefesAl vb.** | TR yerli | 4,7–4,9 (küçük) | Reklam+IAP | Küçük, özellik-sayıca zayıf; TR yerelleştirme açığı |
| QuitGuide (NCI), Quit It, SmokeBeat, Quitter | — | — | — | **Kapanmış/listeden çıkmış** — kategori yüksek turnover |

### Kullanıcı sinyali analizi (mağaza yorumları, Tier-3)

**Rakiplerin çoğunda olan ama kullanıcıların sevmediği şeyler:**
- Abonelik fiyatları ve deneme-tuzak akışları (Kwit $6,49/hafta "shady"; I Am Sober "$40/yıl değmez"; Quit Vaping $19,99/ay)
- Reklamla bozulmuş ücretsiz katman (EasyQuit "ads ridiculous"; Smoke Free/Quit Tracker Play'de reklam)
- Günde soru/anket dayatması ve yanlış işleyen "kontrol" mekanikleri (quitSTART)
- Topluluk için zorunlu hesap (I Am Sober, QuitNow)
- Motivasyon sözü duvarı ("off-topic quotes")

**Rakiplerde eksik olan ama kullanıcıların istediği:**
- Cihaz değişiminde veri güvencesi (export/backup) — EasyQuit şikâyetlerinin başı
- Gerçekçi **azaltma/taper** planı (sadece EasyQuit Slow Mode, Flamy)
- Hesapsız + reklamsız + spam bildirimsiz kullanım
- Sigara içtikten sonra kötü hissettirmeyen, nüksü normalleştiren dil
- Makul fiyatlı lifetime seçeneği

**Kesinlikle yapılacaklar (kanıt: yukarıdaki sinyaller):** tek dokunuş kayıt + widget/kilit ekranı; para + kaçınılan sigara sayaçları; sağlık zaman çizelgesi (WHO kopyasıyla); milestone/başarı sistemi (abartısız); nükste "yeniden devam et"; export + (opsiyonel) cihazlar arası kendi eliyle transfer; hesapsız yerel çalışma; lifetime fiyat.

**Kesinlikle yapılmayacaklar:** haftalık abonelik; reklam SDK'sı; zorunlu hesap; topluluk (backend bağımlılığı); hipnoz/"güçlü zihin" programı iddiası; günde anket; AI koç (sunucu bağımlılığı + kanıt zayıf); "sizi anlıyoruz" tarzı fake-empathy chatbot.

**ASO gözlemi:** Başlıklar "Brand + Quit/Stop Smoking" kalıbında ([QuitNow "Quit smoking for good"](https://apps.apple.com/us/app/quitnow/id483994930), [Smoke Free "Quit Smoking Now"](https://apps.apple.com/us/app/smoke-free-quit-smoking-now/id577767592), [quitSTART](https://apps.apple.com/us/app/quitstart-quit-smoking/id494552000)). Az kullanılan anahtar kelimeler: "quit nicotine", "smoking reduction / taper", "days since cigarette", "no subscription", TR: "sigara bırakma sayacı". Kategori: Health & Fitness.

---

## 5. Kullanıcı Segmentleri

| Segment | Tanım | Ürün yaklaşımı |
|---|---|---|
| **S-Azalt (çekirdek hedef)** | Günde 10–20, çoğunlukla 5+ yıldır içen, bırakmaya "hazır değilim ama azaltayım" diyen | Ana ürün: dinamik azaltma planı |
| **S-Bırak-Hazır** | Tarih koyup ani bırakacak, denemiş ve başarısız | Bırakma programı (§10) + ilk 72 saat yoğun destek |
| **S-Kararsız** | "Bir bakayım" indiren; günde 5–10 | Onboarding'de "azaltarak başla" önerisi; düşük efor modu |
| **S-Ağır** | Günde 20+; ilk sigaraya uyanınca <5 dk (HSI yüksek — [Branstetter 2020](https://pmc.ncbi.nlm.nih.gov/articles/PMC7358112/)) | Daha yavaş tempo (haftalık %8–10), hedefin tıbbi kişiselleştirilmesi YOK, "profesyonel destek" yönlendirmesi görünür |
| **S-Hafif/sosyal** | Günde <5, sosyal/stres tetikli | Basit sayaç + tetikleyici farkındalık; hızlı yol bırakma programına |
| **S-Tekrar-deneyen** | 1+ başarısız deneme | Nüks-normalleştirme dili, "geçmiş denemelerim" defteri |
| **Yaş etkisi** | 18–24: vaping karışımı, kısa denemeler, gamification hassasiyeti; 35+: para motivasyonu güçlü; 55+: sağlık motivasyonu, büyük tipografi | Ton ve vurgu kişiselleşir; plan algoritması yaşa göre değişmez (tıbbi gerekçe yok) |

**Etik kısıt:** Hiçbir segmente tıbbi/doza dayalı kişiselleştirme yapılmaz (ör. "senin metabolizmana göre X mg"); plan yalnızca davranışsal hız ayarlamasıdır. 18 yaş altı: uygulama reşit olmayanlara yönelik değildir; kaynak listeleri (Yeşilay 176, 1-800-QUIT-NOW vb.) yaş ne olursa gösterilir.

## 6. Ürün Konsepti

**5 saniyelik tanım:** "Halen, sigaranı günde bir dokunuşla kaydettiğin, planın bozulsa bile kendini yeniden kuran, aboneliksiz ve tamamen telefonunda çalışan bir bırakma yardımcısıdır."

**Bir cümlelik değer önerisi:** "Azaltarak bırakmanın en dürüst yolu — planını seninle birlikte yeniden hesaplayan, hiçbir şeyini sunucuya göndermeyen, tek seferlik fiyatlı bir uygulama."

**"Sigara sayacından" bırakma yardımcısına geçiş üç mekanizmayla olur:**
1. **Plan katmanı:** Sayaç "kaç içtin" der; plan "şimdi en uygun sonraki adımın ne" der (§14).
2. **Dürüstlük katmanı:** Ekrandaki her türetilmiş sayı, kaynağını tek dokunuşla açıklar ("Bu tahmin nasıl hesaplandı?" sayfası: model, varsayım, sınırlılık). Rakiplerde yok.
3. **Kriz katmanı:** İstek anında 30 saniyelik müdahale + atlattın-kayıtı (§15).

**Kullanıcı neden para vermeli?** Ücretsiz katman kaydı asla engellemez (etik + satın alma sonrası değer güvencesi); ancak 3. günden sonra kullanıcının en çok baktığı şeyler — azaltma planının kendisi, haftalık grafikler, tetikleyici analizi, tam sağlık zaman çizelgesi, widget — premium'dadır. Ödeme anı, kullanıcının değer gördüğü kanıtlanmış bir anın (örn. "bu hafta planına %87 uyudun") hemen sonrasına kurulur; onboarding ortasında paywall yok. Tek seferlik fiyat + "verin asla kaybolmaz" + restore, şikâyet listesindeki en büyük üç ağrıya doğrudan cevaptır.

## 7. Benzersiz Değer Önerisi

1. **En güçlü fark — Kendini yeniden kuran plan (Adaptive Taper):** Bugünün hedefini kaçırırsan uygulama sizi cezalandırmaz, kalan günü ve haftayı yeniden optimal biçimde dağıtır ("Bugünkü plana göre yeniden hesapladık" ekranı). Rakiplerin taper'ları statik azaltma tablosudur (EasyQuit) veya hiç yoktur.
2. **İkinci fark — Dürüst veri katmanı:** Tüm S3/S4 gösterimlerde kaynak etiketi + "Bu tahmin nasıl hesaplandı?" şeffaflık ekranı; S5 gösterimlerin hiçbirinin olmaması. Premium algıyı bilimsel alçakgönüllülük yaratır — sağlık uygulamasında güven = dönüşüm.
3. **Üçüncü fark — Gizlilik + adil fiyat birleşimi:** "Hesap yok, sunucu yok, reklam yok, abonelik yok" dörtlüsünü aynı üründe sunan bilinen bir rakip yok.

## 8. Temel Özellikler (öncelik işaretli; P0=olmazsa olmaz, P1=çok değerli, P2=sonraki sürüm, P3=yapılmayacak)

| Özellik | Öncelik | Sınıf |
|---|---|---|
| Tek dokunuş "İçtim" kaydı (+istek etiketi opsiyonel) | P0 | S2 |
| Dinamik azaltma planı motoru (yeniden optimizasyon) | P0 | S3 |
| BUGÜN ana ekranı (hedef ringi, son sigara, sonraki hedef) | P0 | S2/S3 |
| Para tasarrufu (kullanıcı fiyatı, ülke para birimi) | P0 | S3 |
| WHO kaynaklı sağlık geri kazanım zaman çizelgesi | P0 | S4 |
| Craving SOS (4D + nefes + erteleme sayacı + "atlattım" kaydı) | P0 | S2 |
| Yerel DB + şifreleme + JSON/CSV export & import | P0 | S2 |
| Lifetime satın alma + Restore (StoreKit 2 / Play Billing) | P0 | — |
| Bildirimler (plan hatırlatma, günlük özet, kriz desteği; yoğunluk ayarı) | P0 | — |
| Grafikler: günlük sayı, plan/gerçekleşen, sigara-arası süre, saatlik ısı, tasarruf | P0 | S2/S3 |
| Basit tetikleyici etiketleri (kahve, yemek sonrası, stres, alkol, araba, sosyal, iş molası, uyku öncesi) | P0 | S2 |
| Widget (iOS interaktif iOS17+ / Android) | P1 | S2/S3 |
| Kilit ekranı/Kontrol Merkezi hızlı kayıt (iOS 18 ControlWidget), Android QS tile | P1 | S2 |
| Tetikleyici ilişki analizi ("kahveden sonraki 15 dk" kalıbı, n≥10 filtresi) | P1 | S3 |
| Paket barkod tarama → yerel katalog (marka/varyant adı) | P1 | S2 |
| "Yaklaşık kaç hafta kaldı" aralık tahmini | P1 | S3 |
| İçerik kütüphanesi (kaynaklı, kategorili) | P1 | S4 |
| Apple Watch / Wear OS | P2 | S2 |
| Ay/yıl karşılaştırmalı ileri analizler | P2 | S3 |
| Vaping/nikotin poşeti takibi (ayrı ürün tipi) | P2 | S2 |
| **Yapılmayacaklar (P3):** AI chat koçu, topluluk/sosyal, hipnoz programı, "akciğer temizliği" animasyonları, kan/CO "ölçümü", reklam, hesap/zorunlu bulut | P3 | — |

## 9. MVP

**Tanım:** 12–14 ekran, 3 dil (EN/TR/DE), 2 platform, backend yok. MVP'de P0 listesinin tamamı + widget (P1) — çünkü widget tek-dokunuş kaydın ana yüzeyidir ve kategori deneyiminde en çok övülen özelliklerden (Flamy/QuitNow yorumları).

**MVP'den çıkarılanlar:** barkod tarama (v1.1), tetikleyici otomatik ilişki analizi (v1.1, ilk veri birikimi sonrası zaten anlamlı olur), watch, içerik kütüphanesi genişletmesi. **Kesin silinenler:** AI koç, topluluk, kamera ile sağlık uyarısı OCR'ı (bölüm 13'te gerekçesi), "nikotin vücutta şu an X mg" ekranı.

## 10. V1 / V2 / V3 Roadmap

- **V1 (MVP, 0–3 ay):** P0 + widget; EN/TR/DE; ABD, UK, TR, DE lansmanı.
- **V1.1–V1.2 (3–6 ay):** barkod+katalog, tetikleyici analizi, JA/ES/FR, bırakma programı zenginleştirme (§10b), ControlWidget/QS tile, ASO iterasyonu.
- **V2 (6–12 ay):** vaping/poşet ürün tipleri, ileri grafikler, "bırakma sonrası yaşam" modu (uzun vadeli health timeline), optional şifreli (kullanıcı-kilidili) yedek dosya, erişilebilirlik sertleştirme.
- **V3 (12+ ay):** Apple Watch / Wear OS mini uygulama (native, 2–4 hafta/is plat.), Live Activity (aktif istek-erteleme sayacı kilit ekranında), belki hekim raporu paylaşımı (PDF özet).

### 10b. Bırakma Programı (ani bırakmayı seçenler için; §10'un parçası)

Bölümler: hazırlık haftası (tetikleyici envanteri + "nedenim" kaydı + implementation intention cümlesi: "X olursa Y yapacağım" — meta-analiz d≈0,65, [Gollwitzer & Sheeran 2006](https://www.sciencedirect.com/science/chapter/bookseries/pii/S0065260106380021)) → bırakma günü → ilk 24 saat (nikotin eğrisi düşüşü gösterimi, S3) → ilk 72 saat (fiziksel yoksunluk zirvesi; yoğun destek) → 1. hafta → 2–4. hafta → sonrası. **Dil kuralı:** "21 günde bırakırsın" yasak; gerçek dil: "İstekler ilk hafta en sık gelir ve zamanla azalır" ([Hughes 2004](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1360-0443.2004.00540.x)); alışkanlık otomatikleşmesi medyan ~66 gün, kişiye 18–254 gün arası değişir ([Lally 2010](https://onlinelibrary.wiley.com/doi/abs/10.1002/ejsp.674)).

## 11. Onboarding (7 adım, <90 saniye, hesap yok)

| # | Soru | Neden soruluyor (ölçülebilirlik) |
|---|---|---|
| 1 | Yaş grubu (18–24 / 25–34 / 35–44 / 45–54 / 55+ / 18 yaş altı) | Ton/ihbar uyumu; 18 altıysa ebeveyn+genç kaynak yönlendirmesi. **Doğum tarihi istenmez** (minimum veri). |
| 2 | Günlük ortalama sigara (slider) | Planın başlangıç noktası (S2). İlk hafta kullanıcının gerçek kayıtlarıyla kalibre edilir. |
| 3 | Uyanınca ilk sigaraya kaç dk? (<5 / 5–30 / 31–60 / 60+) | HSI/FTND'nin en güçlü tek maddesi — bağımlılık proxy'si ([HSI doğrulaması](https://www.tobaccoinducediseases.org/Agreement-between-the-Fagerstrom-test-for-nicotine-ndependence-FTND-and-the-heaviness,155376,0,2.html)); tempo önerisi (yavaş/standart) için. Tıbbi etiket YOK. |
| 4 | Paket fiyatı (ülke varsayılanı ön-dolu, düzenlenebilir) | Tasarruf hesabı (S2/S3). |
| 5 | Ne zaman içersin? (çoklu: kahve, yemek sonrası, stres, alkol, araba, sosyal, iş molası, uyku öncesi, uyanınca) | Günlük planın saat dağılımı + tetikleyici modeli tohumu (S2). |
| 6 | Hedefin? (Azaltarak bırak ←önerilen / Hemen bırak / Kararsızım) | Program tipi seçimi. Kararsıza "azaltarak başla, sonra karar ver" sunulur. |
| 7 | (opsiyonel) Marka/ürün | Tasarruf hassasiyeti + katalog tohumu; atlanabilir. |

**Bilinçli olarak sorulmayanlar:** cinsiyet, doğum tarihi, ağırlık/boy, sağlık durumu, hamilelik durumu (veri minimizasyonu; güvenlik notu genel ekranla verilir: "Hamilelik, kalp hastalığı gibi özel durumlarda bırakma planını bir sağlık profesyoneliyle konuşun"). Kaç yıldır içtiği sorulmaz (plan algoritmasına girdisi yok; motivasyon içeriğinde v2'de opsiyonel olabilir).

## 12. Ana Ekran UX ve Tasarım Dili

**Ana ekran (BUGÜN):**

```
┌────────────────────────────────────┐
│  Halen · 6 Eylül                   │
│                                    │
│      ╭──────────────╮              │
│      │    6 / 8     │  bugün       │
│      │   (ring)     │              │
│      ╰──────────────╯              │
│  Son sigara: 42 dk önce            │
│  Sonraki hedef: en erken 38 dk sonra│
│  ~ nikotin eğrisi (mini, S3)       │
│                                    │
│  ┌──────────────────────────────┐  │
│  │        İÇTİM                 │  │  ← tek büyük CTA
│  └──────────────────────────────┘  │
│  ✋ İstek atlattım (2 bugün)        │
│                                    │
│  💰 41 ₺ kazandın · 2 sigara atladın│
│  ❤ 3 hafta sonra: dolaşım iyileşiyor│
└────────────────────────────────────┘
```

Kural: birincil aksiyon tek ve ekranda en büyük öğe; ikincil "atlattım" aksiyonu pozitif kayıt (Quit Tracker'ın en sevilen özelliğinin temiz hali); tüm sayılar tek dokunuşla kaynağını açar.

**Tasarım dili:** sıcak nötr zemin (kırık beyaz/koyu grafit), birincil renk derin petrol yeşili (güven/sağlık), tek amber vurgu yalnızca CTA'da; tipografi SF Pro / Inter, Dynamic Type zorunlu; 8pt grid; sigara görseli/paket fotoğrafı yok, gore yok; motion yumuşak (200–300ms, ease-out), "reduce motion" ayarı destekli; ikonlar soyut-nefes temalı (kesik halka, dalga). Çocukça gamification maskotları yok. iOS'ta native his (SF Symbols, swipe-back), Android'de Material 3 uyumu.

**Erişilebilirlik (P0):** VoiceOver/TalkBack etiketleri (özellikle grafiklerin sözel özetleri: "dün 9, hedef 8, plana uyum %89"), WCAG AA kontrast, 44pt+ dokunma hedefleri, renk-körü güvenli palet (kırmızı-yeşil çiftine bilgi yükü vermeme), Dynamic Type, reduce-motion.

### 12.1. Görsel revizyon — 8 Eylül 2026

Yukarıdaki ilk tel kafesin yerine uygulanan düzen: marka ve gün başlığı → koyu orman yeşili günlük odak kartı (kayıt/hedef, son kayıt, sonraki aralık) → tek dokunuşla kayıt ve istek atlatma → tasarruf ve nefes molası → günlük kayıtlar. Tahmini maruziyet eğrisi isteğe bağlı açılan kartta; model açıklamasına buradan ulaşılır. Sayaç tüketimi bir başarı puanı gibi sunmaz; “hak kaldı” ve aşımda kırmızı renk kullanılmaz.

Grafikler: tasarruf özeti, erişilebilir kategori seçimleri, haftalık kayıt sütunları ve ayrı hedef çizgileri. Saatlik dağılım sakin bir palette; aralık grafiği yoğun kayıtta yatay kayar. Tetikleyiciler aynı renk ailesinde, ad ve sayı ile okunur. Veri yokken temsili sonuç üretilmez. Yeni metinler TR/EN/DE yerelleştirmelerine dahildir.

Görsel dil: sıcak taş rengi zemin, beyaz yüzeyler, orman yeşili odak alanları, açık adaçayı vurguları; amber kayıt aksiyonunda. Daha belirgin başlıklar, 20–24 dp içerik boşluğu, 24–28 dp kart köşeleri. Koyu tema ve dar ekranda büyütülmüş metin için esnek yerleşim. Onboarding adımları görünür ilerleme şeridiyle, kriz ekranı okunur dakika:saniye sayacıyla sunulur.

### 12.2. Görsel revizyon — 8 Eylül 2026 (ikinci geçiş)

2026 kategori trendleri (koyu hero kart + dev tipografi + yumuşak gradyan derinlik + tonal yüzeyler; Smoke Free / QuitNow / I Am Sober / Streaks deseni) temel alınarak uygulanan sistemsel yenileme: tek tema dosyasından tüm ekranları kaldıran yeniden yazım — sıcak kâğıt zemin (#F6F4EE) / yeşil-siyah koyu tema (#0C1512), ışık modunda çerçevesiz kartlar + yumuşak gölge, koyu modda tonal saç çizgisi; hero kartlarda radyal ışık dokusu; kalın gradyan halka (gün bütçesi, SOS geri sayımı) parlak uç noktalı; kesikli hedef çizgileri, geçmişe göre %38 saydam + bugün dolgun çubuklar; tetikleyiciler tek sakin renk ailesinde sıra tonlarıyla. Seçili çip etiketi kontrastı durum-çözümlü varsayılana bırakıldı; ikincil metin kontrastı AA için koyulaştırıldı (bugünkü 8.5/10 görsel puan). Kullanılmayan HourlyBarsChart silindi; bozuk utf-8 karakterleri (â€”, â†') temizlendi. İkinci geçişin grafik ayağı: kategori liderlerinin gösterge envanteri (halka göstergesi, büyük sayı kartları, gradyan alan trend eğrisi, dokunmatik ipuçlı yuvarlak çubuklar, milestone ilerleme çubuğu — QuitNow 80 milestone sistemi, Smoke Free tasarruf eğrisi, Streaks halka göstergeleri) uyarlandı: fl_chart 1.2 eklendi (animasyon + dokunmatik tooltip için standart kütüphane); günlük grafik fl_chart BarChart'a taşındı (bugün vurgulu, her çubuğun yanında ince hedef çubuğu), tasarruf hero'sunun içine kümülatif gradyan alan eğrisi, seri kartına 7 günlük milestone ilerleme çubuğu geldi.

---

## 13. Sigara Kayıt Sistemi + Paket Tarama Araştırması

**Kayıt (P0):** Ana CTA tek dokunuş; kayıt sonrası alt-sayfa kapanır, küçük "neden? (opsiyonel)" çipi 8 saniye görünür: tetikleyici/ortam/mood tek satır işaretlenebilir. Kayıt iddiasız ve hızlı: tarih/saat/tanımlayıcı otomatik, günlük toplam + aralık + plan durumu anında işlenir. Kayıt yüzeyleri: uygulama CTA'sı, widget butonu (iOS 17 interaktif widget App Intent ile uygulama açılmadan yazar; Android RemoteViews + broadcast), iOS 18 ControlWidget, Android QS tile, bildirim aksiyon butonu.

**Paket tarama araştırmasının dürüst sonucu:** Brief'teki "kamerayla paketi tara → nikotin/katran/CO değeri" fikri **veri kaynağı açısından çürük**, çünkü: (1) EU TPD Art. 13(1)(a) paketlerde nikotin/katran/CO değeri **basılmasını yasaklar** ([EUR-Lex 2014/40/EU](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32014L0040)); (2) Türkiye 2019'dan beri düz (plain) paket uygulamasında ve değerler basılmıyor ([WHO Europe](https://www.who.int/europe/news/item/15-01-2019-turkey-opts-for-plain-packaging-of-tobacco-products), [tobaccocontrollaws](https://www.tobaccocontrollaws.org/legislation/turkey/summary)); (3) ABD'de de FTC 2008'den beri makine değerleri yasak ([FTC](https://www.ftc.gov/news-events/news/press-releases/2008/11/ftc-rescinds-guidance-1966-statements-concerning-tar-nicotine-yields)). Kamuya açık barkodlu ürün DB'si yok: FDA'nın ~17k ürünlü veritabanı GTIN kapsamı belirsiz ([FDA](https://www.fda.gov/tobacco-products/ctp-newsroom/fda-launches-searchable-tobacco-products-database)), EU track&trace kapalı erişim ([EC](https://health.ec.europa.eu/tobacco/product-regulation/systems-tobacco-traceability-and-security-features_en)), ticari barkod API'lerinde tütün kapsamı düzensiz ve lisanslı. Sağlık uyarısı metinlerinin OCR'ı teknik olarak mümkün ama ürün değerine katkısı yok.

**Bu yüzden tasarım (v1.1, P1):** barkod (EAN-13) → **yerel seed katalog** (lansman pazarlarının en çok satan ~300–500 SKU'su, marka/varyant adı + paket içindeki adet; uygulama güncellemeleriyle büyür) + bulanık isim arama + manuel giriş fallback; yanlış eşleşmede düzeltme ekranı. **Nikotin değeri paketten ASLA alınmaz:** farmakoloji sabiti kullanılır — sigara başına sistemik emilim **~1–1,5 mg** ([Benowitz, NEJM 2010](https://pmc.ncbi.nlm.nih.gov/articles/PMC2953858/)); makine "0,6 mg" etiketi gerçek alımı yansıtmaz (smokers compensate). Marka adı gösterimi: düz metin, nominative fair use çerçevesinde güvenli kabul edilir, logo/paket görseli kullanılmaz, sponsorluk izlenimi verilmez ([New Kids on the Block testi](https://cyber.harvard.edu/metaschool/fisher/domain/tmcases/newkids.htm)).

## 14. Dinamik Azaltma Programı ve Algoritması

**Program süreleri ve bilimsel konumları (dürüst):** 7/14/21/30 günlük ve 6 haftalık sabit programlar pazarlama ürünüdür; literatürde "kaç haftada azaltarak bırak" doğrulanmış bir takvim yoktur. Bilinen: (a) NRT/bulpalarla desteklenen kademeli azaltma, ani bırakma kadar etkilidir (Cochrane RR 1,01, 22 çalışma; [Lindson 2019](https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD013183.pub2/full)); (b) **desteksiz** azaltmanın bırakma üstünlüğü kanıtsızdır (RR 1,74, %95 GA 0,90–3,38, düşük kesinlik); (c) Haftalık %10–25 azaltma pratikte tolere edilebilir ve klinik azaltma çalışmalarında kullanılan aralıktır. Bu yüzden ürünümüz süreleri **hız tercihi** olarak sunar (Sakin ≈ 8 hafta, Standart ≈ 6 hafta, Hızlı ≈ 4 hafta; her biri haftalık %8–10 / %12–15 / %18–22 azaltma) ve "hedef tarihi" vaat değil eğilim olarak gösterir. Her programın açıklama sayfası: avantaj, dezavantaj, kimlere uygun, bozulunca ne olduğu.

**Algoritma (deterministik kural motoru, AI yok):**

Girdiler: bazal tüketim (onboarding değeri → ilk 7 gün gerçek kayıtlarla kalibrasyon), TTFC grubu, saat histogramı, hedef tipi + hız tercihi, son 7/14 günlük uyum oranı, sigara-arası medyan süre.

Çıktılar:
1. **Günlük bütçe:** `hedef_gün = önceki_hafta_ort × (1 − haftalık_oran)`, alt sınıra yuvarlanır (aşama basamakları 10→9→8… mekanik değil; kullanıcının fiili ritmi taban).
2. **Zaman pencereleri:** kullanıcının tarihsel saat histogramından k-means yerine basit "pencere kümeleme" (yogun saat blokları); her sigara için hedef aralık = medyan gap ± %25 tampon. Günde 5 sigara altı kullanıcıda pencere yerine sadece "min aralık" kuralı.
3. **Sonraki öneri:** `son_sigara + medyan_gap × tempo_çarpanı`; gün bütçesi bitince "bugünlük tamamlandı" durumu; aşım varsa öneri ertelenir.
4. **Dinamik yeniden hesap (ürünün kalbi):** her kayıtta günlük kalan bütçe/kalan saat kontrolü; aşım tespitinde (a) günlük hedef kalan sayıya göre yeniden dağıtılır, (b) aşım "sıkışma" desenyse (arıklı kayıtlar) mesaj: "Bugünkü tüketimin planlanan aralığın üzerinde sıkışmış; bir sonrakini planlanan zamana yaklaştırmayı dene."; (c) haftalık bütçe taşarsa sonraki hafta başlangıcı %5 yumuşatılır. **Ceza UI yok, kırmızı yok, "başarısız oldun" yok; metin: "Yeniden hesapladık."**
5. **Tempo adaptasyonu:** 7 günlük uyum ≥%85 → tempo önerisi artır; ≤%55 → program süresi otomatik uzar (faz), kullanıcıya "tempoyu gerçeklerine göre ayarladık"; TTFC<5 dk (HSI yüksek) kullanıcıda başlangıç tempoyla +1 hafta esneklik.
6. **Bırakma günü geçişi:** günlük bütçe ≤3'e indiğinde plan "son hafta" fazına geçer; kullanıcıdan tarih onayı ister (vaat değil plan), sonra bırakma programına (§10b) devreder.
7. **"Kaç günde bırakırım?" cevabı formatı:** "Son 7 günün ilerlemesi bu hızla sürerse hedefe yaklaşık **X–Y hafta** içinde ulaşman mümkün görünüyor" — S3 etiketli, çift taraflı aralık, garantili tarih yok; tahmin her hafta güncellenir.

**Tıbbi sınır notu (S5):** Algoritma davranışsal hız yönetimidir; dozaj/ilaç/meta­bolizma iddiası içermez. Ağır bağımlılık profili + tekrarlayan başarısızlıkta ekranda kalıcı kaynak: "Bir sağlık profesyoneli bırakma yöntemlerini (nikotin replasman tedavisi vb. dahil) sizinle konuşabilir" (ürün kendisi NRT önermez — brief kuralı).

## 15. Craving / Kriz Yönetimi (kanıt etiketleriyle)

| Teknik | Kanıt | Uygulamada kullanım |
|---|---|---|
| Erteleme (2 dk sayaç) | Smokefree resmi öneri: "istek genellikle birkaç dakika sürer, bekleyin" ([NCI Clearing the Air](https://smokefree.gov/sites/default/files/pdf/clearing-the-air-accessible.pdf)); kesin "3–5 dk" sayısını doğrulayan çalışma yok → süre sayacı süre taahhüdü vermez | Ana müdahale: tam ekran sayaç + ilerleme |
| 4D (Delay, Deep breathing, Drink water, Do something else) | Smokefree/NCI resmi yönerge ([how to manage cravings](https://smokefree.gov/challenges-when-quitting/cravings-triggers/how-manage-cravings)) — yönerge düzeyinde güçlü, sonuç çalışması zayıf | Sayaç ekranında 4 adımlı kart |
| Nefes egzersizi (kutu nefesi) | Stres/anlık rahatlama genel kanıtı orta; sigara isteğine özel RCT yok — "kanıtlanmış tedavi" dili yasak | 60 sn rehberli animasyon |
| Kısa egzersiz/yürüyüş | Akut istek azaltımında orta kanıt ([Cochrane Roberts 2017](https://pmc.ncbi.nlm.nih.gov/articles/PMC6819982/); 2023 meta) | "2 dk yürü" görevi |
| Urge surfing / mindfulness | **Dürüst konum:** Craving-to-Quit RCT'sinde 6. ay 7-gün abstinenlik farkı anlamlı çıkmadı (9,8% vs 12,1%; [Garrison 2020](https://pmc.ncbi.nlm.nih.gov/articles/PMC7297096/)) → "istekleri gözlemle, geçer" tekniği sunulur ama "kanıtlanmış yöntem" denmez | "İzle ve bekle" modu |
| Akupresür/masaj | Zayıf/karışık; etkinlik nokta-lokasyonuna bağlı görünmüyor ([umbrella review 2024](https://www.tobaccoinducediseases.org/Acupuncture-and-related-acupoint-therapies-for-smoking-cessation-An-umbrella-review,186147,0,2.html)) | **Dahil edilmez** (bilimsel sunum riski > fayda) |
| Ağız/eld substitution | Resmi öneri; doğrudan çalışma yok (zayıf) | Check-list öğesi |
| "Nikotin replasman ürünü kullan" | NRT güçlü kanıtlı (RR≈1,55; [Cochrane Hartmann-Boyce](https://pubmed.ncbi.nlm.nih.gov/29852054/)) ama ürün kapsamı dışı | Craving ekranında sabit satır: "NRT gibi seçenekleri bir sağlık profesyoneliyle konuşabilirsin" |

**Kriz akışı:** İstek bildirimi/kilit ekranı → "İstek atlatıyorum" butonu → 2 dk sayaç + 4D kartları → sonuç kaydı: "Atlattım" (pozitif sayaç) veya "İçtim" (kayıta yönlendir, utanç dili yok, plan yeniden hesaplanır). Craving günlüğü: her olay zaman + yoğunluk (3'lü) + tetikleyici etiketi → §19 modelini besler.

## 16. Motivasyon Sistemi

Ölçülen gerçeklerden beslenir, klişe söz duvarı değildir: bugün kaçınılan sigara (S3), tasarruf (S3), plan uyum yüzdesi (S3), atlattığın istek sayısı (S2), art arda "hedef içinde" günler (S3), WHO zaman çizelgesinde sıradaki eşik (S4). **Dil kuralları:** suçluluk yok, kırmızı "kaçırdın" yok; başarı çerçevesi "süreç" (kayıt disiplini, uyum) + "sonuç" (sayılar) dengeli. **Streak tasarımı:** kırılan streak'i vurgulamamak — tüketici davranışı araştırması, kırılan streak'in geri dönüşü azalttığını gösteriyor ([Barasch 2023 "Broken Records"](https://www.colorado.edu/business/news/2023/04/20/research-streaks-marketing-tech-barasch); [Silverman 2022](https://udspace.udel.edu/items/42ce576b-8e1f-429a-8541-e29e48dbcfbb)) → seriler "en uzun" olarak saklanır, bozulunca ekrana "yeniden başlamak normaldir" + yeni sayaç gelir, sıfır sayacı gösterilmez. Gamification: rozet/milestone (1 hafta plan uyumu, 10 istek atlattım…) abartısız; seviye/XP sistemi yok (çocukça algı + baskı riski; gamification'ın etkisi sağlıkta küçük-orta ve ağırlıkla engagement üzerinde — [meta-analizler 2022–2024]).

## 17. Sağlık İlerlemesi (Health Timeline)

Kaynak: WHO Q&A ([health benefits of smoking cessation](https://www.who.int/news-room/questions-and-answers/item/tobacco-health-benefits-of-smoking-cessation)) + CDC broşürü ([CDC Stacks](https://stacks.cdc.gov/view/cdc/41642)):

- 20 dk: nabız/tansiyon düşüşü · 12 sa: kan CO düzeyi normale döner · 2–12 hafta: dolaşım ve akciğer fonksiyonu iyileşir · 1–9 ay: öksürük/nefes darlığı azalır · 1 yıl: koroner kalp hastalığı riski sigara içenin yaklaşık yarısı · 5–15 yıl: inme riski içmeyen seviyesine iner (WHO "5–15 yıl" sınırlarını kullanır; CDC materyalleri 2–5 yıl der — **WHO kalıp alınır**) · 10 yıl: akciğer kanseri riski yaklaşık yarıya iner · 15 yıl: koroner risk hiç içmemiş gibi.

**Dil kuralı (S4):** Ekran metni "Genel olarak, sigarayı bırakanlarda…" kalıbıyla; "sende şu anda kesin olarak şu gerçekleşti" yasak. Azaltma modunda çizelge bırakma günü kilitleninceye kadar "önizleme" olarak görünür (tarih şeridi "bıraktığın gün itibarıyla").

## 18. Nikotin Modelinin Bilimsel Sınırları

**Model (S3):** Her sigara = 1,2 mg sistemik emilim varsayımı ([1–1,5 mg, Benowitz NEJM 2010](https://pmc.ncbi.nlm.nih.gov/articles/PMC2953858/)); plazma vekil eğrisi `C(t)=Σ d·2^(−Δt/2h)`; nikotin plazma yarı ömrü ~2 sa (1–3 sa) ([Hukkanen 2005, Pharmacol Rev](https://pubmed.ncbi.nlm.nih.gov/15661022/)); beyne ulaşıp etki başlangıcı 10–20 sn; kotinin yarı ömrü ~16 sa (uzun vadeli iz için içeride tutulur ama kullanıcıya gösterilmez).

**Gösterim kararları:**
- Ekranda **0–100 normalize "tahmini nikotin maruziyet eğrisi"** (mutlak ng/mL gösterilmez — kişisel metabolizma, çekim derinliği, sigara tipi değişkenliği ng/mL'yi anlamsız bir kesinlik hissi yaratır).
- Etiket her yerde: "tahmini · model". "Kanındaki nikotin", "vücudundaki gerçek değer" ifadeleri yasak (S5).
- CO: bırakma sonrası genel bilgi kartı ("kan CO düzeyi ~12 saatte normale döner — WHO") + sigara sayısına bağlı temsilî eğri **yalnızca azaltma modunda** "tahmini maruziyet" çerçevesinde; COHb yarı ömrü ~4–5 sa oda havasında ([ATSDR](https://www.atsdr.cdc.gov/toxprofiles/tp201.pdf)). **Kan CO "ölçümü" gibi sunum yasak.**
- **Katran: modelleme yapılmaz** (S5). Gerekçe: makine değerleri gerçek alımı temsil etmiyor ([FTC 2008](https://www.ftc.gov/news-events/news/press-releases/2008/11/ftc-rescinds-guidance-1966-statements-concerning-tar-nicotine-yields)), gerçek insan katran maruziyeti girdi-sigara sayısından bilimsel olarak türetilemez. Katran yerine "toplam içilen / kaçınılan sigara" gösterilir.
- Tüm S3 ekranlarda "?" → "Bu tahmin nasıl hesaplandı?" (model, varsayım 1,2 mg, t½ 2 sa, sınırlılıklar, kaynaklar).

## 19. Tetikleyici Sistemi

Etiketler onboarding'de seçilir, kayıtlarda tek dokunuş işaretlenir (opsiyonel). Yerel istatistik motoru koşullu olasılık hesaplar: "son 14 kahve kaydının 9'unda sonraki 15 dk içinde sigara içtin" → mesaj: "Kahveden sonraki ilk 15 dakika senin için riskli bir pencere görünüyor." **İstatistik güvenliği:** kural n<10'da sessiz; mesajlar olasılık dili kullanır ("görünüyor/olası"), nedensellik iddiası yok. Yemek sonrası/kahve/alkol ilişkileri literatürle uyumlu yaygın desenlerdir; alkol-istek ilişkisi özellikle güçlü bir klinik gözlemdir ama ürün yine kendi kullanıcı verisinden konuşur, genel iddiadan değil. Yiyecek/içecek bölümü (brief §14): kahve/çay/enerji içeceği/alkol tetikleyici etiketleri + "yemek sonrası" rutin; **"kahveyi yeşil çayla değiştirirsen istek azalır" tarzı kanıtsız beslenme iddiası üretilmez.**

## 20. Bildirim Sistemi

Türler: (1) planlı zaman yaklaşıyor (varsayılan KAPALI — spam riski), (2) günlük özet (akşam, varsayılan AÇIK), (3) sabit motivasyon + bugünün hedefi (AÇIK), (4) bırakma programında ilk 72 saat yoğun destek (AÇIK, kullanıcı kapatabilir), (5) milestone (olay-bazlı), (6) uzun sessizlik sonrası nazik dönüş ("3 gündür kayıt yok — kaldığın yerden devam et"). **Yoğunluk ayarı:** Sakin / Standart / Yoğun 3 kademe + tam kapatma. Teknik: `flutter_local_notifications`; Android 13+ POST_NOTIFICATIONS runtime izni; Android 14'te kesin alarm varsayılan inexact, "tam saat" kullanıcı opt-in'i + Settings deep-link (`USE_EXACT_ALARM` kullanılmaz — Play politikası sadece alarm/saat uygulamalarına izin veriyor; habit uygulaması reddedilir); reboot sonrası otomatik yeniden planlama; iOS'ta provisional yetki + zamanında sor.

## 21. İçerik Motoru

Kategoriler: günlük motivasyon (ölçüm bazlı, klişe değil), sigara bilimi, bırakma rehberi, kriz yönetimi, tetikleyiciler, davranış değişimi, stres/uyku, sosyal durumlar, bilimsel gerçekler. Her içerik kaydı: `id, dil, kategori, kaynak_url, kaynak_yayın_tarihi, hedef_segment, gösterim_koşulu (örn. plan fazı=ilk72s), gövde` — SQLite tablosu; uygulama güncellemeleriyle gelir (sunucu yok). Gösterim: ana ekranın alt "günün notu" şeridi koşula bağlı; tıklanınca tam metin + kaynak linki. İçerik yazım kuralları: her sağlık iddiası Tier-1 kaynağa linkli; S4 dili; "detoks/temizlik" kelimesi yasak.

## 22. Lokal Veri Mimarisi (karşılaştırma + karar)

Araştırma sonucu (Eylül 2026 bakım durumları): **drift** 2.34.4 aktif (günlükler önce), **Isar** 3 yıl sürüm yok (yüksek risk), **Realm/MongoDB SDK'ları Eylül 2024'te kullanımdan kaldırıldı** (destek 30 Eyl 2025'te bitti — yeni projeye girilmez), **hive_ce** topluluk fork'u aktif ama key-value, **ObjectBox** aktif ama Sync ticari, **sqflite** olgun ama reactive değil/şifresiz.

**Karar: drift (SQLite) + SQLCipher.** Gerekçe: olay tablosu + plan + içerik + saatlik agregasyon = ilişkisel iş; `watch()` akışları canlı ana ekranı besler; tip güvenli SQL + migration; SQLCipher drift ≥2.32 ile doğal entegre (~2–3 MB/ABI AAB etkisi); en sağlıklı bakım profili ([drift](https://pub.dev/packages/drift), [şifreleme](https://drift.simonbinder.eu/platforms/encryption/)). hive_ce yalnızca önemsiz ayarlar için opsiyonel.

## 23. Privacy (privacy-first tasarım)

- **Toplanan veri: hiçbiri.** Analytics SDK yok, reklam SDK yok, crash reporter varsayılan yok (opsiyonel opt-in Sentry dahil edilebilse de v1'de edilmez; App Store Connect / Play Console vitals SDK'sız temel çökme verisi verir — [App Analytics](https://developer.apple.com/app-store-connect/analytics/), [Vitals](https://developer.android.com/topic/performance/vitals)).
- **iOS:** veritabanı dosyasına `isExcludedFromBackup=true` — yoksa iCloud yedeklemesi varsayılan olarak uygulama verisini kopyalar ve "veri cihazından çıkmaz" iddiası teknik olarak yalan olur ([Apple backup docs](https://developer.apple.com/documentation/foundation/optimizing-your-app-data-for-icloud-backup)); küçük gizli değerler Keychain (ThisDeviceOnly).
- **Android:** `dataExtractionRules` ile cloud-backup + device-transfer muafiyeti; Keystore ile DB anahtarı ([autobackup](https://developer.android.com/identity/data/autobackup)).
- **Cihaz değişimi:** kullanıcı-init şifreli olmayan ama kullanıcı-kontrolü export/import (JSON) + Android'de istenirse device-transfer izni; otomatik bulut yedeği design kararıyla kapalı (dürüst "veri sunucuya gitmez" iddiasının bedeli kullanıcıya aktarılır ve onboarding'de tek cümleyle anlatılır).
- **Etiketler:** Apple "Data Not Collected"; Play Data safety "No data collected" (on-device veri "collected" sayılmaz — [Play politikası](https://support.google.com/googleplay/android-developer/answer/10787469)); her iki mağazada privacy policy zorunlu.
- **Yasal çerçeve:** sigara verisi GDPR Art. 9 kapsamında "sağlık verisi" sayılabilir ([GDPR-info](https://gdpr-info.eu/art-9-gdpr/)); cihaz-içi işleme + iletim yokluğu pratik yükü şeffaflık+güvenliğe indirger; TR'de KVKK 6698 md.6 özel nitelikli veri ([KVKK](https://www.kvkk.gov.tr/Icerik/6649/Personal-Data-Protection-Law)).

## 24. Flutter Teknik Mimari

**Stack (doğrulanmış sürümler, Eyl 2026):** Flutter 3.47.2 / Dart 3.13 (Impeller-only; iOS 15+/Android 24+ — [platform desteği](https://docs.flutter.dev/reference/supported-platforms)); drift 2.34.4 + SQLCipher; **Riverpod 3.4** (StreamProvider↔drift watch() uyumu, compile-safe DI; Bloc alternatifi kurumsal/event-driven projelerde; Provider küçük ölçek için yetersiz); in_app_purchase 3.3.0 (StoreKit 2 varsayılan; Play Billing 8); flutter_local_notifications 22.3.0; home_widget 0.9.4.

**Katmanlar:** `presentation (screens/widgets)` → `application (controllers: PlanController, CravingController, PurchaseController)` → `domain (entities + PlanEngine + NicotineModel + TriggerStats + saf Dart, %100 test edilebilir)` → `data (drift DAO'lar + repositories + content pack loader + platform channels: purchases/notifications/widgets)`.

**Kritik platform notları:** (1) Entitlement her cold start'ta mağazadan doğrulanır (`Transaction.currentEntitlements` / `queryPurchasesAsync`) — yerel flag'e asla güvenilmez; Android'de acknowledge 3 gün içinde yoksa Google otomatik iade yapar ([Play billing](https://developer.android.com/google/play/billing/integrate)). (2) ML Kit iOS SDK'sı resmen "deprecated" ilan edilmemiş ama 27 Haziran 2025'ten beri güncellenmiyor; iOS tarama planı Apple Vision tabanlı (`mobile_scanner` zaten iOS'ta Vision'a geçti) — barkod v1.1'de Android=ML Kit, iOS=Vision. (3) Watch: Flutter watchOS/Wear OS'i desteklemiyor; V3'te native mini uygulama (SwiftUI/Kotlin, 2–4 hafta), MVP'de widget+ControlWidget bu ihtiyacın büyük kısmını kapatır.

## 25. Veri Modeli (yerel, drift tabloları)

- **UserProfile** (id, created_at, locale, age_band) — minimal
- **SmokingProfile** (baseline_cpd, ttfc_band, price_per_pack, pack_size, brand_id?, target_mode, pace, started_at)
- **CigaretteEvent** (id, ts, source[app|widget|tile|control|notif], trigger_id?, mood?, context?, plan_day_id) — çekirdek tablo
- **CigaretteProduct** (barcode, brand, variant, pack_size, market, source[seed|user], verified_by_user)
- **DailyPlan** (date, target_count, windows_json, phase[reduction|final|quit], tempo)
- **PlanAdjustment** (id, date, reason[overshoot|weekend|missed|pace_up|pace_down], from, to, message_id)
- **Trigger** (id, label_key, custom?)
- **CravingEvent** (id, ts, intensity 1–3, trigger_id?, outcome[resisted|smoked|expired])
- **DailySummary** (date, count, plan_target, adherence, savings, resisted_count, first_ts, last_ts, min_gap)
- **HealthTimelineState** (quit_ts?, milestone_key, acknowledged)
- **MotivationContent** (id, lang, category, body, source_url, source_date, condition_json)
- **PurchaseEntitlement** (store, product_id, purchase_token, state, last_verified_at) — her açılışta mağazayla tazelenir
- **Settings** (notif_level, theme, reduce_motion, haptics, trial_started_at)

## 26. Offline-First Stratejisi

| Özellik | Tamamen offline | İnternet gerektirir | Opsiyonel |
|---|---|---|---|
| Kayıt, plan motoru, grafikler, tasarruf, health timeline, craving araçları, içerik, widget | ✅ | — | — |
| Satın alma / Restore | — | ✅ (mağaza) | offline'da son bilinen entitlement kullanılır |
| Export/Import dosyası | ✅ | — | paylaşım sayfası OS hizmeti |
| Çökme/istatistik | — | — | hiç gönderilmez; store console verisi kullanıcı opt-in'ine tabi |

İçerik paketleri ve katalog uygulama paketiyle gelir; uygulama güncellemesi tek güncelleme kanalı. Sunucu maliyeti: **0**.

## 27. iOS / Android Stratejisi (+ Widget, Watch)

- **Navigation:** iOS büyük başlık + swipe-back; Android back-stack + Material 3 top bar. Tek Flutter kod tabanı; platform ayrımı sadece kabuk bileşenlerinde.
- **Widget:** iOS WidgetKit interaktif (iOS 17+) — widget butonu App Intent ile uygulama açmadan DB'ye yazar ([Apple docs](https://developer.apple.com/documentation/widgetkit/adding-interactivity-to-widgets-and-live-activities)); güncelleme bütçesi (~40–70/gün) stale-toleran tasarımla yönetilir. Android RemoteViews + PendingIntent broadcast. Veri köprüsü: App Group (iOS) / SharedPreferences (Android) → home_widget.
- **Kilit ekranı/Kontrol:** iOS 18 ControlWidget (Kontrol Merkezi + kilit ekranı) 1-dokunuş kayıt; Android QS TileService + bildirim aksiyonu.
- **İzinler:** bildirim tek izin; kamera yalnızca barkod kullanım anında; konum/contacts/mic yok.
- **Purchase UX:** iOS fiyata vergi satırı; Play vergi dahil gösterir; restore butonu iki platformda ayarlarda + paywall'da.
- **Watch (V3):** Apple Watch (SwiftUI, WatchConnectivity) ve Wear OS (Kotlin) ayrı mini uygulamalar; değer: bilekten tek dokunuş kayıt — ürün değerini artırır ama MVP'nin dönüşüm üssü değildir; widget'lar bu ihtiyacın %80'ini V1'de kapatır.

## 28. Monetization

Model: **Free-to-try + tek seferlik Lifetime Unlock.** Abonelik yok, reklam yok, hesap yok, sunucu-bağımlı ek ücretli servis yok. Ücretsiz katman (sonsuza dek): sınırsız kayıt, BUGÜN ekranı, gün sayacı, para tasarrufu, temel grafik (son 7 gün), export/import. Premium (tek seferlik): plan motoru, tam grafikler, tetikleyici analizi, tam health timeline, craving araç setinin tamamı, widget tema/pencere özelleştirme, içerik kütüphanesi. **Deneme:** ilk açılışta 7 gün premium otomatik açık (kredi kartı yok, hatırlatma bildirimi gün 5 ve 7'de) — çünkü Apple'ın introductory offer'ı ve Play'in free trial'ı yalnızca aboneliklerde var; non-consumable'da trial ancak feature-gating ile yapılır ([Apple intro offers](https://developer.apple.com/documentation/storekit/implementing-introductory-offers-in-your-app), [Play](https://developer.android.com/google/play/billing/subscriptions)). Paywall anı: 7. gün doğal kapı + değer kanıtlandıktan sonra (uyum yüzdesi ekranı); onboarding ortasında kesintisiz akış tercih edilir (Kwit'in "shady" akış şikâyetinden ders).

## 29. One-Time Lifetime Purchase Stratejisi (teknik)

- **iOS:** non-consumable IAP; StoreKit 2 `Transaction.currentEntitlements` her açılışta okunur; restore = `AppStore.sync()` + yeniden okuma — Apple ID'ye bağlı, **backend gerekmez** ([StoreKit 2 restore](https://developer.apple.com/videos/play/wwdc2022/110404/)). İade → revocation `Transaction.updates`/sonraki açılışta görünür; UI asla yerel flag'e dayanmaz ([revocation](https://developer.apple.com/documentation/storekit/transaction/revocationreason)).
- **Android:** one-time in-app product; `queryPurchasesAsync` Google hesabına bağlı entitlement'ı reinstall/cihaz değişiminde geri getirir; **acknowledge ≤3 gün** (aksi halde otomatik iade); pending satın alma (nakit/ertelenmiş) tamamlanmadan hak verilmez ([Play billing](https://developer.android.com/google/play/billing/integrate)).
- **Restore Purchases butonu** iki platformda zorunlu-pratik (Apple 3.1.1 "should"; kullanıcı beklentisi). "Lifetime" teriminin şartlarda tanımı: "uygulamanın yayınlandığı süre boyunca".
- **Silip yeniden yükleme:** ücret yeniden alınmaz — entitlement mağaza hesabında; bu davranış hem Apple hem Google'da platform garantisi.

## 30. App Store / Google Play Kuralları (Eylül 2026)

- **Apple:** 1.4.3 bırakmayı teşvik etmeyi değil, sigara tüketimini teşvik etmeyi yasaklar → kategorimiz uygundur; 1.4.1 tıbbi uygulama denetimi — "doktora danışın" disclaimeri + doğruluk iddiası disiplini gerekir ([guidelines](https://developer.apple.com/app-store/review/guidelines/)); yaş derecesi: tütün referansları "Infrequent/Mild" → **12+** ([age ratings](https://developer.apple.com/app-store-connect/reference/app-information/age-ratings-values-and-definitions/)); komisyon 15% (Small Business Program, <$1M — [SBP](https://developer.apple.com/app-store/small-business-program/)); Apple çoğu pazarda merchant of record, vergi dosyalama yükümlülüğü geliştiricide ([tax](https://developer.apple.com/help/app-store-connect/making-payments-to-apple/understanding-taxes/)).
- **Google:** Billing Library 8 zorunlu (31 Ağustos 2026'ya kadar geçiş); **Haziran 2026 itibarıyla yeni ücret yapısı: %10 servis ücreti (ilk $1M) + %5 faturalama ücreti** (Play Billing kullanımında efektif ~%15) ([Play expanded billing](https://android-developers.googleblog.com/2026/06/play-expanded-billing.html)); Health apps declaration formu zorunlu ([health policy](https://support.google.com/googleplay/android-developer/answer/14738291)); içerik derecesi tütün referansı → **Teen 13+** (IARC); target API **36** (Ağustos 2026 sonrası yeni uygulama/güncelleme) ([target sdk](https://developer.android.com/google/play/requirements/target-sdk)); Data safety "No data collected" (SDK eklenirse form geçersizleşir — dikkat).
- **İade gerçekleri:** Google 48 saat koşulsuz iade penceresi + 2026 chargeback maliyet kaydırması; Apple AB/UK 14 gün cayma hakkı + reportaproblem iadeleri → refund bütçesi finansal modelde ~%2–4 kabul edilir.

## 31. Fiyatlandırma

| Pazar | Lifetime fiyat | Gerekçe |
|---|---|---|
| ABD | **$14,99** (lansman 4 hafta $9,99) | 1 paketin altında; Kwit lifetime $169,99'a karşı güçlü kontrast |
| TR | **₺199,99** | ~1,5 paket sigara; QuitNow PRO ₺1.989,99'a karşı;
 TR hedefi geliri değil tabanı ve yorumu büyütmek |
| DE/AT | €14,99 | yüksek WTP, paket ~€9–10,5 |
| UK | £12,99 | paket ~£16,5 — "paketten ucuz" mesajı |
| JP | ¥2.200 | yüksek iOS payı + WTP |
| Global (App Store tier) | $9,99–14,99 bandı | psikolojik eşik altında tutulur |

Komisyon sonrası net: Apple 15% SBP, Google ~%15 → ilk yıl $1M altı gelirde iki platformda da benzer netlik. Strateji: düşük-girişli premium algı; fiyat iadesi oranını düşürmek için ilk 7 gün deneme + satın alma öncesi değer özeti ("bu ay X ₺ tasarruf edeceksin, uygulamanın ömrü boyunca tek ödeme").

## 32. Global Dil / Pazar Stratejisi

| Pazar | Sigara yaygınlığı (E/K, WB 2024) | iOS payı | Rol |
|---|---|---|---|
| ABD | %20,0 / %11,6 | ~%60,7 | Ana gelir pazarı ([StatCounter](https://gs.statcounter.com/os-market-share/mobile/united-states-of-america)) |
| UK | %14,6 / %11,0 | ~%51,4 | Yüksek WTP + NHS bırakma kültürü |
| Japonya | %26,2 / %8,9 | ~%65,0 | En yüksek iOS payı; az rekabet (yerelleştirme kapısı) |
| Almanya | %24,3 / %19,6 | ~%33,0 | EU çapa; kadın yaygınlığı yüksek |
| Türkiye | ~%42 (E) / ~%20 (K) | ~%26,2 | Taban pazarı: ~15M içici, resmi rakip 1,7 puan; gelirden çok social-proof |
| (Dalga 2) Fransa, İtalya, İspanya, Brezilya | FR %35,9/31,2; ES %28,9/26,2 | — | FR/IT/ES-BR v1.x |

**İlk diller:** EN + TR + DE (v1) → +JA, ES, FR (v1.1–1.2) → IT, PT-BR (v2). Gerekçe: iOS payı × WTP × sigara nüfusu × rekabet yoğunluğu; "her dile çevir" yerine dört güçlü pazarda derin yerelleştirme (mağaza metni dahil).

## 33. ASO

- **Resmi mağaza başlığı:** `Halen: Quit Smoking Tracker` (27/30 kr; iOS + Play). **TR başlığı:** `Halen: Sigara Bırakma Sayacı` (25/30 kr). Subtitle (30 kr): `Reduce at your pace`.
- **Keyword havuzu:** quit smoking, stop smoking, smoking cessation, quit nicotine, cigarette tracker, smoking reduction, taper, days since, no subscription, money saved; TR: sigara bırakma, sigara sayacı, sigara azaltma, bırakma yardımcısı; rakip başlıklarında "quit smoking" her sluggeda — "reduction/taper" ve "no subscription" boş alan ([rakip başlık örnekleri §4](https://apps.apple.com/us/app/quitnow/id483994930)).
- **Screenshot stratejisi (5):** 1) BUGÜN + ring "6/8", 2) plan yeniden hesaplama kartı ("Yeniden hesapladık"), 3) para tasarrufu, 4) health timeline, 5) "Tek seferlik · Gizlilik" kapanış.
- **Preview video (15–30 sn):** istek anı → SOS → atlattım → grafik → fiyat kartı.

## 34. Uygulama İsmi Araştırması (30+ aday, doğrulanmış elemeler)

**Doğrulanmış olarak KAPALI:** Unlit (2 aktif iOS bırakma uygulaması), Quitly (tryquitly.com + 2 mağaza kaydı), Unsmoke (PMI kampanyası/trademark), Puffless, Exhale (3 uygulama + getexhale.app), Nixit (mevcut tüketici markası), ZeroNic (vape çağrışımı + kalabalık), Nefes (TR mağazada doymuş), Halcyon, Relume, Smokless (typo), Seno (ES/IT olumsuz anlam), Sighra ("sigara" yazım hatası gibi okunur), Nikor (Nikkor/Nikon karışır), Breave ("Brave" yazım hatası algısı). ([İsim doğrulama kaynakları §A raporu: Unlit iOS](https://apps.apple.com/vn/app/unlit-quit-smoking/id6757922955), [PMI Unsmoke](https://www.pmi.com/our-progress/our-initiatives/unsmoke-your-mind/what-is-unsmoke-your-mind), [Quitly](https://apps.apple.com/us/app/quitly-days-since-counter/id6615060703), [Exhale](https://apps.apple.com/us/app/exhale-quit-vaping-now/id6756926563))

**İsim testi (§41 brief):** Kazanan **Halen** — (1) İngilizce "hale" = sağlıklı, dinç ("hale and hearty") → sağlık çağrışımı doğal; (2) sonda -halen "inhale/exhale"e fonetik gönderme; (3) 5 harf, 2 hece, EN/TR/DE/JP'de kolay telaffuz; TR'de "hâlen" ("şu anda") nötr-olumlu ikinci anlam ("hâlâ bıraktın, hâlâ devam"); (4) mağaza taramasında bırakma uygulaması çakışması bulunamadı; (5) duygusal alan: nefes, kontrol, yeni başlangıç — "yasak/bıçak" çağrışımı yok. Riskler: Van Halen marka gürültüsü (farklı sınıf, düşük), Almanca "Hallen" okuması nötr. **Kesin adım:** TESS/EUIPO/WIPO Class 9/42/44 taraması + halenquitsmoking.com satın alımı isim ilanı öncesi. **Resmi ad kararı (kesinleşti):** tam ad `Halen: Quit Smoking Tracker`, TR `Halen: Sigara Bırakma Sayacı`, kısa ad `Halen`, GitHub repo `halen-quit-smoking`, domain `halenquitsmoking.com`.

## 35. Marka Kararı (nihai)

**Seçilen ve kesinleşen tek isim: `Halen: Quit Smoking Tracker`** (kısa ad: Halen · TR: Halen: Sigara Bırakma Sayacı · domain: halenquitsmoking.com · GitHub: halen-quit-smoking). Gerekçesi §34'te. Araştırma sırasında değerlendirilen tüm diğer adaylar çakışma, telaffuz veya marka gücü gerekçeleriyle elendi; doğrulanmış olarak kapalı isimlerin listesi §34'tedir.

## 36. İkon Konseptleri (5)

1. **Kesik halka (nefes döngüsü):** petrol yeşili zemin, kırık beyaz halka, açık uç alt sağda — "döngü devam ediyor, tamamlanmak üzere". Küçük boyutta okunur. ★ önerilen
2. **Dalgadan düz çizgi:** üstte titrek dalga, altta düz çizgiye oturur — karışıklıktan sakinliğe.
3. **Yükselen ufuk:** amber yarım güneş + petrol zemin — yeni başlangıç (sıcak ama klişeden uzak).
4. **Harf markası "h":** geometrik h, halka soluk nefes iziyle — Apple-komşu minimal.
5. **İki nefes çizgisi:** paralel iki dalga (ver/alan nefes) — çok minimal, risk: genetik-fitness uygulaması karışması.

**Yasaklar:** sigara/paket görseli, yasak işareti 🚭, akciğer organı, kırmızı uyarı estetiği.

## 37. Başarı KPI'ları (hedefler sağlık/fitness kategori gerçeklerine göre; SDK'sız ölçüm: App Store Connect Analytics + Play vitals + uygulama-içi lokal istatistik opt-in anketleri)

| KPI | Hedef | Ölçüm |
|---|---|---|
| Onboarding tamamlama | ≥%65 | lokal olay + store funnel (örneklemeli) |
| İlk 24 saatte ≥1 kayıt | ≥%55 | lokal (kendi cihazında) |
| D7 retention | ≥%18 | store analytics |
| W4 retention | ≥%10 | store analytics |
| Günlük kayıt disiplini (aktif kullanıcı ort.) | ≥70% gün | lokal |
| Plan uyum ortalaması | ≥%75 | lokal |
| Trial başlangıcı (7 gün premium) | ≥%45 | lokal |
| Trial→Paid | %4–8 | store + lokal |
| Refund rate | <%3 | mağaza raporları |
| Nükstenin geri dönüşü (lapse sonrası 7 gün içinde ≥1 kayıt) | ≥%50 | lokal |
| ASO: "sigara bırakma" TR araması ilk 5 | 3. ay | manuel takip |

**Analytics kararı:** SDK'sız başla (Play/Apple store verisi + lokal metrikler). Ürün kararlarına yetmeyen veri kalırsa: opt-in, kendi sunucusuz (statik endpoint + Umami/Plausible self-host) olay akışı — kullanıcı rızası açık, Data safety formu buna göre güncellenir ([Umami](https://umami.is), [Plausible](https://plausible.io/docs/self-hosting)). **Hiçbir koşulda sigara kayıtları içeriği gönderilmez; yalnızca sayısal funnel olayları (onboarding_step, trial_start) opt-in ile.**

## 38. Riskler

| Risk | Etki | Önlem |
|---|---|---|
| Kayıt yorgunluğu → churn (kategori #1) | Yüksek | 1-dokunuş + widget/kilit ekranı; kayıt olmadan da uygulama değer üretir (plan + timeline); "yeniden devam" akışları |
| Kaliteli görünüm + tek geliştirici kapsamı | Orta | Dar MVP, 3 dil, kapsamlı test planı (quitSTART dersi: tek bug puanı yıktı) |
| Mağaza iade/refund sızıntısı | Orta | 7 gün deneme (değer görmeden ödeme yok), satın alma öncesi değer özeti |
| Katalog/kod bakımı (Flutter ekosistemi değişimi: ML Kit iOS donuk) | Düşük-Orta | iOS taramada Vision; sürüm pinleme; v1'de barkod opsiyonel olduğundan kritik yol dışı |
| İsim/trademark son tarama | Düşük | Lansman öncesi TESS/EUIPO taraması şart |
| WHO/istatistik revizyonları (8M→7M örneği) | Düşük | İçerik kayıtlarında kaynak+tarih metadata'sı; sürüm güncellemesinde içerik revizyonu |

## 39. Hukuki / Sağlık Riskleri ve Sınırlar

- **Tıbbi cihaz sınırı:** Genel wellness konumlandırma (haber takibi, plan, motivasyon) FDA'nın General Wellness kapsamında düşük risk — "nicotine dependence'ı tedavi eder" gibi hastalık iddiası cihaz rejimine iter ([FDA General Wellness 2026 revizyonu](https://www.fda.gov/regulatory-information/search-fda-guidance-documents/general-wellness-policy-low-risk-devices); [MDCG 2019-11](https://health.ec.europa.eu/system/files/2020-09/md_mdcg_2019_11_guidance_en_0.pdf) EU tarafı). Ürün dili: yaşam tarzı/davranış; quit-rate/etkinlik istatistiği pazarlamada kullanılmaz.
- **Uygulama-içi disclaimer (P0):** "Bu uygulama tıbbi tavsiye değildir; nikotin bağımlılığının tedavisi için sağlık profesyoneline başvurun. Hamilelik, kalp rahatsızlığı ve psikiyatrik durumlarda önce uzman görüşü alın." + NRT/ilaç önerilmez, sadece profesyonel yönlendirme. Kaynak satırı: TR Yeşilay 176, ABD 1-800-QUIT-NOW, UK NHS, DE BZgA.
- **18 yaş altı:** hedef kitle dışı; 18- seçiminde genel genç kaynakları gösterilir, plan verilmez.
- **Krize yanıt:** uygulama kendini acil destek aracı olarak sunmaz; kalıcı "profesyonel yardım" satırı craving ve plan ekranlarında.
- **Güvenlik sınırları (S5 listesi — kesin yasaklar):** kan nikotinini gerçek ölçüm gibi göstermek; garanti bırakma tarihi; "tedavi eder/iyileştirir" iddiası; ilaç/doz önerisi; kullanıcıyı suçlamak; "detoks"; yanlış biyolojik kesinlik (CO/katran "vücudundaki miktar"); korku pazarlaması.

## 40. Nihai Ürün Önerisi (en güçlü farklar)

1. **TEK EN GÜÇLÜ FARK: Kendini yeniden kuran azaltma planı (Adaptive Taper).** Kullanıcı planı bozduğunda uygulama planı yeniden optimal hale getirir ve bunu olumlu dille anlatır. Kategoride eşdeğeri yok; kullanıcı ihtiyacı yorumlarda belgeli.
2. **İkinci fark: Dürüst veri katmanı.** Her türetilmiş sayı kaynaklı + açıklanabilir; biyolojik sahte kesinlik yok. Premium-sağlık algısının bedelsiz kaynağı.
3. **Üçüncü fark: Gizlilik + adil tek seferlik fiyat birleşimi.** "Hesap yok, sunucu yok, reklam yok, abonelik yok" — dört yalanı aynı anda söylemeyen tek ürün.

## 41. 90 Günlük Geliştirme Planı

| Hafta | Çıktı |
|---|---|
| 1–2 | Figma tasarım sistemi + BUGÜN/plan/SOS ekranları; veri modeli + drift şema; isim/trademark final + domain |
| 3–4 | Kayıt motoru + plan algoritması (domain katmanı, birim testleri: %90+); onboarding |
| 5–6 | Grafikler + tasarruf + health timeline; bildirimler; SQLCipher + backup exclusion |
| 7 | Craving SOS + "atlattım" akışı; widget (iOS WidgetKit interaktif + Android) |
| 8 | IAP (StoreKit 2 + Play Billing 8) + paywall + trial mantığı; EN/TR/DE metinlerinin bitişi |
| 9 | İç beta (TestFlight + Play internal): 15–20 kişi; quitSTART dersi listesi — regresyon testleri (kayıt/kaybı yok) |
| 10 | Hata + UX düzeltmeleri; ASO: başlık/anahtar kelime/screenshot'lar; privacy policy + health declarations |
| 11 | Soft launch **TR** (taban pazar, düşük CAC, hızlı iterasyon) + %30 lansman fiyatı |
| 12–13 | P0 hataları kapat; ABD/UK/DE global lansman; review yönetimi; v1.1 backlog'u (barkod, tetikleyici analizi) önceliklendirme |

---

# 59. Benden Kararlarım (uzman kararı — seçenek listesi değil)

- **Yapardım:** P0 listesinin tamamı + widget'lar; 3 dil; azaltma planını ürünün kalbine koyardım.
- **MVP'den çıkarırdım:** barkod tarama, tetikleyici otomatik analiz, watch, içerik kütüphanesi genişlemesi.
- **Tamamen silerdim:** AI koç, topluluk/sosyal, hipnoz programı, akupresür, günde anket, reklam SDK, zorunlu hesap, "akciğer temizleniyor" animasyonları, katran modellemesi.
- **Ürünün merkezine koyduğum özellik:** Adaptive Taper plan motoru (§14.4 dinamik yeniden hesap).
- **Gelir modeli:** Free tier + 7 gün feature-gated premium deneme + tek seferlik lifetime unlock; abonelik/reklam asla.
- **Fiyat:** ABD $14,99 (lansman $9,99), TR ₺199,99, DE €14,99, UK £12,99, JP ¥2.200.
- **İlk ülkeler:** ABD, UK, TR, DE (Japonya v1.1 ile, JA metni hazır olunca).
- **İlk diller:** EN, TR, DE → JA, ES, FR.
- **İsim:** resmi tam ad **Halen: Quit Smoking Tracker** (kısa ad: Halen; TR: Halen: Sigara Bırakma Sayacı). Domain: **`halenquitsmoking.com`**; GitHub repo: `halen-quit-smoking`.
- **İlk sürüm ekran sayısı:** 14 (splash/izin 1, onboarding 7, BUGÜN 1, kayıt-detay 1, plan 1, istatistik 1, SOS 1, ayarlar 1).
- **Flutter mimarisi:** feature-first klasörleme; presentation→application→domain→data; drift+SQLCipher; Riverpod 3; saf Dart domain (PlanEngine/NicotineModel testleri).
- **Backend:** Hayır. Sıfır sunucu; entitlement mağazada, içerik pakette.
- **Kullanıcıdan istenen veriler:** yaş grubu, günlük sayı, TTFC, paket fiyatı, saatler/tetikleyiciler, hedef tercihi, (ops.) marka.
- **Kesinlikle istenmeyen veriler:** doğum tarihi, cinsiyet, kilo/boy, sağlık geçmişi, hamilelik durumu, konum, kimlik/e-posta, kontaklar.

---

# 60. Nihai Konsept

> **ÜRÜN ADI:** Halen: Quit Smoking Tracker (kısa ad: Halen · TR: Halen: Sigara Bırakma Sayacı · domain: halenquitsmoking.com · GitHub: `halen-quit-smoking`)
> **TAGLINE:** "Reduce at your pace. Quit for good." (TR: "Kendi hızında azalt, kalıcı bırak.")
> **HEDEF KİTLE:** Azaltarak bırakmak isteyen 25–54 yaş sigara içicileri (çekirdek: günde 10–20 sigara, 5+ yıl); ikincil: bırakmaya hazır deneyenler ve kararsızlar
> **ANA PROBLEM:** Niyet–eylem boşluğu: kullanıcı azaltmayı/bırakmayı deniyor; planlar bozuk, efor yüksek, araçlar ya abonelik tuzağı ya sahte biyolojik kesinlik ya da suçlayıcı
> **ANA ÇÖZÜM:** Gerçek içme ritminden beslenen, bozulunca kendini yeniden kuran dinamik azaltma planı + 1-dokunuş kayıt + kriz anında 30 saniyelik araç + dürüst geri bildirim — hepsi cihazda
> **EN GÜÇLÜ FARK:** Adaptive Taper (plan bozulunca "Yeniden hesapladık" — ceza yok, otomatik reoptimizasyon)
> **MVP:** kayıt (+widget), plan motoru, BUGÜN, grafikler, tasarruf, health timeline, SOS, bildirimler, export, lifetime IAP; EN/TR/DE; 14 ekran
> **MONETIZATION:** Free tier + 7 gün premium deneme + tek seferlik Lifetime Unlock (abonelik/reklam yok)
> **LIFETIME PRICE:** ABD $14,99 · TR ₺199,99 · DE €14,99 · UK £12,99 · JP ¥2.200 (lansman -%30)
> **İLK PAZARLAR:** ABD, UK, TR, DE (JP v1.1)
> **İLK DİLLER:** EN, TR, DE (+JA/ES/FR v1.1)
> **TEKNİK STACK:** Flutter 3.47 / Dart 3.13 · drift (SQLite+SQLCipher) · Riverpod 3 · in_app_purchase (StoreKit 2 / Play Billing 8) · flutter_local_notifications · home_widget
> **VERİ MİMARİSİ:** %100 cihaz-içi; 13 tablo (CigaretteEvent çekirdek); SQLCipher; bulut yedeği hariç; JSON export/import
> **ANA EKRAN:** BUGÜN — hedef ringi (6/8), son sigara, sonraki hedef, mini nikotin eğrisi (S3), tek büyük "İÇTİM" + "İstek atlattım", tasarruf şeridi
> **ANA AKIŞ:** İndir → 7 adımlı onboarding (<90 sn) → ilk kayıt → plan kurulumu → günlük 1-dokunuş döngüsü → bozulunca yeniden hesap → bırakma günü → ilk 72 saat yoğun destek → (lapse olursa) yeniden devam → gün 7'de lifetime teklifi
> **EN ÖNEMLİ ALGORİTMA:** Dinamik azaltma planı: haftalık hedef %8–22 hız kademesi, saat-histogramı pencereleme, her kayıtta kalan-bütçe yeniden dağıtımı, uyuma göre tempo adaptasyonu, aralık-dilli tarih tahmini
> **EN BÜYÜK RİSK:** Kayıt yorgunluğu/kalıcılık (kategorinin #1 ölüm sebebi)
> **EN BÜYÜK FIRSAT:** Abonelik yorgunluğu + azaltma modu boşluğu + TR pazarı açığı üçünün kesişimi; dürüst ve adil konumlanma

### "Bu ürün neden insanların gerçekten ödeme yapacağı bir ürün olabilir?"

Ücret, kullanıcının zaten para harcadığı bir kaçınlık noktasının tam karşısına koyuluyor: kişi ayda yüzlerce lira/dolar/avro sigaraya harcıyor; uygulamanın tek seferlik fiyatı bir–iki paketin bedeli. Ödeme yapmayı anlamlı kılan üç itici: (1) **görünür, kişisel ilerleme** — para tasarrufu ve plan uyumu her gün büyüyen kişisel bir sermaye gibi birikir, kaybetmek istemez; (2) **kaygının azalması** — planın kendini onaran yapısı "başarısız olursam ne olacak" kaygısını düşürür, bu da uygulamayı bırakma girişiminin sabit ekipmanı yapar; (3) **adil anlaşma algısı** — rakiplerin haftalık $6,49 aboneliğine karşı "bir kez öde, verilerin hep sende kalsın" teklifi hem etik hem ekonomik bir kontrast. Ekonomik model abonelik geliri üretmez; birim hedef, kayıtlı kullanıcı başına %4–8 lifetime dönüşümü + organik öneri (TR tabanı ve yorum tabanı) ile düşük CAC'tır.

### Kullanıcı perspektifinden kritik sorular (ve ürün tasarımına yansımaları)

- **Neden yüklerler?** Sigara fiyatı artışı + bir bırakma denemesi anı (yeni yıl, hastalık, hamilelik çevresi, sosyal baskı) + "azaltarak deneyeyim" düşük eforlu vaat. Tasarım kararı: onboarding 90 saniye, hesap yok, ilk değer 3. ekranda (ring + tasarruf tahmini).
- **Neden 7 gün sonra silerler?** (1) Kayıt unutulursa sayaç saçmalar → çözüm: kayıt kaçırma normalleştirme + "tahmini tüketim" modu; (2) plan gerçekçiliği → tempo otomatik uzatma; (3) bildirim spam'i → 3 kademe yoğunluk; (4) motivaasyon klişesi → ölçüm bazlı içerik; (5) silme kararı öncesi export hatırlatması + "verilerin silinmesin" farkındalığı.
- **Neden satın alırlar?** 7 günlük denemede planın "işe yaramaya başladığını" görmeleri (grafik aşağı eğri + uyum yüzdesi) + fiyatın bir–iki paketin altında/yanında olması + restore/emniyet hissi. Paywall, değer kanıtının hemen sonrasına koyulur.
- **Neden satın almazlar?** (1) Ücretsiz katmanın zaten yeterli hissi → çizgi ücretsiz/ücretli ayrımı deneyim içinde doğal yaşatılır (plan motoru tamamen premium); (2) "bırakamam ki" öz-yetersizliği → onboarding dilinde öz-etkinlik (küçük kazanım vurgusu); (3) fiyat algısı bazı pazarlarda hâlâ yüksek → bölgesel fiyat + lansman indirimi; (4) deneme bitmeden silinen kullanıcı → gün 5–7 hatırlatma bildirimi + export hatırlatması.
- **Tasarım eleştirisi (kendimize):** En kırılgan varsayım, kullanıcının "plan" kavramına değer vermesi. Bu yüzden v1'de plan kullanmayan (sadece sayaç) kullanıcıyı da tam işlevsel tutuyoruz; plan, sayaç zaten kullanan kullanıcıya 3. günde önerilir — ürün tek doğru davranışı dayatmaz.

---

## Kaynak Katmanları (Tier sınıflandırması)

- **Tier 1 (kurumsal/bilimsel):** WHO ([fact sheet](https://www.who.int/news-room/fact-sheets/detail/tobacco), [cessation Q&A](https://www.who.int/news-room/questions-and-answers/item/tobacco-health-benefits-of-smoking-cessation)), CDC ([lung cancer](https://www.cdc.gov/lung-cancer/risk-factors/index.html), [broşür](https://stacks.cdc.gov/view/cdc/41642)), NCI/Smokefree ([Clearing the Air](https://smokefree.gov/sites/default/files/pdf/clearing-the-air-accessible.pdf), [cravings](https://smokefree.gov/challenges-when-quitting/cravings-triggers/how-manage-cravings)), Cochrane ([reduction](https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD013183.pub2/full), [mobile](https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD006611.pub5/full), [NRT](https://pubmed.ncbi.nlm.nih.gov/29852054/), [exercise](https://pmc.ncbi.nlm.nih.gov/articles/PMC6819982/), [MI](https://cochrane.org/CD006936/TOBACCO_motivational-interviewing-smoking-cessation)), PubMed/NEJM ([Benowitz 2010](https://pmc.ncbi.nlm.nih.gov/articles/PMC2953858/), [Hukkanen 2005](https://pubmed.ncbi.nlm.nih.gov/15661022/), [Garrison 2020](https://pmc.ncbi.nlm.nih.gov/articles/PMC7297096/), [Hughes 2004](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1360-0443.2004.00540.x), [Lally 2010](https://onlinelibrary.wiley.com/doi/abs/10.1002/ejsp.674), [Gollwitzer 2006](https://www.sciencedirect.com/science/chapter/bookseries/pii/S0065260106380021), [Chaiton 2016](https://bmjopen.bmj.com/content/6/6/e011045), [UCL 2024](https://onlinelibrary.wiley.com/doi/10.1111/add.16757)), FTC ([yields](https://www.ftc.gov/news-events/news/press-releases/2008/11/ftc-rescinds-guidance-1966-statements-concerning-tar-nicotine-yields)), EUR-Lex ([TPD](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32014L0040)), ATSDR ([CO](https://www.atsdr.cdc.gov/toxprofiles/tp201.pdf)), FDA ([wellness](https://www.fda.gov/regulatory-information/search-fda-guidance-documents/general-wellness-policy-low-risk-devices), [tobacco DB](https://www.fda.gov/tobacco-products/ctp-newsroom/fda-launches-searchable-tobacco-products-database)), Apple/Google resmi dokümanları (§24, §29, §30 linkleri).
- **Tier 2 (hakemli/sektör):** Tan 2019 (gradual meta), Guo 2023 & Bold 2023 (app meta-analizleri), BMJ EBM 2025 ([basın özeti](https://bmjgroup.com/phone-apps-nearly-3-times-as-good-as-no-basic-support-for-quitting-smoking-long-term/)), Jackson 2024 ([pragmatik RCT](https://www.jmir.org/2024/1/e50963/)), Zhang 2024 (akupresür umbrella), Barasch/Silverman (streak), Michie BCT, Branstetter 2020 (TTFC), StatCounter/Sensor Tower/appfigures pazar verileri.
- **Tier 3 (kullanıcı deneyimi verisi):** App Store/Google Play listeleme ve yorum temaları (§4 tablosundaki 30 link), ekşi sözlük/haberlerin paket etiketi doğrulamaları, fiyat listeleri.

*Rapor: 6 Eylül 2026. Mağaza fiyatları/puanlar bu tarihteki kamu sayfalarından; değişkenler lansman öncesi yeniden doğrulanmalı (özellikle: isim trademark taraması, TR paket fiyatı, Google fee yapısı).*
