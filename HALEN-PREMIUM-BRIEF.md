# Halen — Premium Yönergesi (kendime verdiğim prompt)

> Bu belge bir özet değil, bir **görev tanımı**. Aşağıdaki eleştiriyi üç ayrı
> gözle yazdım: (A) sigarayı gerçekten bırakmaya çalışan bir kullanıcı,
> (B) bu uygulamayı yayımlayacak kıdemli bir mobil ürün geliştiricisi,
> (C) bir tütün kontrolü / bağımlılık uzmanı. Sonra üçünü birden karşılayan
> tek bir yönerge çıkardım. Uygulama planı: `HALEN-PREMIUM-PLAN.md`.
>
> Geri dönüş noktası: `v1.1.0-modules` etiketi.

---

## 0. Neden bu belge var

Uygulama teknik olarak doğru. 219 test geçiyor, her gösterge formülünü
uygulama içinde yayımlıyor, hiçbir yerde ölçülmemiş bir değer ölçülmüş gibi
sunulmuyor.

**Ama premium hissettirmiyor ve bu bir detay değil.** Sigarayı bırakmak
isteyen biri günde 5–15 kez açacağı bir şeyi seçiyor; ucuz hisseden bir araç
üçüncü gün siliniyor. Doğru olmak yetmiyor — *güvenilir hissettirmek* de
gerekiyor. Sağlık uygulamalarında algılanan görsel kalite, algılanan
güvenilirliğin doğrudan bir bileşeni: kötü görünen doğru bilgi, iyi görünen
yanlış bilgiye yeniliyor. Bu yüzden görsel iş burada kozmetik değil, klinik
etkinliğin ön koşulu.

---

## 1. Eleştiri

### A. Bırakmaya çalışan kullanıcı olarak

1. **İlk 60 saniyede hiçbir şey kazanmıyorum.** Yedi adımlık bir form
   dolduruyorum ve karşıma çoğu boş bir ekran çıkıyor. Ödül yok, "vay be"
   anı yok. Oysa girdiğim verilerle bana anında şunları gösterebilirdin:
   yılda kaç paket, yılda ne kadar para, ne kadar zaman, ilk 72 saatte
   vücudumda ne olacak. Veriyi ben verdim; karşılığını görmeliyim.
2. **Ana ekran bir kart yığını.** Alt alta sekiz kart. Hiyerarşi yok,
   "önce şuraya bak" yok. Her kart eşit derecede önemliymiş gibi duruyor —
   bu da hiçbirinin önemli olmadığı anlamına geliyor.
3. **Uygulamanın sesi yok.** Ne bir ton, ne bir ritüel, ne bir karakter.
   "Halen" şu an bir marka değil, bir başlık. Yanımda olan bir şey gibi
   değil, bir form gibi hissettiriyor.
4. **Yazı tipi sistem fontu.** Tek başına bu, "yayımlanmamış proje" hissi
   veriyor. Premium algısının en ucuz ve en büyük kaldıracı tipografidir ve
   hiç kullanılmamış.
5. **Renkler bir palet değil, bir boya kutusu.** Zümrüt, amber, mercan, gök
   mavisi, petrol… Hangi rengin ne anlama geldiği belli değil. Bir renk bir
   şey söylemeli (ilerleme / yük / bilgi / uyarı), süs olmamalı.
6. **Boşluklar rastgele.** Kodda 4, 6, 8, 10, 12, 14, 16, 18, 20, 24, 28
   hepsi var. Göz bunu düzensizlik olarak okur — sebebini adlandıramasa bile.
7. **Kartlar düz.** Derinlik, katman, doku yok; Material varsayılanı. Her
   kart aynı kutu, aynı ağırlık.
8. **Kutlama yok.** İlk gün, ilk hafta, atlatılan yüzüncü istek — hiçbiri
   an gibi hissettirmiyor. Oysa bırakma sürecinin en güçlü yakıtı bu.
9. **Beni geri çağıran bir şey yok.** Bildirim tasarımı yok; uygulamayı
   açmayı unutursam süreç sessizce ölüyor.
10. **Grafikler dağınık.** İstediğim buydu ve hâlâ yok: tek bir yerde,
    kaydırarak geçtiğim, her biri kendi başına anlamlı ve ayrı ayrı güzel
    grafikler. Şu an nikotin eğrisi bir yerde, indeksler başka yerde,
    organlar başka yerde, ekonomi bambaşka yerde.
