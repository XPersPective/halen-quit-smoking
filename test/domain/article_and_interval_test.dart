import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/repositories/article_repository.dart';

void main() {
  group('ArticleRepository', () {
    const repo = ArticleRepository();

    test('returns articles for tr, en and de', () {
      final trArticles = repo.getArticles(locale: 'tr');
      expect(trArticles, isNotEmpty);
      expect(trArticles.length, greaterThanOrEqualTo(8));

      final enArticles = repo.getArticles(locale: 'en');
      expect(enArticles, isNotEmpty);

      final deArticles = repo.getArticles(locale: 'de');
      expect(deArticles, isNotEmpty);
    });

    test('all articles contain valid titles, categories and non-empty takeaways', () {
      final articles = repo.getArticles(locale: 'tr');
      for (final a in articles) {
        expect(a.title, isNotEmpty);
        expect(a.subtitle, isNotEmpty);
        expect(a.readMinutes, greaterThan(0));
        expect(a.sourceName, isNotEmpty);
        expect(a.keyTakeaways, isNotEmpty);
        expect(a.sections, isNotEmpty);
      }
    });

    test('retrieves specific article by ID', () {
      final article = repo.getArticleById('nicotine-first-72h', locale: 'tr');
      expect(article, isNotNull);
      expect(article!.category, ArticleCategory.science);
      expect(article.title, contains('72 Saatte'));
    });

    test('returns null for unknown article ID', () {
      final article = repo.getArticleById('unknown-id-xyz', locale: 'tr');
      expect(article, isNull);
    });
  });
}
