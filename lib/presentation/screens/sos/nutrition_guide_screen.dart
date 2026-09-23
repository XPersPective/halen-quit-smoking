import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';
import '../../../core/theme.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Anti-craving nutrition and hydration guide (Roadmap Faz E.2).
///
/// Explains the biological mechanisms of Vitamin C, urine pH/alkaline foods,
/// cold water vagal stimulation, and caffeine/sugar reduction.
class NutritionGuideScreen extends StatelessWidget {
  const NutritionGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nutritionGuideTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HalenSpace.x5),
          children: [
            Text(
              l10n.nutritionGuideSubtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: HalenSpace.x5),

            _NutritionPillarCard(
              icon: Icons.water_drop_rounded,
              iconColor: HalenColors.skyBlue,
              title: l10n.nutritionPillar1Title,
              scientificBasis: l10n.nutritionPillar1Basis,
              body: l10n.nutritionPillar1Body,
            ),
            const SizedBox(height: HalenSpace.x4),

            _NutritionPillarCard(
              icon: Icons.eco_rounded,
              iconColor: HalenColors.emerald,
              title: l10n.nutritionPillar2Title,
              scientificBasis: l10n.nutritionPillar2Basis,
              body: l10n.nutritionPillar2Body,
            ),
            const SizedBox(height: HalenSpace.x4),

            _NutritionPillarCard(
              icon: Icons.local_florist_rounded,
              iconColor: HalenColors.amberCta,
              title: l10n.nutritionPillar3Title,
              scientificBasis: l10n.nutritionPillar3Basis,
              body: l10n.nutritionPillar3Body,
            ),
            const SizedBox(height: HalenSpace.x4),

            _NutritionPillarCard(
              icon: Icons.warning_amber_rounded,
              iconColor: HalenColors.coral,
              title: l10n.nutritionPillar4Title,
              scientificBasis: l10n.nutritionPillar4Basis,
              body: l10n.nutritionPillar4Body,
            ),
            const SizedBox(height: HalenSpace.x6),
          ],
        ),
      ),
    );
  }
}

class _NutritionPillarCard extends StatelessWidget {
  const _NutritionPillarCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.scientificBasis,
    required this.body,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String scientificBasis;
  final String body;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(HalenSpace.x5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(HalenSpace.x3),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: HalenSpace.x3),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: HalenSpace.x3),
            Container(
              padding: const EdgeInsets.all(HalenSpace.x3),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.science_outlined, size: 16),
                  const SizedBox(width: HalenSpace.x2),
                  Expanded(
                    child: Text(
                      l10n.nutritionClinicalBase(scientificBasis),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: HalenSpace.x3),
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}