11. **Bırakma günü diye bir tören yok.** Tarih belirleme, geri sayım, o güne
    ait kendi ekranı — hiçbiri yok.
12. **"Şimdi ne yapmalıyım?" sorusunun tek bir cevabı yok.** Bilgi çok,
    yönerge az.

### B. Kıdemli mobil ürün geliştiricisi olarak

1. **Tasarım token'ı yok.** Renk, tipografi, boşluk, köşe yarıçapı, gölge,
   hareket süresi — hepsi kodun içine elle serpiştirilmiş. Tutarlılık
   token'la olur, iyi niyetle değil.
2. **`theme.dart` bir tema değil, bir renk listesi.** Semantik rol yok:
   yüzey / yükseltilmiş yüzey / vurgu / bilgi / uyarı / başarı ayrımı yok.
3. **Yeniden kullanılabilir bileşen kütüphanesi yok.** Her ekran kendi
   kartını, başlığını, boş durumunu, sayı bloğunu yeniden yazıyor.
4. **Hareket dili yok.** 220 ms, 280 ms, 700 ms, 4 sn — hepsi elle yazılmış,
   hiçbiri bir sistemin parçası değil.
5. **Karanlık tema hiç görsel olarak doğrulanmadı.** Kod destekliyor;
   kimse bakmadı.
6. **Boş durum tasarımı yok.** Yeni kullanıcı uygulamanın en kötü hâlini
   görüyor — oysa en çok ikna edilmesi gereken an tam orası.
7. **Gerçek cihazda hiç çalıştırılmadı.** Haptik, bildirim teslimi, kaydırma
   hissi, kare hızı — hiçbiri doğrulanmadı.
8. **Her kart kendi `AnimationController`'ını açıyor.** Bir ekranda beş
   bağımsız saat dönüyor; ne senkronlar ne de gerekli.
9. **CI yok.** Testler var ama her push'ta koşan bir şey yok.

### C. Tütün kontrolü / bağımlılık uzmanı olarak

Bunlar kozmetik değil, **klinik eksikler** — ve en ağırları şunlar:

1. **Farmakoterapi hiç yok. En büyük boşluk bu.** Nikotin replasman tedavisi
   bırakma oranını plaseboya göre yaklaşık 1,5–1,6 kat artırır; bant ile
   hızlı formun kombinasyonu tek üründen üstündür; vareniklin yaklaşık 2,2
   kat. Bunu hiç anmayan bir uygulama ciddi bir bırakma aracı sayılmaz.
   En azından şunlar olmalı: nedir, nasıl kullanılır, en sık yapılan hatalar
   (düşük doz, erken bırakma), ve hekim/eczacı yönlendirmesi.
2. **Bırakma tarihi protokolü yok.** Kanıt, azaltmanın **bir bırakma
   tarihine bağlandığında** işe yaradığını söylüyor. Süresiz azaltma kalıcı
   azaltmaya dönüşür; bu da kazançtır ama hedef o değil.
3. **Nüks önleme planı yok.** Yüksek riskli durum listesi, "tek nefes bile
   yok" kuralı ve **kayma (lapse) ile nüks (relapse) ayrımı** — kayma
   sonrası toparlanmayı belirleyen en kritik bilgi bu ve uygulamada yok.
   Uygulama "içtim" kaydını cezasız karşılıyor, ki doğru; ama kişiye
   *ne olduğunu* ve *şimdi ne yapacağını* öğretmiyor.
4. **Sosyal destek devreye alınmıyor.** Birine söylemek, destek istemek,
   ortak bırakmak — kanıtlı ve ücretsiz. Uygulama bunu hiç istemiyor.
5. **Ruh hâli taraması yok.** Bırakma, yatkın kişilerde depresyon ve
   anksiyeteyi belirginleştirebilir. Kısa bir tarama (PHQ-2 tipi) ve net
   bir yönlendirme eşiği olmalı.
6. **5A yapısı yok** (Sor – Öner – Değerlendir – Yardım et – Takip planla).
   Uygulama bilgi veriyor ama bir danışmanlık iskeleti yok.
7. **Motivasyon görüşmesi tonu yok.** Kişinin kendi nedenini çıkarmak
   (değerler, kararsızlık dengesi) bilgi vermekten daha etkilidir.
8. **Öz-yeterlik inşası zayıf.** "Daha önce neyi başardın" verisi var ama
   kişiye geri yansıtılmıyor.
