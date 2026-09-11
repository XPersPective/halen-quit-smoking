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
  String get ctaSmoked => 'I smoked one';

  @override
  String get ctaResisted => 'I resisted it';

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
    return 'Carbon monoxide in your blood is $percent% below its peak.';
  }

  @override
  String get loadNicotineAcute => 'Nicotine now';

  @override
  String get loadNicotineBaseline => 'Nicotine built up in your body';

  @override
  String get loadCarbonMonoxide => 'Carbon monoxide in your blood';

  @override
  String get loadTar => 'Tar build-up';

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
  String get lungsMistLabel => 'Tar build-up, compared with your usual';

  @override
  String get organMapTitle => 'Body map';

  @override
  String get organHarmTitle => 'What smoking does';

  @override
  String get organRecoveryTitle => 'What happens when you stop';

  @override
  String get organTimelineTitle => 'Recovery timeline';

  @override
  String get organTimelineCaption =>
      'Time since your last cigarette — population data, not a personal measurement';

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
  String get componentNicotineBaselineFall => 'Fall in built-up nicotine';

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
      'Each curve is C(t) = sum of dose x 2^(-time since / half-life), fed only by the times you logged. Half-lives: nicotine 2 h, nicotine built up in your body 16 h (the cotinine it turns into), carbon monoxide 4.5 h, tar build-up 30 days (representative).';

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

  @override
  String get economyEquivalentTitle => 'That is about';

  @override
  String get equivalentGroceries => 'a month of groceries';

  @override
  String get equivalentFuelTank => 'a full tank of fuel';

  @override
  String get equivalentGymMonth => 'a month at the gym';

  @override
  String get equivalentFlightTicket => 'a short-haul flight';

  @override
  String get equivalentPhone => 'a new phone';

  @override
  String economyEquivalentCount(int count, String item) {
    return '${count}x $item';
  }

  @override
  String get cravingWhatToDo => 'What helps here';

  @override
  String cravingSuggestionAt(String time, String technique) {
    return 'Around $time you usually reach for one. When it comes, try: $technique';
  }

  @override
  String get cravingOpenToolkit => 'Open the toolkit';

  @override
  String get earGuideTitle => 'Ear acupressure';

  @override
  String get earGuideStart => 'Start the 60 seconds';

  @override
  String earGuideStep(String point, int seconds) {
    return '$point · $seconds s';
  }

  @override
  String get earGuideFinished => 'That is the full round.';

  @override
  String toxicantsToday(int count) {
    return '$count logged today';
  }

  @override
  String get loadBandTitle => 'Your load, day by day';

  @override
  String get loadBandWeek => '7 days';

  @override
  String get loadBandMonth => '30 days';

  @override
  String loadBandTrendDown(int percent) {
    return 'down $percent% on last week';
  }

  @override
  String loadBandTrendUp(int percent) {
    return 'up $percent% on last week';
  }

  @override
  String get loadBandTrendFlat => 'level with last week';

  @override
  String get mindAccuracyChartTitle => 'What I guessed vs what you felt';

  @override
  String lungsGapAt(int age, String points) {
    return 'By $age, about $points points of lung function apart.';
  }

  @override
  String get supportWeekNote => 'The point is the pattern, not a full grid.';

  @override
  String get taperEasiestFirst =>
      'We widen your easiest hours first and leave the hardest ones for last.';

  @override
  String planQuotaToday(int count) {
    return 'Today\'s ceiling: $count';
  }

  @override
  String motivationSaved(String amount) {
    return 'You have kept $amount that would have gone up in smoke.';
  }

  @override
  String motivationRides(int count) {
    return '$count cravings ridden out this month.';
  }

  @override
  String motivationTime(String time) {
    return '$time back, on the population average.';
  }

  @override
  String get motivationTitle => 'For today';

  @override
  String get quitDayCoTitle => 'Since you stopped';

  @override
  String get quitDayCoBody =>
      'Carbon monoxide clears fastest of everything smoke leaves behind. This is the typical curve for the hours after a last cigarette.';

  @override
  String quitDayHoursAxis(int hours) {
    return '$hours h';
  }

  @override
  String get settingsRiskyWindowReminder =>
      'Heads-up before your riskiest hour';

  @override
  String get settingsRiskyWindowNote =>
      'Off by default. Needs about a month of records before it knows your pattern.';

  @override
  String get notifRiskyWindowTitle => 'Your usual hour is coming up';

  @override
  String get notifRiskyWindowBody =>
      'Twenty minutes. A short walk now works better than willpower later.';

  @override
  String get chartLast30Days => 'Last 30 days';

  @override
  String get chartToday => 'today';

  @override
  String chartDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get chartNotEnoughYet => 'A few more days and this line appears.';

  @override
  String get indicesProgressLegend => 'Progress — higher is better';

  @override
  String get indicesHarmLegend => 'Harm Load — lower is better';

  @override
  String get indicesMeaning =>
      'The green line is what you are doing. The grey line is what you are carrying. Green up and grey down is the direction that counts.';

  @override
  String get indicesAxisCaption =>
      'points, 0-100 — higher progress is better, lower load is better';

  @override
  String get economyMeaning =>
      'Both lines are money spent over the next year. The lower one is the plan; the shaded gap is what finishing it keeps in your pocket.';

  @override
  String get lungsMeaning =>
      'Typical lung function for your age group under three futures. Higher is better, and the gap between the top two lines is what quitting is worth.';

  @override
  String get mindMeaning =>
      'What the app guessed, against what you said. Where the lines separate, the guess was wrong.';

  @override
  String get mindLegendGuess => 'My guess';

  @override
  String get mindLegendFelt => 'What you said';

  @override
  String get loadBandMeaning =>
      'One bar per day: the taller the bar, the more your body carried that day. The cap is that day\'s peak.';

  @override
  String get bodyLoadMeaning =>
      'Each spike is a cigarette; the fall after it is your body clearing it. Green marks are the spikes that never happened.';

  @override
  String get loadAxisCaption =>
      '% of your own peak — a model, not a measurement';

  @override
  String get loadAxisNow => 'now';

  @override
  String loadAxisHoursAgo(int hours) {
    return '$hours h ago';
  }

  @override
  String get nowInBodyTitle => 'In your body right now';

  @override
  String get nowInBodyLast => 'Last cigarette';

  @override
  String get nowInBodyNever => 'none yet';

  @override
  String get nowInBodyOpen => 'See the whole picture';

  @override
  String get nowInBodyEmpty =>
      'Log your first cigarette and your live curve starts here.';

  @override
  String get glossaryTitle => 'What the words mean';

  @override
  String get glossaryIntro =>
      'Every term this app uses, in one line each. No jargon, no small print.';

  @override
  String get glossaryOpen => 'What do these words mean?';

  @override
  String get glossaryProgress =>
      'How well you are doing what you set out to do, out of 100. It looks at your last two weeks and moves slowly on purpose.';

  @override
  String get glossaryHarm =>
      'How much smoking your body is carrying, out of 100. Cutting down lowers about half of it; the rest is history that only time softens.';

  @override
  String get glossaryBodyLoad =>
      'An estimate of what is still in you from the cigarettes you logged. It is calculated, never measured.';

  @override
  String get glossaryCo =>
      'The gas in smoke that takes the place of oxygen in your blood. It leaves fastest — usually within a day.';

  @override
  String get glossaryTarLoad =>
      'How your particle exposure compares with your own usual level. It is a comparison, not an amount.';

  @override
  String get glossaryCravingWindow =>
      'The hours you most often reach for a cigarette, learned from your own records.';

  @override
  String get glossaryAdherence =>
      'The share of days you stayed inside your plan.';

  @override
  String get glossaryPackYears =>
      'A standard way to add up a smoking history: a pack a day for a year is one pack-year.';

  @override
  String get glossaryWithdrawalPressure =>
      'A guess at how hard today is likely to feel. Only you know if it is right, and telling the app teaches it.';

  @override
  String get glossaryEvidence =>
      'How strong the science is behind a suggestion: strong, promising, or traditional with no proof.';

  @override
  String get glossarySoftTaper =>
      'Widening the gap between cigarettes in small steps you can actually keep.';

  @override
  String get glossaryTermSoftTaper => 'Soft taper';

  @override
  String get glossaryTermPackYears => 'Pack-years';

  @override
  String get organTapHint =>
      'Tap a point to see what it does and what recovery looks like.';

  @override
  String organImpactAttributable(int percent) {
    return '$percent% of these cases in the population are attributed to smoking';
  }

  @override
  String organImpactRelative(int percent) {
    return 'Risk about $percent% higher than in someone who never smoked';
  }

  @override
  String get organNotYou =>
      'These are population figures — not a reading of your body.';

  @override
  String get obWhyTitle => 'Why do you want to stop?';

  @override
  String get obWhyHint =>
      'Pick the one that is truest today. Halen shows it back to you when a craving hits.';

  @override
  String get reasonChildren => 'For my children';

  @override
  String get reasonHealth => 'For my health';

  @override
  String get reasonMoney => 'For the money';

  @override
  String get reasonFreedom => 'To not be owned by it';

  @override
  String get reasonSmell => 'For the smell';

  @override
  String get reasonFitness => 'To breathe better';

  @override
  String get reasonSomeoneAsked => 'Someone asked me to';

  @override
  String get resultTitle => 'This is where you are starting';

  @override
  String get resultSubtitle =>
      'All of it worked out from what you just told us.';

  @override
  String get resultPerYearPacks => 'Packs a year';

  @override
  String get resultPerYearMoney => 'A year';

  @override
  String get resultPerYearTime => 'A year, smoking';

  @override
  String get resultDependenceTitle => 'How much your body is leaning on it';

  @override
  String get resultDependenceLow => 'Light';

  @override
  String get resultDependenceModerate => 'Moderate';

  @override
  String get resultDependenceHigh => 'Strong';

  @override
  String get resultDependenceExplain =>
      'From two questions: how many a day, and how soon after waking. It sets how gently your plan starts — nothing else.';

  @override
  String get resultFirst72Title => 'What the first 72 hours look like';

  @override
  String get resultFirst7220m => '20 minutes';

  @override
  String get resultFirst7220mBody =>
      'Heart rate and blood pressure start to fall.';

  @override
  String get resultFirst7212h => '12 hours';

  @override
  String get resultFirst7212hBody =>
      'Carbon monoxide clears; more oxygen reaches your blood.';

  @override
  String get resultFirst7248h => '48-72 hours';

  @override
  String get resultFirst7248hBody =>
      'The hardest stretch, and the peak of it. Taste and smell start coming back.';

  @override
  String get resultStart => 'Start';

  @override
  String get resultSourceNote => 'Milestones from WHO and CDC population data.';

  @override
  String get quitPlanTitle => 'Your quit plan';

  @override
  String get quitPlanSubtitle =>
      'Five things that make an attempt stick. None of them are compulsory.';

  @override
  String quitPlanReadiness(int done, int total) {
    return '$done of $total ready';
  }

  @override
  String get quitDateTitle => 'A date to stop';

  @override
  String get quitDateNone => 'Not set yet';

  @override
  String get quitDateSet => 'Pick a date';

  @override
  String get quitDateChange => 'Move the date';

  @override
  String get quitDateClear => 'Remove the date';

  @override
  String get quitDateWhy =>
      'Cutting down works when it is aimed at a day. Without one, reducing tends to settle into a habit of its own.';

  @override
  String quitDateIn(int days) {
    return 'In $days days';
  }

  @override
  String get quitDateTomorrow => 'Tomorrow';

  @override
  String get quitDateToday => 'Today';

  @override
  String quitDatePassed(int days) {
    return 'Day $days';
  }

  @override
  String get quitDateTooSoonNote =>
      'Under three days leaves no room to get ready — to get medicine, tell someone, clear the house.';

  @override
  String get quitDateTooFarNote =>
      'Past six weeks a date stops working as a commitment. Nearer is better.';

  @override
  String quitDateMovedNote(int count) {
    return 'Moved $count times so far. That is allowed.';
  }

  @override
  String get medicinesTitle => 'Medicines that help';

  @override
  String get medicinesLead =>
      'These roughly double the chance an attempt succeeds. It is the most effective help available, and most people never try it.';

  @override
  String get medicinesOtc => 'Available at a pharmacy';

  @override
  String get medicinesPrescription => 'Ask a doctor';

  @override
  String get medicinesHowItWorks => 'How it works';

  @override
  String get medicinesTypicalUse => 'How it is used';

  @override
  String get medicinesCommonMistake => 'The usual mistake';

  @override
  String medicinesRatioPlacebo(int percent) {
    return 'Raises the chance of quitting by about $percent% compared with a dummy treatment, across trials';
  }

  @override
  String medicinesRatioSingle(int percent) {
    return 'Raises the chance of quitting by about $percent% compared with one form alone, across trials';
  }

  @override
  String get medicinesCombinationSuggestion =>
      'Given how much you smoke, the usual starting point is a patch plus one fast form. Worth asking a pharmacist about.';

  @override
  String get medicinesDisclaimer =>
      'Halen is not a prescriber and sells nothing. Doses, suitability and interactions are for a pharmacist or a doctor to judge — especially in pregnancy, heart disease or a psychiatric condition.';

  @override
  String get copingTitle => 'The hard moments';

  @override
  String get copingLead =>
      'Name what you will do instead, before you are in it. Deciding in the moment is the part that fails.';

  @override
  String get copingHint => 'What will you do instead?';

  @override
  String get copingSaved => 'Saved';

  @override
  String get copingEmpty =>
      'Your plan is empty. Even one line for your worst moment is worth having.';

  @override
  String get notAPuffTitle => 'Not a single puff';

  @override
  String get notAPuffBody =>
      'The rule is not about willpower. One cigarette re-teaches the craving that smoking still works, and that is what turns one into ten.';

  @override
  String get notAPuffAccept => 'I take the rule';

  @override
  String get notAPuffTaken => 'Rule taken';

  @override
  String get supportPersonTitle => 'Someone who knows';

  @override
  String get supportPersonBody =>
      'Telling one person raises the odds. First name is enough — Halen never reads your contacts and stores nothing else.';

  @override
  String get supportPersonHint => 'First name';

  @override
  String supportPersonDraft(String date) {
    return 'Something you could send: \"I am stopping smoking on $date. If I get unbearable, that is why. Ask me how it is going.\"';
  }

  @override
  String get supportPersonCopy => 'Copy the message';

  @override
  String get supportPersonCopied => 'Copied';

  @override
  String get moodCheckTitle => 'Two questions about your mood';

  @override
  String get moodCheckLead =>
      'Over the last two weeks, how often have you been bothered by...';

  @override
  String get moodCheckQ1 => 'Little interest or pleasure in doing things';

  @override
  String get moodCheckQ2 => 'Feeling down, depressed or hopeless';

  @override
  String get moodCheckNever => 'Not at all';

  @override
  String get moodCheckSomeDays => 'Several days';

  @override
  String get moodCheckMostDays => 'More than half the days';

  @override
  String get moodCheckEveryDay => 'Nearly every day';

  @override
  String get moodCheckWhy =>
      'Stopping can bring low mood to the surface in people prone to it. This is a screen, not a diagnosis, and nothing here leaves your phone.';

  @override
  String get moodCheckResultClear =>
      'Nothing here suggests you need to change course. Ask again whenever you want.';

  @override
  String get moodCheckResultTalk =>
      'This score is at the level where talking to a doctor is worth doing — not because stopping is wrong for you, but because low mood is treatable and easier to carry when it is treated.';

  @override
  String get moodCheckDone => 'Done';

  @override
  String get slipTitle => 'That was one cigarette';

  @override
  String get slipBody =>
      'One is a slip, not the end of the attempt. What decides the next week is what you do in the next hour.';

  @override
  String get slipAction =>
      'Throw the rest away, and go back to the plan now — not tomorrow, not Monday.';

  @override
  String get slipClusteringTitle => 'This is getting harder';

  @override
  String get slipClusteringBody =>
      'Several in a week usually means the situation is stronger than the plan, not that you are weak. This is the moment medicine helps most.';

  @override
  String get slipRelapseTitle => 'The attempt has slipped back';

  @override
  String get slipRelapseBody =>
      'Most people who stop for good have done this several times first. The attempt that works is usually not the first one.';

  @override
  String get slipSetNewDate => 'Set a new date';

  @override
  String get slipSeeMedicines => 'See what medicine could do';

  @override
  String get quitDayTitle => 'Today is the day';

  @override
  String get quitDayLead =>
      'The first day is mostly logistics. Here is the whole of it.';

  @override
  String get quitDayMorning => 'This morning';

  @override
  String get quitDayMorningBody =>
      'Throw away every cigarette, lighter and ashtray you own. Not hidden — gone.';

  @override
  String get quitDayAfternoon => 'This afternoon';

  @override
  String get quitDayAfternoonBody =>
      'The first cravings come in waves of a few minutes. Walk, water, breathe — they pass whether or not you smoke.';

  @override
  String get quitDayEvening => 'Tonight';

  @override
  String get quitDayEveningBody =>
      'Evening is the hardest hour of day one. Change what you do at that hour, not just what you hold.';

  @override
  String quitDayReasonReminder(String reason) {
    return 'You said you were doing this $reason.';
  }

  @override
  String get helplineTitle => 'A person on the phone';

  @override
  String get helplineBody =>
      'Quitlines work — talking to a trained counsellor raises the odds on its own.';

  @override
  String get statusTitle => 'Where you are';

  @override
  String get statusSwipeHint => 'Swipe for the next one';

  @override
  String get statusOpen => 'See all your numbers';

  @override
  String get statusPageNicotine => 'Nicotine';

  @override
  String get statusPageOxygen => 'Carbon monoxide in your blood';

  @override
  String get statusPageBaseline => 'Nicotine built up in your body';

  @override
  String get statusPageParticles => 'Tar build-up';

  @override
  String get statusPageProgress => 'Progress score';

  @override
  String get statusPageHarm => 'Harm load';

  @override
  String get statusPageMoney => 'Money';

  @override
  String get statusPageTime => 'Time';

  @override
  String get statusNeedsData => 'A few more records and this one draws itself.';

  @override
  String get celebrateTitle => 'That is a real one';

  @override
  String get celebrateClose => 'Keep going';

  @override
  String get celebrateDay1 => 'One full day';

  @override
  String get celebrateDay3 => 'Three days — past the peak';

  @override
  String get celebrateWeek1 => 'One week';

  @override
  String get celebrateMonth1 => 'One month';

  @override
  String get celebrateResisted100 => '100 cravings ridden out';

  @override
  String get commonNotNow => 'Not now';

  @override
  String get commonOpen => 'Open';

  @override
  String get todaySectionState => 'Where you stand';

  @override
  String get todaySectionSupport => 'Today\'s support';

  @override
  String get startupFailTitle => 'Halen could not open its database';

  @override
  String get startupFailBody =>
      'The encrypted store on this device would not open, so the app stopped rather than start without it.';

  @override
  String get startupFailDataSafe =>
      'Nothing has been lost and nothing was sent anywhere. If this keeps happening, the detail below is what a developer needs.';

  @override
  String get startupFailRetry => 'Try again';

  @override
  String get startupFailDetailTitle => 'Technical detail';

  @override
  String get startupFailCopy => 'Copy the detail';

  @override
  String get startupFailUnknown => 'No further detail was reported.';

  @override
  String get smokedHeadline0 => 'Recorded. Your nicotine level has peaked.';

  @override
  String get smokedHeadline1 =>
      'Cigarette logged. Carbon monoxide clearance has reset.';

  @override
  String get smokedHeadline2 => 'Record updated. Stay focused on your rhythm.';

  @override
  String get smokedHeadline3 =>
      'Logged. Delaying the next one is in your hands.';

  @override
  String get smokedAdvice0 =>
      'Drink a large glass of cold water now to neutralize nicotine taste and stimulate the vagus nerve.';

  @override
  String get smokedAdvice1 =>
      'Get up and take a short walk. Changing your environment weakens the next urge.';

  @override
  String get smokedAdvice2 =>
      'Take a deep diaphragm breath. Give yourself at least an hour before the next one.';

  @override
  String get smokedAdvice3 =>
      'Your body takes about 8 hours to clear this nicotine. Hydrate to support your metabolism.';

  @override
  String get splashContinue => 'Continue';

  @override
  String get packTitle => 'My pack';

  @override
  String packLabelLine(String tar, String nicotine) {
    return 'Label: $tar mg tar, $nicotine mg nicotine per cigarette';
  }

  @override
  String get packLabelDefaulted =>
      'Using the legal maximum until you enter your pack\'s own values.';

  @override
  String get packTar => 'Tar per cigarette (mg)';

  @override
  String get packNicotine => 'Nicotine per cigarette (mg)';

  @override
  String get packLabelHint =>
      'Printed on the side of the pack. Leave empty to use the legal maximum (10 mg tar, 1 mg nicotine).';

  @override
  String get purchasesTitle => 'My pack purchases';

  @override
  String get purchasesAdd => 'Add a purchase';

  @override
  String get purchasesEmpty =>
      'No purchases yet. Add the packs you buy and you will see what the habit really costs, month by month.';

  @override
  String get purchasesThisMonth => 'Spent this month';

  @override
  String get purchasesLastMonth => 'Last month';

  @override
  String purchasesEvery(String days) {
    return 'One pack every $days days on average';
  }

  @override
  String purchasesMonthlyRate(String amount) {
    return 'At this rate, about $amount a month';
  }

  @override
  String get purchasesChartTitle => 'Spending per month';

  @override
  String get purchasesChartMeaning =>
      'One bar per month: what went on cigarettes. The solid bar is this month.';

  @override
  String get purchasesChartAxis => 'amount spent';

  @override
  String get purchasesHistory => 'History';

  @override
  String get purchasesDeleted => 'Purchase removed';

  @override
  String get purchasesDate => 'Date';

  @override
  String get purchasesPacks => 'Packs';

  @override
  String get purchasesPrice => 'Price per pack';

  @override
  String get purchasesPackSize => 'Cigarettes';

  @override
  String get purchasesBrand => 'Brand (optional)';

  @override
  String get purchasesUpdatesPack =>
      'This becomes your current pack, so every cost figure in the app follows what you actually paid.';

  @override
  String get tarTitle => 'Tar you took in';

  @override
  String get tarThisWeek => 'This week';

  @override
  String get tarThisMonth => 'Last 30 days';

  @override
  String tarPicture(String count, String measure) {
    return 'about $count $measure';
  }

  @override
  String get measureTeaSpoon => 'tea spoons';

  @override
  String get measureDessertSpoon => 'dessert spoons';

  @override
  String get measureTableSpoon => 'table spoons';

  @override
  String get measureWaterGlass => 'glasses of water';

  @override
  String tarGrams(String grams) {
    return '$grams g';
  }

  @override
  String get tarChartMeaning =>
      'Tar brought into your lungs each week, from your own count and your pack label.';

  @override
  String get tarChartAxis => 'grams of tar per week';

  @override
  String tarWeekShort(int n) {
    return '$n wk';
  }

  @override
  String tarBasis(String tar) {
    return 'Worked out from $tar mg tar per cigarette on the label. This is a floor: people inhale more deeply than the test machine, so real intake is usually higher.';
  }

  @override
  String get tarSpoonNote =>
      'Spoons by volume, taking tar at about 1 g per millilitre. A Turkish tea spoon holds about 2.5 mL.';

  @override
  String get nicotineMgAxis =>
      'estimated nicotine still in your body, mg — a model, not a measurement';

  @override
  String get nicotineMgBasis =>
      'About 1.2 mg of nicotine is absorbed per cigarette, and half of it leaves the body every 2 hours (Benowitz).';

  @override
  String mgValue(String value) {
    return '$value mg';
  }

  @override
  String get organExposureTitle => 'This organ, last 24 hours';

  @override
  String organExposureNow(int percent) {
    return 'Right now: $percent% of its peak today';
  }

  @override
  String get organExposureMeaning =>
      'Each spike is a cigarette reaching this organ; the fall is your body clearing it. The flatter the line, the more rest the organ gets.';

  @override
  String organExposureLoads(String loads) {
    return 'Driven by: $loads';
  }

  @override
  String organSinceLast(String time) {
    return 'Since your last cigarette: $time';
  }

  @override
  String get organAcuteHeart =>
      'After a cigarette the heart beats about 10-20 times a minute faster and blood pressure rises, for roughly 20-30 minutes.';

  @override
  String get organAcuteVessels =>
      'Nicotine narrows blood vessels within minutes, and each cigarette keeps them narrowed for about an hour.';

  @override
  String get organAcuteLungs =>
      'Smoke slows the tiny hairs that sweep the airways clean, and tar settles in the lungs with every cigarette.';

  @override
  String get organAcuteBrain =>
      'Nicotine reaches the brain in 10-20 seconds; as it falls over the next hours, it comes back as the next craving.';

  @override
  String get organAcuteBlood =>
      'Carbon monoxide takes the place of oxygen in the blood; half of it clears in about 4-5 hours.';

  @override
  String get organAcuteGeneral =>
      'The harmful substances in smoke travel in the blood to every organ; exposure grows with every cigarette.';

  @override
  String get envTitle => 'What your planet got back';

  @override
  String envTrees(String count) {
    return '$count trees not cut down';
  }

  @override
  String envButts(int count) {
    return '$count filters kept out of nature';
  }

  @override
  String get envBasis =>
      'WHO estimates about one tree is lost for every 300 cigarettes made, mostly to dry tobacco leaves and make paper. Cigarette filters are plastic (cellulose acetate) and are the most littered item on Earth.';

  @override
  String get envPlantTitle => 'Plant a real tree';

  @override
  String get envPlantBody =>
      'A small part of what you have saved can plant a real sapling. Halen takes no money and earns nothing from this; the buttons open the organisations directly.';

  @override
  String envSavedCovers(int count) {
    return 'What you saved so far would plant about $count saplings.';
  }

  @override
  String get envOpenFailed => 'Could not open the link.';

  @override
  String get measureDrop => 'drops';

  @override
  String get tarThisWeekShort => 'now';

  @override
  String get envTreesLabel => 'Trees';

  @override
  String get envFiltersLabel => 'Filters';

  @override
  String get callQuitlineA171 => 'Turkey Quitline (ALO 171)';

  @override
  String get callYedam115 => 'Green Crescent Helpline (YEDAM 115)';

  @override
  String get callQuitlineUs => 'US Quitline (1-800-QUIT-NOW)';

  @override
  String get callQuitlineUk => 'UK NHS Smokefree (0300 123 1044)';

  @override
  String get callQuitlineDe => 'Germany BZgA Quitline (0800 8 313131)';

  @override
  String get callQuitlineFr => 'France Tabac Info (39 89)';

  @override
  String get nutritionGuideTitle => 'Anti-Craving Nutrition Guide';

  @override
  String get nutritionGuideSubtitle =>
      'Vitamin C, alkaline foods and hydration support';

  @override
  String get planCardTitle => 'Active Plan & Rhythm';

  @override
  String get planCardSwitch => 'Manage / Switch Plan';

  @override
  String planCardTarget(int count) {
    return 'Today\'s Target: $count cigarettes';
  }

  @override
  String get planCardNextInterval => 'Next Target Interval';

  @override
  String get economyHistoricalTitle => 'Lifetime Smoking Expenditure';

  @override
  String get economyHistoricalSubtitle =>
      'Estimated total money spent on cigarettes historically';

  @override
  String get economyTimeFilter1m => '1 Month';

  @override
  String get economyTimeFilter1y => '1 Year';

  @override
  String get economyTimeFilterAll => 'All Time (Halen)';

  @override
  String get economyTimeFilterLifetime => 'Lifetime History';

  @override
  String get progressScoreExplainer =>
      'Adherence Score (out of 100): Reflects adherence to daily quotas, spacing between cigarettes, and resisted urges.';

  @override
  String get mindPressureExplainer =>
      'Nicotine Withdrawal Pressure: Simulation of biological withdrawal pressure from nicotinic receptors. Peaks are temporary (~5-10 min).';
}
