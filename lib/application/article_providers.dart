import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/article_repository.dart';

final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  return const ArticleRepository();
});

final selectedArticleCategoryProvider =
    NotifierProvider<SelectedArticleCategoryNotifier, ArticleCategory?>(
  SelectedArticleCategoryNotifier.new,
);

class SelectedArticleCategoryNotifier extends Notifier<ArticleCategory?> {
  @override
  ArticleCategory? build() => null;

  void selectCategory(ArticleCategory? category) {
    state = category;
  }
}

/// Active locale string (defaults to system locale or en/tr/de).
final currentLocaleProvider = Provider<String>((ref) {
  final locale = PlatformDispatcher.instance.locale;
  return locale.languageCode;
});

final articlesListProvider = Provider<List<Article>>((ref) {
  final repo = ref.watch(articleRepositoryProvider);
  final locale = ref.watch(currentLocaleProvider);
  final category = ref.watch(selectedArticleCategoryProvider);

  final all = repo.getArticles(locale: locale);
  if (category == null) {
    return all;
  }
  return all.where((a) => a.category == category).toList();
});

final articleByIdProvider = Provider.family<Article?, String>((ref, id) {
  final repo = ref.watch(articleRepositoryProvider);
  final locale = ref.watch(currentLocaleProvider);
  return repo.getArticleById(id, locale: locale);
});
