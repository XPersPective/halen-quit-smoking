// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Halen';

  @override
  String get tagline => 'Reduce at your pace. Quit for good.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonDone => 'Done';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonOk => 'OK';

  @override
  String get commonHowCalculated => 'How is this estimate calculated?';

  @override
  String get commonModelTag => 'estimate · model';

  @override
  String get commonErrorTitle => 'Something went wrong';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonPremiumLocked =>
      'This is part of Halen Premium. Your 7-day trial covers everything for free.';

  @override
  String get commonUnlockPremium => 'See lifetime offer';

  @override
  String get splashWelcomeTitle => 'Welcome to Halen';

  @override
  String get splashTagline => 'Reduce at your pace. Quit for good.';

  @override
  String get splashPrivacyLine =>
      'No account. No servers. Your data stays on this device.';

  @override
  String get splashBackupLine =>
      'Automatic cloud backup is off; your records never leave this phone.';

  @override
  String get splashMedicalNote =>
      'This app is not medical advice. For the treatment of nicotine dependence, consult a health professional.';

  @override
  String get splashNotificationRationale =>
      'Notifications remind you of your plan — never spam. You can also enable them later.';

  @override
  String get splashEnableNotifications => 'Allow notifications';

  @override
  String get splashStart => 'Start';

  @override
  String obStepOf(int n) {
    return 'Step $n of 7';
  }

  @override
  String get obAgeTitle => 'How old are you?';

  @override
  String get obAgeUnder18 => 'Under 18';

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
      'Halen is designed for adults. For young people, support programmes are a better fit — these free resources can help you.';

  @override
  String get obUnder18NoPlan => 'No reduction plan will be created.';

  @override
  String get obCpdTitle =>
      'On average, how many cigarettes do you smoke per day?';

  @override
  String get obCpdHint =>
      'Your first week will calibrate this with your real records.';

  @override
  String get obTtfcTitle =>
      'After waking up, how soon do you smoke your first cigarette?';

  @override
  String get obTtfcUnder5 => 'Within 5 minutes';

  @override
  String get obTtfc5to30 => '5–30 minutes';

  @override
  String get obTtfc31to60 => '31–60 minutes';

  @override
  String get obTtfcOver60 => 'After 60 minutes';

  @override
  String get obPriceTitle => 'How much does a pack cost?';

  @override
  String get obPriceHint =>
      'Pre-filled with a typical price in your country — edit it to your real price.';

  @override
  String get obPackSizeLabel => 'Cigarettes per pack';

  @override
  String get obTimesTitle => 'When do you usually smoke?';

  @override
  String get obTimesHint => 'Pick any that apply. This shapes your daily plan.';

  @override
  String get triggerCoffee => 'Coffee';

  @override
  String get triggerAfterMeal => 'After a meal';

  @override
  String get triggerStress => 'Stress';

  @override
  String get triggerAlcohol => 'Alcohol';

  @override
  String get triggerCar => 'In the car';

  @override
  String get triggerSocial => 'Socialising';

  @override
  String get triggerWorkBreak => 'Work break';

  @override
  String get triggerBeforeSleep => 'Before sleep';

  @override
  String get triggerWakeUp => 'After waking up';

  @override
  String get obGoalTitle => 'What is your goal?';

  @override
  String get obGoalReduce => 'Reduce, then quit';

  @override
  String get obGoalReduceHint => 'Recommended — a plan that adapts to you';

  @override
  String get obGoalQuitNow => 'Quit right away';

  @override
  String get obGoalQuitNowHint =>
      'A quit-day programme with intense early support';

  @override
  String get obGoalUndecided => 'Not sure yet';

  @override
  String get obGoalUndecidedHint => 'Start reducing — decide later';

  @override
  String get obBrandTitle => 'Your brand (optional)';

  @override
  String get obBrandHint =>
      'Only used for savings precision. You can skip this.';

  @override
  String get obBrandSkip => 'Skip';

  @override
  String get obFinalDisclaimer =>
      'This app is not medical advice; for the treatment of nicotine dependence consult a health professional. If you are pregnant, or have a heart condition or a psychiatric condition, seek expert advice first.';

  @override
  String get obDataNote =>
      'These answers only shape your plan and never leave your device.';

  @override
  String get obFinish => 'Set up my plan';

  @override
  String get todayTitle => 'Today';

  @override
  String todayRingLabel(int smoked, int target) {
    return 'Today $smoked of $target';
  }

  @override
  String lastCigaretteMinutes(int n) {
    return 'Last cigarette: $n min ago';
  }

  @override
  String lastCigaretteHours(int h, int m) {
    return 'Last cigarette: $h h $m min ago';
  }

  @override
  String get lastCigaretteNone => 'No cigarette recorded yet today';

  @override
  String nextTargetIn(int n) {
    return 'Next target: at least $n min from now';
  }

  @override
  String nextTargetHoursIn(int h, int m) {
    return 'Next target: at least $h h $m min from now';
  }

  @override
  String get nextTargetReady =>
      'Next target: you are inside your planned window';

  @override
  String get nextTargetDayDone => 'Daily plan completed — well done';

  @override
  String get nicotineMiniLabel => 'Estimated nicotine exposure (model)';

  @override
  String get ctaSmoked => 'I SMOKED';

  @override
  String get ctaResisted => 'I resisted a craving';

  @override
  String resistedTodayCount(int n) {
    return '$n today';
  }

  @override
  String savingsStrip(String amount, int n) {
    return 'You saved $amount · $n cigarettes avoided';
  }

  @override
  String healthStrip(String text) {
    return 'Coming up: $text';
  }

  @override
  String get recalcTitle => 'We recalculated.';

  @override
  String get recalcDistributed =>
      'Your remaining budget for today is spread over the rest of the day.';

  @override
  String get recalcBunched =>
      'Today\'s smoking is bunched tighter than planned; try to hold the next one closer to the planned time.';

  @override
  String get recalcWeekSoftened =>
      'This week ran over budget, so next week starts 5% gentler.';

  @override
  String get todayEmptyFirstDay =>
      'This is your first day — the plan takes shape from your records and your answers.';

  @override
  String get todayPlanLockedFree =>
      'Your adaptive plan lives in Premium. Records, savings and the day counter are free forever.';

  @override
  String daysSinceStart(int n) {
    return 'Day $n with Halen';
  }

  @override
  String get recordDetailTitle => 'Log details';

  @override
  String get recordDetailHint => 'Optional — add a tag in one tap.';

  @override
  String get recordDetailSaved => 'Logged.';

  @override
  String get recordLoggedToast => 'Logged.';

  @override
  String get sourceApp => 'In app';

  @override
  String get sourceWidget => 'From widget';

  @override
  String get sourceTile => 'From quick tile';

  @override
  String get sourceControl => 'From control';

  @override
  String get sourceNotif => 'From notification';

  @override
  String get planTitle => 'Plan';

  @override
  String planTodayBudget(int n) {
    return 'Today\'s budget: $n';
  }

  @override
  String get planWindowsTitle => 'Planned windows';

  @override
  String planMinGapRule(int n) {
    return 'Keep at least $n minutes between cigarettes.';
  }

  @override
  String planAdherence7(int n) {
    return '7-day plan adherence: $n%';
  }

  @override
  String planAdherence14(int n) {
    return '14-day plan adherence: $n%';
  }

  @override
  String planWeeksEstimate(int x, int y) {
    return 'If the progress of the last 7 days continues at this rate, you could reach your goal in roughly $x–$y weeks.';
  }

  @override
  String get planPhaseReduction => 'Reduction';

  @override
  String get planPhaseFinal => 'Final week';

  @override
  String get planPhaseQuit => 'Quit programme';

  @override
  String phaseWeekOf(int n, int total) {
    return 'Week $n of $total';
  }

  @override
  String get paceCalm => 'Calm — 8 weeks, about 8–10% less per week';

  @override
  String get paceStandard => 'Standard — 6 weeks, about 12–15% less per week';

  @override
  String get paceFast => 'Fast — 4 weeks, about 18–22% less per week';

  @override
  String get paceSettingLabel => 'Reduction pace';

  @override
  String get paceChanged => 'Pace updated.';

  @override
  String get tempoAutoAdjusted =>
      'We adjusted the tempo to your real progress.';

  @override
  String get tempoUpSuggestion =>
      'You are keeping to your plan consistently. Want to increase the pace a little?';

  @override
  String get tempoUpApply => 'Increase pace';

  @override
  String get finalWeekTitle => 'Final week';

  @override
  String get finalWeekBody =>
      'Your daily budget is at 3 or fewer. Pick your quit day — a plan, not a promise.';

  @override
  String get quitDayConfirmTitle => 'Confirm your quit day';

  @override
  String quitDaySet(String date) {
    return 'Quit day set: $date';
  }

  @override
  String get quitDayChoose => 'Choose a day';

  @override
  String get quitProgramTitle => 'Quit programme';

  @override
  String get quitPrepTitle => 'Preparation week';

  @override
  String get quitPrepBody =>
      'List your triggers and your reason. Finish the sentence: “If X happens, I will Y.”';

  @override
  String get quit24hTitle => 'First 24 hours';

  @override
  String get quit24hBody =>
      'Your estimated exposure curve is falling fast. Cravings usually pass within a few minutes.';

  @override
  String get quit72hTitle => 'First 72 hours';

  @override
  String get quit72hBody =>
      'Physical withdrawal is usually most intense in the first week and eases over time. Extra support is available now.';

  @override
  String get quitWeek1Title => 'Week 1';

  @override
  String get quitWeek1Body =>
      'Cravings come most often in the first week and get less frequent over time.';

  @override
  String get quitWeek2to4Title => 'Weeks 2–4';

  @override
  String get quitWeek2to4Body =>
      'Habits take time — median habit change is around 66 days and varies a lot between people.';

  @override
  String get planLockedFree =>
      'The adaptive plan engine is part of Premium. Logging, savings and your day counter stay free forever.';

  @override
  String get quitSupportLine =>
      'A health professional can discuss quitting methods with you, including nicotine replacement therapy.';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get chartDaily => 'Daily count';

  @override
  String get chartPlanVsActual => 'Plan vs actual';

  @override
  String get chartGaps => 'Time between cigarettes';

  @override
  String get chartHourly => 'Hourly pattern';

  @override
  String get chartSavings => 'Savings';

  @override
  String get statsRange7 => 'Last 7 days';

  @override
  String get statsRange30 => 'Last 30 days';

  @override
  String get statsRangeAll => 'All time';

  @override
  String get statsRangeLockedPremium =>
      '30-day and all-time charts are in Premium.';

  @override
  String get triggerAnalysisTitle => 'Trigger patterns';

  @override
  String get triggerAnalysisEmpty =>
      'Trigger patterns need at least 10 tagged records. Keep tagging — this appears on its own.';

  @override
  String triggerRiskWindow(String trigger) {
    return 'The first 15 minutes after $trigger look like a risky window for you.';
  }

  @override
  String triggerSampleNote(int n) {
    return 'Based on $n tagged records.';
  }

  @override
  String a11yDailyChartSummary(int count, int target, int adherence) {
    return 'Yesterday $count, target $target, plan adherence $adherence percent.';
  }

  @override
  String get sosTitle => 'Craving SOS';

  @override
  String get sosIntro =>
      'Cravings usually pass within a few minutes. Wait it out with one of these.';

  @override
  String get sosTimerTitle => '2-minute timer';

  @override
  String sosTimerRunning(int s) {
    return 'Hold on — $s s left';
  }

  @override
  String get sosTimerDone => 'Two minutes done. The wave passed.';

  @override
  String get sos4dDelay => 'Delay';

  @override
  String get sos4dDelayBody => 'Give it two minutes before you decide.';

  @override
  String get sos4dBreathe => 'Deep breathing';

  @override
  String get sos4dBreatheBody => 'Sixty seconds of box breathing, guided.';

  @override
  String get sos4dWater => 'Drink water';

  @override
  String get sos4dWaterBody => 'A glass of water, slowly.';

  @override
  String get sos4dElse => 'Do something else';

  @override
  String get sos4dElseBody =>
      'Two minutes of anything — walk, wash your hands, step outside.';

  @override
  String get sosUrgeSurf => 'Watch and wait';

  @override
  String get sosUrgeSurfBody =>
      'Notice the craving like a wave: it rises, peaks and falls. You don\'t have to fight it.';

  @override
  String get sosBreathingIn => 'Breathe in';

  @override
  String get sosBreathingHold => 'Hold';

  @override
  String get sosBreathingOut => 'Breathe out';

  @override
  String get sosBreathingFinished => 'One minute done.';

  @override
  String get sosOutcomeTitle => 'How did it go?';

  @override
  String get sosResisted => 'I resisted';

  @override
  String get sosSmoked => 'I smoked';

  @override
  String sosResistedCount(int n) {
    return 'You have resisted $n cravings so far.';
  }

  @override
  String get sosAfterSmoked =>
      'Logged. We recalculated your plan — it just keeps adapting.';

  @override
  String get sosIntensityTitle => 'How strong was it?';

  @override
  String get sosIntensity1 => 'Mild';

  @override
  String get sosIntensity2 => 'Medium';

  @override
  String get sosIntensity3 => 'Strong';

  @override
  String get sosAfterResisted =>
      'After the log: well done — every resisted craving counts.';

  @override
  String get sosNrtLine =>
      'You can talk to a health professional about options such as NRT.';

  @override
  String get sosLocked =>
      'The full SOS toolkit (breathing animation, watch-and-wait) is in Premium — free during your trial.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get notifDensity => 'Density';

  @override
  String get notifDensityCalm => 'Calm';

  @override
  String get notifDensityStandard => 'Standard';

  @override
  String get notifDensityIntense => 'Intense';

  @override
  String get notifDensityOff => 'Off';

  @override
  String get notifSummaryTitle => 'Your day with Halen';

  @override
  String notifSummaryBody(int count, int target) {
    return 'Today: $count of $target. Every record keeps the plan honest.';
  }

  @override
  String get notifMorningTitle => 'Today’s budget is waiting in Halen';

  @override
  String get notifMorningBody => 'Small steps count. You set the pace.';

  @override
  String get notifPlanTitle => 'Planned time is approaching';

  @override
  String get notifPlanBody => 'Your next planned window starts soon.';

  @override
  String get notifReturnTitle => 'Still there?';

  @override
  String get notifReturnBody =>
      'No records for a few days — pick up right where you left off.';

  @override
  String get notifQuitTitle => 'First hours matter most';

  @override
  String get notifQuitBody =>
      'The wave rises, peaks and falls. Hold on — this app is with you.';

  @override
  String get notifMilestoneTitle => 'Milestone reached';

  @override
  String get notifMilestoneBody =>
      'A new health milestone is in. Check your timeline.';

  @override
  String get notifChannelReminders => 'Reminders';

  @override
  String get notifChannelSupport => 'Support';

  @override
  String get notifSummaryGeneric => 'Every record keeps the plan honest.';

  @override
  String get notifDailySummary => 'Daily summary (evening)';

  @override
  String get notifMorningGoal => 'Morning goal';

  @override
  String get notifPlanReminder => 'Planned time approaching';

  @override
  String get notifQuitSupport => 'Quit-day support (first 72 hours)';

  @override
  String get notifMilestones => 'Milestones';

  @override
  String get notifGentleReturn => 'Gentle nudge after silence';

  @override
  String get notifExactTime => 'Exact-time reminders';

  @override
  String get notifExactTimeHint =>
      'Off by default; Android shows these as approximate. Enabling uses exact alarms.';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsReduceMotion => 'Reduce motion';

  @override
  String get settingsHaptics => 'Haptics';

  @override
  String get settingsData => 'Your data';

  @override
  String get settingsExport => 'Export data (JSON)';

  @override
  String get settingsImport => 'Import data (JSON)';

  @override
  String settingsExportDone(String path) {
    return 'Backup saved: $path';
  }

  @override
  String settingsImportDone(int n) {
    return 'Imported — $n records restored.';
  }

  @override
  String get settingsDeleteAll => 'Delete all data';

  @override
  String get deleteAllConfirm => 'Delete everything? This cannot be undone.';

  @override
  String get settingsPurchase => 'Halen Lifetime';

  @override
  String get purchaseCopy => 'One-time · Lifetime · No subscription';

  @override
  String get purchaseCta => 'Buy once';

  @override
  String get purchaseRestore => 'Restore purchase';

  @override
  String get purchaseOwned => 'You own Halen Lifetime.';

  @override
  String get purchasePending =>
      'Your purchase is pending — access unlocks when it completes.';

  @override
  String trialDaysLeft(int n) {
    return 'Trial: $n days left';
  }

  @override
  String get trialExpiredFree =>
      'Trial ended — the free tier (logging, savings, day counter, 7-day chart, export) stays yours forever.';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsDisclaimerTitle => 'Health notice';

  @override
  String get settingsDisclaimer =>
      'This app is not medical advice; for the treatment of nicotine dependence consult a health professional. If you are pregnant, or have a heart condition or a psychiatric condition, seek expert advice first.';

  @override
  String get settingsHelplines =>
      'Support lines: TR Yeşilay 176 · US 1-800-QUIT-NOW · UK NHS · DE BZgA';

  @override
  String get settingsPrivacy =>
      'Privacy: no account, no servers, no analytics. Your records stay on this device.';

  @override
  String get settingsPrivacyPolicy => 'Privacy policy';

  @override
  String settingsVersion(String v) {
    return 'Version $v';
  }

  @override
  String get paywallTitle => 'Keep going with Halen Premium';

  @override
  String paywallValueLine(int n) {
    return 'This week you kept to your plan $n% of the time.';
  }

  @override
  String get paywallFeaturePlan =>
      'The adaptive reduction plan that recalculates itself';

  @override
  String get paywallFeatureCharts =>
      'Full charts: plan vs actual, gaps, hourly pattern';

  @override
  String get paywallFeatureTriggers => 'Trigger patterns';

  @override
  String get paywallFeatureTimeline => 'The full health timeline';

  @override
  String get paywallFeatureSos => 'The complete SOS toolkit';

  @override
  String get paywallFeatureWidget => 'Widget customisation';

  @override
  String get paywallTrialNote =>
      'Your 7-day free trial starts on first launch — no card needed.';

  @override
  String get timelineTitle => 'Health timeline';

  @override
  String get timelinePreviewLocked =>
      'In reduce mode the countdown starts on your quit day. Until then this is a preview.';

  @override
  String get timelineSourceWho => 'Source: WHO';

  @override
  String get timelineSourceCdc => 'Source: CDC';

  @override
  String get timelineGeneralPattern =>
      'In general, among people who quit smoking…';

  @override
  String get timelineMilestone20min => '20 minutes';

  @override
  String get timelineBody20min =>
      'In general, among people who quit smoking, heart rate and blood pressure drop.';

  @override
  String get timelineMilestone12h => '12 hours';

  @override
  String get timelineBody12h =>
      'In general, among people who quit smoking, the carbon monoxide level in their blood returns to normal.';

  @override
  String get timelineCoCard =>
      'Blood carbon monoxide returns to normal in about 12 hours — WHO';

  @override
  String get timelineMilestone2to12w => '2–12 weeks';

  @override
  String get timelineBody2to12w =>
      'In general, among people who quit smoking, circulation and lung function improve.';

  @override
  String get timelineMilestone1to9m => '1–9 months';

  @override
  String get timelineBody1to9m =>
      'In general, among people who quit smoking, coughing and shortness of breath decrease.';

  @override
  String get timelineMilestone1y => '1 year';

  @override
  String get timelineBody1y =>
      'In general, among people who quit smoking, the risk of coronary heart disease is about half that of a smoker\'s.';

  @override
  String get timelineMilestone5to15y => '5–15 years';

  @override
  String get timelineBody5to15y =>
      'In general, among people who quit smoking, the risk of stroke falls to that of a non-smoker.';

  @override
  String get timelineMilestone10y => '10 years';

  @override
  String get timelineBody10y =>
      'In general, among people who quit smoking, the risk of lung cancer falls to about half that of a smoker\'s.';

  @override
  String get timelineMilestone15y => '15 years';

  @override
  String get timelineBody15y =>
      'In general, among people who quit smoking, the risk of coronary heart disease becomes similar to that of someone who has never smoked.';

  @override
  String get howNicotineTitle => 'How the nicotine estimate is calculated';

  @override
  String get howNicotineBody =>
      'Each cigarette is assumed to deliver about 1.2 mg of absorbed nicotine (a published range of roughly 1–1.5 mg). Your estimated exposure curve sums every cigarette you log and halves that total every 2 hours — nicotine\'s typical plasma half-life. The screen shows a 0–100 normalised curve, never an absolute blood level.';

  @override
  String get howNicotineLimits =>
      'Limits: this is a behavioural model, not a measurement. Absorption varies with how you smoke, the product and your metabolism. Nothing in this app is measured from your body.';

  @override
  String get howNicotineSources =>
      'Sources: Benowitz, NEJM 2010 (nicotine absorption 1–1.5 mg/cigarette); Hukkanen et al., Pharmacol Rev 2005 (plasma half-life ~2 h).';

  @override
  String get howWeeksTitle => 'How the weeks estimate is calculated';

  @override
  String get howWeeksBody =>
      'We compare the average of your last 7 days with your weekly reduction rate and solve for when your daily budget reaches the final-week level. The result is always a range, updated weekly — never a fixed date.';

  @override
  String get howSavingsTitle => 'How savings are calculated';

  @override
  String get howSavingsBody =>
      'Your pack price divided by cigarettes per pack gives a per-cigarette cost. Cigarettes you avoid relative to your baseline multiply that cost. Prices you enter stay on your device.';

  @override
  String get howTitle => 'How this estimate is calculated';

  @override
  String motivationStreakBest(int n) {
    return 'Longest on-plan streak: $n days';
  }

  @override
  String get motivationStreakRestart => 'Starting again is normal.';

  @override
  String motivationAvoidedTotal(int n) {
    return '$n cigarettes avoided so far';
  }

  @override
  String motivationWhoNext(String text) {
    return 'Next milestone: $text';
  }

  @override
  String get notificationDailySummaryTitle => 'Today\'s summary';

  @override
  String notificationDailySummaryBody(int smoked, int target, String extra) {
    return '$smoked of $target today. $extra';
  }

  @override
  String notificationMorningTitle(int n) {
    return 'Today\'s target: $n';
  }

  @override
  String get notificationMorningBody =>
      'One tap is enough — Halen keeps the count.';

  @override
  String get notificationPlanReminderTitle => 'Planned window';

  @override
  String get notificationPlanReminderBody =>
      'Your next planned window is around now.';

  @override
  String get notificationQuitSupportTitle => 'You are doing it';

  @override
  String get notificationQuitSupportBody =>
      'Cravings peak early and fade. Open SOS if one hits.';

  @override
  String notificationMilestoneTitle(String name) {
    return 'Milestone: $name';
  }

  @override
  String get notificationGentleReturnTitle => 'Pick up where you left off';

  @override
  String get notificationGentleReturnBody =>
      'No records for a few days — your plan is waiting, unchanged. One tap resumes everything.';

  @override
  String get under18YouthTitle => 'Support for young people';

  @override
  String get under18YouthBody =>
      'Halen is built for adults and will not create a plan for you. Free, youth-appropriate support exists — talking to a doctor, school counsellor or a quitline is a strong first step.';

  @override
  String get errorDatabaseTitle => 'Database could not be opened';

  @override
  String get errorDatabaseBody =>
      'Your encrypted database could not be unlocked on this device. Nothing was sent anywhere.';

  @override
  String get emptyGeneric => 'Nothing here yet.';

  @override
  String get emptyNoRecords =>
      'No records yet — your first tap starts the count.';

  @override
  String a11yRing(int smoked, int target) {
    return 'Today\'s ring: $smoked of $target cigarettes';
  }

  @override
  String get a11yNicotineChart =>
      'Estimated nicotine exposure chart. It rises with each logged cigarette and falls by half every two hours.';

  @override
  String get a11ySavingsChart =>
      'Savings chart, cumulative over the selected range.';

  @override
  String get navToday => 'Today';

  @override
  String get navStats => 'Analytics';

  @override
  String get navPlan => 'Plan';

  @override
  String get navArticles => 'Guides';

  @override
  String get navSos => 'Craving SOS';

  @override
  String get statsTabDaily => 'Daily Trends';

  @override
  String get statsTabHourly => '24h Hourly';

  @override
  String get statsTabIntervals => 'Intervals';

  @override
  String get statsTabTriggers => 'Triggers';

  @override
  String get intervalTitle => 'Inter-Cigarette Intervals';

  @override
  String get intervalSubtitle =>
      'Distribution of time elapsed between each cigarette';

  @override
  String get intervalAverage => 'Average interval';

  @override
  String get intervalLongest => 'Longest smoke-free gap';

  @override
  String get intervalShortest => 'Shortest gap';

  @override
  String get intervalCurrent => 'Current smoke-free time';

  @override
  String intervalMinutes(int m) {
    return '$m min';
  }

  @override
  String intervalHoursMinutes(int h, int m) {
    return '${h}h ${m}m';
  }

  @override
  String get hourlyTitle => '24-Hour Distribution';

  @override
  String get hourlySubtitle => 'When you smoke during the day';

  @override
  String hourlyPeak(int hour, int count) {
    return 'Peak hour: $hour:00 ($count cigarettes)';
  }

  @override
  String get timeMorning => 'Morning (06–12)';

  @override
  String get timeAfternoon => 'Afternoon (12–18)';

  @override
  String get timeEvening => 'Evening (18–24)';

  @override
  String get timeNight => 'Night (00–06)';

  @override
  String get triggerTitle => 'Trigger Analysis';

  @override
  String get triggerSubtitle => 'What sparks the urge';

  @override
  String triggerOccurrences(int count, int percent) {
    return '$count times ($percent%)';
  }

  @override
  String get todayLogTitle => 'Today\'s Cigarette Log';

  @override
  String get todayLogSubtitle => 'Detailed breakdown of today\'s smokes';

  @override
  String get todayLogEmpty => 'No cigarettes logged yet today';

  @override
  String get deleteCigaretteConfirm => 'Delete this cigarette record?';

  @override
  String get deletedCigaretteSuccess => 'Record deleted';

  @override
  String get articlesTitle => 'Guides & Articles';

  @override
  String get articlesSubtitle => 'Evidence-based smoking cessation science';

  @override
  String get articleCategoryAll => 'All';

  @override
  String get articleCategoryScience => 'Science';

  @override
  String get articleCategoryCrisis => 'Craving Relief';

  @override
  String get articleCategoryTriggers => 'Triggers';

  @override
  String get articleCategoryHealth => 'Health';

  @override
  String get articleCategoryPsychology => 'Behavior';

  @override
  String articleReadTime(int min) {
    return '$min min read';
  }

  @override
  String articleSourceLabel(String source) {
    return 'Scientific source: $source';
  }

  @override
  String get articleKeyTakeaways => 'Key Takeaways';

  @override
  String get todayFocusTitle => 'More space.\nMore you.';

  @override
  String get todayFocusNote => 'Every pause is a step forward.';

  @override
  String get dailyBudgetCaption => 'Logged / daily target';

  @override
  String get todayOverview => 'Your day, at a glance';

  @override
  String get todaySupportTitle => 'Take a breathing break';

  @override
  String get todaySupportNote => 'A quiet moment, whenever you need it.';

  @override
  String get statsIntro => 'Small steps. A clearer picture.';

  @override
  String get chartActualLabel => 'Logged';

  @override
  String get chartTargetLabel => 'Daily target';

  @override
  String get chartEmptyTitle => 'Your story starts here';

  @override
  String get chartEmptyBody =>
      'Your entries will turn into a picture of your progress.';

  @override
  String get chartTimeBlocks => 'Throughout the day';

  @override
  String get chartIntervalAxis => 'Time between entries · minutes';

  @override
  String get chartIntervalEmpty =>
      'Two entries are enough to see your first interval.';

  @override
  String get chartTriggerEmpty =>
      'Add a tag when logging to discover your patterns.';

  @override
  String get statsSavingsNote => 'Estimated from your entries';

  @override
  String get moduleModelTag =>
      'Modelled from your records — not a measurement.';

  @override
  String get moduleNeedMoreData => 'A few more entries and this appears.';

  @override
  String get moduleSourceLabel => 'Source';

  @override
  String get bodyLoadTitle => 'Body Load';

  @override
  String bodyLoadSinceLast(String time) {
    return '$time since your last cigarette';
  }

  @override
  String bodyLoadNicotineNow(int percent) {
    return 'Estimated nicotine load is at $percent% of its peak.';
  }

  @override
  String bodyLoadCoDrop(int percent) {
    return 'Oxygen debt down $percent%.';
  }

  @override
  String get loadNicotineAcute => 'Nicotine now';

  @override
  String get loadNicotineBaseline => 'All-day baseline';

  @override
  String get loadCarbonMonoxide => 'Oxygen debt';

  @override
  String get loadTar => 'Particle load';

  @override
  String get loadBandLow => 'Low';

  @override
  String get loadBandMedium => 'Medium';

  @override
  String get loadBandHigh => 'High';

  @override
  String get bodyLoadTarNote =>
      'Tar cannot be measured in a body. This compares your exposure with your own baseline.';

  @override
  String get bodyLoadCoNote =>
      'Carbon monoxide clears fastest — it is the first thing that changes when you stop.';

  @override
  String get bodyLoadEmpty =>
      'Log a few cigarettes and your own rhythm appears here.';

  @override
  String get ghostPeakLabel => 'A peak that never happened';

  @override
  String get metabolismTitle => 'Clearance pace';

  @override
  String get metabolismNote =>
      'Nicotine clears at different speeds in different people. Pick what matches how you feel — this only calibrates the curve, it measures nothing.';

  @override
  String get metabolismSlow => 'Slow';

  @override
  String get metabolismNormal => 'Normal';

  @override
  String get metabolismFast => 'Fast';

  @override
  String get cravingWindowTitle => 'Craving window';

  @override
  String get cravingRiskCalm => 'Calm';

  @override
  String get cravingRiskWatch => 'Watch';

  @override
  String get cravingRiskHigh => 'High';

  @override
  String get cravingFallingNote =>
      'Craving usually arrives when nicotine is falling, not when it rises.';

  @override
  String cravingLowestThird(int percent) {
    return '$percent% of your cravings arrived while your load was in its lowest third.';
  }

  @override
  String get cravingRiskyHours => 'Your risky hours';

  @override
  String cravingWindowRange(int start, int end) {
    return '$start:00–$end:00';
  }

  @override
  String get cravingHeatmapTitle => 'Your week, hour by hour';

  @override
  String get economyTitle => 'Money and time';

  @override
  String get economySaved => 'Money saved';

  @override
  String get economySpent => 'Still spent';

  @override
  String get economyExactNote =>
      'Nothing here is an estimate — it is your own numbers.';

  @override
  String get economyProjectionTitle =>
      'If you keep this pace vs. if you finish your plan';

  @override
  String get economyShadedArea => 'This shaded area is your decision.';

  @override
  String get economyKeepPace => 'This pace';

  @override
  String get economyFinishPlan => 'Plan finished';

  @override
  String get economyTimeLedger => 'Time ledger';

  @override
  String get economyTimeRegained => 'Time regained';

  @override
  String get economyTimeLost => 'Time spent';

  @override
  String get economyLifeAverageNote =>
      'Population average of about 20 minutes per cigarette — an average, never a promise about you.';

  @override
  String get economyGoalTitle => 'Your goal';

  @override
  String get economyGoalHint => 'What are you saving for?';

  @override
  String get economyGoalLabel => 'Goal name';

  @override
  String get economyGoalAmount => 'Amount';

  @override
  String economyGoalRemaining(int days) {
    return '$days days to go at this pace';
  }

  @override
  String get mindTitle => 'Mind state';

  @override
  String get mindPressureLabel => 'Likely withdrawal pressure';

  @override
  String get mindBandCalm => 'Calm';

  @override
  String get mindBandUnderPressure => 'Under pressure';

  @override
  String get mindBandTough => 'Tough';

  @override
  String get mindOnlyYouKnow => 'This is a guess. Only you know how you feel.';

  @override
  String get mindHowDoYouFeel => 'How do you feel right now?';

  @override
  String mindAccuracy(int percent) {
    return 'My guess matched how you felt $percent% of the time.';
  }

  @override
  String get mindQuitLowersAnxiety =>
      'Quitting lowers anxiety and depression on average — it does not raise them.';

  @override
  String get mindTypicalCurve => 'Typical course';

  @override
  String get mindPeakNote =>
      'Withdrawal peaks on days 1–3 and eases over 3–4 weeks.';

  @override
  String get mindWeightTitle => 'About weight';

  @override
  String get mindWeightBody =>
      'Appetite rises after quitting and most weight change happens in the first three months — on average around 4–5 kg in a year. That risk is small next to smoking, and regular meals blunt it.';

  @override
  String get lungsTitle => 'Your lungs today';

  @override
  String get lungsNotAScan => 'This is not a scan of your lungs.';

  @override
  String get lungsSlowsLine =>
      'Quitting is the only thing that slows this line.';

  @override
  String get lungsScenarioNever => 'Never smoked';

  @override
  String get lungsScenarioKeep => 'This pace';

  @override
  String get lungsScenarioQuit => 'Quit today';

  @override
  String get lungsTypicalLabel => 'Typical for your age group';

  @override
  String get lungsAxisAge => 'Age';

  @override
  String get lungsMistLabel => 'Relative particle load';

  @override
  String get organMapTitle => 'Body map';

  @override
  String get organHarmTitle => 'What smoking does';

  @override
  String get organRecoveryTitle => 'What happens when you stop';

  @override
  String get organPopulationNote =>
      'Population-level findings. Not a personal risk estimate.';

  @override
  String get toxicantsTitle => 'What\'s in the smoke';

  @override
  String toxicantsSubtitle(int chemicals, int carcinogens) {
    return '$chemicals chemicals, more than $carcinogens of them known carcinogens';
  }

  @override
  String get toxicantAnalogyLabel => 'Also found in';

  @override
  String get toxicantMechanismLabel => 'In the body';

  @override
  String get toxicantNoDose => 'A recognition aid, not a dose comparison.';

  @override
  String toxicantIarcLabel(String group) {
    return 'IARC group $group';
  }

  @override
  String get evidenceStrong => 'Strong evidence';

  @override
  String get evidencePromising => 'Promising';

  @override
  String get evidenceTraditional => 'Traditional';

  @override
  String get evidenceLabel => 'Evidence';

  @override
  String get sosWhatWorked => 'What worked for you before';

  @override
  String get sosTechniquesTitle => 'Something to do right now';

  @override
  String get sosEarPointsTitle => 'Five points, twelve seconds each';

  @override
  String get sosEarPointShenMen => 'Shen Men';

  @override
  String get sosEarPointAutonomic => 'Autonomic';

  @override
  String get sosEarPointKidney => 'Kidney';

  @override
  String get sosEarPointLiver => 'Liver';

  @override
  String get sosEarPointLung => 'Lung';

  @override
  String get sosNoNeedles => 'Fingers only — never needles.';

  @override
  String get progressScoreTitle => 'Progress Score';

  @override
  String get progressWindowLabel => 'last 14 days';

  @override
  String get progressBandStarting => 'Starting';

  @override
  String get progressBandOnTrack => 'On track';

  @override
  String get progressBandStrong => 'Strong';

  @override
  String get progressBandVeryStrong => 'Very strong';

  @override
  String get progressBehaviourNote =>
      'This measures your behaviour, not your health.';

  @override
  String progressDeltaUp(int points) {
    return 'up $points points in 7 days';
  }

  @override
  String progressDeltaDown(int points) {
    return 'down $points points in 7 days';
  }

  @override
  String get progressDeltaFlat => 'steady this week';

  @override
  String get harmLoadTitle => 'Harm Load';

  @override
  String get harmBandLight => 'Light';

  @override
  String get harmBandModerate => 'Moderate';

  @override
  String get harmBandHeavy => 'Heavy';

  @override
  String get harmBandVeryHeavy => 'Very heavy';

  @override
  String get harmNotRisk => 'This is not a disease risk estimate.';

  @override
  String harmPackYears(String value) {
    return '$value pack-years';
  }

  @override
  String get harmMovingPartNote =>
      'Almost half of this falls as you cut down. The rest is history — quitting slows it and, over years, eases it.';

  @override
  String get indicesScissorTitle => 'Progress and load';

  @override
  String get indicesScissorNote =>
      'The wider the gap, the better you are doing.';

  @override
  String get indicesBreakdownTitle => 'What makes up this number';

  @override
  String get componentAdherence => 'Plan adherence';

  @override
  String get componentConsumptionTrend => 'Consumption trend';

  @override
  String get componentCravingCoping => 'Craving coping';

  @override
  String get componentLoggingConsistency => 'Logging consistency';

  @override
  String get componentNicotineBaselineFall => 'Nicotine baseline fall';

  @override
  String get componentCumulativeExposure => 'Cumulative exposure';

  @override
  String get componentCurrentIntensity => 'Current intensity';

  @override
  String get componentDependenceDepth => 'Dependence depth';

  @override
  String get componentAgeAndDuration => 'Age and duration';

  @override
  String get componentBodySize => 'Body size (optional)';

  @override
  String componentWeightLabel(String points, int weight) {
    return '$points of $weight points';
  }

  @override
  String get planKindGradual => 'Gradual taper';

  @override
  String get planKindGradualNote =>
      'Widen the gap between cigarettes, step by step.';

  @override
  String get planKindQuota => 'Daily quota';

  @override
  String get planKindQuotaNote =>
      'A daily ceiling, no clock rules — for irregular days.';

  @override
  String get planKindQuitDay => 'Quit day';

  @override
  String get planKindQuitDayNote =>
      'Pick a date and get withdrawal support around it.';

  @override
  String get planKindTrackOnly => 'Track only';

  @override
  String get planKindTrackOnlyNote =>
      'No target, no judgement. Just your records.';

  @override
  String get planSwitchTitle => 'Change plan';

  @override
  String planTooSoon(int days) {
    return 'Give this plan $days more days — every plan needs a little time.';
  }

  @override
  String get planReportCardTitle => 'How this plan is going';

  @override
  String get planReportDays => 'Days in this plan';

  @override
  String get planReportAdherence => 'Adherence';

  @override
  String get planReportHardestHour => 'Hardest hour';

  @override
  String get planReportResisted => 'Cravings ridden out';

  @override
  String get planSuggestionLabel => 'Suggested for you';

  @override
  String get planFrequentSwitchNote =>
      'Changing plans is not failure — but every plan needs a few weeks to show itself.';

  @override
  String get planHistoryKept => 'Your history stays. Only the plan changes.';

  @override
  String planStripLabel(String plan, int week) {
    return '$plan · week $week';
  }

  @override
  String get taperHoldStep => 'Holding this step one more day.';

  @override
  String taperAdvance(int minutes) {
    return 'New target gap: $minutes minutes.';
  }

  @override
  String get taperSoftLanding =>
      'Your plan was re-tuned to you. Nothing is lost.';

  @override
  String logSmokedNeutral(int count, String average) {
    return 'Today: $count. Your average: $average.';
  }

  @override
  String get logNotAFailure => 'Not a failure. A data point.';

  @override
  String get logSkippedTitle => 'A peak that never happened';

  @override
  String logSkippedCount(int count) {
    return '$count rides out this month';
  }

  @override
  String logNextTarget(String time) {
    return 'Next target time $time';
  }

  @override
  String get logUndo => 'Undo';

  @override
  String get logPauseTitle => 'Twenty seconds first';

  @override
  String get logPauseNote =>
      'Your entry is already saved. Take a breath — you can undo it if you change your mind.';

  @override
  String get logPauseSettingTitle => 'Pause before logging';

  @override
  String get supportTitle => 'Today\'s support';

  @override
  String get supportChannelMovement => 'Movement';

  @override
  String get supportChannelNutrition => 'Food';

  @override
  String get supportChannelRitual => 'Ritual';

  @override
  String get supportMarkDone => 'I did it';

  @override
  String get supportNotATest => 'This is not a test. Skipping costs nothing.';

  @override
  String get supportWeekTitle => 'This week';

  @override
  String supportMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get howBodyLoadTitle => 'Body load curves';

  @override
  String get howBodyLoadBody =>
      'Each curve is C(t) = sum of dose x 2^(-elapsed / half-life), fed only by the times you logged. Half-lives: nicotine 2 h, all-day baseline 16 h (cotinine proxy), carbon monoxide 4.5 h, particle load 30 days (representative).';

  @override
  String get howBodyLoadLimits =>
      'No phone can measure nicotine, tar or carbon monoxide in a body. Values are shown normalized to 0–100 against your own peak, never in ng/mL or milligrams, and clearance speed varies between people.';

  @override
  String get howCravingTitle => 'Craving window';

  @override
  String get howCravingBody =>
      'Risk = 0.45 x how deep your nicotine trough is, + 0.35 x how busy this hour is in your own history, + 0.20 x how often records in this hour carry a trigger. Hour-based signals stay switched off until you have about 21 entries.';

  @override
  String get howProgressTitle => 'Progress Score';

  @override
  String get howProgressBody =>
      'Out of 100: plan adherence 35, consumption trend 30, craving coping 20, logging consistency 10, nicotine baseline fall 5. It looks at 14 days, moves at most 4 points a day, and never resets.';

  @override
  String get howHarmTitle => 'Harm Load';

  @override
  String get howHarmBody =>
      'Out of 100: cumulative exposure 40 (pack-years, log scale), current intensity 30, dependence 15, age and duration 10, body size 5. Validated risk models told us which variables matter; the number is a load index, not a disease risk. Body data is optional and the weights renormalize without it.';

  @override
  String get howMindTitle => 'Withdrawal pressure';

  @override
  String get howMindBody =>
      'A published symptom curve that peaks on days 1–3 and eases over 3–4 weeks, scaled by how deep your current nicotine trough is, then corrected by the difference between our guesses and what you actually reported. The output is a band, never a percentage.';

  @override
  String get howLungTitle => 'Lung scenarios';

  @override
  String get howLungBody =>
      'Published annual FEV1 decline rates drawn as three typical curves: never-smoker about 30 mL/year, sustained quitter about 33, current smoker 40 up to 70 at heavier intake. These are population averages for your age group, not a measurement of your lungs.';

  @override
  String get settingsBodyDataTitle => 'Body data (optional)';

  @override
  String get settingsBodyDataNote =>
      'Only used to sharpen the Harm Load. Leave it empty and nothing is locked — the index simply reweighs what it has.';

  @override
  String get settingsHeight => 'Height (cm)';

  @override
  String get settingsWeight => 'Weight (kg)';

  @override
  String get settingsSmokingYears => 'Years smoking';

  @override
  String get settingsSex => 'Sex (for the time ledger)';

  @override
  String get sexUnspecified => 'Prefer not to say';

  @override
  String get sexMale => 'Male';

  @override
  String get sexFemale => 'Female';

  @override
  String get settingsModelTitle => 'Model settings';

  @override
  String get settingsPrelogPauseNote =>
      'Your entry is saved either way; the pause only gives you a moment and an undo.';

  @override
  String get dailyCardKnowledge => 'Good to know';

  @override
  String get dailyCardReality => 'The hard part';

  @override
  String get dailyCardGain => 'What you gain';

  @override
  String get dailyCardMotivation => 'For today';

  @override
  String get dailyCardAction => 'What you can do';

  @override
  String dailyCardReadMinutes(int minutes) {
    return '$minutes min read';
  }

  @override
  String get sourcesTitle => 'Scientific sources';

  @override
  String get sourcesIntro =>
      'Every claim in this app comes from one of these. Tap to open the original.';
}
