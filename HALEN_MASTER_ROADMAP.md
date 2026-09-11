# HALEN — MASTER ÇALIŞMA DOSYASI VE TEK GERÇEK KAYNAK (SSOT)
> **Versiyon:** 2.0.0 (Master Roadmap)  
> **Temel Alınan Git Etiketi:** `v1.3.1-baseline` (origin/master üzerinde commit'li ve etiketli)  
> **Durum:** Aktif Yol Haritası & Canlı Mimari Kılavuzu  
> **Gizlilik & Güvenlik:** SIFIR sunucu, SIFIR telemetri, %100 yerel SQLCipher şifreleme.

---

## 0. BU BELGE NEDİR VE NASIL KULLANILIR?

Bu belge, **Halen: Quit Smoking Tracker** projesinin **tek geçerli ve bağlayıcı master çalışma belgesidir**.  
Önceki tüm dağınık araştırma, ön rapor ve plan dosyalarının (`HALEN-PREMIUM-BRIEF.md`, `HALEN-PREMIUM-PLAN.md`, `halen-modul-derin-arastirma-raporu.md`, `sigara-birakma-app-on-arastirma-ve-urun-raporu.md`) özü, kullanıcının kapsamlı eleştirisi ve yeni sistem mimarisi bu belgede birleştirilmiştir.

### Başka Bir Yapay Zekâ veya Geliştirici İçin Devralma Kuralı:
1. Bu dosyayı okuyan herhangi bir mühendis veya yapay zekâ, projenin vizyonunu, matematiksel ve klinik temellerini, kod mimarisini ve hangi aşamada olduğunu **başka hiçbir belgeye ihtiyaç duymadan** tam olarak anlar.
2. Aşağıdaki **Bölüm 5 (Mevcut Durum)** tamamlanan maddeleri (`[x]`), **Bölüm 6 (Yeni Yol Haritası)** ise sırayla yapılacak işleri (`[ ]`) temsil eder.
3. Bir iş tamamlandığında bu dosyadaki ilgili madde `[x]` olarak işaretlenir.

---

## 1. ACIMASIZ ÖZ ELEŞTİRİ VE KULLANICI GÖZÜNDEN SORUN ANALİZİ

Uygulamanın mevcut durumu teknik olarak çalışan bir iskelete sahip olsa da, **gerçek bir sigara bağımlısı ve titiz bir son kullanıcı gözüyle incelendiğinde ciddi UX faciaları, kopukluklar ve mantık hataları barındırmaktadır**:

### 1.1. Akciğer Çizimi ve Organ Haritası Çıkmazı
* **Akciğer Çizimi İlkel:** Mevcut `LungView` çizimi iki asimetrik geometrik balon ve düz çizgilerden ibaret. Ne bir medikal derinliği, ne estetik bir zarafeti ne de nefes alma dinamizmi var. Kullanıcıya "kötü bir teknik çizim" hissi veriyor.
* **Akciğer Neden Organ Haritasından Ayrı?** `BodyScreen` içinde Akciğerler Tab 0, Organ Haritası Tab 1 yapılmış. Akciğer bir organ değil mi? Kullanıcı organ haritasına girdiğinde akciğeri orada görememekte, iki ayrı sekme arasında anlamsızca gezinmektedir.
* **Organ İsmi Gizemi (Büyük UX Hatası):** Organ haritasında herhangi bir organa (örn. Kalp, Karaciğer) tıklandığında açılan kartın en tepesinde dev harflerle **"Bu organ, son 24 saat"** yazıyor! Hangi organa tıklandığı belli değil! Kullanıcı aşağı kaydırınca ancak organın ismini görüyor. Kullanıcı organın ismini bilmeden bir grafiğe ve yük durumuna bakmak zorunda bırakılıyor. Bu durum kullanıcı deneyimi açısından kabul edilemez.
* **Organlar Kıyıda Köşede:** Organların sigaradan nasıl etkilendiği ve bırakıldığında nasıl hızla iyileşmeye başladığı, ana ekranda kullanıcıyı motive edecek şekilde yer almıyor; alt sekmelere hapsedilmiş.

### 1.2. Ana Ekran Hiyerarşisi ve Dil Sorunları
* **"Sigarayı İçtim" Tepkisi Yanlış ve Ödüllendirici:** Kullanıcı sigara içtiğinde çıkan geri bildirim metinleri ("Başarısızlık değil. Önümüzdeki bir saat senin.", "Bu geçti...") sanki sigara içmek ödüllendiriliyormuş veya önemsizleştiriliyormuş gibi bir algı yaratıyor. Kullanıcı bunu bir motivasyon değil, yapay bir teselli ve anlamsızlık olarak görüyor.
* **Slogan Çöplüğü ("Her gün biraz daha özgür"):** Ana odak kartının en tepesinde devasa puntolarla yazılan "Her gün, biraz daha özgür" gibi içi boş edebiyat cümleleri kullanıcının hiçbir işine yaramıyor. Kullanıcı orada hangi planda olduğunu, bugün ne yapması gerektiğini ve sınırını görmek istiyor.
* **Aktif Plan Görünmüyor:** Kullanıcı ana ekranda "Ben şu an hangi plandayım? Kademeli azaltmada mıyım? Soğuk bırakmada mıyım? Kaçıncı gündeyim/haftadayım? Planımı buradan değiştirebilir miyim?" sorularının cevabını göremiyor.
* **Sigara Günlüğü En Dipte:** Sigara içme kaydı ve günlüğü (`TodayLogCard`), 8 büyük kartın altında, sayfanın en dibine atılmış. Kullanıcı gün içinde ne zaman içtiğini, saat aralıklarını ve ritmini anında görmek isterken ekranı kilometrelerce aşağı kaydırmak zorunda kalıyor.

### 1.3. Bilimsel Hesaplama ve Kişiselleştirme Eksikliği (Katran, Boy, Kilo, Yaş)
* **Katran (Tar) Nerede?** Ana ekrandaki "Şu an vücudunda" şeridinde nikotin ve karbonmonoksit var ama **en somut zehir olan KATRAN yok!** Kullanıcının ciğerine yapışan katran miktarı ana ekranda vurgulanmıyor.
* **Vücut Parametreleri Kullanılmıyor:** Kullanıcının boyu, kilosu, yaşı hesaba katılmıyor. Oysa nikotinin dağılım hacmi ($V_d \approx 2.6 \text{ L/kg}$), metabolizma klerensi ve katran birikimi doğrudan vücut kütlesi ve yaşla ilişkilidir.
* **Paket Bilgileri Yetersiz:** Paketin üzerindeki katran (örn. 8-10 mg), nikotin (örn. 0.6-0.8 mg) değerleri girilebilmeli; girilmediğinde ise standart ortalamalar üzerinden net bilimsel karşılıklar verilmelidir.
* **Zaman Çerçevesi Belirsizliği:** "Aldığın katran miktarı yaklaşık 2 damla" deniyor; fakat bu bugün mü, bu hafta mı, son 30 günde mi? Birim ve zaman dilimi muğlak.

### 1.4. İlerleme Skoru ve Psikolojik Basınç Grafiği Belirsizliği
* **"İlerleme Durumu" Neyi Ölçüyor?** İlerleme puanı verildiğinde kullanıcı "Bu iyi bir şey mi, kötü bir şey mi? İlerleme derken vücudumun temizlenmesi mi yoksa sigara içme davranışı mı?" diye soruyor. "Sağlığını değil davranışını ölçer" gibi soğuk ve belirsiz bir cümle kafa karıştırıyor.
* **"Basınç Altında" Grafiği Anlamsızlığı:** "Basınç altında, sakin, zorlu" ifadeleri bir yüzde mi, bir kriz skoru mu? Eksen neyi ifade ediyor? Kullanıcı bunu anlayamıyor.

### 1.5. Ekonomi ve Tasarruf Mantık Faciası
* **Hayali Kazanç Skandalı ("17.000 TL Kazanılan", "37 Gün Zaman"):** Uygulamayı yeni kuran veya birkaç gündür kullanan birine 90 günlük boş veritabanı üzerinden "Kazanılan: 17.000 TL, Kazanılan zaman: 37 gün" yazılması tam bir mantık hatasıdır. Kullanıcı haklı olarak "Ben bunu nerede kazandım, nasıl kazandım?" diye isyan etmektedir.
* **Tarihsel Maliyet vs. Gerçek Tasarruf:** Kullanıcının 5, 10, 15, 20 yıllık sigara geçmişinde harcadığı devasa servet ("Geçmiş Sigara Maliyeti/Zararı") ile uygulamayı kullanmaya başladığından bu yana gerçekten cebinde kalan para ("Fiili Tasarruf") net bir şekilde ayrılmamış ve ana ekrana taşınmamıştır.

### 1.6. Kriz / SOS, Destek Hatları ve Rehber Eksikleri
* **Rehber Yüzeysel:** Akupunktur denmiş ama kulaktaki noktaların (Shen Men, Akciğer, Karaciğer vb.) ne işe yaradığı, vücutta hangi semptomu bastırdığı anlatılmamış.
* **Beslenme Desteği Yok:** Nikotin krizini hafifleten alkali gıdalar, C vitamini zengini besinler, dopamin desteği sağlayan besinler ve krizi tetikleyen kahve/alkol ilişkisi rehberde yok.
* **Destek Hatları Küçücük ve Hatalı:** T.C. Sağlık Bakanlığı ALO 171 Sigara Bırakma Danışma Hattı, Yeşilay Danışmanlık Merkezi YEDAM 115 ve dünya çapındaki bırakma hatları (ABD 1-800-QUIT-NOW, UK NHS 0300 123 1044, DE BZgA) kriz anında tek tıkla aranabilir, büyük butonlarla verilmemiş; dipnotlara gizlenmiş.
* **Kriz Takibi İletişimi:** "Nasıl geçti? Ne kadar güçlüydü?" soruları bağlamsız duruyor. Kullanıcı atlattığı isteklerin zamanla nasıl azaldığını somut bir istek günlüğünde görmek istiyor.

---

## 2. TEMEL İLKELER VE MİMARİ OMURGA

### 2.1. Dürüstlük ve Veri Sözleşmesi (S1–S5 Sınıflandırması)
* **S1 (Doğrudan Zaman):** Kronometre, sigarasız geçen saat/gün. Kesin gerçek.
* **S2 (Kullanıcı Verisi):** Paket fiyatı, içilen sigara sayısı, boy, kilo, yaş.
* **S3 (Farmakokinetik & Matematiksel Model):** 
  - Yarı ömür eğrileri (Nikotin $t_{1/2} \approx 2$ saat; CO $t_{1/2} \approx 4$ saat; Katran/Hava yolu temizlenmesi).
  - Dağılım hacmi hesabı ($V_d = 2.6 \text{ L/kg} \times \text{Kilo}$).
  - Katran birikim modeli ($N_{\text{sigara}} \times \text{katran\_mg}$).
  - **Asla "kanındaki ölçüm" denmez; "bilimsel tahmin ve yük modeli" olarak şeffaf formülle sunulur.**
* **S4 (Popülasyon Ortalaması):** "Sigara başına ortalama ~20 dakika yaşam süresi" gibi hakemli literatür verileri.
* **S5 (YASAK ALAN):** Cihazın ölçemeyeceği şeyi "ölçtük" demek (Örn: "Kanında 14 ng/ml nikotin var", "Akciğerinin %42'si temizlendi"). **BU KESİNLİKLE YAPILMAZ.**

### 2.2. Teknoloji Yığını
* **Framework:** Flutter (Dart 3.x, Records, Patterns, Sealed Classes).
* **State Management:** Riverpod 3 (StateNotifier / AsyncNotifier / Providers).
* **Veritabanı:** Drift + SQLCipher (AES-256 şifreli yerel SQLite deposu).
* **Güvenli Depolama:** `flutter_secure_storage` (Android Keystore / iOS Keychain).
* **Çevrimdışı & Bağımsız:** Sıfır sunucu, sıfır üçüncü taraf takip kodu.

---

## 3. MODÜL VE SİSTEM MİMARİSİ (YENİLENMİŞ TASARIM)

### 3.1. Akciğer ve Organ İyileşme Sistemi (Bütünleşik Mimari)
* **Anatomik Vektörel Akciğer:** Tıbbi illüstrasyon zarafetinde, sol ve sağ lob ayrımı, trakea ve bronş dallanmaları olan, nefes alışverişiyle organik genişleyen, biriken katran yükünü mikro-partikül yoğunluğuyla zarifçe hissettiren yeni nesil Canvas motoru.
* **Bütünleşik Vücut & Organ Haritası:** Akciğer ayrı bir sekme olmaktan çıkarılır; vücut siluetinde Akciğerler, Kalp/Dolaşım, Beyin/Sinir Sistemi, Karaciğer, Mide ve Cilt tek bir interaktif haritada birleşir.
* **Organ Kartı Başlığı Düzeltmesi:** Bir organ seçildiğinde en üstte net bir şekilde:
  `[Organ İkonu] [Organ Adı: örn. Kalp & Damar Sistemi]`  
  `Durum: Toparlanma Aşamasında · Son Maruziyet: 4 saat önce`  
  yazacak. "Bu organ, son 24 saat" gibi absürt başlıklar kaldırılacak.
* **Ana Ekran Vücut Kokpiti:** Ana ekranda kullanıcının vücudundaki toparlanma durumunu (Akciğer oksijenasyonu, Kalp ritmi dengesi, CO arınması) gösteren görsel bir mini organ barı yer alacak.

### 3.2. Bilimsel Toksin ve Vücut Hesaplama Motoru
* **Girdi Parametreleri:** Boy ($cm$), Kilo ($kg$), Yaş, Cinsiyet (opsiyonel), Sigara başına katran ($mg$), Sigara başına nikotin ($mg$).
* **Formüller:**
  - Katran Birikimi ($mg$) = $\sum (\text{İçilen Sigara}) \times \text{Paket Katranı (mg)}$
  - Nikotin Dağılım Hacmi $V_d = \text{Kilo} \times 2.6 \text{ L/kg}$
  - Karbonmonoksit $t_{1/2} \approx 4$ saat klerens eğrisi
* **Görsel Eşdeğerler:** Katran miktarı miligramın yanında fiziksel hacim olarak da gösterilir (örn: "Bugün ciğerine giren katran: 16 mg ≈ 0.3 damla katran"). Zaman dilimi ("Bugün", "Bu Hafta", "Son 30 Gün", "Toplam") açıkça seçilebilir olacak.

### 3.3. Ana Ekran Yönetici Kokpiti (Executive Dashboard)
1. **Üst Bar:** Halen Logo + Bildirim/Profil ikonu + Ayarlar.
2. **Aktif Plan ve Ritim Kartı (Hero):**
   - Aktif Plan Adı (örn: *Kademeli Azaltma — 2. Hafta / 8 Hafta*)
   - Bugünkü Kota: *5 / 8 Sigara* (İlerleme çemberi)
   - Bir sonraki izin verilen / önerilen aralık: *14:30 (45 dk sonra)*
   - "Planı Yönet / Değiştir" hızlı geçiş butonu.
3. **Temel Eylem Çifti (Action Buttons):**
   - **BİR İSTEĞİ ATLATTIM (+1 Zafer)** — Parlak zümrüt yeşili, büyük, motive edici.
   - **SİGARAYI İÇTİM** — Nötr, sakin, gri-konturlu; cezalandırmayan ama ödüllendirmeyen net kayıt butonu.
4. **Sigara Günlüğü & Zaman Çizelgesi (YUKARI TAŞINDI):**
   - Eylem butonlarının hemen altında!
   - Bugün içilen saatler, aralıklar, son sigaradan geçen süre, anında geri alma (undo) ve düzenleme.
5. **Vücudum Şu Anda (Toksin & Organ Durumu):**
   - Nikotin (mg / Yük)
   - Karbonmonoksit (%)
   - **KATRAN (Bugünkü birikim mg)**
   - Mini Organ İyileşme Göstergesi (Tıklanınca Organ Haritasına zıplar).
6. **Ekonomi & Zaman Özeti (Hatasız):**
   - Fiili Tasarruf Edilen TL (Sadece Halen ile kaydedilen içilmeyen sigaralar).
   - Geçmiş Yılların Toplam Kaybı (Seçilebilir: 1 Yıl / 5 Yıl / 10 Yıl).
7. **Kriz & Destek (SOS) Hızlı Erişim Barı:**
   - Acil Nefes Egzersizi, Akupunktur Noktaları, ALO 171 ve Yeşilay 115 Tek Dokunuşla Arama.

### 3.4. Sigara İçildiğinde Verilen Tepki ve Psikoloji (Tone of Voice)
* **Kaldırılanlar:** "Başarısızlık değil, önümüzdeki 1 saat serin bırakmak için...", "Her gün biraz daha özgür."
* **Yeni Dil:**
  - **Başlık:** "Kayıt alındı."
  - **Biyolojik Gerçek:** "Vücuduna 1.0 mg nikotin ve 10 mg katran girdi. Vücudun bunu temizlemek için yaklaşık 8 saat çalışacak."
  - **Eylemsel Öneri:** "Şimdi büyük bir bardak su iç ve derin nefes al. Bir sonraki hedef saatine kadar kendine zaman tanı."
  - **Hızlı Geri Al:** "Yanlışlıkla mı bastın? Geri al."

### 3.5. Kriz (SOS), Akupunktur, Beslenme ve Destek Hatları
* **Kulak Akupunkturu (NADA Protokolü):**
  - Noktalar: *Shen Men (Ruh Kapısı - Stres kesici)*, *Sempatik (Sinir gevşetici)*, *Böbrek (İrade ve korku direnci)*, *Karaciğer (Öfke ve gerginlik regülasyonu)*, *Akciğer (Solunum açlığı ve detoks)*.
  - Her nokta için anatomik kulağın üzerinde tam konum, kaç saniye masaj yapılacağı ve vücuda etkisi.
* **Beslenme Rehberi:**
  - Kriz anında nikotini nötralize eden ve dopamini destekleyen gıdalar: Bol su, taze limon/portakal (C vitamini), havuç/kereviz sapı (ağız oyalaması ve alkali etki), çiğ badem (magnezyum).
  - Kaçınılması gerekenler: Alkol, aşırı kahve, rafine şeker (ani şeker düşüşü krizi tetikler).
* **Dünya ve Türkiye Bırakma Destek Hatları (Büyük Butonlar):**
  - 🇹🇷 **T.C. Sağlık Bakanlığı ALO 171 Sigara Bırakma Hattı**
  - 🇹🇷 **Yeşilay YEDAM 115**
  - 🇺🇸 **ABD:** 1-800-QUIT-NOW (1-800-784-8669)
  - 🇬🇧 **İngiltere:** NHS Smokefree 0300 123 1044
  - 🇩🇪 **Almanya:** BZgA 0800 8 313131
  - 🇫🇷 **Fransa:** Tabac Info Service 39 89

---

## 4. VERİTABANI VE MODEL MİMARİSİ (GENİŞLETİLMİŞ)

### 4.1. Kullanıcı Profili Tablosu (`user_profile`)
* `height_cm` (INT, nullable - Boy)
* `weight_kg` (DOUBLE, nullable - Kilo)
* `birth_year` (INT, nullable - Yaş hesabı için)
* `tar_per_cig` (DOUBLE, default 10.0 - Paket katranı mg)
* `nicotine_per_cig` (DOUBLE, default 0.8 - Paket nikotini mg)
* `smoking_years` (INT, default 5 - Geçmiş içicilik yılı)

### 4.2. Ekonomi ve Tasarruf Mantığı
* `actual_saved_money`: Sadece kullanıcının başlangıç tarihinden itibaren `baseline_cpd - actual_smoked` farkından hesaplanır. Geçmişe dönük hayali günler asla eklenmez!
* `lifetime_spent_money`: `smoking_years * 365 * baseline_cpd * price_per_cig`. Kullanıcının bugüne kadar sigaraya gömdüğü toplam servet.

---

## 5. MEVCUT DURUM VE TAMAMLANANLAR (CHECKLIST)

Aşağıdaki maddeler kod tabanında halihazırda uygulanmış ve doğrulanmıştır:

- [x] **Git Temel Doğrulaması:** Mevcut çalışma ağacı temizlendi, `v1.3.1-baseline` olarak etiketlendi ve origin/master'a push edildi.
- [x] **Tasarım Token Katmanı:** `lib/core/design/tokens.dart` ve `lib/core/design/data_palette.dart` mevcut.
- [x] **Tipografi:** Inter font ailesi (tabular rakam desteği ile) yüklü.
- [x] **Yerel Şifreli Veritabanı:** Drift + SQLCipher ve `flutter_secure_storage` entegrasyonu çalışıyor.
- [x] **Kademeli Azaltma Algoritması:** `plan_engine.dart` ve `soft_taper.dart` çekirdeği aktif.
- [x] **Çoklu Dil Altyapısı (l10n):** Türkçe (`app_tr.arb`), İngilizce (`app_en.arb`) ve Almanca (`app_de.arb`) altyapısı kurulu.
- [x] **Farmakoterapi Rehberi:** `medicines_screen.dart` ve temel NRT bilgileri mevcut.

---

## 6. YENİ YOL HARİTASI VE YAPILACAKLAR LİSTESİ (TODO CHECKLIST)

Bu liste, bu belgeden sonra sırayla ve adım adım hayata geçirilecek maddeleri içerir:

### Faz A: Bütünleşik Organ Haritası ve Yeni Nesil Akciğer Motoru
- [x] **A.1 Yeni Akciğer Çizim Motoru (`LungView`):** İlkel çizgisel çizim yerine medikal-estetik lob ayrımı, organik bronşiyal dallanma ve derinlikli nefes simülasyonu olan yeni CustomPainter geliştirmek.
- [x] **A.2 Akciğer ve Organ Sekmelerini Birleştirmek:** `BodyScreen` içerisindeki ayrı 'Bugün Akciğerlerin' sekmesini kaldırıp organ haritası ile tam entegre hale getirmek.
- [x] **A.3 Organ Kartı Başlık ve Bilgi Hiyerarşisi Düzeltmesi:** Organa tıklandığında 'Bu organ son 24 saat' yazısını kaldırmak; en üste organın adını, ikonunu, maruziyet seviyesini ve net toparlanma durumunu koymak.
- [x] **A.4 Ana Ekran Organ Toparlanma Vitrini:** Ana ekranda kullanıcının organlarının iyileşme hızını özetleyen interaktif mini organ kokpitini eklemek.

### Faz B: Bilimsel Hesaplama Motoru (Boy, Kilo, Yaş, Katran, Paket Verileri)
- [x] **B.1 Profil Modeline Parametrelerin Eklenmesi:** Drift şemasında ve `UserProfile` entity'sinde boy, kilo, yaş/doğum yılı, paket katranı ve nikotini alanlarını tanımlamak.
- [x] **B.2 Onboarding ve Ayarlar Ekranlarına Entegrasyon:** Kullanıcının boy, kilo, yaş ve paket değerlerini girebilmesi; boş bırakıldığında yasal/tıbbi ortalamaların atanması.
- [x] **B.3 Farmakokinetik Hesaplayıcı Güncellemesi:** Nikotin dağılım hacmini kilo ile ölçeklemek; katran birikimini ve klerensini günlük/haftalık/aylık metriklerle tam bilimsel temele oturtmak.
- [x] **B.4 Ana Ekranda KATRAN (Tar) Göstergesi:** `NowInBodyStrip` bileşenine nikotin ve karbonmonoksitin yanına belirgin bir şekilde KATRAN yükünü eklemek.

### Faz C: Ana Ekran Yönetici Kokpiti ve UX Düzeltmeleri
- [x] **C.1 Aktif Plan ve Durum Kartı:** 'Her gün biraz daha özgür' sloganını kaldırmak; yerine kullanıcının aktif planını, haftasını, bugünkü hedefini ve bir sonraki sigara zamanını gösteren yönetici kartını yerleştirmek.
- [x] **C.2 Sigara Günlüğü Bileşenini Yukarı Taşımak:** `TodayLogCard`'ı eylem butonlarının hemen altına yerleştirerek kullanıcının içtiği sigaraları ve zaman aralıklarını anında görmesini sağlamak.
- [x] **C.3 'Sigarayı İçtim' Geri Bildirim Dili Düzeltmesi:** Ödüllendirici/pasif-agresif metinleri kaldırıp; objektif biyolojik etki (alınan nikotin/katran) ve hemen atılabilecek sağlıklı adım (su içme, yürüyüş) sunan net bir dile geçmek.
- [x] **C.4 İlerleme Puanı ve Basınç Göstergesi Sadeleştirmesi:** 'Davranışsal Hedefe Uyum Skoru' ile 'Toksin Yükü' arasındaki farkı netleştirmek; yoksunluk basınç grafiğini yüzde ve somut zaman dilimleriyle açıklamak.

### Faz D: Ekonomi ve Tasarruf Mantık Hatasının Düzeltilmesi
- [x] **D.1 Boş Günlerden Doğan Hayali Kazancı Yok Etmek:** `economy_screen.dart` ve `economy.dart` içindeki geçmiş 90 gün açığını düzeltmek; sadece kullanıcının takipte olduğu gerçek günlerin içilmeyen sigaralarını tasarrufa dahil etmek.
- [x] **D.2 Geçmiş Zarar vs. Gelecek Kazanç Ayrımı:** Kullanıcının sigara içtiği yıllar (5, 10, 15, 20 yıl) boyunca harcadığı toplam tutarı gösteren 'Geçmiş Maliyet' grafiği ile 'Halen ile Fiili Tasarruf'u iki ayrı net sekme/filtre ile sunmak (1 Ay, 1 Yıl, Tümü).

### Faz E: Kriz (SOS), Akupunktur, Beslenme ve Bırakma Destek Hatları
- [x] **E.1 Kapsamlı Kulak Akupunkturu Rehberi:** NADA protokolü 5 noktasını (Shen Men, Akciğer, Karaciğer, Böbrek, Otonom) anatomik rehber, görsel illüstrasyon, masaj süresi ve etki mekanizmasıyla zenginleştirmek.
- [x] **E.2 Sigara Krizini Bastıran Beslenme & Gıda Rehberi:** C vitamini, alkali gıdalar, magnezyum zengini besinler ve kaçınılması gereken tetikleyicilerle ilgili yeni bir rehber/modül ekranı eklemek.
- [x] **E.3 Destek Hatları Acil Arama Butonları:** SOS ekranına ve Kriz merkezine ALO 171 Sigara Bırakma Hattı, YEDAM 115 ve uluslararası hatlar için tek tıkla arama sağlayan belirgin butonlar eklemek.
- [x] **E.4 İstek Atlatma (Craving) Günlüğü:** 'Nasıl geçti? Ne kadar güçlüydü?' akışını kullanıcının geçmiş krizleri nasıl yendiğini gösteren motive edici bir başarı geçmişine dönüştürmek.

---

## 7. ESKİ BELGELERİN ARŞİVLENMESİ / TEMİZLENMESİ

Bu master belgenin yürürlüğe girmesiyle birlikte:
* `HALEN-PREMIUM-BRIEF.md` -> Silindi (İçeriği bu belgeye aktarıldı)
* `HALEN-PREMIUM-PLAN.md` -> Silindi (İçeriği bu belgeye aktarıldı)
* `halen-modul-derin-arastirma-raporu.md` -> Silindi (İçeriği bu belgeye aktarıldı)
* `sigara-birakma-app-on-arastirma-ve-urun-raporu.md` -> Silindi (İçeriği bu belgeye aktarıldı)

Projedeki tek kılavuz ve geçerli çalışma planı artık **bu dosyadır (`HALEN_MASTER_ROADMAP.md`)**.
