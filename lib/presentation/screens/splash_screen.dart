import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;

import 'package:halen/application/providers.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/widgets/notification_permission_card.dart';

import '../../core/design/tokens.dart';
import '../../data/db/app_database.dart';

/// Screen 1: splash / permission rationale / privacy promise (report §12).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  /// Null while we find out; true only on a first launch.
  bool? _firstLaunch;
  bool _requiresTrialConsent = false;
  bool _onboarded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _route());
  }

  Future<void> _route() async {
    final onboarded = await ref.read(hasOnboardedProvider.future);
    _onboarded = onboarded;
    if (!mounted) {
      return;
    }
    if (onboarded) {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        final settings = await ref
            .read(databaseProvider)
            .settingsDao
            .getSettings();
        if (!mounted) return;
        if (settings.androidTrialConsent == null) {
          setState(() => _requiresTrialConsent = true);
          return;
        }
      }
      // A returning user has read the privacy promise and the medical note
      // already, and both live in Settings. Showing them on every launch is
      // the kind of delay that makes an app feel slow, so we go straight in.
      Navigator.pushReplacementNamed(context, Routes.today);
      return;
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final settings = await ref
          .read(databaseProvider)
          .settingsDao
          .getSettings();
      if (!mounted) return;
      _requiresTrialConsent = settings.androidTrialConsent == null;
    }
    // First launch: stay put. This screen used to route away on its own
    // first frame, so the privacy promise, the medical note and the
    // notification question flashed past unread — and its own Start button
    // was unreachable. The person moves on when they tap it.
    setState(() => _firstLaunch = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    if (_firstLaunch != true && !_requiresTrialConsent) {
      // A plain frame in the app's own ground while we check. The native
      // launch window is the same colour, so this reads as one continuous
      // start rather than a flash of text.
      return const Scaffold(body: SizedBox.shrink());
    }
    if (_requiresTrialConsent && _firstLaunch != true) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(HalenSpace.x6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.trialPrivacyTitle,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: HalenSpace.x3),
                  Text(l10n.trialPrivacyBody, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: HalenSpace.x6),
                  FilledButton(
                    onPressed: () => _answerTrialConsent(true),
                    child: Text(l10n.trialPrivacyAccept),
                  ),
                  TextButton(
                    onPressed: () => _answerTrialConsent(false),
                    child: Text(l10n.trialPrivacyDecline),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(HalenSpace.x6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: HalenSpace.x6),
                // Abstract mark: breathing ring (no cigarette imagery, §12).
                Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primaryContainer,
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 64,
                        height: 64,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(color: Colors.white, width: 6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: HalenSpace.x6),
                Text(
                  l10n.splashWelcomeTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: HalenSpace.x2),
                Text(
                  l10n.splashTagline,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: HalenSpace.x6),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(HalenSpace.x4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bullet(context, l10n.splashPrivacyLine),
                        const SizedBox(height: HalenSpace.x2),
                        _bullet(context, l10n.splashBackupLine),
                      ],
                    ),
                  ),
                ),
                if (_requiresTrialConsent) ...[
                  const SizedBox(height: HalenSpace.x3),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(HalenSpace.x4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.trialPrivacyTitle,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: HalenSpace.x2),
                          Text(l10n.trialPrivacyBody),
                          const SizedBox(height: HalenSpace.x3),
                          FilledButton(
                            onPressed: () => _answerTrialConsent(true),
                            child: Text(l10n.trialPrivacyAccept),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () => _answerTrialConsent(false),
                              child: Text(l10n.trialPrivacyDecline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: HalenSpace.x4),
                Text(l10n.splashMedicalNote, style: theme.textTheme.bodySmall),
                const SizedBox(height: HalenSpace.x6),
                // Notification rationale + allow button (report §20: the
                // explanation is always shown before the runtime request).
                // Notification status from the OS, with rationale, the ask
                // and the settings shortcut (brain T2). Refusal never blocks
                // starting and the card re-reads the OS state on resume.
                const NotificationPermissionCard(),
                const SizedBox(height: HalenSpace.x8),
                FilledButton(
                  onPressed: _requiresTrialConsent
                      ? null
                      : () => Navigator.pushReplacementNamed(
                          context,
                          Routes.onboarding,
                        ),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    foregroundColor: theme.colorScheme.onTertiary,
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: Text(
                    l10n.splashStart,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _answerTrialConsent(bool accepted) async {
    await ref
        .read(databaseProvider)
        .settingsDao
        .updateSettings(
          SettingsCompanion(androidTrialConsent: Value(accepted)),
        );
    if (!mounted) return;
    if (_onboarded) {
      Navigator.pushReplacementNamed(context, Routes.today);
    } else {
      setState(() {
        _requiresTrialConsent = false;
      });
    }
  }

  Widget _bullet(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.check_circle_outline, size: 18),
        ),
        const SizedBox(width: HalenSpace.x2),
        Expanded(child: Text(text)),
      ],
    );
  }
}
