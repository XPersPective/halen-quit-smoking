import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/design/tokens.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/design/halen_components.dart';

/// Shown when the encrypted database could not be opened.
///
/// This screen exists because of a crash on a real device. `main()` caught
/// the failure and passed a `databaseFailed` flag into the app — and the flag
/// was then used for exactly one thing: skipping a background queue drain.
/// Every screen still ran, the splash still asked for the database, and the
/// app died before drawing a single frame. From outside it looked like the
/// app opened and instantly closed, with nothing to go on.
///
/// So the rule this screen enforces: **a failure the app already caught must
/// never be invisible.** It says what happened in plain language, offers the
/// only two useful actions, and carries the technical detail behind a
/// disclosure so it can be read out or copied without putting a stack trace
/// in front of somebody trying to stop smoking.
class StartupFailureScreen extends StatelessWidget {
  const StartupFailureScreen({
    super.key,
    required this.error,
    required this.onRetry,
  });

  /// The underlying failure, verbatim. Never rewritten — a paraphrased error
  /// is one nobody can search for.
  final Object? error;

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final detail = error?.toString() ?? l10n.startupFailUnknown;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: HalenSpace.screen,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 40,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: HalenSpace.x4),
                  Text(
                    l10n.startupFailTitle,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: HalenSpace.x3),
                  Text(
                    l10n.startupFailBody,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: HalenSpace.x3),
                  Text(
                    l10n.startupFailDataSafe,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: HalenSpace.x6),
                  FilledButton.icon(
                    onPressed: onRetry,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.startupFailRetry),
                  ),
                  const SizedBox(height: HalenSpace.x5),
                  HalenCard(
                    emphasis: CardEmphasis.quiet,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.startupFailDetailTitle,
                          style: theme.textTheme.labelLarge,
                        ),
                        const SizedBox(height: HalenSpace.x2),
                        SelectableText(
                          detail,
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: HalenSpace.x3),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            icon: const Icon(Icons.copy_rounded, size: 18),
                            label: Text(l10n.startupFailCopy),
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: detail),
                              );
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.supportPersonCopied),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
