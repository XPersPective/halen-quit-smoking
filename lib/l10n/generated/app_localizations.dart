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

  /// No description provided for @quitlineRegion.
  ///
  /// In en, this message translates to:
  /// **'Country/region for support'**
  String get quitlineRegion;

  /// No description provided for @quitlineHint.
  ///
  /// In en, this message translates to:
  /// **'Services are for the selected region, not emergencies. If your region is missing, ask a local health professional.'**
  String get quitlineHint;

  /// No description provided for @quitlineOther.
  ///
  /// In en, this message translates to:
  /// **'Other region'**
  String get quitlineOther;

  /// No description provided for @quitlineUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not open the phone. Number:'**
  String get quitlineUnavailable;

  /// No description provided for @quitlineCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy number'**
  String get quitlineCopy;

  /// No description provided for @quitlineTR.
  ///
  /// In en, this message translates to:
  /// **'Türkiye'**
  String get quitlineTR;

  /// No description provided for @quitlineUS.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get quitlineUS;

  /// No description provided for @quitlineDE.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get quitlineDE;

  /// No description provided for @quitlineEngland.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom — England'**
  String get quitlineEngland;

  /// No description provided for @quitlineScotland.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom — Scotland'**
  String get quitlineScotland;

  /// No description provided for @quitlineWales.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom — Wales'**
  String get quitlineWales;

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
  /// **'Step {n} of {total}'**
  String obStepOf(int n, int total);

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
  /// **'I smoked one'**
  String get ctaSmoked;

  /// No description provided for @ctaResisted.
  ///
  /// In en, this message translates to:
  /// **'I resisted it'**
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

  /// No description provided for @paywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scientific freedom for less than the cost of a single pack'**
  String get paywallSubtitle;

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
  /// **'The complete SOS toolkit, acupressure and nutrition guide'**
  String get paywallFeatureSos;

  /// No description provided for @paywallFeatureWidget.
  ///
  /// In en, this message translates to:
  /// **'Widget customisation'**
  String get paywallFeatureWidget;

  /// No description provided for @paywallFeaturePrivacy.
  ///
  /// In en, this message translates to:
  /// **'100% on-device privacy: no account, no server, fully encrypted vault'**
  String get paywallFeaturePrivacy;

  /// No description provided for @paywallTrialNote.
  ///
  /// In en, this message translates to:
  /// **'Your 7-day free trial starts on first launch — no card needed.'**
  String get paywallTrialNote;

  /// No description provided for @planTierAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual Plan'**
  String get planTierAnnual;

  /// No description provided for @planTierAnnualBadge.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE · SAVE 50%'**
  String get planTierAnnualBadge;

  /// No description provided for @planTierAnnualSub.
  ///
  /// In en, this message translates to:
  /// **'7-day free trial, then {price}/year'**
  String planTierAnnualSub(String price);

  /// No description provided for @planTierMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly Plan'**
  String get planTierMonthly;

  /// No description provided for @planTierMonthlySub.
  ///
  /// In en, this message translates to:
  /// **'Flexible monthly subscription, cancel anytime'**
  String get planTierMonthlySub;

  /// No description provided for @planTierLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime Access'**
  String get planTierLifetime;

  /// No description provided for @planTierLifetimeBadge.
  ///
  /// In en, this message translates to:
  /// **'ONE-TIME'**
  String get planTierLifetimeBadge;

  /// No description provided for @planTierLifetimeSub.
  ///
  /// In en, this message translates to:
  /// **'One-time payment, unlimited lifetime access'**
  String get planTierLifetimeSub;

  /// No description provided for @paywallTimelineToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get paywallTimelineToday;

  /// No description provided for @paywallTimelineTodayDesc.
  ///
  /// In en, this message translates to:
  /// **'7-day full access trial begins, \$0 charged.'**
  String get paywallTimelineTodayDesc;

  /// No description provided for @paywallTimelineReminder.
  ///
  /// In en, this message translates to:
  /// **'Day 5'**
  String get paywallTimelineReminder;

  /// No description provided for @paywallTimelineReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Gentle reminder before your trial ends.'**
  String get paywallTimelineReminderDesc;

  /// No description provided for @paywallTimelineBilling.
  ///
  /// In en, this message translates to:
  /// **'Day 7'**
  String get paywallTimelineBilling;

  /// No description provided for @paywallTimelineBillingDesc.
  ///
  /// In en, this message translates to:
  /// **'Subscription begins, cancel anytime prior.'**
  String get paywallTimelineBillingDesc;

  /// No description provided for @paywallCtaTrial.
  ///
  /// In en, this message translates to:
  /// **'Start 7-Day Free Trial'**
  String get paywallCtaTrial;

  /// No description provided for @paywallCtaSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get paywallCtaSubscribe;

  /// No description provided for @paywallCtaLifetime.
  ///
  /// In en, this message translates to:
  /// **'Get Lifetime Access'**
  String get paywallCtaLifetime;

  /// No description provided for @paywallTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use (EULA)'**
  String get paywallTerms;

  /// No description provided for @paywallPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get paywallPrivacy;

  /// No description provided for @paywallLegalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period. Manage in your App Store / Google Play account settings.'**
  String get paywallLegalDisclaimer;

  /// No description provided for @paywallRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored successfully.'**
  String get paywallRestoreSuccess;

  /// No description provided for @paywallRestoreNone.
  ///
  /// In en, this message translates to:
  /// **'No active purchases found to restore.'**
  String get paywallRestoreNone;

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
  /// **'Carbon monoxide in your blood is {percent}% below its peak.'**
  String bodyLoadCoDrop(int percent);

  /// No description provided for @loadNicotineAcute.
  ///
  /// In en, this message translates to:
  /// **'Nicotine now'**
  String get loadNicotineAcute;

  /// No description provided for @loadNicotineBaseline.
  ///
  /// In en, this message translates to:
  /// **'Nicotine built up in your body'**
  String get loadNicotineBaseline;

  /// No description provided for @loadCarbonMonoxide.
  ///
  /// In en, this message translates to:
  /// **'Carbon monoxide in your blood'**
  String get loadCarbonMonoxide;

  /// No description provided for @loadTar.
  ///
  /// In en, this message translates to:
  /// **'Tar build-up'**
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
  /// **'Tar build-up, compared with your usual'**
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

  /// No description provided for @organTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery timeline'**
  String get organTimelineTitle;

  /// No description provided for @organTimelineCaption.
  ///
  /// In en, this message translates to:
  /// **'Time since your last cigarette — population data, not a personal measurement'**
  String get organTimelineCaption;

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
  /// **'Fall in built-up nicotine'**
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
  /// **'Each curve is C(t) = sum of dose x 2^(-time since / half-life), fed only by the times you logged. Half-lives: nicotine 2 h, nicotine built up in your body 16 h (the cotinine it turns into), carbon monoxide 4.5 h, tar build-up 30 days (representative).'**
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

  /// No description provided for @dailyCardKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Good to know'**
  String get dailyCardKnowledge;

  /// No description provided for @dailyCardReality.
  ///
  /// In en, this message translates to:
  /// **'The hard part'**
  String get dailyCardReality;

  /// No description provided for @dailyCardGain.
  ///
  /// In en, this message translates to:
  /// **'What you gain'**
  String get dailyCardGain;

  /// No description provided for @dailyCardMotivation.
  ///
  /// In en, this message translates to:
  /// **'For today'**
  String get dailyCardMotivation;

  /// No description provided for @dailyCardAction.
  ///
  /// In en, this message translates to:
  /// **'What you can do'**
  String get dailyCardAction;

  /// No description provided for @dailyCardReadMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String dailyCardReadMinutes(int minutes);

  /// No description provided for @sourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Scientific sources'**
  String get sourcesTitle;

  /// No description provided for @sourcesIntro.
  ///
  /// In en, this message translates to:
  /// **'Every claim in this app comes from one of these. Tap to open the original.'**
  String get sourcesIntro;

  /// No description provided for @economyEquivalentTitle.
  ///
  /// In en, this message translates to:
  /// **'That is about'**
  String get economyEquivalentTitle;

  /// No description provided for @equivalentGroceries.
  ///
  /// In en, this message translates to:
  /// **'a month of groceries'**
  String get equivalentGroceries;

  /// No description provided for @equivalentFuelTank.
  ///
  /// In en, this message translates to:
  /// **'a full tank of fuel'**
  String get equivalentFuelTank;

  /// No description provided for @equivalentGymMonth.
  ///
  /// In en, this message translates to:
  /// **'a month at the gym'**
  String get equivalentGymMonth;

  /// No description provided for @equivalentFlightTicket.
  ///
  /// In en, this message translates to:
  /// **'a short-haul flight'**
  String get equivalentFlightTicket;

  /// No description provided for @equivalentPhone.
  ///
  /// In en, this message translates to:
  /// **'a new phone'**
  String get equivalentPhone;

  /// No description provided for @economyEquivalentCount.
  ///
  /// In en, this message translates to:
  /// **'{count}x {item}'**
  String economyEquivalentCount(int count, String item);

  /// No description provided for @cravingWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'What helps here'**
  String get cravingWhatToDo;

  /// No description provided for @cravingSuggestionAt.
  ///
  /// In en, this message translates to:
  /// **'Around {time} you usually reach for one. When it comes, try: {technique}'**
  String cravingSuggestionAt(String time, String technique);

  /// No description provided for @cravingOpenToolkit.
  ///
  /// In en, this message translates to:
  /// **'Open the toolkit'**
  String get cravingOpenToolkit;

  /// No description provided for @earGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Ear acupressure'**
  String get earGuideTitle;

  /// No description provided for @earGuideStart.
  ///
  /// In en, this message translates to:
  /// **'Start the 60 seconds'**
  String get earGuideStart;

  /// No description provided for @earGuideStep.
  ///
  /// In en, this message translates to:
  /// **'{point} · {seconds} s'**
  String earGuideStep(String point, int seconds);

  /// No description provided for @earGuideFinished.
  ///
  /// In en, this message translates to:
  /// **'That is the full round.'**
  String get earGuideFinished;

  /// No description provided for @toxicantsToday.
  ///
  /// In en, this message translates to:
  /// **'{count} logged today'**
  String toxicantsToday(int count);

  /// No description provided for @loadBandTitle.
  ///
  /// In en, this message translates to:
  /// **'Your load, day by day'**
  String get loadBandTitle;

  /// No description provided for @loadBandWeek.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get loadBandWeek;

  /// No description provided for @loadBandMonth.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get loadBandMonth;

  /// No description provided for @loadBandTrendDown.
  ///
  /// In en, this message translates to:
  /// **'down {percent}% on last week'**
  String loadBandTrendDown(int percent);

  /// No description provided for @loadBandTrendUp.
  ///
  /// In en, this message translates to:
  /// **'up {percent}% on last week'**
  String loadBandTrendUp(int percent);

  /// No description provided for @loadBandTrendFlat.
  ///
  /// In en, this message translates to:
  /// **'level with last week'**
  String get loadBandTrendFlat;

  /// No description provided for @mindAccuracyChartTitle.
  ///
  /// In en, this message translates to:
  /// **'What I guessed vs what you felt'**
  String get mindAccuracyChartTitle;

  /// No description provided for @lungsGapAt.
  ///
  /// In en, this message translates to:
  /// **'By {age}, about {points} points of lung function apart.'**
  String lungsGapAt(int age, String points);

  /// No description provided for @supportWeekNote.
  ///
  /// In en, this message translates to:
  /// **'The point is the pattern, not a full grid.'**
  String get supportWeekNote;

  /// No description provided for @taperEasiestFirst.
  ///
  /// In en, this message translates to:
  /// **'We widen your easiest hours first and leave the hardest ones for last.'**
  String get taperEasiestFirst;

  /// No description provided for @planQuotaToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s ceiling: {count}'**
  String planQuotaToday(int count);

  /// No description provided for @motivationSaved.
  ///
  /// In en, this message translates to:
  /// **'You have kept {amount} that would have gone up in smoke.'**
  String motivationSaved(String amount);

  /// No description provided for @motivationRides.
  ///
  /// In en, this message translates to:
  /// **'{count} cravings ridden out this month.'**
  String motivationRides(int count);

  /// No description provided for @motivationTime.
  ///
  /// In en, this message translates to:
  /// **'{time} back, on the population average.'**
  String motivationTime(String time);

  /// No description provided for @motivationTitle.
  ///
  /// In en, this message translates to:
  /// **'For today'**
  String get motivationTitle;

  /// No description provided for @quitDayCoTitle.
  ///
  /// In en, this message translates to:
  /// **'Since you stopped'**
  String get quitDayCoTitle;

  /// No description provided for @quitDayCoBody.
  ///
  /// In en, this message translates to:
  /// **'Carbon monoxide clears fastest of everything smoke leaves behind. This is the typical curve for the hours after a last cigarette.'**
  String get quitDayCoBody;

  /// No description provided for @quitDayHoursAxis.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String quitDayHoursAxis(int hours);

  /// No description provided for @settingsRiskyWindowReminder.
  ///
  /// In en, this message translates to:
  /// **'Heads-up before your riskiest hour'**
  String get settingsRiskyWindowReminder;

  /// No description provided for @settingsRiskyWindowNote.
  ///
  /// In en, this message translates to:
  /// **'Off by default. Needs about a month of records before it knows your pattern.'**
  String get settingsRiskyWindowNote;

  /// No description provided for @notifRiskyWindowTitle.
  ///
  /// In en, this message translates to:
  /// **'Your usual hour is coming up'**
  String get notifRiskyWindowTitle;

  /// No description provided for @notifRiskyWindowBody.
  ///
  /// In en, this message translates to:
  /// **'Twenty minutes. A short walk now works better than willpower later.'**
  String get notifRiskyWindowBody;

  /// No description provided for @chartLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get chartLast30Days;

  /// No description provided for @chartToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get chartToday;

  /// No description provided for @chartDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String chartDaysAgo(int days);

  /// No description provided for @chartNotEnoughYet.
  ///
  /// In en, this message translates to:
  /// **'A few more days and this line appears.'**
  String get chartNotEnoughYet;

  /// No description provided for @indicesProgressLegend.
  ///
  /// In en, this message translates to:
  /// **'Progress — higher is better'**
  String get indicesProgressLegend;

  /// No description provided for @indicesHarmLegend.
  ///
  /// In en, this message translates to:
  /// **'Harm Load — lower is better'**
  String get indicesHarmLegend;

  /// No description provided for @indicesMeaning.
  ///
  /// In en, this message translates to:
  /// **'The green line is what you are doing. The grey line is what you are carrying. Green up and grey down is the direction that counts.'**
  String get indicesMeaning;

  /// No description provided for @indicesAxisCaption.
  ///
  /// In en, this message translates to:
  /// **'points, 0-100 — higher progress is better, lower load is better'**
  String get indicesAxisCaption;

  /// No description provided for @economyMeaning.
  ///
  /// In en, this message translates to:
  /// **'Both lines are money spent over the next year. The lower one is the plan; the shaded gap is what finishing it keeps in your pocket.'**
  String get economyMeaning;

  /// No description provided for @lungsMeaning.
  ///
  /// In en, this message translates to:
  /// **'Typical lung function for your age group under three futures. Higher is better, and the gap between the top two lines is what quitting is worth.'**
  String get lungsMeaning;

  /// No description provided for @mindMeaning.
  ///
  /// In en, this message translates to:
  /// **'What the app guessed, against what you said. Where the lines separate, the guess was wrong.'**
  String get mindMeaning;

  /// No description provided for @mindLegendGuess.
  ///
  /// In en, this message translates to:
  /// **'My guess'**
  String get mindLegendGuess;

  /// No description provided for @mindLegendFelt.
  ///
  /// In en, this message translates to:
  /// **'What you said'**
  String get mindLegendFelt;

  /// No description provided for @loadBandMeaning.
  ///
  /// In en, this message translates to:
  /// **'One bar per day: the taller the bar, the more your body carried that day. The cap is that day\'s peak.'**
  String get loadBandMeaning;

  /// No description provided for @bodyLoadMeaning.
  ///
  /// In en, this message translates to:
  /// **'Each spike is a cigarette; the fall after it is your body clearing it. Green marks are the spikes that never happened.'**
  String get bodyLoadMeaning;

  /// No description provided for @loadAxisCaption.
  ///
  /// In en, this message translates to:
  /// **'% of your own peak — a model, not a measurement'**
  String get loadAxisCaption;

  /// No description provided for @loadAxisNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get loadAxisNow;

  /// No description provided for @loadAxisHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} h ago'**
  String loadAxisHoursAgo(int hours);

  /// No description provided for @nowInBodyTitle.
  ///
  /// In en, this message translates to:
  /// **'In your body right now'**
  String get nowInBodyTitle;

  /// No description provided for @nowInBodyLast.
  ///
  /// In en, this message translates to:
  /// **'Last cigarette'**
  String get nowInBodyLast;

  /// No description provided for @nowInBodyNever.
  ///
  /// In en, this message translates to:
  /// **'none yet'**
  String get nowInBodyNever;

  /// No description provided for @nowInBodyOpen.
  ///
  /// In en, this message translates to:
  /// **'See the whole picture'**
  String get nowInBodyOpen;

  /// No description provided for @nowInBodyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log your first cigarette and your live curve starts here.'**
  String get nowInBodyEmpty;

  /// No description provided for @glossaryTitle.
  ///
  /// In en, this message translates to:
  /// **'What the words mean'**
  String get glossaryTitle;

  /// No description provided for @glossaryIntro.
  ///
  /// In en, this message translates to:
  /// **'Every term this app uses, in one line each. No jargon, no small print.'**
  String get glossaryIntro;

  /// No description provided for @glossaryOpen.
  ///
  /// In en, this message translates to:
  /// **'What do these words mean?'**
  String get glossaryOpen;

  /// No description provided for @glossaryProgress.
  ///
  /// In en, this message translates to:
  /// **'How well you are doing what you set out to do, out of 100. It looks at your last two weeks and moves slowly on purpose.'**
  String get glossaryProgress;

  /// No description provided for @glossaryHarm.
  ///
  /// In en, this message translates to:
  /// **'How much smoking your body is carrying, out of 100. Cutting down lowers about half of it; the rest is history that only time softens.'**
  String get glossaryHarm;

  /// No description provided for @glossaryBodyLoad.
  ///
  /// In en, this message translates to:
  /// **'An estimate of what is still in you from the cigarettes you logged. It is calculated, never measured.'**
  String get glossaryBodyLoad;

  /// No description provided for @glossaryCo.
  ///
  /// In en, this message translates to:
  /// **'The gas in smoke that takes the place of oxygen in your blood. It leaves fastest — usually within a day.'**
  String get glossaryCo;

  /// No description provided for @glossaryTarLoad.
  ///
  /// In en, this message translates to:
  /// **'How your particle exposure compares with your own usual level. It is a comparison, not an amount.'**
  String get glossaryTarLoad;

  /// No description provided for @glossaryCravingWindow.
  ///
  /// In en, this message translates to:
  /// **'The hours you most often reach for a cigarette, learned from your own records.'**
  String get glossaryCravingWindow;

  /// No description provided for @glossaryAdherence.
  ///
  /// In en, this message translates to:
  /// **'The share of days you stayed inside your plan.'**
  String get glossaryAdherence;

  /// No description provided for @glossaryPackYears.
  ///
  /// In en, this message translates to:
  /// **'A standard way to add up a smoking history: a pack a day for a year is one pack-year.'**
  String get glossaryPackYears;

  /// No description provided for @glossaryWithdrawalPressure.
  ///
  /// In en, this message translates to:
  /// **'A guess at how hard today is likely to feel. Only you know if it is right, and telling the app teaches it.'**
  String get glossaryWithdrawalPressure;

  /// No description provided for @glossaryEvidence.
  ///
  /// In en, this message translates to:
  /// **'How strong the science is behind a suggestion: strong, promising, or traditional with no proof.'**
  String get glossaryEvidence;

  /// No description provided for @glossarySoftTaper.
  ///
  /// In en, this message translates to:
  /// **'Widening the gap between cigarettes in small steps you can actually keep.'**
  String get glossarySoftTaper;

  /// No description provided for @glossaryTermSoftTaper.
  ///
  /// In en, this message translates to:
  /// **'Soft taper'**
  String get glossaryTermSoftTaper;

  /// No description provided for @glossaryTermPackYears.
  ///
  /// In en, this message translates to:
  /// **'Pack-years'**
  String get glossaryTermPackYears;

  /// No description provided for @organTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a point to see what it does and what recovery looks like.'**
  String get organTapHint;

  /// No description provided for @organImpactAttributable.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of these cases in the population are attributed to smoking'**
  String organImpactAttributable(int percent);

  /// No description provided for @organImpactRelative.
  ///
  /// In en, this message translates to:
  /// **'Risk about {percent}% higher than in someone who never smoked'**
  String organImpactRelative(int percent);

  /// No description provided for @organNotYou.
  ///
  /// In en, this message translates to:
  /// **'These are population figures — not a reading of your body.'**
  String get organNotYou;

  /// No description provided for @obWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why do you want to stop?'**
  String get obWhyTitle;

  /// No description provided for @obWhyHint.
  ///
  /// In en, this message translates to:
  /// **'Pick the one that is truest today. Halen shows it back to you when a craving hits.'**
  String get obWhyHint;

  /// No description provided for @reasonChildren.
  ///
  /// In en, this message translates to:
  /// **'For my children'**
  String get reasonChildren;

  /// No description provided for @reasonHealth.
  ///
  /// In en, this message translates to:
  /// **'For my health'**
  String get reasonHealth;

  /// No description provided for @reasonMoney.
  ///
  /// In en, this message translates to:
  /// **'For the money'**
  String get reasonMoney;

  /// No description provided for @reasonFreedom.
  ///
  /// In en, this message translates to:
  /// **'To not be owned by it'**
  String get reasonFreedom;

  /// No description provided for @reasonSmell.
  ///
  /// In en, this message translates to:
  /// **'For the smell'**
  String get reasonSmell;

  /// No description provided for @reasonFitness.
  ///
  /// In en, this message translates to:
  /// **'To breathe better'**
  String get reasonFitness;

  /// No description provided for @reasonSomeoneAsked.
  ///
  /// In en, this message translates to:
  /// **'Someone asked me to'**
  String get reasonSomeoneAsked;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'This is where you are starting'**
  String get resultTitle;

  /// No description provided for @resultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All of it worked out from what you just told us.'**
  String get resultSubtitle;

  /// No description provided for @resultPerYearPacks.
  ///
  /// In en, this message translates to:
  /// **'Packs a year'**
  String get resultPerYearPacks;

  /// No description provided for @resultPerYearMoney.
  ///
  /// In en, this message translates to:
  /// **'A year'**
  String get resultPerYearMoney;

  /// No description provided for @resultPerYearTime.
  ///
  /// In en, this message translates to:
  /// **'A year, smoking'**
  String get resultPerYearTime;

  /// No description provided for @resultDependenceTitle.
  ///
  /// In en, this message translates to:
  /// **'How much your body is leaning on it'**
  String get resultDependenceTitle;

  /// No description provided for @resultDependenceLow.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get resultDependenceLow;

  /// No description provided for @resultDependenceModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get resultDependenceModerate;

  /// No description provided for @resultDependenceHigh.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get resultDependenceHigh;

  /// No description provided for @resultDependenceExplain.
  ///
  /// In en, this message translates to:
  /// **'From two questions: how many a day, and how soon after waking. It sets how gently your plan starts — nothing else.'**
  String get resultDependenceExplain;

  /// No description provided for @resultFirst72Title.
  ///
  /// In en, this message translates to:
  /// **'What the first 72 hours look like'**
  String get resultFirst72Title;

  /// No description provided for @resultFirst7220m.
  ///
  /// In en, this message translates to:
  /// **'20 minutes'**
  String get resultFirst7220m;

  /// No description provided for @resultFirst7220mBody.
  ///
  /// In en, this message translates to:
  /// **'Heart rate and blood pressure start to fall.'**
  String get resultFirst7220mBody;

  /// No description provided for @resultFirst7212h.
  ///
  /// In en, this message translates to:
  /// **'12 hours'**
  String get resultFirst7212h;

  /// No description provided for @resultFirst7212hBody.
  ///
  /// In en, this message translates to:
  /// **'Carbon monoxide clears; more oxygen reaches your blood.'**
  String get resultFirst7212hBody;

  /// No description provided for @resultFirst7248h.
  ///
  /// In en, this message translates to:
  /// **'48-72 hours'**
  String get resultFirst7248h;

  /// No description provided for @resultFirst7248hBody.
  ///
  /// In en, this message translates to:
  /// **'The hardest stretch, and the peak of it. Taste and smell start coming back.'**
  String get resultFirst7248hBody;

  /// No description provided for @resultStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get resultStart;

  /// No description provided for @resultSourceNote.
  ///
  /// In en, this message translates to:
  /// **'Milestones from WHO and CDC population data.'**
  String get resultSourceNote;

  /// No description provided for @quitPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Your quit plan'**
  String get quitPlanTitle;

  /// No description provided for @quitPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Five things that make an attempt stick. None of them are compulsory.'**
  String get quitPlanSubtitle;

  /// No description provided for @quitPlanReadiness.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} ready'**
  String quitPlanReadiness(int done, int total);

  /// No description provided for @quitDateTitle.
  ///
  /// In en, this message translates to:
  /// **'A date to stop'**
  String get quitDateTitle;

  /// No description provided for @quitDateNone.
  ///
  /// In en, this message translates to:
  /// **'Not set yet'**
  String get quitDateNone;

  /// No description provided for @quitDateSet.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get quitDateSet;

  /// No description provided for @quitDateChange.
  ///
  /// In en, this message translates to:
  /// **'Move the date'**
  String get quitDateChange;

  /// No description provided for @quitDateClear.
  ///
  /// In en, this message translates to:
  /// **'Remove the date'**
  String get quitDateClear;

  /// No description provided for @quitDateWhy.
  ///
  /// In en, this message translates to:
  /// **'Cutting down works when it is aimed at a day. Without one, reducing tends to settle into a habit of its own.'**
  String get quitDateWhy;

  /// No description provided for @quitDateIn.
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String quitDateIn(int days);

  /// No description provided for @quitDateTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get quitDateTomorrow;

  /// No description provided for @quitDateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get quitDateToday;

  /// No description provided for @quitDatePassed.
  ///
  /// In en, this message translates to:
  /// **'Day {days}'**
  String quitDatePassed(int days);

  /// No description provided for @quitDateTooSoonNote.
  ///
  /// In en, this message translates to:
  /// **'Under three days leaves no room to get ready — to get medicine, tell someone, clear the house.'**
  String get quitDateTooSoonNote;

  /// No description provided for @quitDateTooFarNote.
  ///
  /// In en, this message translates to:
  /// **'Past six weeks a date stops working as a commitment. Nearer is better.'**
  String get quitDateTooFarNote;

  /// No description provided for @quitDateMovedNote.
  ///
  /// In en, this message translates to:
  /// **'Moved {count} times so far. That is allowed.'**
  String quitDateMovedNote(int count);

  /// No description provided for @medicinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Medicines that help'**
  String get medicinesTitle;

  /// No description provided for @medicinesLead.
  ///
  /// In en, this message translates to:
  /// **'These roughly double the chance an attempt succeeds. It is the most effective help available, and most people never try it.'**
  String get medicinesLead;

  /// No description provided for @medicinesOtc.
  ///
  /// In en, this message translates to:
  /// **'Available at a pharmacy'**
  String get medicinesOtc;

  /// No description provided for @medicinesPrescription.
  ///
  /// In en, this message translates to:
  /// **'Ask a doctor'**
  String get medicinesPrescription;

  /// No description provided for @medicinesHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get medicinesHowItWorks;

  /// No description provided for @medicinesTypicalUse.
  ///
  /// In en, this message translates to:
  /// **'How it is used'**
  String get medicinesTypicalUse;

  /// No description provided for @medicinesCommonMistake.
  ///
  /// In en, this message translates to:
  /// **'The usual mistake'**
  String get medicinesCommonMistake;

  /// No description provided for @medicinesRatioPlacebo.
  ///
  /// In en, this message translates to:
  /// **'Raises the chance of quitting by about {percent}% compared with a dummy treatment, across trials'**
  String medicinesRatioPlacebo(int percent);

  /// No description provided for @medicinesRatioSingle.
  ///
  /// In en, this message translates to:
  /// **'Raises the chance of quitting by about {percent}% compared with one form alone, across trials'**
  String medicinesRatioSingle(int percent);

  /// No description provided for @medicinesCombinationSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Given how much you smoke, the usual starting point is a patch plus one fast form. Worth asking a pharmacist about.'**
  String get medicinesCombinationSuggestion;

  /// No description provided for @medicinesDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Halen is not a prescriber and sells nothing. Doses, suitability and interactions are for a pharmacist or a doctor to judge — especially in pregnancy, heart disease or a psychiatric condition.'**
  String get medicinesDisclaimer;

  /// No description provided for @copingTitle.
  ///
  /// In en, this message translates to:
  /// **'The hard moments'**
  String get copingTitle;

  /// No description provided for @copingLead.
  ///
  /// In en, this message translates to:
  /// **'Name what you will do instead, before you are in it. Deciding in the moment is the part that fails.'**
  String get copingLead;

  /// No description provided for @copingHint.
  ///
  /// In en, this message translates to:
  /// **'What will you do instead?'**
  String get copingHint;

  /// No description provided for @copingSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get copingSaved;

  /// No description provided for @copingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your plan is empty. Even one line for your worst moment is worth having.'**
  String get copingEmpty;

  /// No description provided for @notAPuffTitle.
  ///
  /// In en, this message translates to:
  /// **'Not a single puff'**
  String get notAPuffTitle;

  /// No description provided for @notAPuffBody.
  ///
  /// In en, this message translates to:
  /// **'The rule is not about willpower. One cigarette re-teaches the craving that smoking still works, and that is what turns one into ten.'**
  String get notAPuffBody;

  /// No description provided for @notAPuffAccept.
  ///
  /// In en, this message translates to:
  /// **'I take the rule'**
  String get notAPuffAccept;

  /// No description provided for @notAPuffTaken.
  ///
  /// In en, this message translates to:
  /// **'Rule taken'**
  String get notAPuffTaken;

  /// No description provided for @supportPersonTitle.
  ///
  /// In en, this message translates to:
  /// **'Someone who knows'**
  String get supportPersonTitle;

  /// No description provided for @supportPersonBody.
  ///
  /// In en, this message translates to:
  /// **'Telling one person raises the odds. First name is enough — Halen never reads your contacts and stores nothing else.'**
  String get supportPersonBody;

  /// No description provided for @supportPersonHint.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get supportPersonHint;

  /// No description provided for @supportPersonDraft.
  ///
  /// In en, this message translates to:
  /// **'Something you could send: \"I am stopping smoking on {date}. If I get unbearable, that is why. Ask me how it is going.\"'**
  String supportPersonDraft(String date);

  /// No description provided for @supportPersonCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy the message'**
  String get supportPersonCopy;

  /// No description provided for @supportPersonCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get supportPersonCopied;

  /// No description provided for @moodCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Two questions about your mood'**
  String get moodCheckTitle;

  /// No description provided for @moodCheckLead.
  ///
  /// In en, this message translates to:
  /// **'Over the last two weeks, how often have you been bothered by...'**
  String get moodCheckLead;

  /// No description provided for @moodCheckQ1.
  ///
  /// In en, this message translates to:
  /// **'Little interest or pleasure in doing things'**
  String get moodCheckQ1;

  /// No description provided for @moodCheckQ2.
  ///
  /// In en, this message translates to:
  /// **'Feeling down, depressed or hopeless'**
  String get moodCheckQ2;

  /// No description provided for @moodCheckNever.
  ///
  /// In en, this message translates to:
  /// **'Not at all'**
  String get moodCheckNever;

  /// No description provided for @moodCheckSomeDays.
  ///
  /// In en, this message translates to:
  /// **'Several days'**
  String get moodCheckSomeDays;

  /// No description provided for @moodCheckMostDays.
  ///
  /// In en, this message translates to:
  /// **'More than half the days'**
  String get moodCheckMostDays;

  /// No description provided for @moodCheckEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Nearly every day'**
  String get moodCheckEveryDay;

  /// No description provided for @moodCheckWhy.
  ///
  /// In en, this message translates to:
  /// **'Stopping can bring low mood to the surface in people prone to it. This is a screen, not a diagnosis, and nothing here leaves your phone.'**
  String get moodCheckWhy;

  /// No description provided for @moodCheckResultClear.
  ///
  /// In en, this message translates to:
  /// **'Nothing here suggests you need to change course. Ask again whenever you want.'**
  String get moodCheckResultClear;

  /// No description provided for @moodCheckResultTalk.
  ///
  /// In en, this message translates to:
  /// **'This score is at the level where talking to a doctor is worth doing — not because stopping is wrong for you, but because low mood is treatable and easier to carry when it is treated.'**
  String get moodCheckResultTalk;

  /// No description provided for @moodCheckDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get moodCheckDone;

  /// No description provided for @slipTitle.
  ///
  /// In en, this message translates to:
  /// **'That was one cigarette'**
  String get slipTitle;

  /// No description provided for @slipBody.
  ///
  /// In en, this message translates to:
  /// **'One is a slip, not the end of the attempt. What decides the next week is what you do in the next hour.'**
  String get slipBody;

  /// No description provided for @slipAction.
  ///
  /// In en, this message translates to:
  /// **'Throw the rest away, and go back to the plan now — not tomorrow, not Monday.'**
  String get slipAction;

  /// No description provided for @slipClusteringTitle.
  ///
  /// In en, this message translates to:
  /// **'This is getting harder'**
  String get slipClusteringTitle;

  /// No description provided for @slipClusteringBody.
  ///
  /// In en, this message translates to:
  /// **'Several in a week usually means the situation is stronger than the plan, not that you are weak. This is the moment medicine helps most.'**
  String get slipClusteringBody;

  /// No description provided for @slipRelapseTitle.
  ///
  /// In en, this message translates to:
  /// **'The attempt has slipped back'**
  String get slipRelapseTitle;

  /// No description provided for @slipRelapseBody.
  ///
  /// In en, this message translates to:
  /// **'Most people who stop for good have done this several times first. The attempt that works is usually not the first one.'**
  String get slipRelapseBody;

  /// No description provided for @slipSetNewDate.
  ///
  /// In en, this message translates to:
  /// **'Set a new date'**
  String get slipSetNewDate;

  /// No description provided for @slipSeeMedicines.
  ///
  /// In en, this message translates to:
  /// **'See what medicine could do'**
  String get slipSeeMedicines;

  /// No description provided for @quitDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today is the day'**
  String get quitDayTitle;

  /// No description provided for @quitDayLead.
  ///
  /// In en, this message translates to:
  /// **'The first day is mostly logistics. Here is the whole of it.'**
  String get quitDayLead;

  /// No description provided for @quitDayMorning.
  ///
  /// In en, this message translates to:
  /// **'This morning'**
  String get quitDayMorning;

  /// No description provided for @quitDayMorningBody.
  ///
  /// In en, this message translates to:
  /// **'Throw away every cigarette, lighter and ashtray you own. Not hidden — gone.'**
  String get quitDayMorningBody;

  /// No description provided for @quitDayAfternoon.
  ///
  /// In en, this message translates to:
  /// **'This afternoon'**
  String get quitDayAfternoon;

  /// No description provided for @quitDayAfternoonBody.
  ///
  /// In en, this message translates to:
  /// **'The first cravings come in waves of a few minutes. Walk, water, breathe — they pass whether or not you smoke.'**
  String get quitDayAfternoonBody;

  /// No description provided for @quitDayEvening.
  ///
  /// In en, this message translates to:
  /// **'Tonight'**
  String get quitDayEvening;

  /// No description provided for @quitDayEveningBody.
  ///
  /// In en, this message translates to:
  /// **'Evening is the hardest hour of day one. Change what you do at that hour, not just what you hold.'**
  String get quitDayEveningBody;

  /// No description provided for @quitDayReasonReminder.
  ///
  /// In en, this message translates to:
  /// **'You said you were doing this {reason}.'**
  String quitDayReasonReminder(String reason);

  /// No description provided for @helplineTitle.
  ///
  /// In en, this message translates to:
  /// **'A person on the phone'**
  String get helplineTitle;

  /// No description provided for @helplineBody.
  ///
  /// In en, this message translates to:
  /// **'Quitlines work — talking to a trained counsellor raises the odds on its own.'**
  String get helplineBody;

  /// No description provided for @statusTitle.
  ///
  /// In en, this message translates to:
  /// **'Where you are'**
  String get statusTitle;

  /// No description provided for @statusSwipeHint.
  ///
  /// In en, this message translates to:
  /// **'Swipe for the next one'**
  String get statusSwipeHint;

  /// No description provided for @statusOpen.
  ///
  /// In en, this message translates to:
  /// **'See all your numbers'**
  String get statusOpen;

  /// No description provided for @statusPageNicotine.
  ///
  /// In en, this message translates to:
  /// **'Nicotine'**
  String get statusPageNicotine;

  /// No description provided for @statusPageOxygen.
  ///
  /// In en, this message translates to:
  /// **'Carbon monoxide in your blood'**
  String get statusPageOxygen;

  /// No description provided for @statusPageBaseline.
  ///
  /// In en, this message translates to:
  /// **'Nicotine built up in your body'**
  String get statusPageBaseline;

  /// No description provided for @statusPageParticles.
  ///
  /// In en, this message translates to:
  /// **'Tar build-up'**
  String get statusPageParticles;

  /// No description provided for @statusPageProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress score'**
  String get statusPageProgress;

  /// No description provided for @statusPageHarm.
  ///
  /// In en, this message translates to:
  /// **'Harm load'**
  String get statusPageHarm;

  /// No description provided for @statusPageMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get statusPageMoney;

  /// No description provided for @statusPageTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get statusPageTime;

  /// No description provided for @statusNeedsData.
  ///
  /// In en, this message translates to:
  /// **'A few more records and this one draws itself.'**
  String get statusNeedsData;

  /// No description provided for @celebrateTitle.
  ///
  /// In en, this message translates to:
  /// **'That is a real one'**
  String get celebrateTitle;

  /// No description provided for @celebrateClose.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get celebrateClose;

  /// No description provided for @celebrateDay1.
  ///
  /// In en, this message translates to:
  /// **'One full day'**
  String get celebrateDay1;

  /// No description provided for @celebrateDay3.
  ///
  /// In en, this message translates to:
  /// **'Three days — past the peak'**
  String get celebrateDay3;

  /// No description provided for @celebrateWeek1.
  ///
  /// In en, this message translates to:
  /// **'One week'**
  String get celebrateWeek1;

  /// No description provided for @celebrateMonth1.
  ///
  /// In en, this message translates to:
  /// **'One month'**
  String get celebrateMonth1;

  /// No description provided for @celebrateResisted100.
  ///
  /// In en, this message translates to:
  /// **'100 cravings ridden out'**
  String get celebrateResisted100;

  /// No description provided for @commonNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get commonNotNow;

  /// No description provided for @commonOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get commonOpen;

  /// No description provided for @todaySectionState.
  ///
  /// In en, this message translates to:
  /// **'Where you stand'**
  String get todaySectionState;

  /// No description provided for @todaySectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Today\'s support'**
  String get todaySectionSupport;

  /// No description provided for @startupFailTitle.
  ///
  /// In en, this message translates to:
  /// **'Halen could not open its database'**
  String get startupFailTitle;

  /// No description provided for @startupFailBody.
  ///
  /// In en, this message translates to:
  /// **'The encrypted store on this device would not open, so the app stopped rather than start without it.'**
  String get startupFailBody;

  /// No description provided for @startupFailDataSafe.
  ///
  /// In en, this message translates to:
  /// **'Nothing has been lost and nothing was sent anywhere. If this keeps happening, the detail below is what a developer needs.'**
  String get startupFailDataSafe;

  /// No description provided for @startupFailRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get startupFailRetry;

  /// No description provided for @startupFailDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Technical detail'**
  String get startupFailDetailTitle;

  /// No description provided for @startupFailCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy the detail'**
  String get startupFailCopy;

  /// No description provided for @startupFailUnknown.
  ///
  /// In en, this message translates to:
  /// **'No further detail was reported.'**
  String get startupFailUnknown;

  /// No description provided for @smokedHeadline0.
  ///
  /// In en, this message translates to:
  /// **'Recorded. Your nicotine level has peaked.'**
  String get smokedHeadline0;

  /// No description provided for @smokedHeadline1.
  ///
  /// In en, this message translates to:
  /// **'Cigarette logged. Carbon monoxide clearance has reset.'**
  String get smokedHeadline1;

  /// No description provided for @smokedHeadline2.
  ///
  /// In en, this message translates to:
  /// **'Record updated. Stay focused on your rhythm.'**
  String get smokedHeadline2;

  /// No description provided for @smokedHeadline3.
  ///
  /// In en, this message translates to:
  /// **'Logged. Delaying the next one is in your hands.'**
  String get smokedHeadline3;

  /// No description provided for @smokedAdvice0.
  ///
  /// In en, this message translates to:
  /// **'Drink a large glass of cold water now to neutralize nicotine taste and stimulate the vagus nerve.'**
  String get smokedAdvice0;

  /// No description provided for @smokedAdvice1.
  ///
  /// In en, this message translates to:
  /// **'Get up and take a short walk. Changing your environment weakens the next urge.'**
  String get smokedAdvice1;

  /// No description provided for @smokedAdvice2.
  ///
  /// In en, this message translates to:
  /// **'Take a deep diaphragm breath. Give yourself at least an hour before the next one.'**
  String get smokedAdvice2;

  /// No description provided for @smokedAdvice3.
  ///
  /// In en, this message translates to:
  /// **'Your body takes about 8 hours to clear this nicotine. Hydrate to support your metabolism.'**
  String get smokedAdvice3;

  /// No description provided for @splashContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get splashContinue;

  /// No description provided for @packTitle.
  ///
  /// In en, this message translates to:
  /// **'My pack'**
  String get packTitle;

  /// No description provided for @packLabelLine.
  ///
  /// In en, this message translates to:
  /// **'Label: {tar} mg tar, {nicotine} mg nicotine per cigarette'**
  String packLabelLine(String tar, String nicotine);

  /// No description provided for @packLabelDefaulted.
  ///
  /// In en, this message translates to:
  /// **'Using the legal maximum until you enter your pack\'s own values.'**
  String get packLabelDefaulted;

  /// No description provided for @packTar.
  ///
  /// In en, this message translates to:
  /// **'Tar per cigarette (mg)'**
  String get packTar;

  /// No description provided for @packNicotine.
  ///
  /// In en, this message translates to:
  /// **'Nicotine per cigarette (mg)'**
  String get packNicotine;

  /// No description provided for @packLabelHint.
  ///
  /// In en, this message translates to:
  /// **'Printed on the side of the pack. Leave empty to use the legal maximum (10 mg tar, 1 mg nicotine).'**
  String get packLabelHint;

  /// No description provided for @purchasesTitle.
  ///
  /// In en, this message translates to:
  /// **'My pack purchases'**
  String get purchasesTitle;

  /// No description provided for @purchasesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a purchase'**
  String get purchasesAdd;

  /// No description provided for @purchasesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No purchases yet. Add the packs you buy and you will see what the habit really costs, month by month.'**
  String get purchasesEmpty;

  /// No description provided for @purchasesThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Spent this month'**
  String get purchasesThisMonth;

  /// No description provided for @purchasesLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get purchasesLastMonth;

  /// No description provided for @purchasesEvery.
  ///
  /// In en, this message translates to:
  /// **'One pack every {days} days on average'**
  String purchasesEvery(String days);

  /// No description provided for @purchasesMonthlyRate.
  ///
  /// In en, this message translates to:
  /// **'At this rate, about {amount} a month'**
  String purchasesMonthlyRate(String amount);

  /// No description provided for @purchasesChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending per month'**
  String get purchasesChartTitle;

  /// No description provided for @purchasesChartMeaning.
  ///
  /// In en, this message translates to:
  /// **'One bar per month: what went on cigarettes. The solid bar is this month.'**
  String get purchasesChartMeaning;

  /// No description provided for @purchasesChartAxis.
  ///
  /// In en, this message translates to:
  /// **'amount spent'**
  String get purchasesChartAxis;

  /// No description provided for @purchasesHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get purchasesHistory;

  /// No description provided for @purchasesDeleted.
  ///
  /// In en, this message translates to:
  /// **'Purchase removed'**
  String get purchasesDeleted;

  /// No description provided for @purchasesDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get purchasesDate;

  /// No description provided for @purchasesPacks.
  ///
  /// In en, this message translates to:
  /// **'Packs'**
  String get purchasesPacks;

  /// No description provided for @purchasesPrice.
  ///
  /// In en, this message translates to:
  /// **'Price per pack'**
  String get purchasesPrice;

  /// No description provided for @purchasesPackSize.
  ///
  /// In en, this message translates to:
  /// **'Cigarettes'**
  String get purchasesPackSize;

  /// No description provided for @purchasesBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand (optional)'**
  String get purchasesBrand;

  /// No description provided for @purchasesUpdatesPack.
  ///
  /// In en, this message translates to:
  /// **'This becomes your current pack, so every cost figure in the app follows what you actually paid.'**
  String get purchasesUpdatesPack;

  /// No description provided for @tarTitle.
  ///
  /// In en, this message translates to:
  /// **'Tar you took in'**
  String get tarTitle;

  /// No description provided for @tarThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get tarThisWeek;

  /// No description provided for @tarThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get tarThisMonth;

  /// No description provided for @tarPicture.
  ///
  /// In en, this message translates to:
  /// **'about {count} {measure}'**
  String tarPicture(String count, String measure);

  /// No description provided for @measureTeaSpoon.
  ///
  /// In en, this message translates to:
  /// **'tea spoons'**
  String get measureTeaSpoon;

  /// No description provided for @measureDessertSpoon.
  ///
  /// In en, this message translates to:
  /// **'dessert spoons'**
  String get measureDessertSpoon;

  /// No description provided for @measureTableSpoon.
  ///
  /// In en, this message translates to:
  /// **'table spoons'**
  String get measureTableSpoon;

  /// No description provided for @measureWaterGlass.
  ///
  /// In en, this message translates to:
  /// **'glasses of water'**
  String get measureWaterGlass;

  /// No description provided for @tarGrams.
  ///
  /// In en, this message translates to:
  /// **'{grams} g'**
  String tarGrams(String grams);

  /// No description provided for @tarChartMeaning.
  ///
  /// In en, this message translates to:
  /// **'Tar brought into your lungs each week, from your own count and your pack label.'**
  String get tarChartMeaning;

  /// No description provided for @tarChartAxis.
  ///
  /// In en, this message translates to:
  /// **'grams of tar per week'**
  String get tarChartAxis;

  /// No description provided for @tarWeekShort.
  ///
  /// In en, this message translates to:
  /// **'{n} wk'**
  String tarWeekShort(int n);

  /// No description provided for @tarBasis.
  ///
  /// In en, this message translates to:
  /// **'Worked out from {tar} mg tar per cigarette on the label. This is a floor: people inhale more deeply than the test machine, so real intake is usually higher.'**
  String tarBasis(String tar);

  /// No description provided for @tarSpoonNote.
  ///
  /// In en, this message translates to:
  /// **'Spoons by volume, taking tar at about 1 g per millilitre. A Turkish tea spoon holds about 2.5 mL.'**
  String get tarSpoonNote;

  /// No description provided for @nicotineMgAxis.
  ///
  /// In en, this message translates to:
  /// **'estimated nicotine still in your body, mg — a model, not a measurement'**
  String get nicotineMgAxis;

  /// No description provided for @nicotineMgBasis.
  ///
  /// In en, this message translates to:
  /// **'About 1.2 mg of nicotine is absorbed per cigarette, and half of it leaves the body every 2 hours (Benowitz).'**
  String get nicotineMgBasis;

  /// No description provided for @mgValue.
  ///
  /// In en, this message translates to:
  /// **'{value} mg'**
  String mgValue(String value);

  /// No description provided for @organExposureTitle.
  ///
  /// In en, this message translates to:
  /// **'This organ, last 24 hours'**
  String get organExposureTitle;

  /// No description provided for @organExposureNow.
  ///
  /// In en, this message translates to:
  /// **'Right now: {percent}% of its peak today'**
  String organExposureNow(int percent);

  /// No description provided for @organExposureMeaning.
  ///
  /// In en, this message translates to:
  /// **'Each spike is a cigarette reaching this organ; the fall is your body clearing it. The flatter the line, the more rest the organ gets.'**
  String get organExposureMeaning;

  /// No description provided for @organExposureLoads.
  ///
  /// In en, this message translates to:
  /// **'Driven by: {loads}'**
  String organExposureLoads(String loads);

  /// No description provided for @organSinceLast.
  ///
  /// In en, this message translates to:
  /// **'Since your last cigarette: {time}'**
  String organSinceLast(String time);

  /// No description provided for @organAcuteHeart.
  ///
  /// In en, this message translates to:
  /// **'After a cigarette the heart beats about 10-20 times a minute faster and blood pressure rises, for roughly 20-30 minutes.'**
  String get organAcuteHeart;

  /// No description provided for @organAcuteVessels.
  ///
  /// In en, this message translates to:
  /// **'Nicotine narrows blood vessels within minutes, and each cigarette keeps them narrowed for about an hour.'**
  String get organAcuteVessels;

  /// No description provided for @organAcuteLungs.
  ///
  /// In en, this message translates to:
  /// **'Smoke slows the tiny hairs that sweep the airways clean, and tar settles in the lungs with every cigarette.'**
  String get organAcuteLungs;

  /// No description provided for @organAcuteBrain.
  ///
  /// In en, this message translates to:
  /// **'Nicotine reaches the brain in 10-20 seconds; as it falls over the next hours, it comes back as the next craving.'**
  String get organAcuteBrain;

  /// No description provided for @organAcuteBlood.
  ///
  /// In en, this message translates to:
  /// **'Carbon monoxide takes the place of oxygen in the blood; half of it clears in about 4-5 hours.'**
  String get organAcuteBlood;

  /// No description provided for @organAcuteGeneral.
  ///
  /// In en, this message translates to:
  /// **'The harmful substances in smoke travel in the blood to every organ; exposure grows with every cigarette.'**
  String get organAcuteGeneral;

  /// No description provided for @envTitle.
  ///
  /// In en, this message translates to:
  /// **'What your planet got back'**
  String get envTitle;

  /// No description provided for @envTrees.
  ///
  /// In en, this message translates to:
  /// **'{count} trees not cut down'**
  String envTrees(String count);

  /// No description provided for @envButts.
  ///
  /// In en, this message translates to:
  /// **'{count} filters kept out of nature'**
  String envButts(int count);

  /// No description provided for @envBasis.
  ///
  /// In en, this message translates to:
  /// **'WHO estimates about one tree is lost for every 300 cigarettes made, mostly to dry tobacco leaves and make paper. Cigarette filters are plastic (cellulose acetate) and are the most littered item on Earth.'**
  String get envBasis;

  /// No description provided for @envPlantTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant a real tree'**
  String get envPlantTitle;

  /// No description provided for @envPlantBody.
  ///
  /// In en, this message translates to:
  /// **'A small part of what you have saved can plant a real sapling. Halen takes no money and earns nothing from this; the buttons open the organisations directly.'**
  String get envPlantBody;

  /// No description provided for @envSavedCovers.
  ///
  /// In en, this message translates to:
  /// **'What you saved so far would plant about {count} saplings.'**
  String envSavedCovers(int count);

  /// No description provided for @envOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link.'**
  String get envOpenFailed;

  /// No description provided for @measureDrop.
  ///
  /// In en, this message translates to:
  /// **'drops'**
  String get measureDrop;

  /// No description provided for @tarThisWeekShort.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get tarThisWeekShort;

  /// No description provided for @envTreesLabel.
  ///
  /// In en, this message translates to:
  /// **'Trees'**
  String get envTreesLabel;

  /// No description provided for @envFiltersLabel.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get envFiltersLabel;

  /// No description provided for @callQuitlineA171.
  ///
  /// In en, this message translates to:
  /// **'Turkey Quitline (ALO 171)'**
  String get callQuitlineA171;

  /// No description provided for @callYedam115.
  ///
  /// In en, this message translates to:
  /// **'Green Crescent Helpline (YEDAM 115)'**
  String get callYedam115;

  /// No description provided for @callQuitlineUs.
  ///
  /// In en, this message translates to:
  /// **'US Quitline (1-800-QUIT-NOW)'**
  String get callQuitlineUs;

  /// No description provided for @callQuitlineUk.
  ///
  /// In en, this message translates to:
  /// **'UK NHS Smokefree (0300 123 1044)'**
  String get callQuitlineUk;

  /// No description provided for @callQuitlineDe.
  ///
  /// In en, this message translates to:
  /// **'Germany BZgA Quitline (0800 8 313131)'**
  String get callQuitlineDe;

  /// No description provided for @callQuitlineFr.
  ///
  /// In en, this message translates to:
  /// **'France Tabac Info (39 89)'**
  String get callQuitlineFr;

  /// No description provided for @nutritionGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Anti-Craving Nutrition Guide'**
  String get nutritionGuideTitle;

  /// No description provided for @nutritionGuideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vitamin C, alkaline foods and hydration support'**
  String get nutritionGuideSubtitle;

  /// No description provided for @planCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Plan & Rhythm'**
  String get planCardTitle;

  /// No description provided for @planCardSwitch.
  ///
  /// In en, this message translates to:
  /// **'Manage / Switch Plan'**
  String get planCardSwitch;

  /// No description provided for @planCardTarget.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Target: {count} cigarettes'**
  String planCardTarget(int count);

  /// No description provided for @planCardNextInterval.
  ///
  /// In en, this message translates to:
  /// **'Next Target Interval'**
  String get planCardNextInterval;

  /// No description provided for @economyHistoricalTitle.
  ///
  /// In en, this message translates to:
  /// **'Lifetime Smoking Expenditure'**
  String get economyHistoricalTitle;

  /// No description provided for @economyHistoricalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Estimated total money spent on cigarettes historically'**
  String get economyHistoricalSubtitle;

  /// No description provided for @economyTimeFilter1m.
  ///
  /// In en, this message translates to:
  /// **'1 Month'**
  String get economyTimeFilter1m;

  /// No description provided for @economyTimeFilter1y.
  ///
  /// In en, this message translates to:
  /// **'1 Year'**
  String get economyTimeFilter1y;

  /// No description provided for @economyTimeFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All Time (Halen)'**
  String get economyTimeFilterAll;

  /// No description provided for @economyTimeFilterLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime History'**
  String get economyTimeFilterLifetime;

  /// No description provided for @progressScoreExplainer.
  ///
  /// In en, this message translates to:
  /// **'Adherence Score (out of 100): Reflects adherence to daily quotas, spacing between cigarettes, and resisted urges.'**
  String get progressScoreExplainer;

  /// No description provided for @mindPressureExplainer.
  ///
  /// In en, this message translates to:
  /// **'Nicotine Withdrawal Pressure: Simulation of biological withdrawal pressure from nicotinic receptors. Peaks are temporary (~5-10 min).'**
  String get mindPressureExplainer;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageTr.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTr;

  /// No description provided for @languageDe.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageDe;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;
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
