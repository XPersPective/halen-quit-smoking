import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';
import '../../../domain/progress_index.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Shown instead of the Progress Score until [calibrationDays] real, finished
/// days exist. A score built from a half-lived first day said "78, strong"
/// to someone who had just smoked four in a row (owner, 2026-10-02).
class ProgressCalibrating extends StatelessWidget {
  const ProgressCalibrating({super.key, required this.trackedDays});

  final int trackedDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final done = trackedDays.clamp(0, calibrationDays);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.progressCalibrating, style: theme.textTheme.titleMedium),
        const SizedBox(height: HalenSpace.x2),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: done / calibrationDays,
          ),
        ),
        const SizedBox(height: HalenSpace.x1),
        Text(
          l10n.progressCalibratingCount(done, calibrationDays),
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(height: HalenSpace.x2),
        Text(
          l10n.progressCalibratingBody(calibrationDays),
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
