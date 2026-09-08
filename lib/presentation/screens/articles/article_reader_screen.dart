import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halen/application/article_providers.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/data/repositories/article_repository.dart';
import 'package:halen/l10n/generated/app_localizations.dart';

class ArticleReaderScreen extends ConsumerWidget {
  const ArticleReaderScreen({
    super.key,
    required this.articleId,
  });

  final String articleId;

  String _categoryLabel(ArticleCategory cat, AppLocalizations l10n) {
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
    final article = ref.watch(articleByIdProvider(articleId));

    if (article == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.emptyGeneric)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _categoryLabel(article.category, l10n),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            // Category & Read Time Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _categoryLabel(article.category, l10n),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '•',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.articleReadTime(article.readMinutes),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Title & Subtitle
            Text(
              article.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              article.subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? HalenColors.textSecondaryDark
                    : HalenColors.textSecondaryLight,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Key Takeaways Highlight Box
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: HalenColors.emerald.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: HalenColors.emerald.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.lightbulb_rounded,
                        color: HalenColors.emerald,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.articleKeyTakeaways,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: HalenColors.emerald,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  for (final takeaway in article.keyTakeaways)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 14,
                              color: HalenColors.emerald,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              takeaway,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Content Sections
            for (final sec in article.sections) ...[
              Text(
                sec.heading,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                sec.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: isDark ? HalenColors.textDark : HalenColors.textLight,
                ),
              ),
              const SizedBox(height: 20),
            ],

            const Divider(height: 32),

            // Scientific Source Citation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? HalenColors.surfaceElevatedDark
                    : HalenColors.surfaceElevatedLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: HalenColors.emerald,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bilimsel Dayanak & Kaynak',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          article.sourceName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
