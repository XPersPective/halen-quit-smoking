// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get quitlineRegion => 'Land/Region für Beratung';

  @override
  String get quitlineHint =>
      'Die Dienste gelten für die gewählte Region, nicht für Notfälle. Fehlt deine Region, frage eine Fachkraft vor Ort.';

  @override
  String get quitlineOther => 'Andere Region';

  @override
  String get quitlineUnavailable =>
      'Telefon konnte nicht geöffnet werden. Nummer:';

  @override
  String get quitlineCopy => 'Nummer kopieren';

  @override
  String get quitlineTR => 'Türkei';

  @override
  String get quitlineUS => 'USA';

  @override
  String get quitlineDE => 'Deutschland';

  @override
  String get quitlineEngland => 'Vereinigtes Königreich — England';

  @override
  String get quitlineScotland => 'Vereinigtes Königreich — Schottland';

  @override
  String get quitlineWales => 'Vereinigtes Königreich — Wales';

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
  String obStepOf(int n, int total) {
    return 'Schritt $n von $total';
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
      'Gib deinen tatsächlichen Packungspreis ein. Ein Preis ist erforderlich.';

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
  String get obBrandTitle => 'Deine Zigarettenmarke';

  @override
  String get obBrandHint =>
      'Gib deine Marke ein (1–100 Zeichen). Du kannst sie später ändern.';

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
  String get ctaSmoked => 'Ich habe eine geraucht';

  @override
  String get ctaResisted => 'Ich habe widerstanden';

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
  String get sosAfterResisted =>
      'Eingetragen — jede überstandene Attacke zählt.';

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
  String get notifSummaryTitle => 'Dein Tag mit Halen';

  @override
  String notifSummaryBody(int count, int target) {
    return 'Heute: $count/$target. Jede Eintragung hält den Plan ehrlich.';
  }

  @override
  String get notifMorningTitle => 'Dein heutiges Budget wartet in Halen';

  @override
  String get notifMorningBody =>
      'Kleine Schritte zählen. Du bestimmst das Tempo.';

  @override
  String get notifPlanTitle => 'Geplante Zeit nähert sich';

  @override
  String get notifPlanBody => 'Dein nächstes geplantes Fenster beginnt bald.';

  @override
  String get notifReturnTitle => 'Noch da?';

  @override
  String get notifReturnBody =>
      'Seit ein paar Tagen keine Einträge — mach genau da weiter.';

  @override
  String get notifQuitTitle => 'Die ersten Stunden zählen am meisten';

  @override
  String get notifQuitBody =>
      'Die Welle steigt, kippt und fällt. Halte durch — diese App ist bei dir.';

  @override
  String get notifMilestoneTitle => 'Neue Meilenstein';

  @override
  String get notifMilestoneBody =>
      'Ein neuer Gesundheits-Schwellenwert ist erreicht.';

  @override
  String get notifTrialTitle => 'Deine Testphase endet bald';

  @override
  String get notifTrialBody =>
      'Deine Halen-Premium-Testphase endet in zwei Tagen. Die Planwahl liegt ganz bei dir; es wird nichts automatisch abgebucht.';

  @override
  String get notifChannelReminders => 'Erinnerungen';

  @override
  String get notifChannelSupport => 'Unterstützung';

  @override
  String get notifSummaryGeneric => 'Jede Eintragung hält den Plan ehrlich.';

  @override
  String get notifDailySummary => 'Tageszusammenfassung (abends)';

  @override
  String get notifMorningGoal => 'Morgens Ziel';

  @override
  String get notifPlanReminder => 'Geplante Zeit naht';

  @override
  String get notifPermissionOn => 'Benachrichtigungen sind aktiv';

  @override
  String get notifPermissionOffExplainer =>
      'Benachrichtigungen sind aus, also kommen keine Erinnerungen. Du kannst sie hier erlauben oder die App ohne sie nutzen — sonst ändert sich nichts.';

  @override
  String get notifOpenSystemSettings => 'Systemeinstellungen öffnen';

  @override
  String get notifTrialNudge => 'Testphasen-Erinnerung';

  @override
  String get notifTrialNudgeHint =>
      'Ein sanfter Hinweis an Tag 5, bevor die Testphase endet. Aus, solange du es nicht willst.';

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
  String settingsExportDone(String path) {
    return 'Backup gespeichert: $path';
  }

  @override
  String settingsImportDone(int n) {
    return 'Importiert — $n Einträge wiederhergestellt.';
  }

  @override
  String get settingsDeleteAll => 'Alle Daten löschen';

  @override
  String get deleteAllConfirm =>
      'Wirklich alles löschen? Das kann nicht rückgängig gemacht werden.';

  @override
  String get settingsPurchase => 'Halen Premium';

  @override
  String get purchaseCopy => 'Flexible Pläne · Lebenslange Option';

  @override
  String get purchaseCta => 'Premium-Plan auswählen';

  @override
  String get purchaseRestore => 'Kauf wiederherstellen';

  @override
  String get purchaseOwned => 'Dein Halen-Premium-Zugang ist aktiv.';

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
  String get aboutTitle => 'Über Halen';

  @override
  String get aboutSourceShort => 'GPLv3-Copyleft-Open-Source';

  @override
  String get aboutIntro =>
      'Halen unterstützt das Aufhören oder Reduzieren ruhig, evidenzbewusst und mit Fokus auf Privatsphäre.';

  @override
  String get aboutOpenSourceTitle => 'Warum öffentlicher Quelltext?';

  @override
  String get aboutOpenSourceBody =>
      'Der Quelltext wird unter GPLv3 oder später veröffentlicht, damit Menschen ihn prüfen, daraus lernen und ihn gemeinsam verbessern können. Die GPL verbietet die kommerzielle Nutzung nicht, verlangt aber, dass verteilte Änderungen dieselben Freiheiten und den Quelltext zugänglich halten. Einzelheiten stehen im Lizenztext.';

  @override
  String get aboutPrivacyTitle => 'Deine Daten';

  @override
  String get aboutPrivacyBody =>
      'Es gibt kein Konto, keinen Server und keine Analyse. Deine Einträge bleiben in einer verschlüsselten lokalen Datenbank auf diesem Gerät; Export und Löschung findest du in den Einstellungen.';

  @override
  String get aboutSourceCode => 'Quelltext ansehen';

  @override
  String get aboutLicense => 'Lizenz lesen';

  @override
  String get aboutPrivacyPolicy => 'Datenschutzerklärung lesen';

  @override
  String get aboutSupport => 'Support und Feedback';

  @override
  String get articleSourceHeading => 'Evidenz und Quelle';

  @override
  String get aboutOpenLinkError => 'Der Link konnte nicht geöffnet werden.';

  @override
  String get settingsDisclaimerTitle => 'Gesundheitshinweis';

  @override
  String get settingsDisclaimer =>
      'Diese App ist keine medizinische Beratung; zur Behandlung der Nikotinabhängigkeit wende dich an eine Fachkraft. Bei Schwangerschaft, Herzerkrankung oder psychiatrischen Erkrankungen hole bitte zuerst fachlichen Rat ein.';

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
  String get paywallSubtitle =>
      'Wissenschaftliche Freiheit für weniger als den Preis einer Schachtel';

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
  String get paywallFeatureSos =>
      'Das vollständige SOS-Set, Akupressur und Ernährungsratgeber';

  @override
  String get paywallFeatureWidget => 'Widget-Anpassung';

  @override
  String get paywallFeaturePrivacy =>
      '100 % Privatsphäre: kein Konto, kein Server, verschlüsselter lokaler Tresor';

  @override
  String get paywallTrialNote =>
      'Deine 7-tägige kostenlose Testphase startet beim ersten Start — ohne Karte.';

  @override
  String get planTierAnnual => 'Jahresplan';

  @override
  String get planTierAnnualBadge => 'BELIEBTESTE · 50% SPAREN';

  @override
  String planTierAnnualSub(String price) {
    return 'Jahresplan · $price/Jahr · Store-Bedingungen beim Kauf';
  }

  @override
  String get planTierMonthly => 'Monatsplan';

  @override
  String get planTierMonthlySub => 'Flexibles Monatsabo, jederzeit kündbar';

  @override
  String get planTierLifetime => 'Lebenslanger Zugriff';

  @override
  String get planTierLifetimeBadge => 'EINMALIG';

  @override
  String get planTierLifetimeSub =>
      'Einmalige Zahlung, unbegrenzter lebenslanger Zugriff';

  @override
  String get paywallTimelineToday => 'Heute';

  @override
  String get paywallTimelineTitle => 'Deine 7-tägige Halen-Premium-Testphase';

  @override
  String get paywallTimelineTodayDesc =>
      'Vollzugriff startet ohne Karte und ohne automatische Abbuchung.';

  @override
  String get paywallTimelineReminder => 'Tag 5';

  @override
  String get paywallTimelineReminderDesc =>
      'Optional: eine sanfte Erinnerung an Tag 5, wenn du in den Einstellungen «Testphasen-Erinnerung» aktivierst.';

  @override
  String get paywallTimelineBilling => 'Tag 7';

  @override
  String get paywallTimelineBillingDesc =>
      'Die Testphase endet; wähle einen Plan im Store. Es wird nichts automatisch berechnet.';

  @override
  String get paywallCtaTrial => 'Jahresplan wählen';

  @override
  String get paywallCtaSubscribe => 'Jetzt abonnieren';

  @override
  String get paywallCtaLifetime => 'Lebenslang sichern';

  @override
  String get paywallTerms => 'Nutzungsbedingungen (EULA)';

  @override
  String get paywallTermsBody =>
      'Apple Standard End User License Agreement (EULA):\nhttps://www.apple.com/legal/internet-services/itunes/dev/stdeula/\n\nGoogle Play-Nutzungsbedingungen:\nhttps://play.google.com/about/play-terms/\n\nPreis-, Test-, Verlängerungs- und Kündigungsbedingungen werden vor dem Kauf im Bestätigungsbildschirm des jeweiligen Stores angezeigt. Abonnements verlängern sich automatisch, sofern sie nicht mindestens 24 Stunden vor Ablauf des aktuellen Zeitraums gekündigt werden; die Verwaltung erfolgt in den Kontoeinstellungen des App Store bzw. Google Play.';

  @override
  String get paywallPrivacy => 'Datenschutzerklärung';

  @override
  String get paywallPrivacyBody =>
      'Halen sendet keine personenbezogenen Daten, Rauchprotokolle oder Daten zur Verlangensunterstützung an externe Server. Die Datenbank wird auf diesem Gerät mit SQLCipher verschlüsselt; Export und Löschung findest du in den Einstellungen.';

  @override
  String get paywallLegalDisclaimer =>
      'Das Abonnement verlängert sich automatisch, sofern es nicht mindestens 24 Stunden vor Ablauf des aktuellen Zeitraums gekündigt wird. Verwaltung in den Kontoeinstellungen.';

  @override
  String get paywallPlansTitle => 'Premium-Pläne';

  @override
  String get paywallPriceUnavailable => 'Store-Preis nicht verfügbar';

  @override
  String get paywallRestoreSuccess =>
      'Wiederherstellungsanfrage gesendet. Wenn dein Store-Konto einen aktiven Kauf hat, erscheint der Zugang gleich.';

  @override
  String get paywallRestoreNone =>
      'Der Store konnte nicht erreicht werden; versuche es später erneut.';

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
      'Grenzen: Das ist ein Verhaltensmodell, keine Messung. Die Aufnahme variiert mit der Rauchart, dem Produkt und deinem Stoffwechsel. Nichts in dieser App misst deinen Körper.';

  @override
  String get howNicotineSources =>
      'Quellen: Benowitz, NEJM 2010 (Aufnahme 1–1,5 mg/Zigarette); Hukkanen et al., Pharmacol Rev 2005 (Plasmahalbwertszeit ~2 h).';

  @override
  String get howWeeksTitle => 'Wie die Wochen-Schätzung berechnet wird';

  @override
  String get howWeeksBody =>
      'Wir vergleichen den Schnitt deiner letzten 7 Tage mit deiner wöchentlichen Reduktionsrate und lösen, wann dein Tagesbudget das Niveau der letzten Woche erreicht. Das Ergebnis ist immer eine Spanne, wöchentlich aktualisiert — nie ein festes Datum.';

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

  @override
  String get navToday => 'Heute';

  @override
  String get navStats => 'Analysen';

  @override
  String get navPlan => 'Plan';

  @override
  String get navArticles => 'Ratgeber';

  @override
  String get navSos => 'Notfall SOS';

  @override
  String get statsTabDaily => 'Täglicher Trend';

  @override
  String get statsTabHourly => '24h-Verteilung';

  @override
  String get statsTabIntervals => 'Intervalle';

  @override
  String get statsTabTriggers => 'Auslöser';

  @override
  String get intervalTitle => 'Intervalle zwischen Zigaretten';

  @override
  String get intervalSubtitle => 'Zeitdauer zwischen den gerauchten Zigaretten';

  @override
  String get intervalAverage => 'Durchschnittliches Intervall';

  @override
  String get intervalLongest => 'Längste rauchfreie Zeit';

  @override
  String get intervalShortest => 'Kürzestes Intervall';

  @override
  String get intervalCurrent => 'Aktuelle rauchfreie Zeit';

  @override
  String intervalMinutes(int m) {
    return '$m Min.';
  }

  @override
  String intervalHoursMinutes(int h, int m) {
    return '$h Std. $m Min.';
  }

  @override
  String get hourlyTitle => '24-Stunden-Verteilung';

  @override
  String get hourlySubtitle => 'Wann du am Tag rauchst';

  @override
  String hourlyPeak(int hour, int count) {
    return 'Spitzenzeit: $hour:00 ($count Zigaretten)';
  }

  @override
  String get timeMorning => 'Morgen (06–12)';

  @override
  String get timeAfternoon => 'Nachmittag (12–18)';

  @override
  String get timeEvening => 'Abend (18–24)';

  @override
  String get timeNight => 'Nacht (00–06)';

  @override
  String get triggerTitle => 'Auslöser-Analyse';

  @override
  String get triggerSubtitle => 'Was das Verlangen am meisten auslöst';

  @override
  String triggerOccurrences(int count, int percent) {
    return '$count Mal ($percent%)';
  }

  @override
  String get todayLogTitle => 'Heutiges Rauchprotokoll';

  @override
  String get todayLogSubtitle => 'Übersicht der heute gerauchten Zigaretten';

  @override
  String get todayLogEmpty => 'Heute noch keine Zigaretten eingetragen';

  @override
  String get deleteCigaretteConfirm => 'Diesen Eintrag löschen?';

  @override
  String get deletedCigaretteSuccess => 'Eintrag gelöscht';

  @override
  String get articlesTitle => 'Ratgeber & Artikel';

  @override
  String get articlesSubtitle => 'Evidenzbasierte Rauchstopp-Bibliothek';

  @override
  String get articleCategoryAll => 'Alle';

  @override
  String get articleCategoryScience => 'Wissenschaft';

  @override
  String get articleCategoryCrisis => 'Notfallhilfe';

  @override
  String get articleCategoryTriggers => 'Auslöser';

  @override
  String get articleCategoryHealth => 'Gesundheit';

  @override
  String get articleCategoryPsychology => 'Verhalten';

  @override
  String articleReadTime(int min) {
    return '$min Min. Lesezeit';
  }

  @override
  String articleSourceLabel(String source) {
    return 'Wissenschaftliche Quelle: $source';
  }

  @override
  String get articleKeyTakeaways => 'Wichtigste Erkenntnisse & Schritte';

  @override
  String get todayFocusTitle => 'Mehr Freiraum.\nFür dich.';

  @override
  String get todayFocusNote => 'Jede Pause ist ein Schritt.';

  @override
  String get dailyBudgetCaption => 'Einträge / Tagesziel';

  @override
  String get todayOverview => 'Dein Tag im Überblick';

  @override
  String get todaySupportTitle => 'Zeit für eine Atempause';

  @override
  String get todaySupportNote => 'Ein ruhiger Moment, wenn du ihn brauchst.';

  @override
  String get statsIntro => 'Kleine Schritte werden sichtbar.';

  @override
  String get chartActualLabel => 'Erfasst';

  @override
  String get chartTargetLabel => 'Tagesziel';

  @override
  String get chartEmptyTitle => 'Dein Weg beginnt hier';

  @override
  String get chartEmptyBody =>
      'Mit deinen Einträgen wird dein Fortschritt sichtbar.';

  @override
  String get chartTimeBlocks => 'Im Tagesverlauf';

  @override
  String get chartIntervalAxis => 'Zeit zwischen Einträgen · Minuten';

  @override
  String get chartIntervalEmpty =>
      'Zwei Einträge reichen für deinen ersten Abstand.';

  @override
  String get chartTriggerEmpty =>
      'Füge beim Erfassen ein Stichwort hinzu, um Muster zu erkennen.';

  @override
  String get statsSavingsNote => 'Aus deinen Einträgen geschätzt';

  @override
  String get moduleModelTag =>
      'Aus deinen Einträgen berechnet — keine Messung.';

  @override
  String get moduleNeedMoreData =>
      'Noch ein paar Einträge, dann erscheint das hier.';

  @override
  String get moduleSourceLabel => 'Quelle';

  @override
  String get bodyLoadTitle => 'Körperlast';

  @override
  String bodyLoadSinceLast(String time) {
    return '$time seit deiner letzten Zigarette';
  }

  @override
  String bodyLoadNicotineNow(int percent) {
    return 'Die geschätzte Nikotinlast liegt bei $percent% des Höchstwerts.';
  }

  @override
  String bodyLoadCoDrop(int percent) {
    return 'Die modellierte Kohlenmonoxidlast liegt $percent % unter ihrem Höchstwert.';
  }

  @override
  String get loadNicotineAcute => 'Nikotin jetzt';

  @override
  String get loadNicotineBaseline => 'Im Körper angesammeltes Nikotin';

  @override
  String get loadCarbonMonoxide => 'Kohlenmonoxid im Blut';

  @override
  String get loadTar => 'Teeransammlung';

  @override
  String get loadBandLow => 'Niedrig';

  @override
  String get loadBandMedium => 'Mittel';

  @override
  String get loadBandHigh => 'Hoch';

  @override
  String get bodyLoadTarNote =>
      'Teer lässt sich im Körper nicht messen. Dies vergleicht deine Belastung mit deiner eigenen Basis.';

  @override
  String get bodyLoadCoNote =>
      'Kohlenmonoxid baut sich am schnellsten ab — es ändert sich zuerst.';

  @override
  String get bodyLoadEmpty =>
      'Erfasse ein paar Zigaretten, dann erscheint dein Rhythmus hier.';

  @override
  String get ghostPeakLabel => 'Eine Spitze, die nie entstand';

  @override
  String get metabolismTitle => 'Abbau-Tempo';

  @override
  String get metabolismNote =>
      'Nikotin baut sich unterschiedlich schnell ab. Wähle, was zu dir passt — das kalibriert nur die Kurve.';

  @override
  String get metabolismSlow => 'Langsam';

  @override
  String get metabolismNormal => 'Normal';

  @override
  String get metabolismFast => 'Schnell';

  @override
  String get cravingWindowTitle => 'Verlangensfenster';

  @override
  String get cravingRiskCalm => 'Ruhig';

  @override
  String get cravingRiskWatch => 'Achtung';

  @override
  String get cravingRiskHigh => 'Hoch';

  @override
  String get cravingFallingNote =>
      'Verlangen kommt meist beim Absinken des Nikotins, nicht beim Anstieg.';

  @override
  String cravingLowestThird(int percent) {
    return '$percent% deines Verlangens kam, während deine Last im untersten Drittel lag.';
  }

  @override
  String get cravingRiskyHours => 'Deine riskanten Stunden';

  @override
  String cravingWindowRange(int start, int end) {
    return '$start:00–$end:00';
  }

  @override
  String get cravingHeatmapTitle => 'Deine Woche, Stunde für Stunde';

  @override
  String get economyTitle => 'Geld und Zeit';

  @override
  String get economySaved => 'Gespart';

  @override
  String get economySpent => 'Weiterhin ausgegeben';

  @override
  String get economyExactNote =>
      'Nichts hier ist geschätzt — das sind deine eigenen Zahlen.';

  @override
  String get economyProjectionTitle =>
      'Wenn du so weitermachst vs. wenn du deinen Plan beendest';

  @override
  String get economyShadedArea =>
      'Diese schraffierte Fläche ist deine Entscheidung.';

  @override
  String get economyKeepPace => 'Dieses Tempo';

  @override
  String get economyFinishPlan => 'Plan beendet';

  @override
  String get economyTimeLedger => 'Zeitkonto';

  @override
  String get economyTimeRegained => 'Zurückgewonnene Zeit';

  @override
  String get economyTimeLost => 'Verbrauchte Zeit';

  @override
  String get economyLifeAverageNote =>
      'Bevölkerungsdurchschnitt von etwa 20 Minuten je Zigarette — ein Durchschnitt, kein Versprechen.';

  @override
  String get economyGoalTitle => 'Dein Ziel';

  @override
  String get economyGoalHint => 'Wofür sparst du?';

  @override
  String get economyGoalLabel => 'Name des Ziels';

  @override
  String get economyGoalAmount => 'Betrag';

  @override
  String economyGoalRemaining(int days) {
    return 'Noch $days Tage in diesem Tempo';
  }

  @override
  String get mindTitle => 'Gemütslage';

  @override
  String get mindPressureLabel => 'Wahrscheinlicher Entzugsdruck';

  @override
  String get mindBandCalm => 'Ruhig';

  @override
  String get mindBandUnderPressure => 'Unter Druck';

  @override
  String get mindBandTough => 'Hart';

  @override
  String get mindOnlyYouKnow =>
      'Das ist eine Schätzung. Nur du weißt, wie du dich fühlst.';

  @override
  String get mindHowDoYouFeel => 'Wie fühlst du dich gerade?';

  @override
  String mindAccuracy(int percent) {
    return 'Meine Schätzung traf zu $percent% zu.';
  }

  @override
  String get mindQuitLowersAnxiety =>
      'Aufhören senkt im Schnitt Angst und Depression — es erhöht sie nicht.';

  @override
  String get mindTypicalCurve => 'Typischer Verlauf';

  @override
  String get mindPeakNote =>
      'Der Entzug gipfelt an Tag 1–3 und lässt über 3–4 Wochen nach.';

  @override
  String get mindWeightTitle => 'Zum Gewicht';

  @override
  String get mindWeightBody =>
      'Nach dem Aufhören steigt der Appetit; die meiste Gewichtsänderung passiert in den ersten drei Monaten — im Schnitt 4–5 kg im Jahr. Das Risiko ist klein gegenüber dem Rauchen.';

  @override
  String get lungsTitle => 'Deine Lunge heute';

  @override
  String get lungsNotAScan => 'Das ist keine Aufnahme deiner Lunge.';

  @override
  String get lungsSlowsLine => 'Nur Aufhören verlangsamt diese Linie.';

  @override
  String get lungsScenarioNever => 'Nie geraucht';

  @override
  String get lungsScenarioKeep => 'Dieses Tempo';

  @override
  String get lungsScenarioQuit => 'Heute aufhören';

  @override
  String get lungsTypicalLabel => 'Typisch für deine Altersgruppe';

  @override
  String get lungsAxisAge => 'Alter';

  @override
  String get lungsMistLabel => 'Teeransammlung, verglichen mit deinem Üblichen';

  @override
  String get organMapTitle => 'Körperkarte';

  @override
  String get organHarmTitle => 'Was Rauchen bewirkt';

  @override
  String get organRecoveryTitle => 'Was passiert, wenn du aufhörst';

  @override
  String get organTimelineTitle => 'Erholungs-Zeitachse';

  @override
  String get organTimelineCaption =>
      'Zeit seit deiner letzten Zigarette — Populationsdaten, keine persönliche Messung';

  @override
  String get organPopulationNote =>
      'Ergebnisse auf Bevölkerungsebene. Keine persönliche Risikoschätzung.';

  @override
  String get toxicantsTitle => 'Was im Rauch steckt';

  @override
  String toxicantsSubtitle(int chemicals, int carcinogens) {
    return '$chemicals Chemikalien, mehr als $carcinogens davon bekannte Karzinogene';
  }

  @override
  String get toxicantAnalogyLabel => 'Auch zu finden in';

  @override
  String get toxicantMechanismLabel => 'Im Körper';

  @override
  String get toxicantNoDose => 'Eine Erkennungshilfe, kein Dosisvergleich.';

  @override
  String toxicantIarcLabel(String group) {
    return 'IARC-Gruppe $group';
  }

  @override
  String get evidenceStrong => 'Starke Evidenz';

  @override
  String get evidencePromising => 'Vielversprechend';

  @override
  String get evidenceTraditional => 'Traditionell';

  @override
  String get evidenceLabel => 'Evidenz';

  @override
  String get sosWhatWorked => 'Was dir früher geholfen hat';

  @override
  String get sosTechniquesTitle => 'Etwas, das du jetzt tun kannst';

  @override
  String get sosEarPointsTitle => 'Fünf Punkte, je zwölf Sekunden';

  @override
  String get sosEarPointShenMen => 'Shen Men';

  @override
  String get sosEarPointAutonomic => 'Vegetativum';

  @override
  String get sosEarPointKidney => 'Niere';

  @override
  String get sosEarPointLiver => 'Leber';

  @override
  String get sosEarPointLung => 'Lunge';

  @override
  String get sosNoNeedles => 'Nur Finger — niemals Nadeln.';

  @override
  String get progressScoreTitle => 'Fortschrittswert';

  @override
  String get progressWindowLabel => 'letzte 14 Tage';

  @override
  String get progressBandStarting => 'Anfang';

  @override
  String get progressBandOnTrack => 'Auf Kurs';

  @override
  String get progressBandStrong => 'Stark';

  @override
  String get progressBandVeryStrong => 'Sehr stark';

  @override
  String get progressBehaviourNote =>
      'Das misst dein Verhalten, nicht deine Gesundheit.';

  @override
  String progressDeltaUp(int points) {
    return '$points Punkte in 7 Tagen gestiegen';
  }

  @override
  String progressDeltaDown(int points) {
    return '$points Punkte in 7 Tagen gesunken';
  }

  @override
  String get progressDeltaFlat => 'diese Woche stabil';

  @override
  String get harmLoadTitle => 'Schadenslast';

  @override
  String get harmBandLight => 'Leicht';

  @override
  String get harmBandModerate => 'Mittel';

  @override
  String get harmBandHeavy => 'Schwer';

  @override
  String get harmBandVeryHeavy => 'Sehr schwer';

  @override
  String get harmNotRisk => 'Das ist keine Krankheitsrisiko-Schätzung.';

  @override
  String harmPackYears(String value) {
    return '$value Packungsjahre';
  }

  @override
  String get harmMovingPartNote =>
      'Fast die Hälfte sinkt, wenn du reduzierst. Der Rest ist Vergangenheit — Aufhören verlangsamt sie.';

  @override
  String get indicesScissorTitle => 'Fortschritt und Last';

  @override
  String get indicesScissorNote =>
      'Je größer der Abstand, desto besser läuft es.';

  @override
  String get indicesBreakdownTitle => 'Woraus sich diese Zahl ergibt';

  @override
  String get componentAdherence => 'Planeinhaltung';

  @override
  String get componentConsumptionTrend => 'Konsumtrend';

  @override
  String get componentCravingCoping => 'Umgang mit Verlangen';

  @override
  String get componentLoggingConsistency => 'Erfassungs-Konstanz';

  @override
  String get componentNicotineBaselineFall =>
      'Rückgang des angesammelten Nikotins';

  @override
  String get componentCumulativeExposure => 'Kumulative Belastung';

  @override
  String get componentCurrentIntensity => 'Aktuelle Intensität';

  @override
  String get componentDependenceDepth => 'Abhängigkeitstiefe';

  @override
  String get componentAgeAndDuration => 'Alter und Dauer';

  @override
  String get componentBodySize => 'Körpermaße (optional)';

  @override
  String componentWeightLabel(String points, int weight) {
    return '$points von $weight Punkten';
  }

  @override
  String get planKindGradual => 'Schrittweise Reduktion';

  @override
  String get planKindGradualNote =>
      'Vergrößere den Abstand zwischen Zigaretten Schritt für Schritt.';

  @override
  String get planKindQuota => 'Tageskontingent';

  @override
  String get planKindQuotaNote =>
      'Eine Tagesgrenze ohne Uhrzeitregeln — für unregelmäßige Tage.';

  @override
  String get planKindQuitDay => 'Rauchstopp-Tag';

  @override
  String get planKindQuitDayNote =>
      'Wähle ein Datum und erhalte Unterstützung beim Entzug.';

  @override
  String get planKindTrackOnly => 'Nur erfassen';

  @override
  String get planKindTrackOnlyNote =>
      'Kein Ziel, kein Urteil. Nur deine Einträge.';

  @override
  String get planSwitchTitle => 'Plan wechseln';

  @override
  String planTooSoon(int days) {
    return 'Gib diesem Plan noch $days Tage — jeder Plan braucht etwas Zeit.';
  }

  @override
  String get planReportCardTitle => 'Wie dieser Plan läuft';

  @override
  String get planReportDays => 'Tage in diesem Plan';

  @override
  String get planReportAdherence => 'Einhaltung';

  @override
  String get planReportHardestHour => 'Schwerste Stunde';

  @override
  String get planReportResisted => 'Überstandenes Verlangen';

  @override
  String get planSuggestionLabel => 'Für dich empfohlen';

  @override
  String get planFrequentSwitchNote =>
      'Planwechsel ist kein Scheitern — aber jeder Plan braucht ein paar Wochen.';

  @override
  String get planHistoryKept =>
      'Deine Historie bleibt. Nur der Plan ändert sich.';

  @override
  String planStripLabel(String plan, int week) {
    return '$plan · Woche $week';
  }

  @override
  String get taperHoldStep => 'Wir bleiben einen Tag länger auf dieser Stufe.';

  @override
  String taperAdvance(int minutes) {
    return 'Neuer Zielabstand: $minutes Minuten.';
  }

  @override
  String get taperSoftLanding =>
      'Dein Plan wurde neu justiert. Nichts ist verloren.';

  @override
  String logSmokedNeutral(int count, String average) {
    return 'Heute: $count. Dein Schnitt: $average.';
  }

  @override
  String get logNotAFailure => 'Kein Scheitern. Ein Datenpunkt.';

  @override
  String get logSkippedTitle => 'Eine Spitze, die nie entstand';

  @override
  String logSkippedCount(int count) {
    return '$count überstanden in diesem Monat';
  }

  @override
  String logNextTarget(String time) {
    return 'Nächste Zielzeit $time';
  }

  @override
  String get logUndo => 'Rückgängig';

  @override
  String get logPauseTitle => 'Erst zwanzig Sekunden';

  @override
  String get logPauseNote =>
      'Dein Eintrag ist gespeichert. Atme durch — du kannst ihn rückgängig machen.';

  @override
  String get logPauseSettingTitle => 'Pause vor dem Erfassen';

  @override
  String get supportTitle => 'Heutige Unterstützung';

  @override
  String get supportChannelMovement => 'Bewegung';

  @override
  String get supportChannelNutrition => 'Ernährung';

  @override
  String get supportChannelRitual => 'Ritual';

  @override
  String get supportMarkDone => 'Erledigt';

  @override
  String get supportNotATest =>
      'Das ist keine Prüfung. Auslassen kostet nichts.';

  @override
  String get supportWeekTitle => 'Diese Woche';

  @override
  String supportMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String get howBodyLoadTitle => 'Körperlast-Kurven';

  @override
  String get howBodyLoadBody =>
      'Jede Kurve ist C(t) = Summe aus Dosis × 2^(−vergangene Zeit / Halbwertszeit) und speist sich nur aus deinen Einträgen. Halbwertszeiten: Nikotin 2 Std., angesammeltes Nikotin 16 Std. (das daraus entstehende Cotinin), Kohlenmonoxid 4,5 Std., Teeransammlung 30 Tage (repräsentativ).';

  @override
  String get howBodyLoadLimits =>
      'Kein Telefon kann Nikotin, Teer oder Kohlenmonoxid im Körper messen. Werte werden auf 0–100 normiert, nie in ng/mL oder Milligramm.';

  @override
  String get howCravingTitle => 'Verlangensfenster';

  @override
  String get howCravingBody =>
      'Risiko = 0,45 x Tiefe des Nikotintals + 0,35 x Dichte dieser Stunde in deiner Historie + 0,20 x Anteil der Einträge mit Auslöser. Stundensignale bleiben bis ca. 21 Einträgen aus.';

  @override
  String get howProgressTitle => 'Fortschrittswert';

  @override
  String get howProgressBody =>
      'Von 100: Planeinhaltung 35, Konsumtrend 30, Umgang mit Verlangen 20, Erfassungs-Konstanz 10, Sinken der Nikotinbasis 5. 14 Tage Fenster, max. 4 Punkte pro Tag, nie zurückgesetzt.';

  @override
  String get howHarmTitle => 'Schadenslast';

  @override
  String get howHarmBody =>
      'Von 100: kumulative Belastung 40 (Packungsjahre, logarithmisch), aktuelle Intensität 30, Abhängigkeit 15, Alter und Dauer 10, Körpermaße 5. Die Zahl ist ein Lastindex, kein Krankheitsrisiko.';

  @override
  String get howMindTitle => 'Entzugsdruck';

  @override
  String get howMindBody =>
      'Eine veröffentlichte Symptomkurve mit Gipfel an Tag 1–3, skaliert mit der Tiefe deines Nikotintals und korrigiert um die Differenz zu deinen eigenen Angaben. Ausgabe ist ein Band, nie ein Prozentwert.';

  @override
  String get howLungTitle => 'Lungen-Szenarien';

  @override
  String get howLungBody =>
      'Veröffentlichte jährliche FEV1-Abfallraten als drei typische Kurven: Nieraucher ca. 30 mL/Jahr, dauerhafter Aussteiger ca. 33, Raucher 40 bis 70. Bevölkerungsdurchschnitte, keine Messung.';

  @override
  String get settingsBodyDataTitle => 'Körperdaten (optional)';

  @override
  String get settingsBodyDataNote =>
      'Dient nur der Schärfung der Schadenslast. Lässt du es leer, wird nichts gesperrt.';

  @override
  String get settingsHeight => 'Größe (cm)';

  @override
  String get settingsWeight => 'Gewicht (kg)';

  @override
  String get settingsSmokingYears => 'Rauchjahre';

  @override
  String get settingsSex => 'Geschlecht (für das Zeitkonto)';

  @override
  String get sexUnspecified => 'Keine Angabe';

  @override
  String get sexMale => 'Männlich';

  @override
  String get sexFemale => 'Weiblich';

  @override
  String get settingsModelTitle => 'Modell-Einstellungen';

  @override
  String get settingsPrelogPauseNote =>
      'Dein Eintrag wird ohnehin gespeichert; die Pause gibt dir nur einen Moment und ein Rückgängig.';

  @override
  String get dailyCardKnowledge => 'Gut zu wissen';

  @override
  String get dailyCardReality => 'Der harte Teil';

  @override
  String get dailyCardGain => 'Was du gewinnst';

  @override
  String get dailyCardMotivation => 'Für heute';

  @override
  String get dailyCardAction => 'Was du tun kannst';

  @override
  String dailyCardReadMinutes(int minutes) {
    return '$minutes Min. Lesezeit';
  }

  @override
  String get sourcesTitle => 'Wissenschaftliche Quellen';

  @override
  String get sourcesIntro =>
      'Jede Aussage in dieser App stammt aus einer dieser Quellen.';

  @override
  String get economyEquivalentTitle => 'Das entspricht etwa';

  @override
  String get equivalentGroceries => 'ein Monat Lebensmittel';

  @override
  String get equivalentFuelTank => 'eine Tankfüllung';

  @override
  String get equivalentGymMonth => 'ein Monat Fitnessstudio';

  @override
  String get equivalentFlightTicket => 'ein Kurzstreckenflug';

  @override
  String get equivalentPhone => 'ein neues Handy';

  @override
  String economyEquivalentCount(int count, String item) {
    return '${count}x $item';
  }

  @override
  String get cravingWhatToDo => 'Was hier hilft';

  @override
  String cravingSuggestionAt(String time, String technique) {
    return 'Gegen $time greifst du meist zu einer. Wenn es kommt, versuche: $technique';
  }

  @override
  String get cravingOpenToolkit => 'Werkzeugkasten öffnen';

  @override
  String get earGuideTitle => 'Ohr-Akupressur';

  @override
  String get earGuideStart => 'Die 60 Sekunden starten';

  @override
  String earGuideStep(String point, int seconds) {
    return '$point · $seconds Sek.';
  }

  @override
  String get earGuideFinished => 'Die Runde ist komplett.';

  @override
  String toxicantsToday(int count) {
    return '$count heute erfasst';
  }

  @override
  String get loadBandTitle => 'Deine Last, Tag für Tag';

  @override
  String get loadBandWeek => '7 Tage';

  @override
  String get loadBandMonth => '30 Tage';

  @override
  String loadBandTrendDown(int percent) {
    return '$percent% weniger als letzte Woche';
  }

  @override
  String loadBandTrendUp(int percent) {
    return '$percent% mehr als letzte Woche';
  }

  @override
  String get loadBandTrendFlat => 'gleich wie letzte Woche';

  @override
  String get mindAccuracyChartTitle => 'Meine Schätzung vs. dein Gefühl';

  @override
  String lungsGapAt(int age, String points) {
    return 'Mit $age rund $points Punkte Unterschied in der Lungenfunktion.';
  }

  @override
  String get supportWeekNote =>
      'Es geht um das Muster, nicht um ein volles Raster.';

  @override
  String get taperEasiestFirst =>
      'Wir dehnen zuerst deine leichtesten Stunden und lassen die schwersten zuletzt.';

  @override
  String planQuotaToday(int count) {
    return 'Heutige Obergrenze: $count';
  }

  @override
  String motivationSaved(String amount) {
    return 'Du hast $amount behalten, die sonst in Rauch aufgegangen wären.';
  }

  @override
  String motivationRides(int count) {
    return '$count Verlangen in diesem Monat überstanden.';
  }

  @override
  String motivationTime(String time) {
    return '$time zurück, im Bevölkerungsdurchschnitt.';
  }

  @override
  String get motivationTitle => 'Für heute';

  @override
  String get quitDayCoTitle => 'Seit du aufgehört hast';

  @override
  String get quitDayCoBody =>
      'Kohlenmonoxid baut sich am schnellsten ab. Das ist die typische Kurve für die Stunden nach der letzten Zigarette.';

  @override
  String quitDayHoursAxis(int hours) {
    return '$hours Std';
  }

  @override
  String get settingsRiskyWindowReminder =>
      'Hinweis vor deiner riskantesten Stunde';

  @override
  String get settingsRiskyWindowNote =>
      'Standardmäßig aus. Braucht etwa einen Monat Einträge.';

  @override
  String get notifRiskyWindowTitle => 'Deine übliche Stunde steht bevor';

  @override
  String get notifRiskyWindowBody =>
      'Zwanzig Minuten. Ein kurzer Spaziergang jetzt wirkt besser als Willenskraft später.';

  @override
  String get chartLast30Days => 'Letzte 30 Tage';

  @override
  String get chartToday => 'heute';

  @override
  String chartDaysAgo(int days) {
    return 'vor $days T';
  }

  @override
  String get chartNotEnoughYet =>
      'Noch ein paar Tage, dann erscheint diese Linie.';

  @override
  String get indicesProgressLegend => 'Fortschritt — höher ist besser';

  @override
  String get indicesHarmLegend => 'Schadenslast — niedriger ist besser';

  @override
  String get indicesMeaning =>
      'Die grüne Linie ist dein Verhalten, die graue deine Last. Grün hoch und grau runter ist die Richtung, die zählt.';

  @override
  String get indicesAxisCaption =>
      'Punkte, 0-100 — Fortschritt hoch, Last runter ist gut';

  @override
  String get economyMeaning =>
      'Beide Linien zeigen die Ausgaben im nächsten Jahr. Die untere ist der Plan; die schraffierte Fläche bleibt dir.';

  @override
  String get lungsMeaning =>
      'Typische Lungenfunktion deiner Altersgruppe in drei Zukünften. Höher ist besser.';

  @override
  String get mindMeaning =>
      'Was die App schätzte, gegen das, was du sagtest. Wo die Linien auseinandergehen, lag sie falsch.';

  @override
  String get mindLegendGuess => 'Meine Schätzung';

  @override
  String get mindLegendFelt => 'Was du sagtest';

  @override
  String get loadBandMeaning =>
      'Ein Balken pro Tag: je höher, desto mehr trug dein Körper. Der Strich ist der Tageshöchstwert.';

  @override
  String get bodyLoadMeaning =>
      'Jede Spitze ist eine protokollierte Zigarette; die fallende Linie ist Modellabbau, keine Messung. Grüne Marken sind nie entstandene Spitzen.';

  @override
  String get loadAxisCaption =>
      '% deines eigenen Höchstwerts — ein Modell, keine Messung';

  @override
  String get loadAxisNow => 'jetzt';

  @override
  String loadAxisHoursAgo(int hours) {
    return 'vor $hours Std.';
  }

  @override
  String get nowInBodyTitle => 'Gerade in deinem Körper';

  @override
  String get nowInBodyLast => 'Letzte Zigarette';

  @override
  String get nowInBodyNever => 'noch keine';

  @override
  String get nowInBodyOpen => 'Das ganze Bild ansehen';

  @override
  String get nowInBodyEmpty =>
      'Trag die erste Zigarette ein, dann beginnt hier deine Live-Kurve.';

  @override
  String get glossaryTitle => 'Was die Begriffe bedeuten';

  @override
  String get glossaryIntro =>
      'Jeder Begriff dieser App in einem Satz. Kein Fachjargon.';

  @override
  String get glossaryOpen => 'Was bedeuten diese Begriffe?';

  @override
  String get glossaryProgress =>
      'Wie gut du tust, was du dir vorgenommen hast, von 100. Blickt auf zwei Wochen und bewegt sich bewusst langsam.';

  @override
  String get glossaryHarm =>
      'Wie viel Rauchen dein Körper trägt, von 100. Reduzieren senkt etwa die Hälfte.';

  @override
  String get glossaryBodyLoad =>
      'Eine Schätzung dessen, was von deinen Zigaretten noch in dir ist. Berechnet — keine Messung.';

  @override
  String get glossaryCo =>
      'Das Gas im Rauch, das den Sauerstoff im Blut verdrängt. Es verschwindet am schnellsten.';

  @override
  String get glossaryTarLoad =>
      'Wie deine Partikelbelastung zu deinem eigenen Normal steht. Ein Vergleich, keine Menge.';

  @override
  String get glossaryCravingWindow =>
      'Die Stunden, in denen du am häufigsten greifst — aus deinen Einträgen gelernt.';

  @override
  String get glossaryAdherence =>
      'Der Anteil der Tage, an denen du im Plan geblieben bist.';

  @override
  String get glossaryPackYears =>
      'Ein Standardmaß: eine Schachtel täglich für ein Jahr ist ein Packungsjahr.';

  @override
  String get glossaryWithdrawalPressure =>
      'Eine Schätzung, wie schwer der Tag wird. Nur du weißt es — und dein Feedback lehrt die App.';

  @override
  String get glossaryEvidence =>
      'Wie stark die Evidenz ist: stark, vielversprechend oder traditionell ohne Beleg.';

  @override
  String get glossarySoftTaper =>
      'Den Abstand zwischen Zigaretten in kleinen, haltbaren Schritten vergrößern.';

  @override
  String get glossaryTermSoftTaper => 'Sanfte Reduktion';

  @override
  String get glossaryTermPackYears => 'Packungsjahre';

  @override
  String get organTapHint =>
      'Tippe auf einen Punkt, um Wirkung und Erholung zu sehen.';

  @override
  String organImpactAttributable(int percent) {
    return '$percent% dieser Fälle in der Bevölkerung werden dem Rauchen zugeschrieben';
  }

  @override
  String organImpactRelative(int percent) {
    return 'Risiko etwa $percent % höher als bei jemandem, der nie geraucht hat';
  }

  @override
  String get organNotYou =>
      'Das sind Bevölkerungszahlen — keine Messung deines Körpers.';

  @override
  String get obWhyTitle => 'Warum willst du aufhören?';

  @override
  String get obWhyHint =>
      'Wähl das, was heute am ehesten stimmt. Halen zeigt es dir wieder, wenn das Verlangen kommt.';

  @override
  String get reasonChildren => 'Für meine Kinder';

  @override
  String get reasonHealth => 'Für meine Gesundheit';

  @override
  String get reasonMoney => 'Wegen des Geldes';

  @override
  String get reasonFreedom => 'Um nicht beherrscht zu werden';

  @override
  String get reasonSmell => 'Wegen des Geruchs';

  @override
  String get reasonFitness => 'Um besser zu atmen';

  @override
  String get reasonSomeoneAsked => 'Jemand hat mich darum gebeten';

  @override
  String get resultTitle => 'Hier stehst du am Anfang';

  @override
  String get resultSubtitle =>
      'Alles daraus berechnet, was du gerade angegeben hast.';

  @override
  String get resultPerYearPacks => 'Packungen pro Jahr';

  @override
  String get resultPerYearMoney => 'Pro Jahr';

  @override
  String get resultPerYearTime => 'Pro Jahr, mit Rauchen';

  @override
  String get resultDependenceTitle => 'Wie stark dein Körper daran hängt';

  @override
  String get resultDependenceLow => 'Leicht';

  @override
  String get resultDependenceModerate => 'Mittel';

  @override
  String get resultDependenceHigh => 'Stark';

  @override
  String get resultDependenceExplain =>
      'Aus zwei Fragen: wie viele pro Tag und wie schnell nach dem Aufwachen. Das bestimmt nur, wie sanft dein Plan startet.';

  @override
  String get resultFirst72Title => 'So sehen die ersten 72 Stunden aus';

  @override
  String get resultFirst7220m => '20 Minuten';

  @override
  String get resultFirst7220mBody => 'Puls und Blutdruck beginnen zu sinken.';

  @override
  String get resultFirst7212h => '12 Stunden';

  @override
  String get resultFirst7212hBody =>
      'Kohlenmonoxid verschwindet; mehr Sauerstoff gelangt ins Blut.';

  @override
  String get resultFirst7248h => '48-72 Stunden';

  @override
  String get resultFirst7248hBody =>
      'Der härteste Abschnitt und sein Höhepunkt. Geschmack und Geruch kommen zurück.';

  @override
  String get resultStart => 'Los geht es';

  @override
  String get resultSourceNote =>
      'Meilensteine aus WHO- und CDC-Bevölkerungsdaten.';

  @override
  String get quitPlanTitle => 'Dein Ausstiegsplan';

  @override
  String get quitPlanSubtitle =>
      'Fünf Dinge, an denen ein Versuch hält. Keines davon ist Pflicht.';

  @override
  String quitPlanReadiness(int done, int total) {
    return '$done von $total bereit';
  }

  @override
  String get quitDateTitle => 'Ein Datum zum Aufhören';

  @override
  String get quitDateNone => 'Noch nicht gesetzt';

  @override
  String get quitDateSet => 'Datum wählen';

  @override
  String get quitDateChange => 'Datum verschieben';

  @override
  String get quitDateClear => 'Datum entfernen';

  @override
  String get quitDateWhy =>
      'Reduzieren wirkt, wenn es auf einen Tag zielt. Ohne Datum wird daraus meist eine eigene Gewohnheit.';

  @override
  String quitDateIn(int days) {
    return 'In $days Tagen';
  }

  @override
  String get quitDateTomorrow => 'Morgen';

  @override
  String get quitDateToday => 'Heute';

  @override
  String quitDatePassed(int days) {
    return 'Tag $days';
  }

  @override
  String get quitDateTooSoonNote =>
      'Unter drei Tagen bleibt keine Zeit zur Vorbereitung — Medikament holen, jemandem sagen, die Wohnung räumen.';

  @override
  String get quitDateTooFarNote =>
      'Jenseits von sechs Wochen wirkt ein Datum nicht mehr als Zusage. Näher ist besser.';

  @override
  String quitDateMovedNote(int count) {
    return 'Bisher $count mal verschoben. Das ist erlaubt.';
  }

  @override
  String get medicinesTitle => 'Medikamente, die helfen';

  @override
  String get medicinesLead =>
      'Medikamente und Beratung können die Chance auf einen Rauchstopp deutlich erhöhen. Welche Option passt, hängt von deiner Gesundheit und fachlicher Beratung ab.';

  @override
  String get medicinesOtc => 'In der Apotheke erhältlich';

  @override
  String get medicinesPrescription => 'Ärztlich verschreiben lassen';

  @override
  String get medicinesHowItWorks => 'Wie es wirkt';

  @override
  String get medicinesTypicalUse => 'Wie es angewendet wird';

  @override
  String get medicinesCommonMistake => 'Der übliche Fehler';

  @override
  String medicinesRatioPlacebo(int percent) {
    return 'Erhöht die Aufhörchance über Studien hinweg um etwa $percent % gegenüber Scheinbehandlung';
  }

  @override
  String medicinesRatioSingle(int percent) {
    return 'Erhöht die Aufhörchance über Studien hinweg um etwa $percent % gegenüber einer Einzelform';
  }

  @override
  String get medicinesCombinationSuggestion =>
      'Bei deiner Menge ist der übliche Einstieg ein Pflaster plus eine schnelle Form. Frag in der Apotheke danach.';

  @override
  String get medicinesDisclaimer =>
      'Halen verschreibt nichts und verkauft nichts. Dosis, Eignung und Wechselwirkungen beurteilen Apotheke oder Ärztin — besonders in Schwangerschaft, bei Herzkrankheit oder psychiatrischer Erkrankung.';

  @override
  String get copingTitle => 'Die schwierigen Momente';

  @override
  String get copingLead =>
      'Schreib auf, was du stattdessen tust, bevor du drinsteckst. Im Moment zu entscheiden ist der Teil, der scheitert.';

  @override
  String get copingHint => 'Was tust du stattdessen?';

  @override
  String get copingSaved => 'Gespeichert';

  @override
  String get copingEmpty =>
      'Dein Plan ist leer. Schon eine Zeile für deinen schwersten Moment lohnt.';

  @override
  String get notAPuffTitle => 'Kein einziger Zug';

  @override
  String get notAPuffBody =>
      'Die Regel ist keine Willensfrage. Eine Zigarette lehrt das Verlangen neu, dass Rauchen noch funktioniert — daraus werden zehn.';

  @override
  String get notAPuffAccept => 'Ich nehme die Regel an';

  @override
  String get notAPuffTaken => 'Regel angenommen';

  @override
  String get supportPersonTitle => 'Jemand, der Bescheid weiß';

  @override
  String get supportPersonBody =>
      'Einer Person Bescheid zu sagen erhöht die Chancen. Der Vorname reicht — Halen liest keine Kontakte und speichert nichts weiter.';

  @override
  String get supportPersonHint => 'Vorname';

  @override
  String supportPersonDraft(String date) {
    return 'Etwas, das du senden könntest: „Ich höre am $date mit dem Rauchen auf. Wenn ich unausstehlich werde, liegt es daran. Frag mich, wie es läuft.\"';
  }

  @override
  String get supportPersonCopy => 'Nachricht kopieren';

  @override
  String get supportPersonCopied => 'Kopiert';

  @override
  String get moodCheckTitle => 'Zwei Fragen zu deiner Stimmung';

  @override
  String get moodCheckLead =>
      'Wie oft hat dich in den letzten zwei Wochen Folgendes belastet...';

  @override
  String get moodCheckQ1 => 'Wenig Interesse oder Freude an Dingen';

  @override
  String get moodCheckQ2 =>
      'Niedergeschlagenheit, Schwermut oder Hoffnungslosigkeit';

  @override
  String get moodCheckNever => 'Überhaupt nicht';

  @override
  String get moodCheckSomeDays => 'An einzelnen Tagen';

  @override
  String get moodCheckMostDays => 'An mehr als der Hälfte der Tage';

  @override
  String get moodCheckEveryDay => 'Beinahe jeden Tag';

  @override
  String get moodCheckWhy =>
      'Aufhören kann bei anfälligen Menschen gedrückte Stimmung hervorholen. Das ist ein Screening, keine Diagnose, und nichts verlässt dein Handy.';

  @override
  String get moodCheckResultClear =>
      'Nichts deutet darauf hin, dass du etwas ändern musst. Frag jederzeit erneut.';

  @override
  String get moodCheckResultTalk =>
      'Dieser Wert liegt in dem Bereich, in dem ein Arztgespräch sinnvoll ist — nicht weil Aufhören falsch für dich wäre, sondern weil gedrückte Stimmung behandelbar ist.';

  @override
  String get moodCheckDone => 'Fertig';

  @override
  String get slipTitle => 'Das war eine Zigarette';

  @override
  String get slipBody =>
      'Eine ist ein Ausrutscher, nicht das Ende. Was die nächste Woche entscheidet, ist die nächste Stunde.';

  @override
  String get slipAction =>
      'Wirf den Rest weg und geh jetzt zum Plan zurück — nicht morgen, nicht am Montag.';

  @override
  String get slipClusteringTitle => 'Es wird schwerer';

  @override
  String get slipClusteringBody =>
      'Mehrere in einer Woche heißt meist, die Situation ist stärker als der Plan — nicht, dass du schwach bist. Jetzt hilft Medikation am meisten.';

  @override
  String get slipRelapseTitle => 'Der Versuch ist zurückgerutscht';

  @override
  String get slipRelapseBody =>
      'Die meisten, die dauerhaft aufhören, haben das mehrfach erlebt. Der Versuch, der hält, ist selten der erste.';

  @override
  String get slipSetNewDate => 'Neues Datum setzen';

  @override
  String get slipSeeMedicines => 'Sieh, was Medikamente können';

  @override
  String get quitDayTitle => 'Heute ist der Tag';

  @override
  String get quitDayLead =>
      'Der erste Tag ist vor allem Logistik. Hier ist das Ganze.';

  @override
  String get quitDayMorning => 'Heute Morgen';

  @override
  String get quitDayMorningBody =>
      'Wirf jede Zigarette, jedes Feuerzeug und jeden Aschenbecher weg. Nicht verstecken — weg.';

  @override
  String get quitDayAfternoon => 'Heute Nachmittag';

  @override
  String get quitDayAfternoonBody =>
      'Die ersten Schübe kommen in Wellen von wenigen Minuten. Geh, trink Wasser, atme — sie gehen vorbei, ob du rauchst oder nicht.';

  @override
  String get quitDayEvening => 'Heute Abend';

  @override
  String get quitDayEveningBody =>
      'Der Abend ist die härteste Stunde von Tag eins. Ändere, was du in dieser Stunde tust — nicht nur, was du in der Hand hältst.';

  @override
  String quitDayReasonReminder(String reason) {
    return 'Du hast gesagt, du tust das: $reason.';
  }

  @override
  String get helplineTitle => 'Ein Mensch am Telefon';

  @override
  String get helplineBody =>
      'Beratungstelefone wirken — ein Gespräch mit geschulten Beratenden erhöht die Chancen für sich genommen.';

  @override
  String get statusTitle => 'Wo du stehst';

  @override
  String get statusSwipeHint => 'Für das Nächste wischen';

  @override
  String get statusOpen => 'Alle deine Zahlen ansehen';

  @override
  String get statusPageNicotine => 'Nikotin';

  @override
  String get statusPageOxygen => 'Kohlenmonoxid im Blut';

  @override
  String get statusPageBaseline => 'Im Körper angesammeltes Nikotin';

  @override
  String get statusPageParticles => 'Teeransammlung';

  @override
  String get statusPageProgress => 'Fortschrittswert';

  @override
  String get statusPageHarm => 'Schadenslast';

  @override
  String get statusPageMoney => 'Geld';

  @override
  String get statusPageTime => 'Zeit';

  @override
  String get statusNeedsData =>
      'Noch ein paar Einträge, dann zeichnet sich das von selbst.';

  @override
  String get celebrateTitle => 'Das ist ein echter';

  @override
  String get celebrateClose => 'Weiter';

  @override
  String get celebrateDay1 => 'Ein ganzer Tag';

  @override
  String get celebrateDay3 => 'Drei Tage — über den Höhepunkt';

  @override
  String get celebrateWeek1 => 'Eine Woche';

  @override
  String get celebrateMonth1 => 'Ein Monat';

  @override
  String get celebrateResisted100 => '100 Verlangen ausgehalten';

  @override
  String get commonNotNow => 'Jetzt nicht';

  @override
  String get commonOpen => 'Öffnen';

  @override
  String get todaySectionState => 'Wo du stehst';

  @override
  String get todaySectionSupport => 'Heutige Unterstützung';

  @override
  String get startupFailTitle => 'Halen konnte seine Datenbank nicht öffnen';

  @override
  String get startupFailBody =>
      'Der verschlüsselte Speicher auf diesem Gerät ließ sich nicht öffnen, deshalb hat die App abgebrochen statt ohne ihn zu starten.';

  @override
  String get startupFailDataSafe =>
      'Es ist nichts verloren gegangen und nichts wurde irgendwohin gesendet. Wenn das wieder passiert, ist das Detail unten das, was Entwickelnde brauchen.';

  @override
  String get startupFailRetry => 'Erneut versuchen';

  @override
  String get startupFailDetailTitle => 'Technisches Detail';

  @override
  String get startupFailCopy => 'Detail kopieren';

  @override
  String get startupFailUnknown => 'Kein weiteres Detail gemeldet.';

  @override
  String get smokedHeadline0 =>
      'Erfasst. Das Nikotinmodell wurde neu berechnet.';

  @override
  String get smokedHeadline1 =>
      'Zigarette protokolliert. Das Kohlenmonoxidmodell wurde neu berechnet.';

  @override
  String get smokedHeadline2 =>
      'Eintrag aktualisiert. Bleib auf deinem Rhythmus.';

  @override
  String get smokedHeadline3 =>
      'Gespeichert. Die nächste hinauszuzögern, liegt in deiner Hand.';

  @override
  String get smokedAdvice0 =>
      'Wenn es hilft, trink kaltes Wasser in kleinen Schlucken; es beschäftigt Mund und Hände, während der Drang nachlässt.';

  @override
  String get smokedAdvice1 =>
      'Steh auf und mach einen kurzen Spaziergang. Ein Umgebungswechsel schwächt den Drang.';

  @override
  String get smokedAdvice2 =>
      'Nimm einen tiefen Atemzug. Gönne deinem Körper mindestens eine Stunde Pause.';

  @override
  String get smokedAdvice3 =>
      'Es gibt keine feste Abbauzeit für jede Person. Die modellierte Nikotinkurve fällt über Stunden; Wasser beschleunigt diese Biologie nicht.';

  @override
  String get splashContinue => 'Weiter';

  @override
  String get packTitle => 'Meine Packung';

  @override
  String packLabelLine(String tar, String nicotine) {
    return 'Etikett: $tar mg Teer, $nicotine mg Nikotin pro Zigarette';
  }

  @override
  String get packLabelDefaulted =>
      'Bis du die Werte deiner Packung einträgst, gilt der gesetzliche Höchstwert.';

  @override
  String get packTar => 'Teer pro Zigarette (mg)';

  @override
  String get packNicotine => 'Nikotin pro Zigarette (mg)';

  @override
  String get packLabelHint =>
      'Steht seitlich auf der Packung. Leer lassen für den gesetzlichen Höchstwert (10 mg Teer, 1 mg Nikotin).';

  @override
  String get purchasesTitle => 'Meine Packungskäufe';

  @override
  String get purchasesAdd => 'Kauf hinzufügen';

  @override
  String get purchasesEmpty =>
      'Noch keine Käufe. Trag deine Packungen ein und du siehst, was die Gewohnheit wirklich kostet, Monat für Monat.';

  @override
  String get purchasesThisMonth => 'Diesen Monat ausgegeben';

  @override
  String get purchasesLastMonth => 'Letzten Monat';

  @override
  String purchasesEvery(String days) {
    return 'Im Schnitt alle $days Tage eine Packung';
  }

  @override
  String purchasesMonthlyRate(String amount) {
    return 'In diesem Tempo etwa $amount im Monat';
  }

  @override
  String get purchasesChartTitle => 'Ausgaben pro Monat';

  @override
  String get purchasesChartMeaning =>
      'Ein Balken pro Monat: was für Zigaretten ausgegeben wurde. Der volle Balken ist dieser Monat.';

  @override
  String get purchasesChartAxis => 'ausgegebener Betrag';

  @override
  String get purchasesHistory => 'Verlauf';

  @override
  String get purchasesDeleted => 'Kauf entfernt';

  @override
  String get purchasesDate => 'Datum';

  @override
  String get purchasesPacks => 'Packungen';

  @override
  String get purchasesPrice => 'Preis pro Packung';

  @override
  String get purchasesPackSize => 'Zigaretten';

  @override
  String get purchasesBrand => 'Marke (optional)';

  @override
  String get purchasesUpdatesPack =>
      'Das wird deine aktuelle Packung, damit jede Kostenangabe dem folgt, was du wirklich bezahlt hast.';

  @override
  String get tarTitle => 'Aufgenommener Teer';

  @override
  String get tarThisWeek => 'Diese Woche';

  @override
  String get tarThisMonth => 'Letzte 30 Tage';

  @override
  String tarPicture(String count, String measure) {
    return 'etwa $count $measure';
  }

  @override
  String get measureTeaSpoon => 'Teelöffel';

  @override
  String get measureDessertSpoon => 'Dessertlöffel';

  @override
  String get measureTableSpoon => 'Esslöffel';

  @override
  String get measureWaterGlass => 'Wassergläser';

  @override
  String tarGrams(String grams) {
    return '$grams g';
  }

  @override
  String get tarChartMeaning =>
      'Teer, der jede Woche in deine Lunge kam — aus deiner Zählung und dem Packungsetikett.';

  @override
  String get tarChartAxis => 'Gramm Teer pro Woche';

  @override
  String tarWeekShort(int n) {
    return '$n Wo';
  }

  @override
  String tarBasis(String tar) {
    return 'Berechnet aus $tar mg Teer pro Zigarette laut Etikett. Das ist eine Untergrenze: Menschen ziehen tiefer als die Prüfmaschine, die echte Aufnahme ist meist höher.';
  }

  @override
  String get tarSpoonNote =>
      'Löffel nach Volumen, Teer mit etwa 1 g pro Milliliter gerechnet. Ein Teelöffel fasst etwa 2,5 mL.';

  @override
  String get organExposureTitle => 'Dieses Organ, letzte 24 Stunden';

  @override
  String organExposureNow(int percent) {
    return 'Gerade: $percent % des heutigen Höchstwerts';
  }

  @override
  String get organExposureMeaning =>
      'Jede Spitze ist eine protokollierte Zigarette als Eingang in ein relatives Modell; der Abfall ist Modellabbau, keine Organmessung.';

  @override
  String organExposureLoads(String loads) {
    return 'Getrieben von: $loads';
  }

  @override
  String organSinceLast(String time) {
    return 'Seit der letzten Zigarette: $time';
  }

  @override
  String get organAcuteHeart =>
      'Rauchen kann Herzfrequenz und Blutdruck erhöhen; Ausmaß und Dauer unterscheiden sich.';

  @override
  String get organAcuteVessels =>
      'Nikotin kann Blutgefäße verengen; Zeitpunkt und Dauer unterscheiden sich.';

  @override
  String get organAcuteLungs =>
      'Rauch kann die feinen Härchen der Atemwege beeinträchtigen; die App kann Teer in deiner Lunge nicht schätzen.';

  @override
  String get organAcuteBrain =>
      'Inhaltiertes Nikotin erreicht das Gehirn schnell; sinkende Spiegel und gelernte Auslöser können neues Verlangen begünstigen.';

  @override
  String get organAcuteBlood =>
      'Kohlenmonoxid verringert die Sauerstofftransportkapazität; nach dem Aufhören sinkt der Wert meist, der Zeitraum ist individuell.';

  @override
  String get organAcuteGeneral =>
      'Rauch enthält Schadstoffe, die viele Organe erreichen können; dies ist eine Erklärung auf Bevölkerungsebene, keine persönliche Messung.';

  @override
  String get envTitle => 'Was die Umwelt zurückbekommt';

  @override
  String envTrees(String count) {
    return '$count Bäume nicht gefällt';
  }

  @override
  String envButts(int count) {
    return '$count Filter nicht in der Natur';
  }

  @override
  String get envBasis =>
      'Laut WHO geht für etwa 300 hergestellte Zigaretten ein Baum verloren, meist für das Trocknen von Tabak und für Papier. Filter sind Plastik (Celluloseacetat) und der häufigste Abfall der Welt.';

  @override
  String get envPlantTitle => 'Einen echten Baum pflanzen';

  @override
  String get envPlantBody =>
      'Ein kleiner Teil des Gesparten kann einen echten Setzling pflanzen. Halen nimmt dafür kein Geld und verdient nichts; die Knöpfe öffnen die Organisationen direkt.';

  @override
  String envSavedCovers(int count) {
    return 'Mit dem bisher Gesparten ließen sich etwa $count Setzlinge pflanzen.';
  }

  @override
  String get envOpenFailed => 'Link konnte nicht geöffnet werden.';

  @override
  String get measureDrop => 'Tropfen';

  @override
  String get tarThisWeekShort => 'jetzt';

  @override
  String get envTreesLabel => 'Bäume';

  @override
  String get envFiltersLabel => 'Filter';

  @override
  String get callQuitlineA171 => 'Türkei Rauchstopp-Hotline (ALO 171)';

  @override
  String get callYedam115 => 'YEDAM Beratungshotline (115)';

  @override
  String get callQuitlineUs => 'US Quitline (1-800-QUIT-NOW)';

  @override
  String get callQuitlineUk => 'UK NHS Smokefree (0300 123 1044)';

  @override
  String get callQuitlineDe => 'BZgA Beratungstelefon (0800 8 313131)';

  @override
  String get callQuitlineFr => 'Frankreich Tabac Info (39 89)';

  @override
  String get nutritionGuideTitle => 'Ernährungs- & Flüssigkeitsratgeber';

  @override
  String get nutritionGuideSubtitle =>
      'Vitamin C, basische Kost und akute Flüssigkeitszufuhr';

  @override
  String get planCardTitle => 'Aktiver Plan & Rhythmus';

  @override
  String get planCardSwitch => 'Plan verwalten / wechseln';

  @override
  String planCardTarget(int count) {
    return 'Heutiges Ziel: $count Zigaretten';
  }

  @override
  String get planCardNextInterval => 'Nächstes empfohlenes Intervall';

  @override
  String get economyHistoricalTitle => 'Lebenslange Ausgaben fürs Rauchen';

  @override
  String get economyHistoricalSubtitle =>
      'Geschätzte Gesamtausgaben für Zigaretten in der Vergangenheit';

  @override
  String get economyTimeFilter1m => '1 Monat';

  @override
  String get economyTimeFilter1y => '1 Jahr';

  @override
  String get economyTimeFilterAll => 'Gesamte Zeit (Halen)';

  @override
  String get economyTimeFilterLifetime => 'Rauchgeschichte';

  @override
  String get progressScoreExplainer =>
      'Zieltreue-Score (von 100): Einhaltung der Tagesquoten, Vergrößerung der Abstände und Widerstandskraft.';

  @override
  String get mindPressureExplainer =>
      'Nikotinentzugsdruck: Simulation des biologischen Drucks der Nikotinrezeptoren. Spitzen sind vorübergehend (~5-10 Min.).';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get languageSystem => 'Systemstandard';

  @override
  String get languageEn => 'English';

  @override
  String get languageTr => 'Türkçe';

  @override
  String get languageDe => 'Deutsch';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get todayLogFirstOfDay => 'Erste des Tages';

  @override
  String todayLogGapHours(int h, int m) {
    return '+$h Std $m Min später';
  }

  @override
  String todayLogGapMinutes(int m) {
    return '+$m Min später';
  }

  @override
  String get loadTarToday => 'Teer (heute)';

  @override
  String get nowInBodyCleaning => 'Abbau läuft';

  @override
  String get sosInternationalLines => 'Internationale Rauchstopp-Hotlines';

  @override
  String get economyPastSpentNote =>
      'Dieses Geld ist bereits ausgegeben. Mit Halen aufzuhören sorgt dafür, dass dein Vermögen — und deine Lebenszeit — in den kommenden Jahren in deiner Tasche bleibt.';

  @override
  String economyYearsLabel(String years) {
    return '$years J. / Zigaretten';
  }

  @override
  String economyCigaretteCount(String count) {
    return '$count Zigaretten';
  }

  @override
  String earPointOf(int n) {
    return 'Punkt $n/5';
  }

  @override
  String earPointLocation(String location) {
    return 'Position: $location';
  }

  @override
  String get earPointShenMenTitle => 'Shen Men (Geistestor)';

  @override
  String get earPointShenMenLocation =>
      'Obere Dreieckgrube (Fossa triangularis) des Ohrs';

  @override
  String get earPointShenMenEffect =>
      'Stimuliert das parasympathische Nervensystem; beruhigt Angst, Panik und Stresshormone (Kortisol) in einem Craving.';

  @override
  String get earPointShenMenInstruction =>
      'Mit dem Zeigefinger sanft in die Vertiefung drücken und kleine kreisende Bewegungen ausführen. Beim Einatmen 4 Sek. Druck aufbauen, beim Ausatmen 6 Sek. lösen.';

  @override
  String get earPointAutonomicTitle => 'Sympathikus-/Autonomer Punkt';

  @override
  String get earPointAutonomicLocation =>
      'Oberer Rand der inneren Falte (Helixwurzel)';

  @override
  String get earPointAutonomicEffect =>
      'Löst die Vasokonstriktion (Gefäßverengung) und stabilisiert den durch den Nikotinabfall beschleunigten Puls und die körperliche Anspannung.';

  @override
  String get earPointAutonomicInstruction =>
      'Mit der Fingerkuppe sanft auf den Knorpelrand drücken. Auf den Puls achten und die Schultern locker lassen.';

  @override
  String get earPointKidneyTitle => 'Nierenpunkt';

  @override
  String get earPointKidneyLocation => 'Oberer innerer Bereich der Conchahöhle';

  @override
  String get earPointKidneyEffect =>
      'Lindert Angst und Erschöpfung der Willenskraft; unterstützt den Stoffwechsel der Nieren beim Ausleiten von Toxinen und Teer.';

  @override
  String get earPointKidneyInstruction =>
      'Den Daumen als Stütze hinter das Ohr legen und mit dem Zeigefinger rhythmisch leicht auf die obere Conchahöhle drücken.';

  @override
  String get earPointLiverTitle => 'Leberpunkt';

  @override
  String get earPointLiverLocation =>
      'Mittlerer hinterer Bereich der Conchahöhle';

  @override
  String get earPointLiverEffect =>
      'Beruhigt entzugsbedingte Wut, Gereiztheit, Ungeduld und den impulsiven Drang, eine Zigarette anzuzünden.';

  @override
  String get earPointLiverInstruction =>
      'Die hintere Wand der Concha kreisförmig massieren. Die Stelle kann bei Anspannung leicht empfindlich sein; niemals bis zum Schmerz drücken.';

  @override
  String get earPointLungTitle => 'Lungenpunkt';

  @override
  String get earPointLungLocation =>
      'Mitte und unterer Bereich der Conchahöhle';

  @override
  String get earPointLungEffect =>
      'Löst den Krampf des Luftbedürfnisses in den Atemwegen; vertieft und erleichtert die Atmung.';

  @override
  String get earPointLungInstruction =>
      'Den Finger direkt oberhalb und hinter dem Gehörgang platzieren. Mit jedem Ausatmen den Druck leicht erhöhen.';

  @override
  String nutritionClinicalBase(String basis) {
    return 'Klinische Grundlage: $basis';
  }

  @override
  String get nutritionPillar1Title => '1. Eiskaltes Wasser (Vagus-Stimulation)';

  @override
  String get nutritionPillar1Basis =>
      'Stimulation der oropharyngealen Thermorezeptoren und Aktivierung des Vagotonus.';

  @override
  String get nutritionPillar1Body =>
      'Wenn ein Craving kommt, trinke ein Glas eiskaltes Wasser durch einen Strohhalm, Schluck für Schluck.\n\n• Kaltes Wasser irritiert die nikotinischen Sinnesrezeptoren in Rachen und Mund.\n• Es aktiviert das parasympathische System (Nervus vagus) und senkt erhöhten Puls und Angst innerhalb von Minuten.\n• Es ersetzt Hand-Mund-Bewegungen und füllt die psychomotorische Leere.';

  @override
  String get nutritionPillar2Title =>
      '2. Basische Lebensmittel (Urin-pH und Nikotin-Clearance)';

  @override
  String get nutritionPillar2Basis =>
      'Saurer Urin beschleunigt die Nikotin-Elimination, während ein basischer pH die Nikotinspiegel gleichmäßiger hält (Beckett & Rowland, 1965).';

  @override
  String get nutritionPillar2Body =>
      'Wenn der Körper sauer ist, scheiden die Nieren Nikotin schnell aus dem Blut aus — das verursacht heftige, plötzliche Entzugskrisen.\n\n• Gurkenscheiben, Staudensellerie, rohe Mandeln, Karotten und grünes Blattgemüse verschieben den Urin ins Basische.\n• So fällt der Nikotinspiegel sanft statt abrupt, und Cravings werden seltener.\n• Gurken- oder Karottenstäbchen griffbereit zu haben, ist ein perfekter Kau-Reflex im Craving-Moment.';

  @override
  String get nutritionPillar3Title =>
      '3. Vitamin-C-Unterstützung (Antioxidans-Schild)';

  @override
  String get nutritionPillar3Basis =>
      'Freie Radikale im Tabakrauch verbrauchen die Plasmaspeicher an Ascorbinsäure (Vitamin C) um 30–50 %.';

  @override
  String get nutritionPillar3Body =>
      'Der Nikotinentzug erzeugt eine akute Stressreaktion, und die Nebennieren verbrauchen große Mengen Vitamin C.\n\n• Frisch gepresstes lauwarmes Zitronenwasser, Kiwi, Erdbeeren, Orangen und rote Paprika füllen die Vitamin-C-Speicher schnell auf.\n• Über die Kortisol-Regulation lindert es die Erschöpfung und Gereiztheit des Entzugs.';

  @override
  String get nutritionPillar4Title =>
      '4. Koffein- und Zucker-Warnung (Die kritische Falle)';

  @override
  String get nutritionPillar4Basis =>
      'Tabakrauch stimuliert das Leberenzym CYP1A2, das Koffein schnell abbaut; nach dem Aufhören verlangsamt sich die Koffein-Clearance um etwa 50 %.';

  @override
  String get nutritionPillar4Body =>
      'Wenn du reduzierst oder aufhörst:\n\n• Kaffee bleibt doppelt so lange im Blut! Deine gewohnte Menge kann jetzt Herzrasen, Zittern und Panik verursachen. Die meisten halten das für einen Nikotin-Craving — es ist eine Koffein-Überladung. Reduziere deinen Kaffeekonsum um 50 %.\n• Einfache Zucker (Schokolade, Sirup-Süßigkeiten) erzeugen steile Blutzuckerspitzen und -abstürze (reaktive Hypoglykämie), was den Dopamin-Hunger und das Rauchverlangen anheizt. Greife stattdessen zu ballaststoffreichen Snacks.';
}
