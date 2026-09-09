// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Halen';

  @override
  String get tagline => 'Kendi hızında azalt, kalıcı bırak.';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonNext => 'İleri';

  @override
  String get commonBack => 'Geri';

  @override
  String get commonDone => 'Tamam';

  @override
  String get commonEdit => 'Düzenle';

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get commonOk => 'Tamam';

  @override
  String get commonHowCalculated => 'Bu tahmin nasıl hesaplandı?';

  @override
  String get commonModelTag => 'tahmini · model';

  @override
  String get commonErrorTitle => 'Bir şeyler ters gitti';

  @override
  String get commonLoading => 'Yükleniyor…';

  @override
  String get commonPremiumLocked =>
      'Bu özellik Halen Premium\'da. 7 günlük denemen her şeyi ücretsiz kapsıyor.';

  @override
  String get commonUnlockPremium => 'Tek seferlik teklifi gör';

  @override
  String get splashWelcomeTitle => 'Halen\'e hoş geldin';

  @override
  String get splashTagline => 'Kendi hızında azalt, kalıcı bırak.';

  @override
  String get splashPrivacyLine =>
      'Hesap yok. Sunucu yok. Verilerin sadece bu cihazda.';

  @override
  String get splashBackupLine =>
      'Otomatik bulut yedeği kapalıdır; kayıtların bu telefondan asla çıkmaz.';

  @override
  String get splashMedicalNote =>
      'Bu uygulama tıbbi tavsiye değildir. Nikotin bağımlılığının tedavisi için bir sağlık profesyoneline başvurun.';

  @override
  String get splashNotificationRationale =>
      'Bildirimler planını hatırlatmak için kullanılır — spam asla. İstersen daha sonra da açabilirsin.';

  @override
  String get splashEnableNotifications => 'Bildirimlere izin ver';

  @override
  String get splashStart => 'Başla';

  @override
  String obStepOf(int n) {
    return 'Adım $n/7';
  }

  @override
  String get obAgeTitle => 'Kaç yaşındasın?';

  @override
  String get obAgeUnder18 => '18 yaş altı';

  @override
  String get obAge18to24 => '18–24';

  @override
  String get obAge25to34 => '25–34';

  @override
  String get obAge35to44 => '35–44';

  @override
  String get obAge45to54 => '45–54';

  @override
  String get obAge55plus => '55+';

  @override
  String get obUnder18Notice =>
      'Halen yetişkinler için tasarlandı. Gençler için destek programları daha uygundur — şu ücretsiz kaynaklar yardımcı olabilir.';

  @override
  String get obUnder18NoPlan => 'Azaltma planı oluşturulmayacak.';

  @override
  String get obCpdTitle => 'Ortalama günde kaç sigara içiyorsun?';

  @override
  String get obCpdHint =>
      'İlk hafta bu değeri gerçek kayıtlarınla kalibre ederiz.';

  @override
  String get obTtfcTitle =>
      'Uyandıktan sonra ilk sigaranı kaç dakika içinde içiyorsun?';

  @override
  String get obTtfcUnder5 => '5 dakikadan kısa';

  @override
  String get obTtfc5to30 => '5–30 dakika';

  @override
  String get obTtfc31to60 => '31–60 dakika';

  @override
  String get obTtfcOver60 => '60 dakikadan sonra';

  @override
  String get obPriceTitle => 'Paket fiyatı ne kadar?';

  @override
  String get obPriceHint =>
      'Ülken tipik fiyatıyla ön-dolu — gerçek fiyatınla güncelle.';

  @override
  String get obPackSizeLabel => 'Paketteki sigara sayısı';

  @override
  String get obTimesTitle => 'Sigarayı en çok ne zaman içersin?';

  @override
  String get obTimesHint =>
      'Uygun olanları seç. Günlük planın buna göre şekillenecek.';

  @override
  String get triggerCoffee => 'Kahve';

  @override
  String get triggerAfterMeal => 'Yemek sonrası';

  @override
  String get triggerStress => 'Stres';

  @override
  String get triggerAlcohol => 'Alkol';

  @override
  String get triggerCar => 'Arabada';

  @override
  String get triggerSocial => 'Sosyal ortam';

  @override
  String get triggerWorkBreak => 'İş molası';

  @override
  String get triggerBeforeSleep => 'Uyku öncesi';

  @override
  String get triggerWakeUp => 'Uyanınca';

  @override
  String get obGoalTitle => 'Hedefin ne?';

  @override
  String get obGoalReduce => 'Azaltarak bırak';

  @override
  String get obGoalReduceHint => 'Önerilen — sana uyum sağlayan bir plan';

  @override
  String get obGoalQuitNow => 'Hemen bırak';

  @override
  String get obGoalQuitNowHint =>
      'İlk günlerden yoğun destekli bırakma programı';

  @override
  String get obGoalUndecided => 'Kararsızım';

  @override
  String get obGoalUndecidedHint => 'Azaltarak başla, sonra karar ver';

  @override
  String get obBrandTitle => 'Markan (opsiyonel)';

  @override
  String get obBrandHint =>
      'Yalnızca tasarruf hesabının hassasiyeti için. Atlayabilirsin.';

  @override
  String get obBrandSkip => 'Atla';

  @override
  String get obFinalDisclaimer =>
      'Bu uygulama tıbbi tavsiye değildir; nikotin bağımlılığının tedavisi için bir sağlık profesyoneline başvurun. Hamilelik, kalp rahatsızlığı ve psikiyatrik durumlarda önce uzman görüşü alın.';

  @override
  String get obDataNote =>
      'Bu cevaplar yalnızca planını kurmak için kullanılır ve cihazından çıkmaz.';

  @override
  String get obFinish => 'Planımı kur';

  @override
  String get todayTitle => 'Bugün';

  @override
  String todayRingLabel(int smoked, int target) {
    return 'Bugün $smoked/$target';
  }

  @override
  String lastCigaretteMinutes(int n) {
    return 'Son sigara: $n dk önce';
  }

  @override
  String lastCigaretteHours(int h, int m) {
    return 'Son sigara: $h sa $m dk önce';
  }

  @override
  String get lastCigaretteNone => 'Bugün henüz kayıt yok';

  @override
  String nextTargetIn(int n) {
    return 'Sonraki hedef: en erken $n dk sonra';
  }

  @override
  String nextTargetHoursIn(int h, int m) {
    return 'Sonraki hedef: en erken $h sa $m dk sonra';
  }

  @override
  String get nextTargetReady => 'Sonraki hedef: planlanan aralıktasın';

  @override
  String get nextTargetDayDone => 'Günlük plan tamamlandı — iyi gitti';

  @override
  String get nicotineMiniLabel => 'Tahmini nikotin maruziyeti (model)';

  @override
  String get ctaSmoked => 'İÇTİM';

  @override
  String get ctaResisted => 'İstek atlattım';

  @override
  String resistedTodayCount(int n) {
    return 'bugün $n';
  }

  @override
  String savingsStrip(String amount, int n) {
    return '$amount kazandın · $n sigara atladın';
  }

  @override
  String healthStrip(String text) {
    return 'Sırada: $text';
  }

  @override
  String get recalcTitle => 'Yeniden hesapladık.';

  @override
  String get recalcDistributed =>
      'Bugünün kalan bütçesi günün kalan saatlerine dağıtıldı.';

  @override
  String get recalcBunched =>
      'Bugünkü tüketimin planlanan aralığın üzerinde sıkışmış; bir sonrakini planlanan zamana yaklaştırmayı dene.';

  @override
  String get recalcWeekSoftened =>
      'Bu hafta bütçe taştı; gelecek hafta %5 daha yumuşak başlıyor.';

  @override
  String get todayEmptyFirstDay =>
      'İlk günün — plan, kayıtların ve cevaplarınla şekillenecek.';

  @override
  String get todayPlanLockedFree =>
      'Uyum sağlayan planın Premium\'da. Kayıt, tasarruf ve gün sayacı sonsuza dek ücretsiz.';

  @override
  String daysSinceStart(int n) {
    return 'Halen ile $n. gün';
  }

  @override
  String get recordDetailTitle => 'Kayıt detayı';

  @override
  String get recordDetailHint => 'Opsiyonel — tek dokunuşla etiket ekle.';

  @override
  String get recordDetailSaved => 'Kaydedildi.';

  @override
  String get recordLoggedToast => 'Kaydedildi.';

  @override
  String get sourceApp => 'Uygulama';

  @override
  String get sourceWidget => 'Widget';

  @override
  String get sourceTile => 'Hızlı kutucuk';

  @override
  String get sourceControl => 'Kontrol merkezi';

  @override
  String get sourceNotif => 'Bildirim';

  @override
  String get planTitle => 'Plan';

  @override
  String planTodayBudget(int n) {
    return 'Bugünkü bütçe: $n';
  }

  @override
  String get planWindowsTitle => 'Planlanan aralıklar';

  @override
  String planMinGapRule(int n) {
    return 'İki sigara arasında en az $n dakika bırak.';
  }

  @override
  String planAdherence7(int n) {
    return '7 günlük plan uyumu: %$n';
  }

  @override
  String planAdherence14(int n) {
    return '14 günlük plan uyumu: %$n';
  }

  @override
  String planWeeksEstimate(int x, int y) {
    return 'Son 7 günün ilerlemesi bu hızla sürerse hedefe yaklaşık $x–$y hafta içinde ulaşman mümkün görünüyor.';
  }

  @override
  String get planPhaseReduction => 'Azaltma';

  @override
  String get planPhaseFinal => 'Son hafta';

  @override
  String get planPhaseQuit => 'Bırakma programı';

  @override
  String phaseWeekOf(int n, int total) {
    return '$total haftanın $n. haftası';
  }

  @override
  String get paceCalm => 'Sakin — 8 hafta, haftalık yaklaşık %8–10 azaltma';

  @override
  String get paceStandard =>
      'Standart — 6 hafta, haftalık yaklaşık %12–15 azaltma';

  @override
  String get paceFast => 'Hızlı — 4 hafta, haftalık yaklaşık %18–22 azaltma';

  @override
  String get paceSettingLabel => 'Azaltma hızı';

  @override
  String get paceChanged => 'Hız güncellendi.';

  @override
  String get tempoAutoAdjusted => 'Tempoyu gerçeklerine göre ayarladık.';

  @override
  String get tempoUpSuggestion =>
      'Planına düzenli uyuyorsun. Tempoyu biraz artırmak ister misin?';

  @override
  String get tempoUpApply => 'Tempoyu artır';

  @override
  String get finalWeekTitle => 'Son hafta';

  @override
  String get finalWeekBody =>
      'Günlük bütçen 3\'e indi. Bırakma gününü seç — vaat değil, plan.';

  @override
  String get quitDayConfirmTitle => 'Bırakma gününü onayla';

  @override
  String quitDaySet(String date) {
    return 'Bırakma günü seçildi: $date';
  }

  @override
  String get quitDayChoose => 'Bir gün seç';

  @override
  String get quitProgramTitle => 'Bırakma programı';

  @override
  String get quitPrepTitle => 'Hazırlık haftası';

  @override
  String get quitPrepBody =>
      'Tetikleyicilerini ve nedenini yaz. Cümleyi tamamla: “X olursa, Y yapacağım.”';

  @override
  String get quit24hTitle => 'İlk 24 saat';

  @override
  String get quit24hBody =>
      'Tahmini maruziyet eğrin hızla düşüyor. İstekler genellikle birkaç dakika sürer.';

  @override
  String get quit72hTitle => 'İlk 72 saat';

  @override
  String get quit72hBody =>
      'Fiziksel yoksunluk genellikle ilk hafta en yoğundur ve zamanla azalır. Bu dönemde ekstra destek açık.';

  @override
  String get quitWeek1Title => '1. hafta';

  @override
  String get quitWeek1Body =>
      'İstekler ilk hafta en sık gelir ve zamanla azalır.';

  @override
  String get quitWeek2to4Title => '2–4. hafta';

  @override
  String get quitWeek2to4Body =>
      'Alışkanlıklar zaman ister — alışkanlık değişiminin medyanı ~66 gün ve kişiden kişiye çok değişir.';

  @override
  String get planLockedFree =>
      'Dinamik plan motoru Premium\'da. Kayıt, tasarruf ve gün sayacın sonsuza dek ücretsiz kalır.';

  @override
  String get quitSupportLine =>
      'Bir sağlık profesyoneli bırakma yöntemlerini (nikotin replasman tedavisi dahil) sizinle konuşabilir.';

  @override
  String get statsTitle => 'İstatistikler';

  @override
  String get chartDaily => 'Günlük sayı';

  @override
  String get chartPlanVsActual => 'Plan / gerçekleşen';

  @override
  String get chartGaps => 'Sigara-arası süre';

  @override
  String get chartHourly => 'Saatlik yoğunluk';

  @override
  String get chartSavings => 'Tasarruf';

  @override
  String get statsRange7 => 'Son 7 gün';

  @override
  String get statsRange30 => 'Son 30 gün';

  @override
  String get statsRangeAll => 'Tüm zamanlar';

  @override
  String get statsRangeLockedPremium =>
      '30 günlük ve tüm zamanlar grafikleri Premium\'da.';

  @override
  String get triggerAnalysisTitle => 'Tetikleyici desenleri';

  @override
  String get triggerAnalysisEmpty =>
      'Tetikleyici desenleri için en az 10 etiketli kayıt gerekiyor. Etiketlemeye devam et — bu kendiliğinden görünecek.';

  @override
  String triggerRiskWindow(String trigger) {
    return '$trigger sonrası ilk 15 dakika senin için riskli bir pencere görünüyor.';
  }

  @override
  String triggerSampleNote(int n) {
    return '$n etiketli kayda dayanıyor.';
  }

  @override
  String a11yDailyChartSummary(int count, int target, int adherence) {
    return 'Dün $count, hedef $target, plana uyum yüzde $adherence.';
  }

  @override
  String get sosTitle => 'İstek atlatma';

  @override
  String get sosIntro =>
      'İstekler genellikle birkaç dakika sürer. Bunlardan biriyle bekle.';

  @override
  String get sosTimerTitle => '2 dakikalık sayaç';

  @override
  String sosTimerRunning(int s) {
    return 'Dayan — $s sn kaldı';
  }

  @override
  String get sosTimerDone => 'İki dakika tamam. Dalga geçti.';

  @override
  String get sos4dDelay => 'Ertele';

  @override
  String get sos4dDelayBody => 'Karar vermeden önce iki dakika ver kendine.';

  @override
  String get sos4dBreathe => 'Derin nefes';

  @override
  String get sos4dBreatheBody => 'Rehberli 60 saniye kutu nefesi.';

  @override
  String get sos4dWater => 'Su iç';

  @override
  String get sos4dWaterBody => 'Bir bardak su, yavaş yavaş.';

  @override
  String get sos4dElse => 'Başka bir şey yap';

  @override
  String get sos4dElseBody =>
      'İki dakika herhangi bir şey — yürü, elini yıka, dışarı çık.';

  @override
  String get sosUrgeSurf => 'İzle ve bekle';

  @override
  String get sosUrgeSurfBody =>
      'İsteği bir dalga gibi izle: yükselir, zirve yapar, düşer. Onunla savaşmak zorunda değilsin.';

  @override
  String get sosBreathingIn => 'İçer';

  @override
  String get sosBreathingHold => 'Tut';

  @override
  String get sosBreathingOut => 'Dışa';

  @override
  String get sosBreathingFinished => 'Bir dakika tamam.';

  @override
  String get sosOutcomeTitle => 'Nasıl geçti?';

  @override
  String get sosResisted => 'Atlattım';

  @override
  String get sosSmoked => 'İçtim';

  @override
  String sosResistedCount(int n) {
    return 'Bugüne kadar $n isteği atlattın.';
  }

  @override
  String get sosAfterSmoked =>
      'Kaydettik. Planını yeniden hesapladık — plan sadece uyarlanmaya devam eder.';

  @override
  String get sosIntensityTitle => 'Ne kadar güçlüydü?';

  @override
  String get sosIntensity1 => 'Hafif';

  @override
  String get sosIntensity2 => 'Orta';

  @override
  String get sosIntensity3 => 'Güçlü';

  @override
  String get sosAfterResisted => 'Kaydedildi — atlatılan her istek sayıyor.';

  @override
  String get sosNrtLine =>
      'NRT gibi seçenekleri bir sağlık profesyoneliyle konuşabilirsin.';

  @override
  String get sosLocked =>
      'Tam SOS araç seti (nefes animasyonu, izle ve bekle) Premium\'da — deneme süresince ücretsiz.';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsNotifications => 'Bildirimler';

  @override
  String get notifDensity => 'Yoğunluk';

  @override
  String get notifDensityCalm => 'Sakin';

  @override
  String get notifDensityStandard => 'Standart';

  @override
  String get notifDensityIntense => 'Yoğun';

  @override
  String get notifDensityOff => 'Kapalı';

  @override
  String get notifSummaryTitle => 'Halen ile günün';

  @override
  String notifSummaryBody(int count, int target) {
    return 'Bugün: $count/$target. Her kayıt planı düzgün tutar.';
  }

  @override
  String get notifMorningTitle => 'Bugünün bütçesi Halen’de';

  @override
  String get notifMorningBody => 'Küçük adımlar önemli. Tempo senin.';

  @override
  String get notifPlanTitle => 'Planlanan zaman yaklaşıyor';

  @override
  String get notifPlanBody => 'Sonraki planlı aralığın yakında başlıyor.';

  @override
  String get notifReturnTitle => 'Orada mısın?';

  @override
  String get notifReturnBody =>
      'Bir kaç gündür kayıt yok — kaldığın yerden devam edebilirsin.';

  @override
  String get notifQuitTitle => 'İlk saatler en önemlisi';

  @override
  String get notifQuitBody =>
      'Dalga yükselir, zirve yapar, düşer. Dayan — bu uygulama seninle.';

  @override
  String get notifMilestoneTitle => 'Yeni dönüm noktası';

  @override
  String get notifMilestoneBody => 'Sağlık çizelgende yeni bir eşik açıldı.';

  @override
  String get notifChannelReminders => 'Hatırlatmalar';

  @override
  String get notifChannelSupport => 'Destek';

  @override
  String get notifSummaryGeneric => 'Her kayıt planı düzgün tutar.';

  @override
  String get notifDailySummary => 'Günlük özet (akşam)';

  @override
  String get notifMorningGoal => 'Sabah hedefi';

  @override
  String get notifPlanReminder => 'Planlanan saat yaklaşıyor';

  @override
  String get notifQuitSupport => 'Bırakma günü desteği (ilk 72 saat)';

  @override
  String get notifMilestones => 'Kilometre taşları';

  @override
  String get notifGentleReturn => 'Sessizlikten sonra nazik dönüş';

  @override
  String get notifExactTime => 'Tam saatte hatırlatma';

  @override
  String get notifExactTimeHint =>
      'Varsayılan kapalı; Android bunları yaklaşık saatte gösterir. Açarsan tam alarm kullanılır.';

  @override
  String get settingsAppearance => 'Görünüm';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get settingsReduceMotion => 'Hareketi azalt';

  @override
  String get settingsHaptics => 'Dokunsal geri bildirim';

  @override
  String get settingsData => 'Verilerin';

  @override
  String get settingsExport => 'Verileri dışa aktar (JSON)';

  @override
  String get settingsImport => 'Verileri içe aktar (JSON)';

  @override
  String settingsExportDone(String path) {
    return 'Yedek kaydedildi: $path';
  }

  @override
  String settingsImportDone(int n) {
    return 'İçe aktarıldı — $n kayıt geri geldi.';
  }

  @override
  String get settingsDeleteAll => 'Tüm verileri sil';

  @override
  String get deleteAllConfirm => 'Her şey silinsin mi? Bu işlem geri alınamaz.';

  @override
  String get settingsPurchase => 'Halen Lifetime';

  @override
  String get purchaseCopy => 'Tek seferlik · Ömür boyu · Abonelik yok';

  @override
  String get purchaseCta => 'Tek seferlik satın al';

  @override
  String get purchaseRestore => 'Satın almayı geri yükle';

  @override
  String get purchaseOwned => 'Halen Lifetime\'a sahipsin.';

  @override
  String get purchasePending =>
      'Satın almanın beklemede — tamamlandığında erişim açılır.';

  @override
  String trialDaysLeft(int n) {
    return 'Deneme: $n gün kaldı';
  }

  @override
  String get trialExpiredFree =>
      'Deneme bitti — ücretsiz katman (kayıt, tasarruf, gün sayacı, 7 günlük grafik, export) sonsuza dek senin.';

  @override
  String get settingsAbout => 'Hakkında';

  @override
  String get settingsDisclaimerTitle => 'Sağlık notu';

  @override
  String get settingsDisclaimer =>
      'Bu uygulama tıbbi tavsiye değildir; nikotin bağımlılığının tedavisi için bir sağlık profesyoneline başvurun. Hamilelik, kalp rahatsızlığı ve psikiyatrik durumlarda önce uzman görüşü alın.';

  @override
  String get settingsHelplines =>
      'Destek hatları: TR Yeşilay 176 · ABD 1-800-QUIT-NOW · UK NHS · DE BZgA';

  @override
  String get settingsPrivacy =>
      'Gizlilik: hesap yok, sunucu yok, analitik yok. Kayıtların bu cihazda kalır.';

  @override
  String get settingsPrivacyPolicy => 'Gizlilik politikası';

  @override
  String settingsVersion(String v) {
    return 'Sürüm $v';
  }

  @override
  String get paywallTitle => 'Halen Premium ile devam et';

  @override
  String paywallValueLine(int n) {
    return 'Bu hafta planına zamanın %$n\'inde uyudun.';
  }

  @override
  String get paywallFeaturePlan =>
      'Kendini yeniden hesaplayan dinamik azaltma planı';

  @override
  String get paywallFeatureCharts =>
      'Tam grafikler: plan/gerçekleşen, aralıklar, saatlik desen';

  @override
  String get paywallFeatureTriggers => 'Tetikleyici desenleri';

  @override
  String get paywallFeatureTimeline => 'Tam sağlık çizelgesi';

  @override
  String get paywallFeatureSos => 'Tam SOS araç seti';

  @override
  String get paywallFeatureWidget => 'Widget özelleştirme';

  @override
  String get paywallTrialNote =>
      '7 günlük ücretsiz deneme ilk açılışta başlar — kart gerekmez.';

  @override
  String get timelineTitle => 'Sağlık çizelgesi';

  @override
  String get timelinePreviewLocked =>
      'Azaltma modunda sayma, bırakma gününde başlar. O güne kadar burası bir önizleme.';

  @override
  String get timelineSourceWho => 'Kaynak: WHO';

  @override
  String get timelineSourceCdc => 'Kaynak: CDC';

  @override
  String get timelineGeneralPattern => 'Genel olarak, sigarayı bırakanlarda…';

  @override
  String get timelineMilestone20min => '20 dakika';

  @override
  String get timelineBody20min =>
      'Genel olarak, sigarayı bırakanlarda kalp atış hızı ve tansiyon düşer.';

  @override
  String get timelineMilestone12h => '12 saat';

  @override
  String get timelineBody12h =>
      'Genel olarak, sigarayı bırakanlarda kandaki karbon monoksit düzeyi normale döner.';

  @override
  String get timelineCoCard =>
      'Kanındaki karbon monoksit yaklaşık 12 saatte normale döner — WHO';

  @override
  String get timelineMilestone2to12w => '2–12 hafta';

  @override
  String get timelineBody2to12w =>
      'Genel olarak, sigarayı bırakanlarda dolaşım ve akciğer fonksiyonu iyileşir.';

  @override
  String get timelineMilestone1to9m => '1–9 ay';

  @override
  String get timelineBody1to9m =>
      'Genel olarak, sigarayı bırakanlarda öksürük ve nefes darlığı azalır.';

  @override
  String get timelineMilestone1y => '1 yıl';

  @override
  String get timelineBody1y =>
      'Genel olarak, sigarayı bırakanlarda koroner kalp hastalığı riski, sigara içen birine göre yaklaşık yarıya iner.';

  @override
  String get timelineMilestone5to15y => '5–15 yıl';

  @override
  String get timelineBody5to15y =>
      'Genel olarak, sigarayı bırakanlarda inme riski hiç içmemiş birinin seviyesine iner.';

  @override
  String get timelineMilestone10y => '10 yıl';

  @override
  String get timelineBody10y =>
      'Genel olarak, sigarayı bırakanlarda akciğer kanseri riski, sigara içen birine göre yaklaşık yarıya iner.';

  @override
  String get timelineMilestone15y => '15 yıl';

  @override
  String get timelineBody15y =>
      'Genel olarak, sigarayı bırakanlarda koroner kalp hastalığı riski hiç içmemiş birine benzer seviyeye iner.';

  @override
  String get howNicotineTitle => 'Nikotin tahmini nasıl hesaplanıyor?';

  @override
  String get howNicotineBody =>
      'Her sigara için yaklaşık 1,2 mg emilmiş nikotin varsayılır (yayınlanmış aralık kabaca 1–1,5 mg). Tahmini maruziyet eğrisi kaydettiğin her sigarayı toplar ve toplamı her 2 saatte yarıya indirir — nikotinin tipik plazma yarı ömrü. Ekranda 0–100 normalize eğri görürsün; asla mutlak kan değeri gösterilmez.';

  @override
  String get howNicotineLimits =>
      'Sınırlar: bu bir davranışsal modeldir, ölçüm değildir. Emilim; nasıl içtiğine, ürüne ve metabolizmana göre değişir. Bu uygulamada hiçbir şey bedeninden ölçülmez.';

  @override
  String get howNicotineSources =>
      'Kaynaklar: Benowitz, NEJM 2010 (sigara başına 1–1,5 mg emilim); Hukkanen ve ark., Pharmacol Rev 2005 (plazma yarı ömrü ~2 sa).';

  @override
  String get howWeeksTitle => 'Hafta tahmini nasıl hesaplanıyor?';

  @override
  String get howWeeksBody =>
      'Son 7 günün ortalamasını haftalık azaltma oranınla karşılaştırır ve günlük bütçenin son-hafta seviyesine indiği noktayı hesaplarız. Sonuç her zaman bir aralıktır ve her hafta güncellenir — kesin bir tarih değildir.';

  @override
  String get howSavingsTitle => 'Tasarruf nasıl hesaplanıyor?';

  @override
  String get howSavingsBody =>
      'Paket fiyatının paketteki sigara sayısına bölümü tek sigara maliyetini verir. Taban çizgine göre atladığın sigaralar bu maliyetle çarpılır. Girdiğin fiyatlar cihazında kalır.';

  @override
  String get howTitle => 'Bu tahmin nasıl hesaplandı?';

  @override
  String motivationStreakBest(int n) {
    return 'En uzun plan-uyum serin: $n gün';
  }

  @override
  String get motivationStreakRestart => 'Yeniden başlamak normaldir.';

  @override
  String motivationAvoidedTotal(int n) {
    return 'Bugüne kadar $n sigara atladın';
  }

  @override
  String motivationWhoNext(String text) {
    return 'Sıradaki eşik: $text';
  }

  @override
  String get notificationDailySummaryTitle => 'Bugünün özeti';

  @override
  String notificationDailySummaryBody(int smoked, int target, String extra) {
    return 'Bugün $smoked/$target. $extra';
  }

  @override
  String notificationMorningTitle(int n) {
    return 'Bugünün hedefi: $n';
  }

  @override
  String get notificationMorningBody =>
      'Tek dokunuş yeter — sayıyı Halen tutar.';

  @override
  String get notificationPlanReminderTitle => 'Planlanan aralık';

  @override
  String get notificationPlanReminderBody =>
      'Sıradaki planlanan aralığın şu sıralar.';

  @override
  String get notificationQuitSupportTitle => 'İyi gidiyorsun';

  @override
  String get notificationQuitSupportBody =>
      'İstekler başta zirve yapar ve söner. Gelirse SOS\'u aç.';

  @override
  String notificationMilestoneTitle(String name) {
    return 'Kilometre taşı: $name';
  }

  @override
  String get notificationGentleReturnTitle => 'Kaldığın yerden devam et';

  @override
  String get notificationGentleReturnBody =>
      'Birkaç gündür kayıt yok — planın aynen bekliyor. Tek dokunuş her şeyi sürdürür.';

  @override
  String get under18YouthTitle => 'Gençler için destek';

  @override
  String get under18YouthBody =>
      'Halen yetişkinler için tasarlandı ve sana plan oluşturmayacak. Gençlere uygun ücretsiz destekler var — bir doktor, okul rehberi ya da bırakma hattıyla konuşmak güçlü bir ilk adımdır.';

  @override
  String get errorDatabaseTitle => 'Veritabanı açılamadı';

  @override
  String get errorDatabaseBody =>
      'Şifreli veritabanın bu cihazda açılamadı. Hiçbir veri hiçbir yere gönderilmedi.';

  @override
  String get emptyGeneric => 'Burada henüz bir şey yok.';

  @override
  String get emptyNoRecords => 'Henüz kayıt yok — ilk dokunuş sayacı başlatır.';

  @override
  String a11yRing(int smoked, int target) {
    return 'Bugünün halkası: hedef $target, içilen $smoked';
  }

  @override
  String get a11yNicotineChart =>
      'Tahmini nikotin maruziyet eğrisi. Her kayıtta yükselir, iki saatte bir yarıya düşer.';

  @override
  String get a11ySavingsChart => 'Tasarruf grafiği, seçili aralıkta birikimli.';

  @override
  String get navToday => 'Bugün';

  @override
  String get navStats => 'Grafikler';

  @override
  String get navPlan => 'Plan';

  @override
  String get navArticles => 'Rehber';

  @override
  String get navSos => 'Kriz SOS';

  @override
  String get statsTabDaily => 'Günlük Trend';

  @override
  String get statsTabHourly => '24s Dağılım';

  @override
  String get statsTabIntervals => 'Aralıklar';

  @override
  String get statsTabTriggers => 'Tetikleyiciler';

  @override
  String get intervalTitle => 'Sigara Arası Süreler';

  @override
  String get intervalSubtitle => 'İki sigara arasında geçen sürelerin dağılımı';

  @override
  String get intervalAverage => 'Ortalama aralık';

  @override
  String get intervalLongest => 'En uzun sigarasız süre';

  @override
  String get intervalShortest => 'En kısa aralık';

  @override
  String get intervalCurrent => 'Mevcut sigarasız süre';

  @override
  String intervalMinutes(int m) {
    return '$m dk';
  }

  @override
  String intervalHoursMinutes(int h, int m) {
    return '$h sa $m dk';
  }

  @override
  String get hourlyTitle => '24 Saatlik İçme Dağılımı';

  @override
  String get hourlySubtitle => 'Günün hangi saatlerinde yoğun içiyorsun';

  @override
  String hourlyPeak(int hour, int count) {
    return 'En yoğun saat: $hour:00 ($count sigara)';
  }

  @override
  String get timeMorning => 'Sabah (06–12)';

  @override
  String get timeAfternoon => 'Öğleden Sonra (12–18)';

  @override
  String get timeEvening => 'Akşam (18–24)';

  @override
  String get timeNight => 'Gece (00–06)';

  @override
  String get triggerTitle => 'Tetikleyici Analizi';

  @override
  String get triggerSubtitle => 'İsteği en çok ne tetikliyor';

  @override
  String triggerOccurrences(int count, int percent) {
    return '$count kez (%$percent)';
  }

  @override
  String get todayLogTitle => 'Bugünün Sigara Günlüğü';

  @override
  String get todayLogSubtitle => 'Gün içinde içilen sigaraların saatlik dökümü';

  @override
  String get todayLogEmpty => 'Bugün henüz sigara kaydı yok';

  @override
  String get deleteCigaretteConfirm =>
      'Bu sigara kaydını silmek istiyor musunuz?';

  @override
  String get deletedCigaretteSuccess => 'Kayıt silindi';

  @override
  String get articlesTitle => 'Rehber & Makaleler';

  @override
  String get articlesSubtitle =>
      'Bilimsel kanıta dayalı sigara bırakma kütüphanesi';

  @override
  String get articleCategoryAll => 'Tümü';

  @override
  String get articleCategoryScience => 'Sigara Bilimi';

  @override
  String get articleCategoryCrisis => 'Kriz Yönetimi';

  @override
  String get articleCategoryTriggers => 'Tetikleyiciler';

  @override
  String get articleCategoryHealth => 'Sağlık';

  @override
  String get articleCategoryPsychology => 'Davranış Değişimi';

  @override
  String articleReadTime(int min) {
    return '$min dk okuma';
  }

  @override
  String articleSourceLabel(String source) {
    return 'Bilimsel kaynak: $source';
  }

  @override
  String get articleKeyTakeaways => 'Öne Çıkanlar & Pratik Adımlar';

  @override
  String get todayFocusTitle => 'Her gün,\nbiraz daha özgür.';

  @override
  String get todayFocusNote => 'Her küçük ara, yeni bir adım.';

  @override
  String get dailyBudgetCaption => 'Kayıt / günlük hedef';

  @override
  String get todayOverview => 'Bugün sana kalanlar';

  @override
  String get todaySupportTitle => 'Bir nefes molası ver';

  @override
  String get todaySupportNote => 'İhtiyacın olduğunda, bir an kendine dön.';

  @override
  String get statsIntro => 'Küçük adımlar, görünür bir değişim.';

  @override
  String get chartActualLabel => 'Kaydedilen';

  @override
  String get chartTargetLabel => 'Günlük hedef';

  @override
  String get chartEmptyTitle => 'Değişimin burada başlıyor';

  @override
  String get chartEmptyBody =>
      'Kayıtların biriktikçe kendi ritmini burada göreceksin.';

  @override
  String get chartTimeBlocks => 'Günün zaman dilimleri';

  @override
  String get chartIntervalAxis => 'Kayıtlar arasındaki süre · dakika';

  @override
  String get chartIntervalEmpty =>
      'İlk aralığını görmek için iki kayıt yeterli.';

  @override
  String get chartTriggerEmpty =>
      'Kayıtlarına etiket ekle; tetikleyicilerini birlikte görünür kılalım.';

  @override
  String get statsSavingsNote => 'Kayıtlarına göre tahmini tasarruf';

  @override
  String get moduleModelTag => 'Kayıtlarından hesaplandı — ölçüm değil.';

  @override
  String get moduleNeedMoreData => 'Birkaç kayıt daha, sonra burada görünecek.';

  @override
  String get moduleSourceLabel => 'Kaynak';

  @override
  String get bodyLoadTitle => 'Vücut Yükü';

  @override
  String bodyLoadSinceLast(String time) {
    return 'Son sigaranın üzerinden $time';
  }

  @override
  String bodyLoadNicotineNow(int percent) {
    return 'Tahmini nikotin yükün tepe değerinin %$percent kadarı.';
  }

  @override
  String bodyLoadCoDrop(int percent) {
    return 'Oksijen borcun %$percent azaldı.';
  }

  @override
  String get loadNicotineAcute => 'Nikotin şimdi';

  @override
  String get loadNicotineBaseline => 'Gün boyu zemin';

  @override
  String get loadCarbonMonoxide => 'Oksijen borcu';

  @override
  String get loadTar => 'Partikül yükü';

  @override
  String get loadBandLow => 'Düşük';

  @override
  String get loadBandMedium => 'Orta';

  @override
  String get loadBandHigh => 'Yüksek';

  @override
  String get bodyLoadTarNote =>
      'Katran vücutta ölçülemez. Bu, maruziyetini kendi taban çizgine göre karşılaştırır.';

  @override
  String get bodyLoadCoNote =>
      'En hızlı temizlenen karbonmonoksittir — bırakınca ilk değişen şey odur.';

  @override
  String get bodyLoadEmpty =>
      'Birkaç sigara kaydet, kendi ritmin burada belirsin.';

  @override
  String get ghostPeakLabel => 'Oluşmayan tepe';

  @override
  String get metabolismTitle => 'Temizlenme temposu';

  @override
  String get metabolismNote =>
      'Nikotin herkeste aynı hızda temizlenmez. Kendi hissine uyanı seç — bu yalnızca eğriyi ayarlar, hiçbir şey ölçmez.';

  @override
  String get metabolismSlow => 'Yavaş';

  @override
  String get metabolismNormal => 'Normal';

  @override
  String get metabolismFast => 'Hızlı';

  @override
  String get cravingWindowTitle => 'Kriz penceresi';

  @override
  String get cravingRiskCalm => 'Sakin';

  @override
  String get cravingRiskWatch => 'Dikkat';

  @override
  String get cravingRiskHigh => 'Yüksek';

  @override
  String get cravingFallingNote =>
      'İstek genellikle nikotin yükselirken değil, düşerken gelir.';

  @override
  String cravingLowestThird(int percent) {
    return 'İsteklerinin %$percent kadarı, yükün en düşük üçte birindeyken geldi.';
  }

  @override
  String get cravingRiskyHours => 'Riskli saatlerin';

  @override
  String cravingWindowRange(int start, int end) {
    return '$start:00–$end:00';
  }

  @override
  String get cravingHeatmapTitle => 'Haftan, saat saat';

  @override
  String get economyTitle => 'Para ve zaman';

  @override
  String get economySaved => 'Kazanılan';

  @override
  String get economySpent => 'Hâlâ harcanan';

  @override
  String get economyExactNote =>
      'Buradaki hiçbir şey tahmin değil — kendi verin.';

  @override
  String get economyProjectionTitle =>
      'Bu hızla devam edersen vs. planı tamamlarsan';

  @override
  String get economyShadedArea => 'Bu taralı alan senin kararın.';

  @override
  String get economyKeepPace => 'Bu hız';

  @override
  String get economyFinishPlan => 'Plan tamamlanmış';

  @override
  String get economyTimeLedger => 'Zaman defteri';

  @override
  String get economyTimeRegained => 'Kazanılan zaman';

  @override
  String get economyTimeLost => 'Harcanan zaman';

  @override
  String get economyLifeAverageNote =>
      'Sigara başına ortalama 20 dakika — bu bir popülasyon ortalaması, sana dair bir vaat değil.';

  @override
  String get economyGoalTitle => 'Senin hedefin';

  @override
  String get economyGoalHint => 'Ne için biriktiriyorsun?';

  @override
  String get economyGoalLabel => 'Hedefin adı';

  @override
  String get economyGoalAmount => 'Tutar';

  @override
  String economyGoalRemaining(int days) {
    return 'Bu hızla $days gün kaldı';
  }

  @override
  String get mindTitle => 'Psikolojik durum';

  @override
  String get mindPressureLabel => 'Muhtemel yoksunluk basıncı';

  @override
  String get mindBandCalm => 'Sakin';

  @override
  String get mindBandUnderPressure => 'Basınç altında';

  @override
  String get mindBandTough => 'Zorlu';

  @override
  String get mindOnlyYouKnow =>
      'Bu bir tahmin. Nasıl hissettiğini yalnızca sen bilirsin.';

  @override
  String get mindHowDoYouFeel => 'Şu an nasıl hissediyorsun?';

  @override
  String mindAccuracy(int percent) {
    return 'Tahminim, hislerinle %$percent oranında örtüştü.';
  }

  @override
  String get mindQuitLowersAnxiety =>
      'Bırakmak ortalamada kaygıyı ve depresyonu düşürür, yükseltmez.';

  @override
  String get mindTypicalCurve => 'Tipik seyir';

  @override
  String get mindPeakNote =>
      'Yoksunluk 1.–3. günlerde tepe yapar, 3–4 haftada hafifler.';

  @override
  String get mindWeightTitle => 'Kilo hakkında';

  @override
  String get mindWeightBody =>
      'Bırakınca iştah artar ve kilo değişiminin çoğu ilk üç ayda olur — yılda ortalama 4–5 kg. Bu risk, sigaranın yanında küçüktür; düzenli öğünler dalgayı yumuşatır.';

  @override
  String get lungsTitle => 'Bugün akciğerlerin';

  @override
  String get lungsNotAScan => 'Bu, akciğerinin görüntüsü değildir.';

  @override
  String get lungsSlowsLine => 'Bu çizgiyi yavaşlatan tek şey bırakmaktır.';

  @override
  String get lungsScenarioNever => 'Hiç içmemiş';

  @override
  String get lungsScenarioKeep => 'Bu hız';

  @override
  String get lungsScenarioQuit => 'Bugün bırakırsan';

  @override
  String get lungsTypicalLabel => 'Yaş grubun için tipik';

  @override
  String get lungsAxisAge => 'Yaş';

  @override
  String get lungsMistLabel => 'Göreli partikül yükü';

  @override
  String get organMapTitle => 'Organ haritası';

  @override
  String get organHarmTitle => 'Sigara ne yapıyor';

  @override
  String get organRecoveryTitle => 'Bırakınca ne oluyor';

  @override
  String get organPopulationNote =>
      'Popülasyon düzeyinde bulgular. Kişisel risk tahmini değildir.';

  @override
  String get toxicantsTitle => 'Dumanın içinde ne var';

  @override
  String toxicantsSubtitle(int chemicals, int carcinogens) {
    return '$chemicals kimyasal, bunların $carcinogens kadarı bilinen kanserojen';
  }

  @override
  String get toxicantAnalogyLabel => 'Başka nerede bulunur';

  @override
  String get toxicantMechanismLabel => 'Vücutta';

  @override
  String get toxicantNoDose =>
      'Tanımayı kolaylaştırır; doz karşılaştırması değildir.';

  @override
  String toxicantIarcLabel(String group) {
    return 'IARC grubu $group';
  }

  @override
  String get evidenceStrong => 'Güçlü kanıt';

  @override
  String get evidencePromising => 'Umut verici';

  @override
  String get evidenceTraditional => 'Geleneksel';

  @override
  String get evidenceLabel => 'Kanıt';

  @override
  String get sosWhatWorked => 'Sende daha önce işe yarayan';

  @override
  String get sosTechniquesTitle => 'Şu an yapabileceğin bir şey';

  @override
  String get sosEarPointsTitle => 'Beş nokta, her biri on iki saniye';

  @override
  String get sosEarPointShenMen => 'Shen Men';

  @override
  String get sosEarPointAutonomic => 'Otonom';

  @override
  String get sosEarPointKidney => 'Böbrek';

  @override
  String get sosEarPointLiver => 'Karaciğer';

  @override
  String get sosEarPointLung => 'Akciğer';

  @override
  String get sosNoNeedles => 'Sadece parmakla — asla iğne değil.';

  @override
  String get progressScoreTitle => 'İlerleme Puanı';

  @override
  String get progressWindowLabel => 'son 14 gün';

  @override
  String get progressBandStarting => 'Başlangıç';

  @override
  String get progressBandOnTrack => 'Yolda';

  @override
  String get progressBandStrong => 'Güçlü';

  @override
  String get progressBandVeryStrong => 'Çok güçlü';

  @override
  String get progressBehaviourNote => 'Bu, sağlığını değil davranışını ölçer.';

  @override
  String progressDeltaUp(int points) {
    return '7 günde $points puan arttı';
  }

  @override
  String progressDeltaDown(int points) {
    return '7 günde $points puan azaldı';
  }

  @override
  String get progressDeltaFlat => 'bu hafta sabit';

  @override
  String get harmLoadTitle => 'Zarar Yükü';

  @override
  String get harmBandLight => 'Hafif';

  @override
  String get harmBandModerate => 'Orta';

  @override
  String get harmBandHeavy => 'Ağır';

  @override
  String get harmBandVeryHeavy => 'Çok ağır';

  @override
  String get harmNotRisk => 'Bu, hastalık riski tahmini değildir.';

  @override
  String harmPackYears(String value) {
    return '$value paket-yılı';
  }

  @override
  String get harmMovingPartNote =>
      'Bunun neredeyse yarısı azalttıkça düşer. Kalanı geçmişin — bırakmak onu yavaşlatır ve yıllar içinde hafifletir.';

  @override
  String get indicesScissorTitle => 'İlerleme ve yük';

  @override
  String get indicesScissorNote => 'Makas açıldıkça iyiye gidiyorsun.';

  @override
  String get indicesBreakdownTitle => 'Bu sayıyı ne oluşturuyor';

  @override
  String get componentAdherence => 'Plan uyumu';

  @override
  String get componentConsumptionTrend => 'Tüketim eğilimi';

  @override
  String get componentCravingCoping => 'Kriz başa çıkma';

  @override
  String get componentLoggingConsistency => 'Kayıt tutarlılığı';

  @override
  String get componentNicotineBaselineFall => 'Nikotin zemininin düşüşü';

  @override
  String get componentCumulativeExposure => 'Kümülatif maruziyet';

  @override
  String get componentCurrentIntensity => 'Güncel yoğunluk';

  @override
  String get componentDependenceDepth => 'Bağımlılık derinliği';

  @override
  String get componentAgeAndDuration => 'Yaş ve süre';

  @override
  String get componentBodySize => 'Vücut ölçüsü (isteğe bağlı)';

  @override
  String componentWeightLabel(String points, int weight) {
    return '$weight puanın $points puanı';
  }

  @override
  String get planKindGradual => 'Kademeli azaltma';

  @override
  String get planKindGradualNote => 'Sigaralar arasını adım adım aç.';

  @override
  String get planKindQuota => 'Günlük kota';

  @override
  String get planKindQuotaNote =>
      'Günlük bir tavan, saat kuralı yok — düzensiz günler için.';

  @override
  String get planKindQuitDay => 'Bırakma günü';

  @override
  String get planKindQuitDayNote =>
      'Bir tarih seç, çevresinde yoksunluk desteği al.';

  @override
  String get planKindTrackOnly => 'Yalnızca takip';

  @override
  String get planKindTrackOnlyNote =>
      'Hedef yok, yargı yok. Sadece kayıtların.';

  @override
  String get planSwitchTitle => 'Planı değiştir';

  @override
  String planTooSoon(int days) {
    return 'Bu plana $days gün daha ver — her planın biraz zamana ihtiyacı var.';
  }

  @override
  String get planReportCardTitle => 'Bu plan nasıl gidiyor';

  @override
  String get planReportDays => 'Bu planda geçen gün';

  @override
  String get planReportAdherence => 'Uyum';

  @override
  String get planReportHardestHour => 'En zorlandığın saat';

  @override
  String get planReportResisted => 'Atlatılan kriz';

  @override
  String get planSuggestionLabel => 'Sana önerilen';

  @override
  String get planFrequentSwitchNote =>
      'Plan değiştirmek başarısızlık değil — ama her plan kendini göstermek için birkaç haftaya ihtiyaç duyar.';

  @override
  String get planHistoryKept => 'Geçmişin kalır. Değişen sadece plan.';

  @override
  String planStripLabel(String plan, int week) {
    return '$plan · $week. hafta';
  }

  @override
  String get taperHoldStep => 'Bu adımda bir gün daha kalıyoruz.';

  @override
  String taperAdvance(int minutes) {
    return 'Yeni hedef aralık: $minutes dakika.';
  }

  @override
  String get taperSoftLanding =>
      'Plan sana göre yeniden ayarlandı. Kaybettiğin hiçbir şey yok.';

  @override
  String logSmokedNeutral(int count, String average) {
    return 'Bugün: $count. Ortalaman: $average.';
  }

  @override
  String get logNotAFailure => 'Başarısızlık değil. Bir veri.';

  @override
  String get logSkippedTitle => 'Oluşmayan tepe';

  @override
  String logSkippedCount(int count) {
    return 'Bu ay $count. atlatışın';
  }

  @override
  String logNextTarget(String time) {
    return 'Sonraki hedef saat $time';
  }

  @override
  String get logUndo => 'Geri al';

  @override
  String get logPauseTitle => 'Önce yirmi saniye';

  @override
  String get logPauseNote =>
      'Kaydın çoktan alındı. Bir nefes al — fikrini değiştirirsen geri alabilirsin.';

  @override
  String get logPauseSettingTitle => 'Kayıttan önce duraklat';

  @override
  String get supportTitle => 'Bugünün desteği';

  @override
  String get supportChannelMovement => 'Hareket';

  @override
  String get supportChannelNutrition => 'Beslenme';

  @override
  String get supportChannelRitual => 'Ritüel';

  @override
  String get supportMarkDone => 'Yaptım';

  @override
  String get supportNotATest =>
      'Bu bir sınav değil. Atlamanın hiçbir bedeli yok.';

  @override
  String get supportWeekTitle => 'Bu hafta';

  @override
  String supportMinutes(int minutes) {
    return '$minutes dk';
  }

  @override
  String get howBodyLoadTitle => 'Vücut yükü eğrileri';

  @override
  String get howBodyLoadBody =>
      'Her eğri C(t) = Σ doz × 2^(−geçen süre / yarı ömür) formülüdür ve yalnızca senin kaydettiğin saatlerden beslenir. Yarı ömürler: nikotin 2 sa, gün boyu zemin 16 sa (kotinin karşılığı), karbonmonoksit 4,5 sa, partikül yükü 30 gün (temsilî).';

  @override
  String get howBodyLoadLimits =>
      'Hiçbir telefon vücuttaki nikotini, katranı veya karbonmonoksiti ölçemez. Değerler kendi tepe değerine göre 0–100 arasında normalize gösterilir; ng/mL veya miligram olarak asla verilmez. Temizlenme hızı kişiden kişiye değişir.';

  @override
  String get howCravingTitle => 'Kriz penceresi';

  @override
  String get howCravingBody =>
      'Risk = 0,45 × nikotin çukurunun derinliği + 0,35 × bu saatin kendi geçmişindeki yoğunluğu + 0,20 × bu saatteki kayıtların tetikleyici taşıma oranı. Saate dayalı sinyaller, yaklaşık 21 kayda kadar kapalı kalır.';

  @override
  String get howProgressTitle => 'İlerleme Puanı';

  @override
  String get howProgressBody =>
      '100 üzerinden: plan uyumu 35, tüketim eğilimi 30, kriz başa çıkma 20, kayıt tutarlılığı 10, nikotin zemininin düşüşü 5. 14 güne bakar, günde en fazla 4 puan oynar ve asla sıfırlanmaz.';

  @override
  String get howHarmTitle => 'Zarar Yükü';

  @override
  String get howHarmBody =>
      '100 üzerinden: kümülatif maruziyet 40 (paket-yılı, logaritmik), güncel yoğunluk 30, bağımlılık 15, yaş ve süre 10, vücut ölçüsü 5. Hangi değişkenlerin önemli olduğunu doğrulanmış risk modellerinden aldık; sayı bir yük indeksidir, hastalık riski değildir. Vücut verisi isteğe bağlıdır; girilmezse ağırlıklar yeniden dağıtılır.';

  @override
  String get howMindTitle => 'Yoksunluk basıncı';

  @override
  String get howMindBody =>
      'Yayımlanmış belirti eğrisi 1.–3. günlerde tepe yapar ve 3–4 haftada hafifler; bu eğri mevcut nikotin çukurunun derinliğiyle ölçeklenir, sonra tahminlerimizle senin bildirdiklerin arasındaki farkla düzeltilir. Çıktı bir banttır, asla yüzde değildir.';

  @override
  String get howLungTitle => 'Akciğer senaryoları';

  @override
  String get howLungBody =>
      'Yayımlanmış yıllık FEV1 düşüş hızları üç tipik eğri olarak çizilir: hiç içmemiş ~30 mL/yıl, sürdürülen bırakıcı ~33, hâlen içen 40 ve ağır içimde 70’e kadar. Bunlar yaş grubun için popülasyon ortalamalarıdır, senin akciğerinin ölçümü değil.';

  @override
  String get settingsBodyDataTitle => 'Vücut verisi (isteğe bağlı)';

  @override
  String get settingsBodyDataNote =>
      'Yalnızca Zarar Yükünü keskinleştirmek için kullanılır. Boş bırakırsan hiçbir şey kilitlenmez — indeks elindekini yeniden ağırlıklandırır.';

  @override
  String get settingsHeight => 'Boy (cm)';

  @override
  String get settingsWeight => 'Kilo (kg)';

  @override
  String get settingsSmokingYears => 'Kaç yıldır içiyorsun';

  @override
  String get settingsSex => 'Cinsiyet (zaman defteri için)';

  @override
  String get sexUnspecified => 'Belirtmek istemiyorum';

  @override
  String get sexMale => 'Erkek';

  @override
  String get sexFemale => 'Kadın';

  @override
  String get settingsModelTitle => 'Model ayarları';

  @override
  String get settingsPrelogPauseNote =>
      'Kaydın her hâlükârda alınır; duraklama yalnızca sana bir an ve geri alma imkânı verir.';

  @override
  String get dailyCardKnowledge => 'Bilgi';

  @override
  String get dailyCardReality => 'Zor kısım';

  @override
  String get dailyCardGain => 'Kazandığın';

  @override
  String get dailyCardMotivation => 'Bugün için';

  @override
  String get dailyCardAction => 'Ne yapabilirsin';

  @override
  String dailyCardReadMinutes(int minutes) {
    return '$minutes dk okuma';
  }

  @override
  String get sourcesTitle => 'Bilimsel kaynaklar';

  @override
  String get sourcesIntro =>
      'Bu uygulamadaki her iddia bunlardan birine dayanır. Orijinalini açmak için dokun.';

  @override
  String get economyEquivalentTitle => 'Bu şuna denk';

  @override
  String get equivalentGroceries => 'bir aylık market';

  @override
  String get equivalentFuelTank => 'tam depo yakıt';

  @override
  String get equivalentGymMonth => 'bir aylık spor salonu';

  @override
  String get equivalentFlightTicket => 'kısa mesafe uçak bileti';

  @override
  String get equivalentPhone => 'yeni bir telefon';

  @override
  String economyEquivalentCount(int count, String item) {
    return '${count}x $item';
  }

  @override
  String get cravingWhatToDo => 'Burada ne işe yarar';

  @override
  String cravingSuggestionAt(String time, String technique) {
    return '$time civarında genelde bir tane yakıyorsun. Geldiğinde şunu dene: $technique';
  }

  @override
  String get cravingOpenToolkit => 'Araç setini aç';

  @override
  String get earGuideTitle => 'Kulak akupresürü';

  @override
  String get earGuideStart => '60 saniyeyi başlat';

  @override
  String earGuideStep(String point, int seconds) {
    return '$point · $seconds sn';
  }

  @override
  String get earGuideFinished => 'Tur tamamlandı.';

  @override
  String toxicantsToday(int count) {
    return 'Bugün $count kayıt';
  }

  @override
  String get loadBandTitle => 'Yükün, gün gün';

  @override
  String get loadBandWeek => '7 gün';

  @override
  String get loadBandMonth => '30 gün';

  @override
  String loadBandTrendDown(int percent) {
    return 'geçen haftaya göre %$percent düşük';
  }

  @override
  String loadBandTrendUp(int percent) {
    return 'geçen haftaya göre %$percent yüksek';
  }

  @override
  String get loadBandTrendFlat => 'geçen haftayla aynı';

  @override
  String get mindAccuracyChartTitle => 'Tahminim ve senin hissettiğin';

  @override
  String lungsGapAt(int age, String points) {
    return '$age yaşında, akciğer fonksiyonunda yaklaşık $points puanlık fark.';
  }

  @override
  String get supportWeekNote =>
      'Amaç ızgarayı doldurmak değil, örüntüyü görmek.';

  @override
  String get taperEasiestFirst =>
      'Önce en kolay saatlerini açıyoruz, en zorları sona bırakıyoruz.';

  @override
  String planQuotaToday(int count) {
    return 'Bugünün tavanı: $count';
  }

  @override
  String motivationSaved(String amount) {
    return 'Dumana gidecek $amount sende kaldı.';
  }

  @override
  String motivationRides(int count) {
    return 'Bu ay $count kriz atlattın.';
  }

  @override
  String motivationTime(String time) {
    return 'Popülasyon ortalamasına göre $time geri kazandın.';
  }

  @override
  String get motivationTitle => 'Bugün için';

  @override
  String get quitDayCoTitle => 'Bıraktığından beri';

  @override
  String get quitDayCoBody =>
      'Dumanın bıraktığı her şey içinde en hızlı temizlenen karbonmonoksittir. Bu, son sigaradan sonraki saatlerin tipik eğrisi.';

  @override
  String quitDayHoursAxis(int hours) {
    return '$hours sa';
  }
}
