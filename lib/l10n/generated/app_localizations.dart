import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Halen'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Reduce at your pace. Quit for good.'**
  String get tagline;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonHowCalculated.
  ///
  /// In en, this message translates to:
  /// **'How is this estimate calculated?'**
  String get commonHowCalculated;

  /// No description provided for @commonModelTag.
  ///
  /// In en, this message translates to:
  /// **'estimate · model'**
  String get commonModelTag;

  /// No description provided for @commonErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonErrorTitle;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonPremiumLocked.
  ///
  /// In en, this message translates to:
  /// **'This is part of Halen Premium. Your 7-day trial covers everything for free.'**
  String get commonPremiumLocked;

  /// No description provided for @commonUnlockPremium.
  ///
  /// In en, this message translates to:
  /// **'See lifetime offer'**
  String get commonUnlockPremium;

  /// No description provided for @splashWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Halen'**
  String get splashWelcomeTitle;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Reduce at your pace. Quit for good.'**
  String get splashTagline;

  /// No description provided for @splashPrivacyLine.
  ///
  /// In en, this message translates to:
  /// **'No account. No servers. Your data stays on this device.'**
  String get splashPrivacyLine;

  /// No description provided for @splashBackupLine.
  ///
  /// In en, this message translates to:
  /// **'Automatic cloud backup is off; your records never leave this phone.'**
  String get splashBackupLine;

  /// No description provided for @splashMedicalNote.
  ///
  /// In en, this message translates to:
  /// **'This app is not medical advice. For the treatment of nicotine dependence, consult a health professional.'**
  String get splashMedicalNote;

  /// No description provided for @splashNotificationRationale.
  ///
  /// In en, this message translates to:
  /// **'Notifications remind you of your plan — never spam. You can also enable them later.'**
  String get splashNotificationRationale;

  /// No description provided for @splashEnableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get splashEnableNotifications;

  /// No description provided for @splashStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get splashStart;

  /// No description provided for @obStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {n} of 7'**
  String obStepOf(int n);

  /// No description provided for @obAgeTitle.
  ///
  /// In en, this message translates to:
  /// **'How old are you?'**
  String get obAgeTitle;

  /// No description provided for @obAgeUnder18.
  ///
  /// In en, this message translates to:
  /// **'Under 18'**
  String get obAgeUnder18;

  /// No description provided for @obAge18to24.
  ///
  /// In en, this message translates to:
  /// **'18–24'**
  String get obAge18to24;

  /// No description provided for @obAge25to34.
  ///
  /// In en, this message translates to:
  /// **'25–34'**
  String get obAge25to34;

  /// No description provided for @obAge35to44.
  ///
  /// In en, this message translates to:
  /// **'35–44'**
  String get obAge35to44;

  /// No description provided for @obAge45to54.
  ///
  /// In en, this message translates to:
  /// **'45–54'**
  String get obAge45to54;

  /// No description provided for @obAge55plus.
  ///
  /// In en, this message translates to:
  /// **'55+'**
  String get obAge55plus;

  /// No description provided for @obUnder18Notice.
  ///
  /// In en, this message translates to:
  /// **'Halen is designed for adults. For young people, support programmes are a better fit — these free resources can help you.'**
  String get obUnder18Notice;

  /// No description provided for @obUnder18NoPlan.
  ///
  /// In en, this message translates to:
  /// **'No reduction plan will be created.'**
  String get obUnder18NoPlan;

  /// No description provided for @obCpdTitle.
  ///
  /// In en, this message translates to:
  /// **'On average, how many cigarettes do you smoke per day?'**
  String get obCpdTitle;

  /// No description provided for @obCpdHint.
  ///
  /// In en, this message translates to:
  /// **'Your first week will calibrate this with your real records.'**
  String get obCpdHint;

  /// No description provided for @obTtfcTitle.
  ///
  /// In en, this message translates to:
  /// **'After waking up, how soon do you smoke your first cigarette?'**
  String get obTtfcTitle;

  /// No description provided for @obTtfcUnder5.
  ///
  /// In en, this message translates to:
  /// **'Within 5 minutes'**
  String get obTtfcUnder5;

  /// No description provided for @obTtfc5to30.
  ///
  /// In en, this message translates to:
  /// **'5–30 minutes'**
  String get obTtfc5to30;

  /// No description provided for @obTtfc31to60.
  ///
  /// In en, this message translates to:
  /// **'31–60 minutes'**
  String get obTtfc31to60;

  /// No description provided for @obTtfcOver60.
  ///
  /// In en, this message translates to:
  /// **'After 60 minutes'**
  String get obTtfcOver60;

  /// No description provided for @obPriceTitle.
  ///
  /// In en, this message translates to:
  /// **'How much does a pack cost?'**
  String get obPriceTitle;

  /// No description provided for @obPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Pre-filled with a typical price in your country — edit it to your real price.'**
  String get obPriceHint;

  /// No description provided for @obPackSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Cigarettes per pack'**
  String get obPackSizeLabel;

  /// No description provided for @obTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'When do you usually smoke?'**
  String get obTimesTitle;

  /// No description provided for @obTimesHint.
  ///
  /// In en, this message translates to:
  /// **'Pick any that apply. This shapes your daily plan.'**
  String get obTimesHint;

  /// No description provided for @triggerCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get triggerCoffee;

  /// No description provided for @triggerAfterMeal.
  ///
  /// In en, this message translates to:
  /// **'After a meal'**
  String get triggerAfterMeal;

  /// No description provided for @triggerStress.
  ///
  /// In en, this message translates to:
  /// **'Stress'**
  String get triggerStress;

  /// No description provided for @triggerAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get triggerAlcohol;

  /// No description provided for @triggerCar.
  ///
  /// In en, this message translates to:
  /// **'In the car'**
  String get triggerCar;

  /// No description provided for @triggerSocial.
  ///
  /// In en, this message translates to:
  /// **'Socialising'**
  String get triggerSocial;

  /// No description provided for @triggerWorkBreak.
  ///
  /// In en, this message translates to:
  /// **'Work break'**
  String get triggerWorkBreak;

  /// No description provided for @triggerBeforeSleep.
  ///
  /// In en, this message translates to:
  /// **'Before sleep'**
  String get triggerBeforeSleep;

  /// No description provided for @triggerWakeUp.
  ///
  /// In en, this message translates to:
  /// **'After waking up'**
  String get triggerWakeUp;

  /// No description provided for @obGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your goal?'**
  String get obGoalTitle;

  /// No description provided for @obGoalReduce.
  ///
  /// In en, this message translates to:
  /// **'Reduce, then quit'**
  String get obGoalReduce;

  /// No description provided for @obGoalReduceHint.
  ///
  /// In en, this message translates to:
  /// **'Recommended — a plan that adapts to you'**
  String get obGoalReduceHint;

  /// No description provided for @obGoalQuitNow.
  ///
  /// In en, this message translates to:
  /// **'Quit right away'**
  String get obGoalQuitNow;

  /// No description provided for @obGoalQuitNowHint.
  ///
  /// In en, this message translates to:
  /// **'A quit-day programme with intense early support'**
  String get obGoalQuitNowHint;

  /// No description provided for @obGoalUndecided.
  ///
  /// In en, this message translates to:
  /// **'Not sure yet'**
  String get obGoalUndecided;

  /// No description provided for @obGoalUndecidedHint.
  ///
  /// In en, this message translates to:
  /// **'Start reducing — decide later'**
  String get obGoalUndecidedHint;

  /// No description provided for @obBrandTitle.
  ///
  /// In en, this message translates to:
  /// **'Your brand (optional)'**
  String get obBrandTitle;

  /// No description provided for @obBrandHint.
  ///
  /// In en, this message translates to:
  /// **'Only used for savings precision. You can skip this.'**
  String get obBrandHint;

  /// No description provided for @obBrandSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get obBrandSkip;

  /// No description provided for @obFinalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This app is not medical advice; for the treatment of nicotine dependence consult a health professional. If you are pregnant, or have a heart condition or a psychiatric condition, seek expert advice first.'**
  String get obFinalDisclaimer;

  /// No description provided for @obDataNote.
  ///
  /// In en, this message translates to:
  /// **'These answers only shape your plan and never leave your device.'**
  String get obDataNote;

  /// No description provided for @obFinish.
  ///
  /// In en, this message translates to:
  /// **'Set up my plan'**
  String get obFinish;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// No description provided for @todayRingLabel.
  ///
  /// In en, this message translates to:
  /// **'Today {smoked} of {target}'**
  String todayRingLabel(int smoked, int target);

  /// No description provided for @lastCigaretteMinutes.
  ///
  /// In en, this message translates to:
  /// **'Last cigarette: {n} min ago'**
  String lastCigaretteMinutes(int n);

  /// No description provided for @lastCigaretteHours.
  ///
  /// In en, this message translates to:
  /// **'Last cigarette: {h} h {m} min ago'**
  String lastCigaretteHours(int h, int m);

  /// No description provided for @lastCigaretteNone.
  ///
  /// In en, this message translates to:
  /// **'No cigarette recorded yet today'**
  String get lastCigaretteNone;

  /// No description provided for @nextTargetIn.
  ///
  /// In en, this message translates to:
  /// **'Next target: at least {n} min from now'**
  String nextTargetIn(int n);

  /// No description provided for @nextTargetHoursIn.
  ///
  /// In en, this message translates to:
  /// **'Next target: at least {h} h {m} min from now'**
  String nextTargetHoursIn(int h, int m);

  /// No description provided for @nextTargetReady.
  ///
  /// In en, this message translates to:
  /// **'Next target: you are inside your planned window'**
  String get nextTargetReady;

  /// No description provided for @nextTargetDayDone.
  ///
  /// In en, this message translates to:
  /// **'Daily plan completed — well done'**
  String get nextTargetDayDone;

  /// No description provided for @nicotineMiniLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated nicotine exposure (model)'**
  String get nicotineMiniLabel;

  /// No description provided for @ctaSmoked.
  ///
  /// In en, this message translates to:
  /// **'I SMOKED'**
  String get ctaSmoked;

  /// No description provided for @ctaResisted.
  ///
  /// In en, this message translates to:
  /// **'I resisted a craving'**
  String get ctaResisted;

  /// No description provided for @resistedTodayCount.
  ///
  /// In en, this message translates to:
  /// **'{n} today'**
  String resistedTodayCount(int n);

  /// No description provided for @savingsStrip.
  ///
  /// In en, this message translates to:
  /// **'You saved {amount} · {n} cigarettes avoided'**
  String savingsStrip(String amount, int n);

  /// No description provided for @healthStrip.
  ///
  /// In en, this message translates to:
  /// **'Coming up: {text}'**
  String healthStrip(String text);

  /// No description provided for @recalcTitle.
  ///
  /// In en, this message translates to:
  /// **'We recalculated.'**
  String get recalcTitle;

  /// No description provided for @recalcDistributed.
  ///
  /// In en, this message translates to:
  /// **'Your remaining budget for today is spread over the rest of the day.'**
  String get recalcDistributed;

  /// No description provided for @recalcBunched.
  ///
  /// In en, this message translates to:
  /// **'Today\'s smoking is bunched tighter than planned; try to hold the next one closer to the planned time.'**
  String get recalcBunched;

  /// No description provided for @recalcWeekSoftened.
  ///
  /// In en, this message translates to:
  /// **'This week ran over budget, so next week starts 5% gentler.'**
  String get recalcWeekSoftened;

  /// No description provided for @todayEmptyFirstDay.
  ///
  /// In en, this message translates to:
  /// **'This is your first day — the plan takes shape from your records and your answers.'**
  String get todayEmptyFirstDay;

  /// No description provided for @todayPlanLockedFree.
  ///
  /// In en, this message translates to:
  /// **'Your adaptive plan lives in Premium. Records, savings and the day counter are free forever.'**
  String get todayPlanLockedFree;

  /// No description provided for @daysSinceStart.
  ///
  /// In en, this message translates to:
  /// **'Day {n} with Halen'**
  String daysSinceStart(int n);

  /// No description provided for @recordDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Log details'**
  String get recordDetailTitle;

  /// No description provided for @recordDetailHint.
  ///
  /// In en, this message translates to:
  /// **'Optional — add a tag in one tap.'**
  String get recordDetailHint;

  /// No description provided for @recordDetailSaved.
  ///
  /// In en, this message translates to:
  /// **'Logged.'**
  String get recordDetailSaved;

  /// No description provided for @recordLoggedToast.
  ///
  /// In en, this message translates to:
  /// **'Logged.'**
  String get recordLoggedToast;

  /// No description provided for @sourceApp.
  ///
  /// In en, this message translates to:
  /// **'In app'**
  String get sourceApp;

  /// No description provided for @sourceWidget.
  ///
  /// In en, this message translates to:
  /// **'From widget'**
  String get sourceWidget;

  /// No description provided for @sourceTile.
  ///
  /// In en, this message translates to:
  /// **'From quick tile'**
  String get sourceTile;

  /// No description provided for @sourceControl.
  ///
  /// In en, this message translates to:
  /// **'From control'**
  String get sourceControl;

  /// No description provided for @sourceNotif.
  ///
  /// In en, this message translates to:
  /// **'From notification'**
  String get sourceNotif;

  /// No description provided for @planTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planTitle;

  /// No description provided for @planTodayBudget.
  ///
  /// In en, this message translates to:
  /// **'Today\'s budget: {n}'**
  String planTodayBudget(int n);

  /// No description provided for @planWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Planned windows'**
  String get planWindowsTitle;

  /// No description provided for @planMinGapRule.
  ///
  /// In en, this message translates to:
  /// **'Keep at least {n} minutes between cigarettes.'**
  String planMinGapRule(int n);

  /// No description provided for @planAdherence7.
  ///
  /// In en, this message translates to:
  /// **'7-day plan adherence: {n}%'**
  String planAdherence7(int n);

  /// No description provided for @planAdherence14.
  ///
  /// In en, this message translates to:
  /// **'14-day plan adherence: {n}%'**
  String planAdherence14(int n);

  /// No description provided for @planWeeksEstimate.
  ///
  /// In en, this message translates to:
  /// **'If the progress of the last 7 days continues at this rate, you could reach your goal in roughly {x}–{y} weeks.'**
  String planWeeksEstimate(int x, int y);

  /// No description provided for @planPhaseReduction.
  ///
  /// In en, this message translates to:
  /// **'Reduction'**
  String get planPhaseReduction;

  /// No description provided for @planPhaseFinal.
  ///
  /// In en, this message translates to:
  /// **'Final week'**
  String get planPhaseFinal;

  /// No description provided for @planPhaseQuit.
  ///
  /// In en, this message translates to:
  /// **'Quit programme'**
  String get planPhaseQuit;

  /// No description provided for @phaseWeekOf.
  ///
  /// In en, this message translates to:
  /// **'Week {n} of {total}'**
  String phaseWeekOf(int n, int total);

  /// No description provided for @paceCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm — 8 weeks, about 8–10% less per week'**
  String get paceCalm;

  /// No description provided for @paceStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard — 6 weeks, about 12–15% less per week'**
  String get paceStandard;

  /// No description provided for @paceFast.
  ///
  /// In en, this message translates to:
  /// **'Fast — 4 weeks, about 18–22% less per week'**
  String get paceFast;

  /// No description provided for @paceSettingLabel.
  ///
  /// In en, this message translates to:
  /// **'Reduction pace'**
  String get paceSettingLabel;

  /// No description provided for @paceChanged.
  ///
  /// In en, this message translates to:
  /// **'Pace updated.'**
  String get paceChanged;

  /// No description provided for @tempoAutoAdjusted.
  ///
  /// In en, this message translates to:
  /// **'We adjusted the tempo to your real progress.'**
  String get tempoAutoAdjusted;

  /// No description provided for @tempoUpSuggestion.
  ///
  /// In en, this message translates to:
  /// **'You are keeping to your plan consistently. Want to increase the pace a little?'**
  String get tempoUpSuggestion;

  /// No description provided for @tempoUpApply.
  ///
  /// In en, this message translates to:
  /// **'Increase pace'**
  String get tempoUpApply;

  /// No description provided for @finalWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'Final week'**
  String get finalWeekTitle;

  /// No description provided for @finalWeekBody.
  ///
  /// In en, this message translates to:
  /// **'Your daily budget is at 3 or fewer. Pick your quit day — a plan, not a promise.'**
  String get finalWeekBody;

  /// No description provided for @quitDayConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your quit day'**
  String get quitDayConfirmTitle;

  /// No description provided for @quitDaySet.
  ///
  /// In en, this message translates to:
  /// **'Quit day set: {date}'**
  String quitDaySet(String date);

  /// No description provided for @quitDayChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a day'**
  String get quitDayChoose;

  /// No description provided for @quitProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'Quit programme'**
  String get quitProgramTitle;

  /// No description provided for @quitPrepTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparation week'**
  String get quitPrepTitle;

  /// No description provided for @quitPrepBody.
  ///
  /// In en, this message translates to:
  /// **'List your triggers and your reason. Finish the sentence: “If X happens, I will Y.”'**
  String get quitPrepBody;

  /// No description provided for @quit24hTitle.
  ///
  /// In en, this message translates to:
  /// **'First 24 hours'**
  String get quit24hTitle;

  /// No description provided for @quit24hBody.
  ///
  /// In en, this message translates to:
  /// **'Your estimated exposure curve is falling fast. Cravings usually pass within a few minutes.'**
  String get quit24hBody;

  /// No description provided for @quit72hTitle.
  ///
  /// In en, this message translates to:
  /// **'First 72 hours'**
  String get quit72hTitle;

  /// No description provided for @quit72hBody.
  ///
  /// In en, this message translates to:
  /// **'Physical withdrawal is usually most intense in the first week and eases over time. Extra support is available now.'**
  String get quit72hBody;

  /// No description provided for @quitWeek1Title.
  ///
  /// In en, this message translates to:
  /// **'Week 1'**
  String get quitWeek1Title;

  /// No description provided for @quitWeek1Body.
  ///
  /// In en, this message translates to:
  /// **'Cravings come most often in the first week and get less frequent over time.'**
  String get quitWeek1Body;

  /// No description provided for @quitWeek2to4Title.
  ///
  /// In en, this message translates to:
  /// **'Weeks 2–4'**
  String get quitWeek2to4Title;

  /// No description provided for @quitWeek2to4Body.
  ///
  /// In en, this message translates to:
  /// **'Habits take time — median habit change is around 66 days and varies a lot between people.'**
  String get quitWeek2to4Body;

  /// No description provided for @planLockedFree.
  ///
  /// In en, this message translates to:
  /// **'The adaptive plan engine is part of Premium. Logging, savings and your day counter stay free forever.'**
  String get planLockedFree;

  /// No description provided for @quitSupportLine.
  ///
  /// In en, this message translates to:
  /// **'A health professional can discuss quitting methods with you, including nicotine replacement therapy.'**
  String get quitSupportLine;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @chartDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily count'**
  String get chartDaily;

  /// No description provided for @chartPlanVsActual.
  ///
  /// In en, this message translates to:
  /// **'Plan vs actual'**
  String get chartPlanVsActual;

  /// No description provided for @chartGaps.
  ///
  /// In en, this message translates to:
  /// **'Time between cigarettes'**
  String get chartGaps;

  /// No description provided for @chartHourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly pattern'**
  String get chartHourly;

  /// No description provided for @chartSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get chartSavings;

  /// No description provided for @statsRange7.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get statsRange7;

  /// No description provided for @statsRange30.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get statsRange30;

  /// No description provided for @statsRangeAll.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get statsRangeAll;

  /// No description provided for @statsRangeLockedPremium.
  ///
  /// In en, this message translates to:
  /// **'30-day and all-time charts are in Premium.'**
  String get statsRangeLockedPremium;

  /// No description provided for @triggerAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Trigger patterns'**
  String get triggerAnalysisTitle;

  /// No description provided for @triggerAnalysisEmpty.
  ///
  /// In en, this message translates to:
  /// **'Trigger patterns need at least 10 tagged records. Keep tagging — this appears on its own.'**
  String get triggerAnalysisEmpty;

  /// No description provided for @triggerRiskWindow.
  ///
  /// In en, this message translates to:
  /// **'The first 15 minutes after {trigger} look like a risky window for you.'**
  String triggerRiskWindow(String trigger);

  /// No description provided for @triggerSampleNote.
  ///
  /// In en, this message translates to:
  /// **'Based on {n} tagged records.'**
  String triggerSampleNote(int n);

  /// No description provided for @a11yDailyChartSummary.
  ///
  /// In en, this message translates to:
  /// **'Yesterday {count}, target {target}, plan adherence {adherence} percent.'**
  String a11yDailyChartSummary(int count, int target, int adherence);

  /// No description provided for @sosTitle.
  ///
  /// In en, this message translates to:
  /// **'Craving SOS'**
  String get sosTitle;

  /// No description provided for @sosIntro.
  ///
  /// In en, this message translates to:
  /// **'Cravings usually pass within a few minutes. Wait it out with one of these.'**
  String get sosIntro;

  /// No description provided for @sosTimerTitle.
  ///
  /// In en, this message translates to:
  /// **'2-minute timer'**
  String get sosTimerTitle;

  /// No description provided for @sosTimerRunning.
  ///
  /// In en, this message translates to:
  /// **'Hold on — {s} s left'**
  String sosTimerRunning(int s);

  /// No description provided for @sosTimerDone.
  ///
  /// In en, this message translates to:
  /// **'Two minutes done. The wave passed.'**
  String get sosTimerDone;

  /// No description provided for @sos4dDelay.
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get sos4dDelay;

  /// No description provided for @sos4dDelayBody.
  ///
  /// In en, this message translates to:
  /// **'Give it two minutes before you decide.'**
  String get sos4dDelayBody;

  /// No description provided for @sos4dBreathe.
  ///
  /// In en, this message translates to:
  /// **'Deep breathing'**
  String get sos4dBreathe;

  /// No description provided for @sos4dBreatheBody.
  ///
  /// In en, this message translates to:
  /// **'Sixty seconds of box breathing, guided.'**
  String get sos4dBreatheBody;

  /// No description provided for @sos4dWater.
  ///
  /// In en, this message translates to:
  /// **'Drink water'**
  String get sos4dWater;

  /// No description provided for @sos4dWaterBody.
  ///
  /// In en, this message translates to:
  /// **'A glass of water, slowly.'**
  String get sos4dWaterBody;

  /// No description provided for @sos4dElse.
  ///
  /// In en, this message translates to:
  /// **'Do something else'**
  String get sos4dElse;

  /// No description provided for @sos4dElseBody.
  ///
  /// In en, this message translates to:
  /// **'Two minutes of anything — walk, wash your hands, step outside.'**
  String get sos4dElseBody;

  /// No description provided for @sosUrgeSurf.
  ///
  /// In en, this message translates to:
  /// **'Watch and wait'**
  String get sosUrgeSurf;

  /// No description provided for @sosUrgeSurfBody.
  ///
  /// In en, this message translates to:
  /// **'Notice the craving like a wave: it rises, peaks and falls. You don\'t have to fight it.'**
  String get sosUrgeSurfBody;

  /// No description provided for @sosBreathingIn.
  ///
  /// In en, this message translates to:
  /// **'Breathe in'**
  String get sosBreathingIn;

  /// No description provided for @sosBreathingHold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get sosBreathingHold;

  /// No description provided for @sosBreathingOut.
  ///
  /// In en, this message translates to:
  /// **'Breathe out'**
  String get sosBreathingOut;

  /// No description provided for @sosBreathingFinished.
  ///
  /// In en, this message translates to:
  /// **'One minute done.'**
  String get sosBreathingFinished;

  /// No description provided for @sosOutcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'How did it go?'**
  String get sosOutcomeTitle;

  /// No description provided for @sosResisted.
  ///
  /// In en, this message translates to:
  /// **'I resisted'**
  String get sosResisted;

  /// No description provided for @sosSmoked.
  ///
  /// In en, this message translates to:
  /// **'I smoked'**
  String get sosSmoked;

  /// No description provided for @sosResistedCount.
  ///
  /// In en, this message translates to:
  /// **'You have resisted {n} cravings so far.'**
  String sosResistedCount(int n);

  /// No description provided for @sosAfterSmoked.
  ///
  /// In en, this message translates to:
  /// **'Logged. We recalculated your plan — it just keeps adapting.'**
  String get sosAfterSmoked;

  /// No description provided for @sosIntensityTitle.
  ///
  /// In en, this message translates to:
  /// **'How strong was it?'**
  String get sosIntensityTitle;

  /// No description provided for @sosIntensity1.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get sosIntensity1;

  /// No description provided for @sosIntensity2.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get sosIntensity2;

  /// No description provided for @sosIntensity3.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get sosIntensity3;

  /// No description provided for @sosAfterResisted.
  ///
  /// In en, this message translates to:
  /// **'After the log: well done — every resisted craving counts.'**
  String get sosAfterResisted;

  /// No description provided for @sosNrtLine.
  ///
  /// In en, this message translates to:
  /// **'You can talk to a health professional about options such as NRT.'**
  String get sosNrtLine;

  /// No description provided for @sosLocked.
  ///
  /// In en, this message translates to:
  /// **'The full SOS toolkit (breathing animation, watch-and-wait) is in Premium — free during your trial.'**
  String get sosLocked;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @notifDensity.
  ///
  /// In en, this message translates to:
  /// **'Density'**
  String get notifDensity;

  /// No description provided for @notifDensityCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get notifDensityCalm;

  /// No description provided for @notifDensityStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get notifDensityStandard;

  /// No description provided for @notifDensityIntense.
  ///
  /// In en, this message translates to:
  /// **'Intense'**
  String get notifDensityIntense;

  /// No description provided for @notifDensityOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get notifDensityOff;

  /// No description provided for @notifSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your day with Halen'**
  String get notifSummaryTitle;

  /// No description provided for @notifSummaryBody.
  ///
  /// In en, this message translates to:
  /// **'Today: {count} of {target}. Every record keeps the plan honest.'**
  String notifSummaryBody(int count, int target);

  /// No description provided for @notifMorningTitle.
  ///
  /// In en, this message translates to:
  /// **'Today’s budget is waiting in Halen'**
  String get notifMorningTitle;

  /// No description provided for @notifMorningBody.
  ///
  /// In en, this message translates to:
  /// **'Small steps count. You set the pace.'**
  String get notifMorningBody;

  /// No description provided for @notifPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Planned time is approaching'**
  String get notifPlanTitle;

  /// No description provided for @notifPlanBody.
  ///
  /// In en, this message translates to:
  /// **'Your next planned window starts soon.'**
  String get notifPlanBody;

  /// No description provided for @notifReturnTitle.
  ///
  /// In en, this message translates to:
  /// **'Still there?'**
  String get notifReturnTitle;

  /// No description provided for @notifReturnBody.
  ///
  /// In en, this message translates to:
  /// **'No records for a few days — pick up right where you left off.'**
  String get notifReturnBody;

  /// No description provided for @notifQuitTitle.
  ///
  /// In en, this message translates to:
  /// **'First hours matter most'**
  String get notifQuitTitle;

  /// No description provided for @notifQuitBody.
  ///
  /// In en, this message translates to:
  /// **'The wave rises, peaks and falls. Hold on — this app is with you.'**
  String get notifQuitBody;

  /// No description provided for @notifMilestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestone reached'**
  String get notifMilestoneTitle;

  /// No description provided for @notifMilestoneBody.
  ///
  /// In en, this message translates to:
  /// **'A new health milestone is in. Check your timeline.'**
  String get notifMilestoneBody;

  /// No description provided for @notifChannelReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notifChannelReminders;

  /// No description provided for @notifChannelSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get notifChannelSupport;

  /// No description provided for @notifSummaryGeneric.
  ///
  /// In en, this message translates to:
  /// **'Every record keeps the plan honest.'**
  String get notifSummaryGeneric;

  /// No description provided for @notifDailySummary.
  ///
  /// In en, this message translates to:
  /// **'Daily summary (evening)'**
  String get notifDailySummary;

  /// No description provided for @notifMorningGoal.
  ///
  /// In en, this message translates to:
  /// **'Morning goal'**
  String get notifMorningGoal;

  /// No description provided for @notifPlanReminder.
  ///
  /// In en, this message translates to:
  /// **'Planned time approaching'**
  String get notifPlanReminder;

  /// No description provided for @notifQuitSupport.
  ///
  /// In en, this message translates to:
  /// **'Quit-day support (first 72 hours)'**
  String get notifQuitSupport;

  /// No description provided for @notifMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get notifMilestones;

  /// No description provided for @notifGentleReturn.
  ///
  /// In en, this message translates to:
  /// **'Gentle nudge after silence'**
  String get notifGentleReturn;

  /// No description provided for @notifExactTime.
  ///
  /// In en, this message translates to:
  /// **'Exact-time reminders'**
  String get notifExactTime;

  /// No description provided for @notifExactTimeHint.
  ///
  /// In en, this message translates to:
  /// **'Off by default; Android shows these as approximate. Enabling uses exact alarms.'**
  String get notifExactTimeHint;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsReduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion'**
  String get settingsReduceMotion;

  /// No description provided for @settingsHaptics.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get settingsHaptics;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get settingsData;

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export data (JSON)'**
  String get settingsExport;

  /// No description provided for @settingsImport.
  ///
  /// In en, this message translates to:
  /// **'Import data (JSON)'**
  String get settingsImport;

  /// No description provided for @settingsExportDone.
  ///
  /// In en, this message translates to:
  /// **'Backup saved: {path}'**
  String settingsExportDone(String path);

  /// No description provided for @settingsImportDone.
  ///
  /// In en, this message translates to:
  /// **'Imported — {n} records restored.'**
  String settingsImportDone(int n);

  /// No description provided for @settingsDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get settingsDeleteAll;

  /// No description provided for @deleteAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete everything? This cannot be undone.'**
  String get deleteAllConfirm;

  /// No description provided for @settingsPurchase.
  ///
  /// In en, this message translates to:
  /// **'Halen Lifetime'**
  String get settingsPurchase;

  /// No description provided for @purchaseCopy.
  ///
  /// In en, this message translates to:
  /// **'One-time · Lifetime · No subscription'**
  String get purchaseCopy;

  /// No description provided for @purchaseCta.
  ///
  /// In en, this message translates to:
  /// **'Buy once'**
  String get purchaseCta;

  /// No description provided for @purchaseRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchase'**
  String get purchaseRestore;

  /// No description provided for @purchaseOwned.
  ///
  /// In en, this message translates to:
  /// **'You own Halen Lifetime.'**
  String get purchaseOwned;

  /// No description provided for @purchasePending.
  ///
  /// In en, this message translates to:
  /// **'Your purchase is pending — access unlocks when it completes.'**
  String get purchasePending;

  /// No description provided for @trialDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'Trial: {n} days left'**
  String trialDaysLeft(int n);

  /// No description provided for @trialExpiredFree.
  ///
  /// In en, this message translates to:
  /// **'Trial ended — the free tier (logging, savings, day counter, 7-day chart, export) stays yours forever.'**
  String get trialExpiredFree;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Health notice'**
  String get settingsDisclaimerTitle;

  /// No description provided for @settingsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This app is not medical advice; for the treatment of nicotine dependence consult a health professional. If you are pregnant, or have a heart condition or a psychiatric condition, seek expert advice first.'**
  String get settingsDisclaimer;

  /// No description provided for @settingsHelplines.
  ///
  /// In en, this message translates to:
  /// **'Support lines: TR Yeşilay 176 · US 1-800-QUIT-NOW · UK NHS · DE BZgA'**
  String get settingsHelplines;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy: no account, no servers, no analytics. Your records stay on this device.'**
  String get settingsPrivacy;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {v}'**
  String settingsVersion(String v);

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep going with Halen Premium'**
  String get paywallTitle;

  /// No description provided for @paywallValueLine.
  ///
  /// In en, this message translates to:
  /// **'This week you kept to your plan {n}% of the time.'**
  String paywallValueLine(int n);

  /// No description provided for @paywallFeaturePlan.
  ///
  /// In en, this message translates to:
  /// **'The adaptive reduction plan that recalculates itself'**
  String get paywallFeaturePlan;

  /// No description provided for @paywallFeatureCharts.
  ///
  /// In en, this message translates to:
  /// **'Full charts: plan vs actual, gaps, hourly pattern'**
  String get paywallFeatureCharts;

  /// No description provided for @paywallFeatureTriggers.
  ///
  /// In en, this message translates to:
  /// **'Trigger patterns'**
  String get paywallFeatureTriggers;

  /// No description provided for @paywallFeatureTimeline.
  ///
  /// In en, this message translates to:
  /// **'The full health timeline'**
  String get paywallFeatureTimeline;

  /// No description provided for @paywallFeatureSos.
  ///
  /// In en, this message translates to:
  /// **'The complete SOS toolkit'**
  String get paywallFeatureSos;

  /// No description provided for @paywallFeatureWidget.
  ///
  /// In en, this message translates to:
  /// **'Widget customisation'**
  String get paywallFeatureWidget;

  /// No description provided for @paywallTrialNote.
  ///
  /// In en, this message translates to:
  /// **'Your 7-day free trial starts on first launch — no card needed.'**
  String get paywallTrialNote;

  /// No description provided for @timelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Health timeline'**
  String get timelineTitle;

  /// No description provided for @timelinePreviewLocked.
  ///
  /// In en, this message translates to:
  /// **'In reduce mode the countdown starts on your quit day. Until then this is a preview.'**
  String get timelinePreviewLocked;

  /// No description provided for @timelineSourceWho.
  ///
  /// In en, this message translates to:
  /// **'Source: WHO'**
  String get timelineSourceWho;

  /// No description provided for @timelineSourceCdc.
  ///
  /// In en, this message translates to:
  /// **'Source: CDC'**
  String get timelineSourceCdc;

  /// No description provided for @timelineGeneralPattern.
  ///
  /// In en, this message translates to:
  /// **'In general, among people who quit smoking…'**
  String get timelineGeneralPattern;

  /// No description provided for @timelineMilestone20min.
  ///
  /// In en, this message translates to:
  /// **'20 minutes'**
  String get timelineMilestone20min;

  /// No description provided for @timelineBody20min.
  ///
  /// In en, this message translates to:
  /// **'In general, among people who quit smoking, heart rate and blood pressure drop.'**
  String get timelineBody20min;

  /// No description provided for @timelineMilestone12h.
  ///
  /// In en, this message translates to:
  /// **'12 hours'**
  String get timelineMilestone12h;

  /// No description provided for @timelineBody12h.
  ///
  /// In en, this message translates to:
  /// **'In general, among people who quit smoking, the carbon monoxide level in their blood returns to normal.'**
  String get timelineBody12h;

  /// No description provided for @timelineCoCard.
  ///
  /// In en, this message translates to:
  /// **'Blood carbon monoxide returns to normal in about 12 hours — WHO'**
  String get timelineCoCard;

  /// No description provided for @timelineMilestone2to12w.
  ///
  /// In en, this message translates to:
  /// **'2–12 weeks'**
  String get timelineMilestone2to12w;

  /// No description provided for @timelineBody2to12w.
  ///
  /// In en, this message translates to:
  /// **'In general, among people who quit smoking, circulation and lung function improve.'**
  String get timelineBody2to12w;

  /// No description provided for @timelineMilestone1to9m.
  ///
  /// In en, this message translates to:
  /// **'1–9 months'**
  String get timelineMilestone1to9m;

  /// No description provided for @timelineBody1to9m.
  ///
  /// In en, this message translates to:
  /// **'In general, among people who quit smoking, coughing and shortness of breath decrease.'**
  String get timelineBody1to9m;

  /// No description provided for @timelineMilestone1y.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get timelineMilestone1y;

  /// No description provided for @timelineBody1y.
  ///
  /// In en, this message translates to:
  /// **'In general, among people who quit smoking, the risk of coronary heart disease is about half that of a smoker\'s.'**
  String get timelineBody1y;

  /// No description provided for @timelineMilestone5to15y.
  ///
  /// In en, this message translates to:
  /// **'5–15 years'**
  String get timelineMilestone5to15y;

  /// No description provided for @timelineBody5to15y.
  ///
  /// In en, this message translates to:
  /// **'In general, among people who quit smoking, the risk of stroke falls to that of a non-smoker.'**
  String get timelineBody5to15y;

  /// No description provided for @timelineMilestone10y.
  ///
  /// In en, this message translates to:
  /// **'10 years'**
  String get timelineMilestone10y;

  /// No description provided for @timelineBody10y.
  ///
  /// In en, this message translates to:
  /// **'In general, among people who quit smoking, the risk of lung cancer falls to about half that of a smoker\'s.'**
  String get timelineBody10y;

  /// No description provided for @timelineMilestone15y.
  ///
  /// In en, this message translates to:
  /// **'15 years'**
  String get timelineMilestone15y;

  /// No description provided for @timelineBody15y.
  ///
  /// In en, this message translates to:
  /// **'In general, among people who quit smoking, the risk of coronary heart disease becomes similar to that of someone who has never smoked.'**
  String get timelineBody15y;

  /// No description provided for @howNicotineTitle.
  ///
  /// In en, this message translates to:
  /// **'How the nicotine estimate is calculated'**
  String get howNicotineTitle;

  /// No description provided for @howNicotineBody.
  ///
  /// In en, this message translates to:
  /// **'Each cigarette is assumed to deliver about 1.2 mg of absorbed nicotine (a published range of roughly 1–1.5 mg). Your estimated exposure curve sums every cigarette you log and halves that total every 2 hours — nicotine\'s typical plasma half-life. The screen shows a 0–100 normalised curve, never an absolute blood level.'**
  String get howNicotineBody;

  /// No description provided for @howNicotineLimits.
  ///
  /// In en, this message translates to:
  /// **'Limits: this is a behavioural model, not a measurement. Absorption varies with how you smoke, the product and your metabolism. Nothing in this app is measured from your body.'**
  String get howNicotineLimits;

  /// No description provided for @howNicotineSources.
  ///
  /// In en, this message translates to:
  /// **'Sources: Benowitz, NEJM 2010 (nicotine absorption 1–1.5 mg/cigarette); Hukkanen et al., Pharmacol Rev 2005 (plasma half-life ~2 h).'**
  String get howNicotineSources;

  /// No description provided for @howWeeksTitle.
  ///
  /// In en, this message translates to:
  /// **'How the weeks estimate is calculated'**
  String get howWeeksTitle;

  /// No description provided for @howWeeksBody.
  ///
  /// In en, this message translates to:
  /// **'We compare the average of your last 7 days with your weekly reduction rate and solve for when your daily budget reaches the final-week level. The result is always a range, updated weekly — never a fixed date.'**
  String get howWeeksBody;

  /// No description provided for @howSavingsTitle.
  ///
  /// In en, this message translates to:
  /// **'How savings are calculated'**
  String get howSavingsTitle;

  /// No description provided for @howSavingsBody.
  ///
  /// In en, this message translates to:
  /// **'Your pack price divided by cigarettes per pack gives a per-cigarette cost. Cigarettes you avoid relative to your baseline multiply that cost. Prices you enter stay on your device.'**
  String get howSavingsBody;

  /// No description provided for @howTitle.
  ///
  /// In en, this message translates to:
  /// **'How this estimate is calculated'**
  String get howTitle;

  /// No description provided for @motivationStreakBest.
  ///
  /// In en, this message translates to:
  /// **'Longest on-plan streak: {n} days'**
  String motivationStreakBest(int n);

  /// No description provided for @motivationStreakRestart.
  ///
  /// In en, this message translates to:
  /// **'Starting again is normal.'**
  String get motivationStreakRestart;

  /// No description provided for @motivationAvoidedTotal.
  ///
  /// In en, this message translates to:
  /// **'{n} cigarettes avoided so far'**
  String motivationAvoidedTotal(int n);

  /// No description provided for @motivationWhoNext.
  ///
  /// In en, this message translates to:
  /// **'Next milestone: {text}'**
  String motivationWhoNext(String text);

  /// No description provided for @notificationDailySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s summary'**
  String get notificationDailySummaryTitle;

  /// No description provided for @notificationDailySummaryBody.
  ///
  /// In en, this message translates to:
  /// **'{smoked} of {target} today. {extra}'**
  String notificationDailySummaryBody(int smoked, int target, String extra);

  /// No description provided for @notificationMorningTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s target: {n}'**
  String notificationMorningTitle(int n);

  /// No description provided for @notificationMorningBody.
  ///
  /// In en, this message translates to:
  /// **'One tap is enough — Halen keeps the count.'**
  String get notificationMorningBody;

  /// No description provided for @notificationPlanReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Planned window'**
  String get notificationPlanReminderTitle;

  /// No description provided for @notificationPlanReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Your next planned window is around now.'**
  String get notificationPlanReminderBody;

  /// No description provided for @notificationQuitSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'You are doing it'**
  String get notificationQuitSupportTitle;

  /// No description provided for @notificationQuitSupportBody.
  ///
  /// In en, this message translates to:
  /// **'Cravings peak early and fade. Open SOS if one hits.'**
  String get notificationQuitSupportBody;

  /// No description provided for @notificationMilestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestone: {name}'**
  String notificationMilestoneTitle(String name);

  /// No description provided for @notificationGentleReturnTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick up where you left off'**
  String get notificationGentleReturnTitle;

  /// No description provided for @notificationGentleReturnBody.
  ///
  /// In en, this message translates to:
  /// **'No records for a few days — your plan is waiting, unchanged. One tap resumes everything.'**
  String get notificationGentleReturnBody;

  /// No description provided for @under18YouthTitle.
  ///
  /// In en, this message translates to:
  /// **'Support for young people'**
  String get under18YouthTitle;

  /// No description provided for @under18YouthBody.
  ///
  /// In en, this message translates to:
  /// **'Halen is built for adults and will not create a plan for you. Free, youth-appropriate support exists — talking to a doctor, school counsellor or a quitline is a strong first step.'**
  String get under18YouthBody;

  /// No description provided for @errorDatabaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Database could not be opened'**
  String get errorDatabaseTitle;

  /// No description provided for @errorDatabaseBody.
  ///
  /// In en, this message translates to:
  /// **'Your encrypted database could not be unlocked on this device. Nothing was sent anywhere.'**
  String get errorDatabaseBody;

  /// No description provided for @emptyGeneric.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get emptyGeneric;

  /// No description provided for @emptyNoRecords.
  ///
  /// In en, this message translates to:
  /// **'No records yet — your first tap starts the count.'**
  String get emptyNoRecords;

  /// No description provided for @a11yRing.
  ///
  /// In en, this message translates to:
  /// **'Today\'s ring: {smoked} of {target} cigarettes'**
  String a11yRing(int smoked, int target);

  /// No description provided for @a11yNicotineChart.
  ///
  /// In en, this message translates to:
  /// **'Estimated nicotine exposure chart. It rises with each logged cigarette and falls by half every two hours.'**
  String get a11yNicotineChart;

  /// No description provided for @a11ySavingsChart.
  ///
  /// In en, this message translates to:
  /// **'Savings chart, cumulative over the selected range.'**
  String get a11ySavingsChart;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get navStats;

  /// No description provided for @navPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get navPlan;

  /// No description provided for @navArticles.
  ///
  /// In en, this message translates to:
  /// **'Guides'**
  String get navArticles;

  /// No description provided for @navSos.
  ///
  /// In en, this message translates to:
  /// **'Craving SOS'**
  String get navSos;

  /// No description provided for @statsTabDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily Trends'**
  String get statsTabDaily;

  /// No description provided for @statsTabHourly.
  ///
  /// In en, this message translates to:
  /// **'24h Hourly'**
  String get statsTabHourly;

  /// No description provided for @statsTabIntervals.
  ///
  /// In en, this message translates to:
  /// **'Intervals'**
  String get statsTabIntervals;

  /// No description provided for @statsTabTriggers.
  ///
  /// In en, this message translates to:
  /// **'Triggers'**
  String get statsTabTriggers;

  /// No description provided for @intervalTitle.
  ///
  /// In en, this message translates to:
  /// **'Inter-Cigarette Intervals'**
  String get intervalTitle;

  /// No description provided for @intervalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Distribution of time elapsed between each cigarette'**
  String get intervalSubtitle;

  /// No description provided for @intervalAverage.
  ///
  /// In en, this message translates to:
  /// **'Average interval'**
  String get intervalAverage;

  /// No description provided for @intervalLongest.
  ///
  /// In en, this message translates to:
  /// **'Longest smoke-free gap'**
  String get intervalLongest;

  /// No description provided for @intervalShortest.
  ///
  /// In en, this message translates to:
  /// **'Shortest gap'**
  String get intervalShortest;

  /// No description provided for @intervalCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current smoke-free time'**
  String get intervalCurrent;

  /// No description provided for @intervalMinutes.
  ///
  /// In en, this message translates to:
  /// **'{m} min'**
  String intervalMinutes(int m);

  /// No description provided for @intervalHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{h}h {m}m'**
  String intervalHoursMinutes(int h, int m);

  /// No description provided for @hourlyTitle.
  ///
  /// In en, this message translates to:
  /// **'24-Hour Distribution'**
  String get hourlyTitle;

  /// No description provided for @hourlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'When you smoke during the day'**
  String get hourlySubtitle;

  /// No description provided for @hourlyPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak hour: {hour}:00 ({count} cigarettes)'**
  String hourlyPeak(int hour, int count);

  /// No description provided for @timeMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning (06–12)'**
  String get timeMorning;

  /// No description provided for @timeAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon (12–18)'**
  String get timeAfternoon;

  /// No description provided for @timeEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening (18–24)'**
  String get timeEvening;

  /// No description provided for @timeNight.
  ///
  /// In en, this message translates to:
  /// **'Night (00–06)'**
  String get timeNight;

  /// No description provided for @triggerTitle.
  ///
  /// In en, this message translates to:
  /// **'Trigger Analysis'**
  String get triggerTitle;

  /// No description provided for @triggerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What sparks the urge'**
  String get triggerSubtitle;

  /// No description provided for @triggerOccurrences.
  ///
  /// In en, this message translates to:
  /// **'{count} times ({percent}%)'**
  String triggerOccurrences(int count, int percent);

  /// No description provided for @todayLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Cigarette Log'**
  String get todayLogTitle;

  /// No description provided for @todayLogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Detailed breakdown of today\'s smokes'**
  String get todayLogSubtitle;

  /// No description provided for @todayLogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No cigarettes logged yet today'**
  String get todayLogEmpty;

  /// No description provided for @deleteCigaretteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this cigarette record?'**
  String get deleteCigaretteConfirm;

  /// No description provided for @deletedCigaretteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Record deleted'**
  String get deletedCigaretteSuccess;

  /// No description provided for @articlesTitle.
  ///
  /// In en, this message translates to:
  /// **'Guides & Articles'**
  String get articlesTitle;

  /// No description provided for @articlesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Evidence-based smoking cessation science'**
  String get articlesSubtitle;

  /// No description provided for @articleCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get articleCategoryAll;

  /// No description provided for @articleCategoryScience.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get articleCategoryScience;

  /// No description provided for @articleCategoryCrisis.
  ///
  /// In en, this message translates to:
  /// **'Craving Relief'**
  String get articleCategoryCrisis;

  /// No description provided for @articleCategoryTriggers.
  ///
  /// In en, this message translates to:
  /// **'Triggers'**
  String get articleCategoryTriggers;

  /// No description provided for @articleCategoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get articleCategoryHealth;

  /// No description provided for @articleCategoryPsychology.
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get articleCategoryPsychology;

  /// No description provided for @articleReadTime.
  ///
  /// In en, this message translates to:
  /// **'{min} min read'**
  String articleReadTime(int min);

  /// No description provided for @articleSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Scientific source: {source}'**
  String articleSourceLabel(String source);

  /// No description provided for @articleKeyTakeaways.
  ///
  /// In en, this message translates to:
  /// **'Key Takeaways'**
  String get articleKeyTakeaways;

  /// No description provided for @todayFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'More space.\nMore you.'**
  String get todayFocusTitle;

  /// No description provided for @todayFocusNote.
  ///
  /// In en, this message translates to:
  /// **'Every pause is a step forward.'**
  String get todayFocusNote;

  /// No description provided for @dailyBudgetCaption.
  ///
  /// In en, this message translates to:
  /// **'Logged / daily target'**
  String get dailyBudgetCaption;

  /// No description provided for @todayOverview.
  ///
  /// In en, this message translates to:
  /// **'Your day, at a glance'**
  String get todayOverview;

  /// No description provided for @todaySupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Take a breathing break'**
  String get todaySupportTitle;

  /// No description provided for @todaySupportNote.
  ///
  /// In en, this message translates to:
  /// **'A quiet moment, whenever you need it.'**
  String get todaySupportNote;

  /// No description provided for @statsIntro.
  ///
  /// In en, this message translates to:
  /// **'Small steps. A clearer picture.'**
  String get statsIntro;

  /// No description provided for @chartActualLabel.
  ///
  /// In en, this message translates to:
  /// **'Logged'**
  String get chartActualLabel;

  /// No description provided for @chartTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily target'**
  String get chartTargetLabel;

  /// No description provided for @chartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your story starts here'**
  String get chartEmptyTitle;

  /// No description provided for @chartEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your entries will turn into a picture of your progress.'**
  String get chartEmptyBody;

  /// No description provided for @chartTimeBlocks.
  ///
  /// In en, this message translates to:
  /// **'Throughout the day'**
  String get chartTimeBlocks;

  /// No description provided for @chartIntervalAxis.
  ///
  /// In en, this message translates to:
  /// **'Time between entries · minutes'**
  String get chartIntervalAxis;

  /// No description provided for @chartIntervalEmpty.
  ///
  /// In en, this message translates to:
  /// **'Two entries are enough to see your first interval.'**
  String get chartIntervalEmpty;

  /// No description provided for @chartTriggerEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add a tag when logging to discover your patterns.'**
  String get chartTriggerEmpty;

  /// No description provided for @statsSavingsNote.
  ///
  /// In en, this message translates to:
  /// **'Estimated from your entries'**
  String get statsSavingsNote;

  /// No description provided for @moduleModelTag.
  ///
  /// In en, this message translates to:
  /// **'Modelled from your records — not a measurement.'**
  String get moduleModelTag;

  /// No description provided for @moduleNeedMoreData.
  ///
  /// In en, this message translates to:
  /// **'A few more entries and this appears.'**
  String get moduleNeedMoreData;

  /// No description provided for @moduleSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get moduleSourceLabel;

  /// No description provided for @bodyLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Body Load'**
  String get bodyLoadTitle;

  /// No description provided for @bodyLoadSinceLast.
  ///
  /// In en, this message translates to:
  /// **'{time} since your last cigarette'**
  String bodyLoadSinceLast(String time);

  /// No description provided for @bodyLoadNicotineNow.
  ///
  /// In en, this message translates to:
  /// **'Estimated nicotine load is at {percent}% of its peak.'**
  String bodyLoadNicotineNow(int percent);

  /// No description provided for @bodyLoadCoDrop.
  ///
  /// In en, this message translates to:
  /// **'Oxygen debt down {percent}%.'**
  String bodyLoadCoDrop(int percent);

  /// No description provided for @loadNicotineAcute.
  ///
  /// In en, this message translates to:
  /// **'Nicotine now'**
  String get loadNicotineAcute;

  /// No description provided for @loadNicotineBaseline.
  ///
  /// In en, this message translates to:
  /// **'All-day baseline'**
  String get loadNicotineBaseline;

  /// No description provided for @loadCarbonMonoxide.
  ///
  /// In en, this message translates to:
  /// **'Oxygen debt'**
  String get loadCarbonMonoxide;

  /// No description provided for @loadTar.
  ///
  /// In en, this message translates to:
  /// **'Particle load'**
  String get loadTar;

  /// No description provided for @loadBandLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get loadBandLow;

  /// No description provided for @loadBandMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get loadBandMedium;

  /// No description provided for @loadBandHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get loadBandHigh;

  /// No description provided for @bodyLoadTarNote.
  ///
  /// In en, this message translates to:
  /// **'Tar cannot be measured in a body. This compares your exposure with your own baseline.'**
  String get bodyLoadTarNote;

  /// No description provided for @bodyLoadCoNote.
  ///
  /// In en, this message translates to:
  /// **'Carbon monoxide clears fastest — it is the first thing that changes when you stop.'**
  String get bodyLoadCoNote;

  /// No description provided for @bodyLoadEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log a few cigarettes and your own rhythm appears here.'**
  String get bodyLoadEmpty;

  /// No description provided for @ghostPeakLabel.
  ///
  /// In en, this message translates to:
  /// **'A peak that never happened'**
  String get ghostPeakLabel;

  /// No description provided for @metabolismTitle.
  ///
  /// In en, this message translates to:
  /// **'Clearance pace'**
  String get metabolismTitle;

  /// No description provided for @metabolismNote.
  ///
  /// In en, this message translates to:
  /// **'Nicotine clears at different speeds in different people. Pick what matches how you feel — this only calibrates the curve, it measures nothing.'**
  String get metabolismNote;

  /// No description provided for @metabolismSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get metabolismSlow;

  /// No description provided for @metabolismNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get metabolismNormal;

  /// No description provided for @metabolismFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get metabolismFast;

  /// No description provided for @cravingWindowTitle.
  ///
  /// In en, this message translates to:
  /// **'Craving window'**
  String get cravingWindowTitle;

  /// No description provided for @cravingRiskCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get cravingRiskCalm;

  /// No description provided for @cravingRiskWatch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get cravingRiskWatch;

  /// No description provided for @cravingRiskHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get cravingRiskHigh;

  /// No description provided for @cravingFallingNote.
  ///
  /// In en, this message translates to:
  /// **'Craving usually arrives when nicotine is falling, not when it rises.'**
  String get cravingFallingNote;

  /// No description provided for @cravingLowestThird.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of your cravings arrived while your load was in its lowest third.'**
  String cravingLowestThird(int percent);

  /// No description provided for @cravingRiskyHours.
  ///
  /// In en, this message translates to:
  /// **'Your risky hours'**
  String get cravingRiskyHours;

  /// No description provided for @cravingWindowRange.
  ///
  /// In en, this message translates to:
  /// **'{start}:00–{end}:00'**
  String cravingWindowRange(int start, int end);

  /// No description provided for @cravingHeatmapTitle.
  ///
  /// In en, this message translates to:
  /// **'Your week, hour by hour'**
  String get cravingHeatmapTitle;

  /// No description provided for @economyTitle.
  ///
  /// In en, this message translates to:
  /// **'Money and time'**
  String get economyTitle;

  /// No description provided for @economySaved.
  ///
  /// In en, this message translates to:
  /// **'Money saved'**
  String get economySaved;

  /// No description provided for @economySpent.
  ///
  /// In en, this message translates to:
  /// **'Still spent'**
  String get economySpent;

  /// No description provided for @economyExactNote.
  ///
  /// In en, this message translates to:
  /// **'Nothing here is an estimate — it is your own numbers.'**
  String get economyExactNote;

  /// No description provided for @economyProjectionTitle.
  ///
  /// In en, this message translates to:
  /// **'If you keep this pace vs. if you finish your plan'**
  String get economyProjectionTitle;

  /// No description provided for @economyShadedArea.
  ///
  /// In en, this message translates to:
  /// **'This shaded area is your decision.'**
  String get economyShadedArea;

  /// No description provided for @economyKeepPace.
  ///
  /// In en, this message translates to:
  /// **'This pace'**
  String get economyKeepPace;

  /// No description provided for @economyFinishPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan finished'**
  String get economyFinishPlan;

  /// No description provided for @economyTimeLedger.
  ///
  /// In en, this message translates to:
  /// **'Time ledger'**
  String get economyTimeLedger;

  /// No description provided for @economyTimeRegained.
  ///
  /// In en, this message translates to:
  /// **'Time regained'**
  String get economyTimeRegained;

  /// No description provided for @economyTimeLost.
  ///
  /// In en, this message translates to:
  /// **'Time spent'**
  String get economyTimeLost;

  /// No description provided for @economyLifeAverageNote.
  ///
  /// In en, this message translates to:
  /// **'Population average of about 20 minutes per cigarette — an average, never a promise about you.'**
  String get economyLifeAverageNote;

  /// No description provided for @economyGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Your goal'**
  String get economyGoalTitle;

  /// No description provided for @economyGoalHint.
  ///
  /// In en, this message translates to:
  /// **'What are you saving for?'**
  String get economyGoalHint;

  /// No description provided for @economyGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal name'**
  String get economyGoalLabel;

  /// No description provided for @economyGoalAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get economyGoalAmount;

  /// No description provided for @economyGoalRemaining.
  ///
  /// In en, this message translates to:
  /// **'{days} days to go at this pace'**
  String economyGoalRemaining(int days);

  /// No description provided for @mindTitle.
  ///
  /// In en, this message translates to:
  /// **'Mind state'**
  String get mindTitle;

  /// No description provided for @mindPressureLabel.
  ///
  /// In en, this message translates to:
  /// **'Likely withdrawal pressure'**
  String get mindPressureLabel;

  /// No description provided for @mindBandCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get mindBandCalm;

  /// No description provided for @mindBandUnderPressure.
  ///
  /// In en, this message translates to:
  /// **'Under pressure'**
  String get mindBandUnderPressure;

  /// No description provided for @mindBandTough.
  ///
  /// In en, this message translates to:
  /// **'Tough'**
  String get mindBandTough;

  /// No description provided for @mindOnlyYouKnow.
  ///
  /// In en, this message translates to:
  /// **'This is a guess. Only you know how you feel.'**
  String get mindOnlyYouKnow;

  /// No description provided for @mindHowDoYouFeel.
  ///
  /// In en, this message translates to:
  /// **'How do you feel right now?'**
  String get mindHowDoYouFeel;

  /// No description provided for @mindAccuracy.
  ///
  /// In en, this message translates to:
  /// **'My guess matched how you felt {percent}% of the time.'**
  String mindAccuracy(int percent);

  /// No description provided for @mindQuitLowersAnxiety.
  ///
  /// In en, this message translates to:
  /// **'Quitting lowers anxiety and depression on average — it does not raise them.'**
  String get mindQuitLowersAnxiety;

  /// No description provided for @mindTypicalCurve.
  ///
  /// In en, this message translates to:
  /// **'Typical course'**
  String get mindTypicalCurve;

  /// No description provided for @mindPeakNote.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal peaks on days 1–3 and eases over 3–4 weeks.'**
  String get mindPeakNote;

  /// No description provided for @mindWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'About weight'**
  String get mindWeightTitle;

  /// No description provided for @mindWeightBody.
  ///
  /// In en, this message translates to:
  /// **'Appetite rises after quitting and most weight change happens in the first three months — on average around 4–5 kg in a year. That risk is small next to smoking, and regular meals blunt it.'**
  String get mindWeightBody;

  /// No description provided for @lungsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your lungs today'**
  String get lungsTitle;

  /// No description provided for @lungsNotAScan.
  ///
  /// In en, this message translates to:
  /// **'This is not a scan of your lungs.'**
  String get lungsNotAScan;

  /// No description provided for @lungsSlowsLine.
  ///
  /// In en, this message translates to:
  /// **'Quitting is the only thing that slows this line.'**
  String get lungsSlowsLine;

  /// No description provided for @lungsScenarioNever.
  ///
  /// In en, this message translates to:
  /// **'Never smoked'**
  String get lungsScenarioNever;

  /// No description provided for @lungsScenarioKeep.
  ///
  /// In en, this message translates to:
  /// **'This pace'**
  String get lungsScenarioKeep;

  /// No description provided for @lungsScenarioQuit.
  ///
  /// In en, this message translates to:
  /// **'Quit today'**
  String get lungsScenarioQuit;

  /// No description provided for @lungsTypicalLabel.
  ///
  /// In en, this message translates to:
  /// **'Typical for your age group'**
  String get lungsTypicalLabel;

  /// No description provided for @lungsAxisAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get lungsAxisAge;

  /// No description provided for @lungsMistLabel.
  ///
  /// In en, this message translates to:
  /// **'Relative particle load'**
  String get lungsMistLabel;

  /// No description provided for @organMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Body map'**
  String get organMapTitle;

  /// No description provided for @organHarmTitle.
  ///
  /// In en, this message translates to:
  /// **'What smoking does'**
  String get organHarmTitle;

  /// No description provided for @organRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'What happens when you stop'**
  String get organRecoveryTitle;

  /// No description provided for @organPopulationNote.
  ///
  /// In en, this message translates to:
  /// **'Population-level findings. Not a personal risk estimate.'**
  String get organPopulationNote;

  /// No description provided for @toxicantsTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s in the smoke'**
  String get toxicantsTitle;

  /// No description provided for @toxicantsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{chemicals} chemicals, more than {carcinogens} of them known carcinogens'**
  String toxicantsSubtitle(int chemicals, int carcinogens);

  /// No description provided for @toxicantAnalogyLabel.
  ///
  /// In en, this message translates to:
  /// **'Also found in'**
  String get toxicantAnalogyLabel;

  /// No description provided for @toxicantMechanismLabel.
  ///
  /// In en, this message translates to:
  /// **'In the body'**
  String get toxicantMechanismLabel;

  /// No description provided for @toxicantNoDose.
  ///
  /// In en, this message translates to:
  /// **'A recognition aid, not a dose comparison.'**
  String get toxicantNoDose;

  /// No description provided for @toxicantIarcLabel.
  ///
  /// In en, this message translates to:
  /// **'IARC group {group}'**
  String toxicantIarcLabel(String group);

  /// No description provided for @evidenceStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong evidence'**
  String get evidenceStrong;

  /// No description provided for @evidencePromising.
  ///
  /// In en, this message translates to:
  /// **'Promising'**
  String get evidencePromising;

  /// No description provided for @evidenceTraditional.
  ///
  /// In en, this message translates to:
  /// **'Traditional'**
  String get evidenceTraditional;

  /// No description provided for @evidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get evidenceLabel;

  /// No description provided for @sosWhatWorked.
  ///
  /// In en, this message translates to:
  /// **'What worked for you before'**
  String get sosWhatWorked;

  /// No description provided for @sosTechniquesTitle.
  ///
  /// In en, this message translates to:
  /// **'Something to do right now'**
  String get sosTechniquesTitle;

  /// No description provided for @sosEarPointsTitle.
  ///
  /// In en, this message translates to:
  /// **'Five points, twelve seconds each'**
  String get sosEarPointsTitle;

  /// No description provided for @sosEarPointShenMen.
  ///
  /// In en, this message translates to:
  /// **'Shen Men'**
  String get sosEarPointShenMen;

  /// No description provided for @sosEarPointAutonomic.
  ///
  /// In en, this message translates to:
  /// **'Autonomic'**
  String get sosEarPointAutonomic;

  /// No description provided for @sosEarPointKidney.
  ///
  /// In en, this message translates to:
  /// **'Kidney'**
  String get sosEarPointKidney;

  /// No description provided for @sosEarPointLiver.
  ///
  /// In en, this message translates to:
  /// **'Liver'**
  String get sosEarPointLiver;

  /// No description provided for @sosEarPointLung.
  ///
  /// In en, this message translates to:
  /// **'Lung'**
  String get sosEarPointLung;

  /// No description provided for @sosNoNeedles.
  ///
  /// In en, this message translates to:
  /// **'Fingers only — never needles.'**
  String get sosNoNeedles;

  /// No description provided for @progressScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress Score'**
  String get progressScoreTitle;

  /// No description provided for @progressWindowLabel.
  ///
  /// In en, this message translates to:
  /// **'last 14 days'**
  String get progressWindowLabel;

  /// No description provided for @progressBandStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting'**
  String get progressBandStarting;

  /// No description provided for @progressBandOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get progressBandOnTrack;

  /// No description provided for @progressBandStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get progressBandStrong;

  /// No description provided for @progressBandVeryStrong.
  ///
  /// In en, this message translates to:
  /// **'Very strong'**
  String get progressBandVeryStrong;

  /// No description provided for @progressBehaviourNote.
  ///
  /// In en, this message translates to:
  /// **'This measures your behaviour, not your health.'**
  String get progressBehaviourNote;

  /// No description provided for @progressDeltaUp.
  ///
  /// In en, this message translates to:
  /// **'up {points} points in 7 days'**
  String progressDeltaUp(int points);

  /// No description provided for @progressDeltaDown.
  ///
  /// In en, this message translates to:
  /// **'down {points} points in 7 days'**
  String progressDeltaDown(int points);

  /// No description provided for @progressDeltaFlat.
  ///
  /// In en, this message translates to:
  /// **'steady this week'**
  String get progressDeltaFlat;

  /// No description provided for @harmLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Harm Load'**
  String get harmLoadTitle;

  /// No description provided for @harmBandLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get harmBandLight;

  /// No description provided for @harmBandModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get harmBandModerate;

  /// No description provided for @harmBandHeavy.
  ///
  /// In en, this message translates to:
  /// **'Heavy'**
  String get harmBandHeavy;

  /// No description provided for @harmBandVeryHeavy.
  ///
  /// In en, this message translates to:
  /// **'Very heavy'**
  String get harmBandVeryHeavy;

  /// No description provided for @harmNotRisk.
  ///
  /// In en, this message translates to:
  /// **'This is not a disease risk estimate.'**
  String get harmNotRisk;

  /// No description provided for @harmPackYears.
  ///
  /// In en, this message translates to:
  /// **'{value} pack-years'**
  String harmPackYears(String value);

  /// No description provided for @harmMovingPartNote.
  ///
  /// In en, this message translates to:
  /// **'Almost half of this falls as you cut down. The rest is history — quitting slows it and, over years, eases it.'**
  String get harmMovingPartNote;

  /// No description provided for @indicesScissorTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress and load'**
  String get indicesScissorTitle;

  /// No description provided for @indicesScissorNote.
  ///
  /// In en, this message translates to:
  /// **'The wider the gap, the better you are doing.'**
  String get indicesScissorNote;

  /// No description provided for @indicesBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'What makes up this number'**
  String get indicesBreakdownTitle;

  /// No description provided for @componentAdherence.
  ///
  /// In en, this message translates to:
  /// **'Plan adherence'**
  String get componentAdherence;

  /// No description provided for @componentConsumptionTrend.
  ///
  /// In en, this message translates to:
  /// **'Consumption trend'**
  String get componentConsumptionTrend;

  /// No description provided for @componentCravingCoping.
  ///
  /// In en, this message translates to:
  /// **'Craving coping'**
  String get componentCravingCoping;

  /// No description provided for @componentLoggingConsistency.
  ///
  /// In en, this message translates to:
  /// **'Logging consistency'**
  String get componentLoggingConsistency;

  /// No description provided for @componentNicotineBaselineFall.
  ///
  /// In en, this message translates to:
  /// **'Nicotine baseline fall'**
  String get componentNicotineBaselineFall;

  /// No description provided for @componentCumulativeExposure.
  ///
  /// In en, this message translates to:
  /// **'Cumulative exposure'**
  String get componentCumulativeExposure;

  /// No description provided for @componentCurrentIntensity.
  ///
  /// In en, this message translates to:
  /// **'Current intensity'**
  String get componentCurrentIntensity;

  /// No description provided for @componentDependenceDepth.
  ///
  /// In en, this message translates to:
  /// **'Dependence depth'**
  String get componentDependenceDepth;

  /// No description provided for @componentAgeAndDuration.
  ///
  /// In en, this message translates to:
  /// **'Age and duration'**
  String get componentAgeAndDuration;

  /// No description provided for @componentBodySize.
  ///
  /// In en, this message translates to:
  /// **'Body size (optional)'**
  String get componentBodySize;

  /// No description provided for @componentWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'{points} of {weight} points'**
  String componentWeightLabel(String points, int weight);

  /// No description provided for @planKindGradual.
  ///
  /// In en, this message translates to:
  /// **'Gradual taper'**
  String get planKindGradual;

  /// No description provided for @planKindGradualNote.
  ///
  /// In en, this message translates to:
  /// **'Widen the gap between cigarettes, step by step.'**
  String get planKindGradualNote;

  /// No description provided for @planKindQuota.
  ///
  /// In en, this message translates to:
  /// **'Daily quota'**
  String get planKindQuota;

  /// No description provided for @planKindQuotaNote.
  ///
  /// In en, this message translates to:
  /// **'A daily ceiling, no clock rules — for irregular days.'**
  String get planKindQuotaNote;

  /// No description provided for @planKindQuitDay.
  ///
  /// In en, this message translates to:
  /// **'Quit day'**
  String get planKindQuitDay;

  /// No description provided for @planKindQuitDayNote.
  ///
  /// In en, this message translates to:
  /// **'Pick a date and get withdrawal support around it.'**
  String get planKindQuitDayNote;

  /// No description provided for @planKindTrackOnly.
  ///
  /// In en, this message translates to:
  /// **'Track only'**
  String get planKindTrackOnly;

  /// No description provided for @planKindTrackOnlyNote.
  ///
  /// In en, this message translates to:
  /// **'No target, no judgement. Just your records.'**
  String get planKindTrackOnlyNote;

  /// No description provided for @planSwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'Change plan'**
  String get planSwitchTitle;

  /// No description provided for @planTooSoon.
  ///
  /// In en, this message translates to:
  /// **'Give this plan {days} more days — every plan needs a little time.'**
  String planTooSoon(int days);

  /// No description provided for @planReportCardTitle.
  ///
  /// In en, this message translates to:
  /// **'How this plan is going'**
  String get planReportCardTitle;

  /// No description provided for @planReportDays.
  ///
  /// In en, this message translates to:
  /// **'Days in this plan'**
  String get planReportDays;

  /// No description provided for @planReportAdherence.
  ///
  /// In en, this message translates to:
  /// **'Adherence'**
  String get planReportAdherence;

  /// No description provided for @planReportHardestHour.
  ///
  /// In en, this message translates to:
  /// **'Hardest hour'**
  String get planReportHardestHour;

  /// No description provided for @planReportResisted.
  ///
  /// In en, this message translates to:
  /// **'Cravings ridden out'**
  String get planReportResisted;

  /// No description provided for @planSuggestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Suggested for you'**
  String get planSuggestionLabel;

  /// No description provided for @planFrequentSwitchNote.
  ///
  /// In en, this message translates to:
  /// **'Changing plans is not failure — but every plan needs a few weeks to show itself.'**
  String get planFrequentSwitchNote;

  /// No description provided for @planHistoryKept.
  ///
  /// In en, this message translates to:
  /// **'Your history stays. Only the plan changes.'**
  String get planHistoryKept;

  /// No description provided for @planStripLabel.
  ///
  /// In en, this message translates to:
  /// **'{plan} · week {week}'**
  String planStripLabel(String plan, int week);

  /// No description provided for @taperHoldStep.
  ///
  /// In en, this message translates to:
  /// **'Holding this step one more day.'**
  String get taperHoldStep;

  /// No description provided for @taperAdvance.
  ///
  /// In en, this message translates to:
  /// **'New target gap: {minutes} minutes.'**
  String taperAdvance(int minutes);

  /// No description provided for @taperSoftLanding.
  ///
  /// In en, this message translates to:
  /// **'Your plan was re-tuned to you. Nothing is lost.'**
  String get taperSoftLanding;

  /// No description provided for @logSmokedNeutral.
  ///
  /// In en, this message translates to:
  /// **'Today: {count}. Your average: {average}.'**
  String logSmokedNeutral(int count, String average);

  /// No description provided for @logNotAFailure.
  ///
  /// In en, this message translates to:
  /// **'Not a failure. A data point.'**
  String get logNotAFailure;

  /// No description provided for @logSkippedTitle.
  ///
  /// In en, this message translates to:
  /// **'A peak that never happened'**
  String get logSkippedTitle;

  /// No description provided for @logSkippedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} rides out this month'**
  String logSkippedCount(int count);

  /// No description provided for @logNextTarget.
  ///
  /// In en, this message translates to:
  /// **'Next target time {time}'**
  String logNextTarget(String time);

  /// No description provided for @logUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get logUndo;

  /// No description provided for @logPauseTitle.
  ///
  /// In en, this message translates to:
  /// **'Twenty seconds first'**
  String get logPauseTitle;

  /// No description provided for @logPauseNote.
  ///
  /// In en, this message translates to:
  /// **'Your entry is already saved. Take a breath — you can undo it if you change your mind.'**
  String get logPauseNote;

  /// No description provided for @logPauseSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pause before logging'**
  String get logPauseSettingTitle;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s support'**
  String get supportTitle;

  /// No description provided for @supportChannelMovement.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get supportChannelMovement;

  /// No description provided for @supportChannelNutrition.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get supportChannelNutrition;

  /// No description provided for @supportChannelRitual.
  ///
  /// In en, this message translates to:
  /// **'Ritual'**
  String get supportChannelRitual;

  /// No description provided for @supportMarkDone.
  ///
  /// In en, this message translates to:
  /// **'I did it'**
  String get supportMarkDone;

  /// No description provided for @supportNotATest.
  ///
  /// In en, this message translates to:
  /// **'This is not a test. Skipping costs nothing.'**
  String get supportNotATest;

  /// No description provided for @supportWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get supportWeekTitle;

  /// No description provided for @supportMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String supportMinutes(int minutes);

  /// No description provided for @howBodyLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Body load curves'**
  String get howBodyLoadTitle;

  /// No description provided for @howBodyLoadBody.
  ///
  /// In en, this message translates to:
  /// **'Each curve is C(t) = sum of dose x 2^(-elapsed / half-life), fed only by the times you logged. Half-lives: nicotine 2 h, all-day baseline 16 h (cotinine proxy), carbon monoxide 4.5 h, particle load 30 days (representative).'**
  String get howBodyLoadBody;

  /// No description provided for @howBodyLoadLimits.
  ///
  /// In en, this message translates to:
  /// **'No phone can measure nicotine, tar or carbon monoxide in a body. Values are shown normalized to 0–100 against your own peak, never in ng/mL or milligrams, and clearance speed varies between people.'**
  String get howBodyLoadLimits;

  /// No description provided for @howCravingTitle.
  ///
  /// In en, this message translates to:
  /// **'Craving window'**
  String get howCravingTitle;

  /// No description provided for @howCravingBody.
  ///
  /// In en, this message translates to:
  /// **'Risk = 0.45 x how deep your nicotine trough is, + 0.35 x how busy this hour is in your own history, + 0.20 x how often records in this hour carry a trigger. Hour-based signals stay switched off until you have about 21 entries.'**
  String get howCravingBody;

  /// No description provided for @howProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress Score'**
  String get howProgressTitle;

  /// No description provided for @howProgressBody.
  ///
  /// In en, this message translates to:
  /// **'Out of 100: plan adherence 35, consumption trend 30, craving coping 20, logging consistency 10, nicotine baseline fall 5. It looks at 14 days, moves at most 4 points a day, and never resets.'**
  String get howProgressBody;

  /// No description provided for @howHarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Harm Load'**
  String get howHarmTitle;

  /// No description provided for @howHarmBody.
  ///
  /// In en, this message translates to:
  /// **'Out of 100: cumulative exposure 40 (pack-years, log scale), current intensity 30, dependence 15, age and duration 10, body size 5. Validated risk models told us which variables matter; the number is a load index, not a disease risk. Body data is optional and the weights renormalize without it.'**
  String get howHarmBody;

  /// No description provided for @howMindTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal pressure'**
  String get howMindTitle;

  /// No description provided for @howMindBody.
  ///
  /// In en, this message translates to:
  /// **'A published symptom curve that peaks on days 1–3 and eases over 3–4 weeks, scaled by how deep your current nicotine trough is, then corrected by the difference between our guesses and what you actually reported. The output is a band, never a percentage.'**
  String get howMindBody;

  /// No description provided for @howLungTitle.
  ///
  /// In en, this message translates to:
  /// **'Lung scenarios'**
  String get howLungTitle;

  /// No description provided for @howLungBody.
  ///
  /// In en, this message translates to:
  /// **'Published annual FEV1 decline rates drawn as three typical curves: never-smoker about 30 mL/year, sustained quitter about 33, current smoker 40 up to 70 at heavier intake. These are population averages for your age group, not a measurement of your lungs.'**
  String get howLungBody;

  /// No description provided for @settingsBodyDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Body data (optional)'**
  String get settingsBodyDataTitle;

  /// No description provided for @settingsBodyDataNote.
  ///
  /// In en, this message translates to:
  /// **'Only used to sharpen the Harm Load. Leave it empty and nothing is locked — the index simply reweighs what it has.'**
  String get settingsBodyDataNote;

  /// No description provided for @settingsHeight.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get settingsHeight;

  /// No description provided for @settingsWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get settingsWeight;

  /// No description provided for @settingsSmokingYears.
  ///
  /// In en, this message translates to:
  /// **'Years smoking'**
  String get settingsSmokingYears;

  /// No description provided for @settingsSex.
  ///
  /// In en, this message translates to:
  /// **'Sex (for the time ledger)'**
  String get settingsSex;

  /// No description provided for @sexUnspecified.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get sexUnspecified;

  /// No description provided for @sexMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get sexMale;

  /// No description provided for @sexFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get sexFemale;

  /// No description provided for @settingsModelTitle.
  ///
  /// In en, this message translates to:
  /// **'Model settings'**
  String get settingsModelTitle;

  /// No description provided for @settingsPrelogPauseNote.
  ///
  /// In en, this message translates to:
  /// **'Your entry is saved either way; the pause only gives you a moment and an undo.'**
  String get settingsPrelogPauseNote;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