9. **Güvenlik ağı akışın içinde değil.** Gebelik, kalp hastalığı,
   psikiyatrik tanı — metinde var, akışta yok.
10. **Yardım hattı yönlendirmesi görünmüyor.** Mağaza metninde var; kriz
    anında, uygulamanın içinde yok.

---

## 2. Teşhis, tek cümlede

**Halen doğru bir ölçüm aracı, ama henüz bir bırakma programı değil ve bir
ürün gibi görünmüyor.** Eksik olan üç şey: *klinik iskelet*, *tasarım
sistemi*, *ilk-60-saniye ikna*.

---

## 3. Kendime verdiğim görev (prompt)

> Sen aynı anda üç kişisin: (1) tütün kontrolünde deneyimli bir klinisyen,
> (2) sağlık uygulamaları yapan kıdemli bir mobil ürün tasarımcısı, (3) bu
> Flutter kod tabanını yıllardır taşıyan bir mühendis.
>
> **Görevin:** Halen'i, sigarayı bırakmaya çalışan birinin günde on kez
> açmak isteyeceği, ilk altmış saniyede değerini kanıtlayan, kanıta dayalı
> bir bırakma programına dönüştürmek — mevcut dürüstlük kurallarının
> **hiçbirini** gevşetmeden.
>
> Her değişikliği şu dört soruyla sına:
>
> 1. **Klinik:** Bu, kanıtlı bir bırakma müdahalesini uyguluyor mu, yoksa
>    sadece veri mi gösteriyor?
> 2. **Dürüstlük:** Ürettiğim her sayının bir birimi ve bir kaynağı var mı?
>    Ölçülemeyen bir şeyi ölçülmüş gibi mi sunuyorum?
> 3. **Kavrama:** En basit kullanıcı bu ekrana üç saniye bakıp ne olduğunu
>    söyleyebilir mi?
> 4. **Zanaat:** Bu, tasarım sisteminin bir parçası mı, yoksa bir kerelik
>    elle yazılmış bir şey mi?
>
> Bir şey bu dördünden birini geçemiyorsa, yapma.

### Değişmez kurallar (gevşetilmeyecek)

- **S5 yasağı:** ölçülmüş kan nikotini veya katranı, "ciğerinin yüzde şu
  kadarı temizlendi", garantili bırakma tarihi, kişisel kanser riski
  yüzdesi — asla.
- **Her eksenin birimi yazılır.** Sayısı olmayan eksen konmaz.
- **Her zarar kartının yanında iyileşme kartı olur.**
- **Kırmızı, sağlık verisinde kullanılmaz.** Suçlama yok, ceza arayüzü yok.
- **Her tavsiye kanıt derecesiyle etiketlenir** (güçlü / umut verici /
  geleneksel / kanıt yok).
- **Tıbbi tavsiye yerine geçmez.** Farmakoterapi bilgisi daima hekim veya
  eczacı yönlendirmesiyle birlikte verilir.
- **Veri cihazda kalır.** Hesap yok, sunucu yok, analiz yok.

### Kabul kriterleri

Aşağıdakiler doğru değilse iş bitmemiştir:

1. Onboarding'in sonunda kullanıcı, **kendi verisinden üretilmiş** bir özet
   görür: yılda paket, para, zaman, ilk 72 saatte ne olacağı.
2. Ana ekranda **tek bir birincil bilgi** vardır; gerisi ona göre ikincildir.
3. Bütün metrikler **tek bir kaydırmalı akışta**, ayrı ayrı grafiklerle
   görülebilir; her grafiğin başlığı, birimi ve tek cümlelik anlamı vardır.
4. Uygulamada **NRT/farmakoterapi rehberi** ve **hekim yönlendirmesi** vardır.
5. **Bırakma tarihi** belirlenebilir, geri sayımı vardır, o gün özel bir
   ekran açılır.
6. **Nüks önleme planı** vardır: yüksek riskli durumlar ve kayma/nüks ayrımı.
7. **Kilometre taşları kutlanır** — bir animasyon ve bir cümleyle.
8. Renk, tipografi, boşluk, köşe, gölge ve hareket **token'dan** gelir;
   ekran dosyalarında elle yazılmış sabit kalmaz.
9. **Karanlık tema görsel olarak doğrulanmıştır.**
10. **Boş durumlar tasarlanmıştır**; yeni kullanıcı boş kart görmez.
