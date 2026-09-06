// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Halen';

  @override
  String get tagline => 'Reduziere in deinem Tempo. Hör für immer auf.';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonNext => 'Weiter';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonDone => 'Fertig';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonOk => 'OK';

  @override
  String get commonHowCalculated => 'Wie wird diese Schätzung berechnet?';

  @override
  String get commonModelTag => 'Schätzung · Modell';

  @override
  String get commonErrorTitle => 'Etwas ist schiefgelaufen';

  @override
  String get commonLoading => 'Lädt…';

  @override
  String get commonPremiumLocked =>
      'Das gehört zu Halen Premium. Deine 7-tägige Testphase deckt alles kostenlos ab.';

  @override
  String get commonUnlockPremium => 'Einmalangebot ansehen';

  @override
  String get splashWelcomeTitle => 'Willkommen bei Halen';

  @override
  String get splashTagline => 'Reduziere in deinem Tempo. Hör für immer auf.';

  @override
  String get splashPrivacyLine =>
      'Kein Konto. Keine Server. Deine Daten bleiben auf diesem Gerät.';

  @override
  String get splashBackupLine =>
      'Automatisches Cloud-Backup ist aus; deine Einträge verlassen dieses Telefon nie.';

  @override
  String get splashMedicalNote =>
      'Diese App ist keine medizinische Beratung. Zur Behandlung der Nikotinabhängigkeit wende dich an eine Fachkraft.';

  @override
  String get splashNotificationRationale =>
      'Benachrichtigungen erinnern dich an deinen Plan — nie Spam. Du kannst sie auch später aktivieren.';

  @override
  String get splashEnableNotifications => 'Benachrichtigungen erlauben';

  @override
  String get splashStart => 'Starten';

  @override
  String obStepOf(int n) {
    return 'Schritt $n von 7';
  }

  @override
  String get obAgeTitle => 'Wie alt bist du?';

  @override
  String get obAgeUnder18 => 'Unter 18';

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
      'Halen ist für Erwachsene entwickelt. Für junge Menschen passen Unterstützungsangebote besser — diese kostenlosen Hilfen können helfen.';

  @override
  String get obUnder18NoPlan => 'Es wird kein Reduktionsplan erstellt.';

  @override
  String get obCpdTitle =>
      'Wie viele Zigaretten rauchst du im Durchschnitt pro Tag?';

  @override
  String get obCpdHint =>
      'In der ersten Woche kalibrieren wir das mit deinen echten Einträgen.';

  @override
  String get obTtfcTitle =>
      'Wie schnell nach dem Aufwachen rauchst du die erste Zigarette?';

  @override
  String get obTtfcUnder5 => 'Innerhalb von 5 Minuten';

  @override
  String get obTtfc5to30 => '5–30 Minuten';

  @override
  String get obTtfc31to60 => '31–60 Minuten';

  @override
  String get obTtfcOver60 => 'Nach 60 Minuten';

  @override
  String get obPriceTitle => 'Was kostet eine Schachtel?';

  @override
  String get obPriceHint =>
      'Mit einem typischen Preis für dein Land vorbefüllt — trag deinen echten Preis ein.';

  @override
  String get obPackSizeLabel => 'Zigaretten pro Schachtel';

  @override
  String get obTimesTitle => 'Wann rauchst du gewöhnlich?';

  @override
  String get obTimesHint =>
      'Wähl alles Zutreffende. Das formt deinen Tagesplan.';

  @override
  String get triggerCoffee => 'Kaffee';

  @override
  String get triggerAfterMeal => 'Nach dem Essen';

  @override
  String get triggerStress => 'Stress';

  @override
  String get triggerAlcohol => 'Alkohol';

  @override
  String get triggerCar => 'Im Auto';

  @override
  String get triggerSocial => 'Unter Leuten';

  @override
  String get triggerWorkBreak => 'Arbeitspause';

  @override
  String get triggerBeforeSleep => 'Vor dem Schlafen';

  @override
  String get triggerWakeUp => 'Nach dem Aufwachen';

  @override
  String get obGoalTitle => 'Was ist dein Ziel?';

  @override
  String get obGoalReduce => 'Reduzieren, dann aufhören';

  @override
  String get obGoalReduceHint => 'Empfohlen — ein Plan, der sich dir anpasst';

  @override
  String get obGoalQuitNow => 'Sofort aufhören';

  @override
  String get obGoalQuitNowHint =>
      'Ein Stopp-Programm mit intensiver früher Unterstützung';

  @override
  String get obGoalUndecided => 'Noch unsicher';

  @override
  String get obGoalUndecidedHint => 'Beginne mit Reduktion — entscheide später';

  @override
  String get obBrandTitle => 'Deine Marke (optional)';

  @override
  String get obBrandHint =>
      'Nur für die Genauigkeit der Ersparnis. Kannst du überspringen.';

  @override
  String get obBrandSkip => 'Überspringen';

  @override
  String get obFinalDisclaimer =>
      'Diese App ist keine medizinische Beratung; zur Behandlung der Nikotinabhängigkeit wende dich an eine Fachkraft. Bei Schwangerschaft, Herzerkrankung oder psychiatrischen Erkrankungen hole bitte zuerst fachlichen Rat ein.';

  @override
  String get obDataNote =>
      'Diese Antworten formen nur deinen Plan und verlassen dein Gerät nie.';

  @override
  String get obFinish => 'Plan einrichten';

  @override
  String get todayTitle => 'Heute';

  @override
  String todayRingLabel(int smoked, int target) {
    return 'Heute $smoked von $target';
  }

  @override
  String lastCigaretteMinutes(int n) {
    return 'Letzte Zigarette: vor $n Min.';
  }

  @override
  String lastCigaretteHours(int h, int m) {
    return 'Letzte Zigarette: vor $h Std. $m Min.';
  }

  @override
  String get lastCigaretteNone => 'Heute noch kein Eintrag';

  @override
  String nextTargetIn(int n) {
    return 'Nächstes Ziel: frühestens in $n Min.';
  }

  @override
  String nextTargetHoursIn(int h, int m) {
    return 'Nächstes Ziel: frühestens in $h Std. $m Min.';
  }

  @override
  String get nextTargetReady =>
      'Nächstes Ziel: du bist in deinem geplanten Fenster';

  @override
  String get nextTargetDayDone => 'Tagesplan geschafft — gut gemacht';

  @override
  String get nicotineMiniLabel => 'Geschätzte Nikotin-Exposition (Modell)';

  @override
  String get ctaSmoked => 'GERAUCHT';

  @override
  String get ctaResisted => '✋ Gelüstet überstanden';

  @override
  String resistedTodayCount(int n) {
    return 'heute $n';
  }

  @override
  String savingsStrip(String amount, int n) {
    return '$amount gespart · $n Zigaretten vermieden';
  }

  @override
  String healthStrip(String text) {
    return 'Als Nächstes: $text';
  }

  @override
  String get recalcTitle => 'Wir haben neu berechnet.';

  @override
  String get recalcDistributed =>
      'Dein verbleibendes Tagesbudget verteilt sich auf die restlichen Stunden.';

  @override
  String get recalcBunched =>
      'Dein Konsum today liegt gedrängter über dem Plan; versuche, die nächste Zigarette näher an der geplanten Zeit zu lassen.';

  @override
  String get recalcWeekSoftened =>
      'Diese Woche lief über dem Budget — nächste Woche startet 5 % sanfter.';

  @override
  String get todayEmptyFirstDay =>
      'Dein erster Tag — der Plan formt sich aus deinen Einträgen und Antworten.';

  @override
  String get todayPlanLockedFree =>
      'Dein anpassungsfähiger Plan steckt in Premium. Einträge, Ersparnis und Tageszähler bleiben für immer gratis.';

  @override
  String daysSinceStart(int n) {
    return 'Tag $n mit Halen';
  }

  @override
  String get recordDetailTitle => 'Einzelheiten';

  @override
  String get recordDetailHint => 'Optional — mit einem Tipp markieren.';

  @override
  String get recordDetailSaved => 'Gespeichert.';

  @override
  String get recordLoggedToast => 'Gespeichert.';

  @override
  String get sourceApp => 'In der App';

  @override
  String get sourceWidget => 'Aus dem Widget';

  @override
  String get sourceTile => 'Aus der Schnellkachel';

  @override
  String get sourceControl => 'Aus der Steuerung';

  @override
  String get sourceNotif => 'Aus der Benachrichtigung';

  @override
  String get planTitle => 'Plan';

  @override
  String planTodayBudget(int n) {
    return 'Heutiges Budget: $n';
  }

  @override
  String get planWindowsTitle => 'Geplante Fenster';

  @override
  String planMinGapRule(int n) {
    return 'Lass mindestens $n Minuten zwischen Zigaretten.';
  }

  @override
  String planAdherence7(int n) {
    return '7-Tage-Plangetreue: $n %';
  }

  @override
  String planAdherence14(int n) {
    return '14-Tage-Plangetreue: $n %';
  }

  @override
  String planWeeksEstimate(int x, int y) {
    return 'Wenn der Fortschritt der letzten 7 Tage so weitergeht, erreichst du dein Ziel ungefähr in $x–$y Wochen.';
  }

  @override
  String get planPhaseReduction => 'Reduktion';

  @override
  String get planPhaseFinal => 'Letzte Woche';

  @override
  String get planPhaseQuit => 'Stopp-Programm';

  @override
  String phaseWeekOf(int n, int total) {
    return 'Woche $n von $total';
  }

  @override
  String get paceCalm => 'Ruhig — 8 Wochen, etwa 8–10 % weniger pro Woche';

  @override
  String get paceStandard =>
      'Standard — 6 Wochen, etwa 12–15 % weniger pro Woche';

  @override
  String get paceFast => 'Schnell — 4 Wochen, etwa 18–22 % weniger pro Woche';

  @override
  String get paceSettingLabel => 'Reduktionstempo';

  @override
  String get paceChanged => 'Tempo aktualisiert.';

  @override
  String get tempoAutoAdjusted =>
      'Wir haben das Tempo an deinen echten Fortschritt angepasst.';

  @override
  String get tempoUpSuggestion =>
      'Du hältst deinen Plan zuverlässig ein. Möchtest du das Tempo etwas erhöhen?';

  @override
  String get tempoUpApply => 'Tempo erhöhen';

  @override
  String get finalWeekTitle => 'Letzte Woche';

  @override
  String get finalWeekBody =>
      'Dein Tagesbudget liegt bei 3 oder weniger. Wähl deinen Stopp-Tag — ein Plan, kein Versprechen.';

  @override
  String get quitDayConfirmTitle => 'Stopp-Tag bestätigen';

  @override
  String quitDaySet(String date) {
    return 'Stopp-Tag gesetzt: $date';
  }

  @override
  String get quitDayChoose => 'Tag wählen';

  @override
  String get quitProgramTitle => 'Stopp-Programm';

  @override
  String get quitPrepTitle => 'Vorbereitungswoche';

  @override
  String get quitPrepBody =>
      'Notiere deine Auslöser und deinen Grund. Vervollständige: „Wenn X passiert, werde ich Y tun.“';

  @override
  String get quit24hTitle => 'Erste 24 Stunden';

  @override
  String get quit24hBody =>
      'Deine geschätzte Expositionskurve fällt schnell. Gelüste dauern meist nur wenige Minuten.';

  @override
  String get quit72hTitle => 'Erste 72 Stunden';

  @override
  String get quit72hBody =>
      'Körperliche Entzugssymptome sind in der ersten Woche meist am stärksten und lassen nach. Extra Unterstützung ist jetzt aktiv.';

  @override
  String get quitWeek1Title => 'Woche 1';

  @override
  String get quitWeek1Body =>
      'Gelüste kommen in der ersten Woche am häufigsten und werden mit der Zeit seltener.';

  @override
  String get quitWeek2to4Title => 'Wochen 2–4';

  @override
  String get quitWeek2to4Body =>
      'Gewohnheiten brauchen Zeit — der Median liegt bei rund 66 Tagen und variiert stark.';

  @override
  String get planLockedFree =>
      'Der dynamische Planmotor ist Teil von Premium. Einträge, Ersparnis und Tageszähler bleiben für immer gratis.';

  @override
  String get quitSupportLine =>
      'Eine Fachkraft kann Aufhörmethoden mit dir besprechen, einschließlich Nikotinersatztherapie.';

  @override
  String get statsTitle => 'Statistiken';

  @override
  String get chartDaily => 'Tagesmenge';

  @override
  String get chartPlanVsActual => 'Plan / tatsächlich';

  @override
  String get chartGaps => 'Zeit zwischen Zigaretten';

  @override
  String get chartHourly => 'Stundenmuster';

  @override
  String get chartSavings => 'Ersparnis';

  @override
  String get statsRange7 => 'Letzte 7 Tage';

  @override
  String get statsRange30 => 'Letzte 30 Tage';

  @override
  String get statsRangeAll => 'Gesamt';

  @override
  String get statsRangeLockedPremium =>
      '30-Tage- und Gesamt-Charts sind in Premium.';

  @override
  String get triggerAnalysisTitle => 'Auslöser-Muster';

  @override
  String get triggerAnalysisEmpty =>
      'Für Auslöser-Muster brauchst du mindestens 10 markierte Einträge. Markiere weiter — das erscheint von selbst.';

  @override
  String triggerRiskWindow(String trigger) {
    return 'Die ersten 15 Minuten nach $trigger sehen für dich nach einem riskanten Fenster aus.';
  }

  @override
  String triggerSampleNote(int n) {
    return 'Basiert auf $n markierten Einträgen.';
  }

  @override
  String a11yDailyChartSummary(int count, int target, int adherence) {
    return 'Gestern $count, Ziel $target, Plangetreue $adherence Prozent.';
  }

  @override
  String get sosTitle => 'Gelüst-Notfall';

  @override
  String get sosIntro =>
      'Gelüste ebben meist nach wenigen Minuten ab. Überbrücke sie damit.';

  @override
  String get sosTimerTitle => '2-Minuten-Timer';

  @override
  String sosTimerRunning(int s) {
    return 'Durchhalten — $s s übrig';
  }

  @override
  String get sosTimerDone => 'Zwei Minuten geschafft. Die Welle ist vorbei.';

  @override
  String get sos4dDelay => 'Hinauszögern';

  @override
  String get sos4dDelayBody => 'Gib dir zwei Minuten, bevor du entscheidest.';

  @override
  String get sos4dBreathe => 'Tief atmen';

  @override
  String get sos4dBreatheBody => 'Sechzig Sekunden geführtes Boxatmen.';

  @override
  String get sos4dWater => 'Wasser trinken';

  @override
  String get sos4dWaterBody => 'Ein Glas Wasser, in Ruhe.';

  @override
  String get sos4dElse => 'Etwas anderes tun';

  @override
  String get sos4dElseBody =>
      'Zwei Minuten irgendwas — spazieren, Hände waschen, rausgehen.';

  @override
  String get sosUrgeSurf => 'Beobachten und aushalten';

  @override
  String get sosUrgeSurfBody =>
      'Betrachte den Gelust wie eine Welle: Sie steigt, kulminiert, fällt. Du musst nicht dagegen kämpfen.';

  @override
  String get sosBreathingIn => 'Einatmen';

  @override
  String get sosBreathingHold => 'Halten';

  @override
  String get sosBreathingOut => 'Ausatmen';

  @override
  String get sosBreathingFinished => 'Eine Minute geschafft.';

  @override
  String get sosOutcomeTitle => 'Wie ist es gelaufen?';

  @override
  String get sosResisted => 'Überstanden';

  @override
  String get sosSmoked => 'Geraucht';

  @override
  String sosResistedCount(int n) {
    return 'Du hast bisher $n Gelüste überstanden.';
  }

  @override
  String get sosAfterSmoked =>
      'Gespeichert. Wir haben deinen Plan neu berechnet — er passt sich einfach weiter an.';

  @override
  String get sosIntensityTitle => 'Wie stark war er?';

  @override
  String get sosIntensity1 => 'Leicht';

  @override
  String get sosIntensity2 => 'Mittel';

  @override
  String get sosIntensity3 => 'Stark';

  @override
  String get sosNrtLine =>
      'Optionen wie Nikotinersatztherapie kannst du mit einer Fachkraft besprechen.';

  @override
  String get sosLocked =>
      'Das komplette SOS-Set (Atemanimation, Beobachten & Aushalten) ist in Premium — in deiner Testphase gratis.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsNotifications => 'Benachrichtigungen';

  @override
  String get notifDensity => 'Dichte';

  @override
  String get notifDensityCalm => 'Ruhig';

  @override
  String get notifDensityStandard => 'Standard';

  @override
  String get notifDensityIntense => 'Intensiv';

  @override
  String get notifDensityOff => 'Aus';

  @override
  String get notifDailySummary => 'Tageszusammenfassung (abends)';

  @override
  String get notifMorningGoal => 'Morgens Ziel';

  @override
  String get notifPlanReminder => 'Geplante Zeit naht';

  @override
  String get notifQuitSupport => 'Stopp-Tag-Unterstützung (erste 72 Stunden)';

  @override
  String get notifMilestones => 'Meilensteine';

  @override
  String get notifGentleReturn => 'Sanfter Anstoß nach Stille';

  @override
  String get notifExactTime => 'Erinnerungen zur exakten Uhrzeit';

  @override
  String get notifExactTimeHint =>
      'Standardmäßig aus; Android zeigt sie ungefähr. Beim Einschalten werden exakte Alarme genutzt.';

  @override
  String get settingsAppearance => 'Erscheinungsbild';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get settingsReduceMotion => 'Bewegung reduzieren';

  @override
  String get settingsHaptics => 'Haptik';

  @override
  String get settingsData => 'Deine Daten';

  @override
  String get settingsExport => 'Daten exportieren (JSON)';

  @override
  String get settingsImport => 'Daten importieren (JSON)';

  @override
  String get settingsDeleteAll => 'Alle Daten löschen';

  @override
  String get deleteAllConfirm =>
      'Wirklich alles löschen? Das kann nicht rückgängig gemacht werden.';

  @override
  String get settingsPurchase => 'Halen Lifetime';

  @override
  String get purchaseCopy => 'Einmalig · Lebenslang · Kein Abo';

  @override
  String get purchaseCta => 'Einmal kaufen';

  @override
  String get purchaseRestore => 'Kauf wiederherstellen';

  @override
  String get purchaseOwned => 'Du besitzt Halen Lifetime.';

  @override
  String get purchasePending =>
      'Dein Kauf wartet — der Zugang wird nach Abschluss freigeschaltet.';

  @override
  String trialDaysLeft(int n) {
    return 'Testphase: noch $n Tage';
  }

  @override
  String get trialExpiredFree =>
      'Testphase beendet — die Gratis-Stufe (Einträge, Ersparnis, Tageszähler, 7-Tage-Chart, Export) bleibt für immer deine.';

  @override
  String get settingsAbout => 'Über';

  @override
  String get settingsDisclaimerTitle => 'Gesundheitshinweis';

  @override
  String get settingsDisclaimer =>
      'Diese App ist keine medizinische Beratung; zur Behandlung der Nikotinabhängigkeit wende dich an eine Fachkraft. Bei Schwangerschaft, Herzerkrankung oder psychiatrischen Erkrankungen hole bitte zuerst fachlichen Rat ein.';

  @override
  String get settingsHelplines =>
      'Hilfsangebote: DE BZgA · UK NHS · US 1-800-QUIT-NOW · TR Yeşilay 176';

  @override
  String get settingsPrivacy =>
      'Datenschutz: kein Konto, keine Server, keine Analyse. Deine Einträge bleiben auf diesem Gerät.';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String settingsVersion(String v) {
    return 'Version $v';
  }

  @override
  String get paywallTitle => 'Weiter mit Halen Premium';

  @override
  String paywallValueLine(int n) {
    return 'Diese Woche hast du zu $n % deinen Plan eingehalten.';
  }

  @override
  String get paywallFeaturePlan =>
      'Der adaptive Reduktionsplan, der sich selbst neu berechnet';

  @override
  String get paywallFeatureCharts =>
      'Volle Charts: Plan/tatsächlich, Abstände, Stundenmuster';

  @override
  String get paywallFeatureTriggers => 'Auslöser-Muster';

  @override
  String get paywallFeatureTimeline => 'Die komplette Gesundheits-Zeitleiste';

  @override
  String get paywallFeatureSos => 'Das vollständige SOS-Set';

  @override
  String get paywallFeatureWidget => 'Widget-Anpassung';

  @override
  String get paywallTrialNote =>
      'Deine 7-tägige kostenlose Testphase startet beim ersten Start — ohne Karte.';

  @override
  String get timelineTitle => 'Gesundheits-Zeitleiste';

  @override
  String get timelinePreviewLocked =>
      'Im Reduktionsmodus zählt der Countdown ab deinem Stopp-Tag. Bis dahin ist das eine Vorschau.';

  @override
  String get timelineSourceWho => 'Quelle: WHO';

  @override
  String get timelineSourceCdc => 'Quelle: CDC';

  @override
  String get timelineGeneralPattern =>
      'Im Allgemeinen gilt bei Menschen, die mit dem Rauchen aufhören…';

  @override
  String get timelineMilestone20min => '20 Minuten';

  @override
  String get timelineBody20min =>
      'Im Allgemeinen sinken bei Menschen, die mit dem Rauchen aufhören, Puls und Blutdruck.';

  @override
  String get timelineMilestone12h => '12 Stunden';

  @override
  String get timelineBody12h =>
      'Im Allgemeinen normalisiert sich bei Menschen, die mit dem Rauchen aufhören, der Kohlenmonoxidspiegel im Blut.';

  @override
  String get timelineCoCard =>
      'Kohlenmonoxid im Blut normalisiert sich in etwa 12 Stunden — WHO';

  @override
  String get timelineMilestone2to12w => '2–12 Wochen';

  @override
  String get timelineBody2to12w =>
      'Im Allgemeinen verbessern sich bei Menschen, die mit dem Rauchen aufhören, Kreislauf und Lungenfunktion.';

  @override
  String get timelineMilestone1to9m => '1–9 Monate';

  @override
  String get timelineBody1to9m =>
      'Im Allgemeinen nehmen bei Menschen, die mit dem Rauchen aufhören, Husten und Atemnot ab.';

  @override
  String get timelineMilestone1y => '1 Jahr';

  @override
  String get timelineBody1y =>
      'Im Allgemeinen ist bei Menschen, die mit dem Rauchen aufhören, das Risiko koronarer Herzkrankheit etwa halb so hoch wie bei Rauchenden.';

  @override
  String get timelineMilestone5to15y => '5–15 Jahre';

  @override
  String get timelineBody5to15y =>
      'Im Allgemeinen sinkt bei Menschen, die mit dem Rauchen aufhören, das Schlaganfallrisiko auf das von Nichtrauchenden.';

  @override
  String get timelineMilestone10y => '10 Jahre';

  @override
  String get timelineBody10y =>
      'Im Allgemeinen fällt bei Menschen, die mit dem Rauchen aufhören, das Lungenkrebsrisiko auf etwa die Hälfte.';

  @override
  String get timelineMilestone15y => '15 Jahre';

  @override
  String get timelineBody15y =>
      'Im Allgemeinen wird bei Menschen, die mit dem Rauchen aufhören, das Risiko koronarer Herzkrankheit ähnlich dem von Menschen, die nie geraucht haben.';

  @override
  String get howNicotineTitle => 'Wie die Nikotin-Schätzung berechnet wird';

  @override
  String get howNicotineBody =>
      'Pro Zigarette wird von etwa 1,2 mg aufgenommener Nikotin ausgegangen (publizierter Bereich rund 1–1,5 mg). Die geschätzte Expositionskurve summiert jede geloggte Zigarette und halbiert die Summe alle 2 Stunden — die typische Plasmahalbwertszeit. Angezeigt wird eine 0–100 normalisierte Kurve, nie ein absoluter Blutwert.';

  @override
  String get howNicotineLimits =>
      'Grenzen: Das ist ein Verhaltensmodell, keine Messung. Die Aufnahme variiert mit der Rauchart, dem Produkt und deinem Stoffwechsel. Nichts in dieser App wird an deinem Körper gemessen.';

  @override
  String get howNicotineSources =>
      'Quellen: Benowitz, NEJM 2010 (Aufnahme 1–1,5 mg/Zigarette); Hukkanen et al., Pharmacol Rev 2005 (Plasmahalbwertszeit ~2 h).';

  @override
  String get howWeeksTitle => 'Wie die Wochen-Schätzung berechnet wird';

  @override
  String get howWeeksBody =>
      'Wir vergleichen den Schnitt deiner letzten 7 Tage mit deiner wöchentlichen Reduktionsrate und lösen, wann dein Tagesbudget das Niveau der letzten Woche erreicht. Das Ergebnis ist immer eine Spanne, wöchentlich aktualisiert — nie ein garantiertes Datum.';

  @override
  String get howSavingsTitle => 'Wie die Ersparnis berechnet wird';

  @override
  String get howSavingsBody =>
      'Schachtelpreis geteilt durch Zigaretten pro Schachtel ergibt den Preis je Zigarette. Vermiedene Zigaretten gegenüber deinem Ausgangswert multiplizieren diesen Preis. Deine Preiseingaben bleiben auf dem Gerät.';

  @override
  String get howTitle => 'Wie wird diese Schätzung berechnet?';

  @override
  String motivationStreakBest(int n) {
    return 'Längste Plan-Serie: $n Tage';
  }

  @override
  String get motivationStreakRestart => 'Neu anzufangen ist normal.';

  @override
  String motivationAvoidedTotal(int n) {
    return 'Bisher $n Zigaretten vermieden';
  }

  @override
  String motivationWhoNext(String text) {
    return 'Nächster Meilenstein: $text';
  }

  @override
  String get notificationDailySummaryTitle => 'Heutige Zusammenfassung';

  @override
  String notificationDailySummaryBody(int smoked, int target, String extra) {
    return 'Heute $smoked/$target. $extra';
  }

  @override
  String notificationMorningTitle(int n) {
    return 'Heutiges Ziel: $n';
  }

  @override
  String get notificationMorningBody => 'Ein Tipp genügt — Halen zählt mit.';

  @override
  String get notificationPlanReminderTitle => 'Geplantes Fenster';

  @override
  String get notificationPlanReminderBody =>
      'Dein nächstes geplantes Fenster ist etwa jetzt.';

  @override
  String get notificationQuitSupportTitle => 'Du schaffst das';

  @override
  String get notificationQuitSupportBody =>
      'Gelüste kulminieren früh und ebben ab. Öffne SOS, wenn einer kommt.';

  @override
  String notificationMilestoneTitle(String name) {
    return 'Meilenstein: $name';
  }

  @override
  String get notificationGentleReturnTitle => 'Mach weiter, wo du warst';

  @override
  String get notificationGentleReturnBody =>
      'Seit ein paar Tagen keine Einträge — dein Plan wartet unverändert. Ein Tipp genügt.';

  @override
  String get under18YouthTitle => 'Unterstützung für junge Menschen';

  @override
  String get under18YouthBody =>
      'Halen ist für Erwachsene gebaut und erstellt dir keinen Plan. Es gibt kostenlose, jugendgerechte Hilfe — ein Gespräch mit Arzt/Ärztin, Schulberatung oder einer Aufhör-Hotline ist ein starker erster Schritt.';

  @override
  String get errorDatabaseTitle => 'Datenbank konnte nicht geöffnet werden';

  @override
  String get errorDatabaseBody =>
      'Deine verschlüsselte Datenbank ließ sich auf diesem Gerät nicht entsperren. Es wurde nichts versendet.';

  @override
  String get emptyGeneric => 'Hier ist noch nichts.';

  @override
  String get emptyNoRecords =>
      'Noch keine Einträge — dein erster Tipp startet den Zähler.';

  @override
  String a11yRing(int smoked, int target) {
    return 'Heutiger Ring: $smoked von $target Zigaretten';
  }

  @override
  String get a11yNicotineChart =>
      'Diagramm der geschätzten Nikotin-Exposition. Steigt mit jedem Eintrag, halbiert sich alle zwei Stunden.';

  @override
  String get a11ySavingsChart =>
      'Ersparnis-Chart, kumuliert über den gewählten Zeitraum.';
}
