import 'package:flutter/material.dart';

import 'package:halen/data/notification_service.dart';
import 'package:halen/l10n/generated/app_localizations.dart';

/// Resolves notification content from the app's stored locale without a
/// BuildContext (scheduling happens in controllers). Daily-scheduled
/// notifications carry generic bodies — today's numbers belong to the app,
/// not to a fixed-time push.
NotificationTexts notificationTextsFor(String localeCode) {
  final l10n = lookupAppLocalizations(Locale(localeCode));
  return NotificationTexts(
    summaryTitle: l10n.notifSummaryTitle,
    summaryBody: l10n.notifSummaryGeneric,
    morningTitle: l10n.notifMorningTitle,
    morningBody: l10n.notifMorningBody,
    returnTitle: l10n.notifReturnTitle,
    returnBody: l10n.notifReturnBody,
    quitTitle: l10n.notifQuitTitle,
    quitBody: l10n.notifQuitBody,
    milestoneTitle: l10n.notifMilestoneTitle,
    milestoneBody: l10n.notifMilestoneBody,
    riskyWindowTitle: l10n.notifRiskyWindowTitle,
    riskyWindowBody: l10n.notifRiskyWindowBody,
    trialTitle: l10n.notifTrialTitle,
    trialBody: l10n.notifTrialBody,
  );
}
