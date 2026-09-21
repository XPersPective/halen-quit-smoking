import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halen/application/article_providers.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/data/repositories/article_repository.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/shell_screen.dart';
import 'package:halen/domain/ad_policy.dart';
import 'package:halen/presentation/widgets/ads/halen_ad_banner.dart';
import '../../../core/design/tokens.dart';

class ArticlesScreen extends ConsumerWidget {
  const ArticlesScreen({super.key});

  String _categoryLabel(ArticleCategory? cat, AppLocalizations l10n) {
    if (cat == null) return l10n.articleCategoryAll;
    return switch (cat) {
      ArticleCategory.science => l10n.articleCategoryScience,
      ArticleCategory.crisis => l10n.articleCategoryCrisis,
      ArticleCategory.triggers => l10n.articleCategoryTriggers,
      ArticleCategory.health => l10n.articleCategoryHealth,
      ArticleCategory.psychology => l10n.articleCategoryPsychology,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final articles = ref.watch(articlesListProvider);
    final selectedCategory = ref.watch(selectedArticleCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.articlesTitle,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: const [ShellSettingsButton()],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category filter chips
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: HalenSpace.x5),
                children: [
                  _FilterChip(
                    label: l10n.articleCategoryAll,
                    isSelected: selectedCategory == null,
                    onTap: () => ref
                        .read(selectedArticleCategoryProvider.notifier)
                        .selectCategory(null),
                  ),
                  for (final cat in ArticleCategory.values)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: _categoryLabel(cat, l10n),
                        isSelected: selectedCategory == cat,
                        onTap: () => ref
                            .read(selectedArticleCategoryProvider.notifier)
                            .selectCategory(cat),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: HalenSpace.x3),

            // Articles List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: articles.length,
                separatorBuilder: (_, _) => const SizedBox(height: HalenSpace.x4),
                itemBuilder: (context, index) {
                  final article = articles[index];
                  final isFeatured = index == 0 && selectedCategory == null;

                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.articleReader,
                        arguments: article.id,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(HalenSpace.x5),
                        decoration: isFeatured
                            ? BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    theme.colorScheme.primary.withValues(alpha: 0.12),
                                    HalenColors.emerald.withValues(alpha: 0.05),
                                  ],
                                ),
                              )
                            : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isFeatured
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _categoryLabel(article.category, l10n),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isFeatured
                                            ? Colors.white
                                            : theme.colorScheme
                                                  .onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: HalenSpace.x2),
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 13,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: HalenSpace.x1),
                                Flexible(
                                  child: Text(
                                    l10n.articleReadTime(article.readMinutes),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: HalenSpace.x3),
                            Text(
                              article.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: HalenSpace.x2),
                            Text(
                              article.subtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? HalenColors.textSecondaryDark
                                    : HalenColors.textSecondaryLight,
                                height: 1.35,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: HalenSpace.x3),
                            Row(
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  size: 14,
                                  color: HalenColors.emerald,
                                ),
                                const SizedBox(width: HalenSpace.x1),
                                Expanded(
                                  child: Text(
                                    article.sourceName,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: isDark
                                          ? HalenColors.textSecondaryDark
                                          : HalenColors.textSecondaryLight,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: HalenSpace.x4),
            // T21: labelled banner, free users past the trial only.
            const HalenAdBanner(surface: AdSurface.guideBottom),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : (isDark
                  ? HalenColors.surfaceElevatedDark
                  : HalenColors.surfaceElevatedLight),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? HalenColors.textDark : HalenColors.textLight),
            ),
          ),
        ),
      ),
    );
  }
}
