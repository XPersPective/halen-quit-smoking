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
  String get ctaResisted => '✋ I resisted a craving';

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
      'We compare the average of your last 7 days with your weekly reduction rate and solve for when your daily budget reaches the final-week level. The result is always a range, updated weekly — never a guaranteed date.';

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
}
