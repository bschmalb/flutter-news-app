import 'dart:developer';
import 'package:ksta/app/app_repository_globals.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';

class ArticlePreviewStore {
  ArticlePreviewStore();

  final Map<int, ArticlePreviewModel> _cache = {};
  final Map<int, Future<ArticlePreviewModel?>> _inFlight = {};

  ArticlePreviewModel? peek(int articleId) => _cache[articleId];

  Map<int, ArticlePreviewModel?> peekMany(Iterable<int> articleIds) {
    return {for (final articleId in articleIds) articleId: _cache[articleId]};
  }

  Future<ArticlePreviewModel?> fetch(int articleId, {bool refresh = false}) {
    if (!refresh) {
      final cached = _cache[articleId];
      if (cached != null) {
        return Future.value(cached);
      }

      final inFlight = _inFlight[articleId];
      if (inFlight != null) {
        return inFlight;
      }
    }

    final future = () async {
      try {
        final article = await homepageRepository.fetchArticlePreview(articleId);
        final hydratedArticle = await _hydrateAuthors(article, refresh: refresh);
        _cache[articleId] = hydratedArticle;
        return hydratedArticle;
      } catch (error, stackTrace) {
        log('Failed to fetch article preview for $articleId: $error', stackTrace: stackTrace);
        return null;
      } finally {
        _inFlight.remove(articleId);
      }
    }();

    _inFlight[articleId] = future;
    return future;
  }

  Future<Map<int, ArticlePreviewModel?>> fetchMany(Iterable<int> articleIds, {bool refresh = false}) async {
    final uniqueArticleIds = articleIds.toSet().toList(growable: false);
    final results = await Future.wait(
      uniqueArticleIds.map((articleId) async => MapEntry(articleId, await fetch(articleId, refresh: refresh))),
    );

    return Map<int, ArticlePreviewModel?>.fromEntries(results);
  }

  Future<ArticlePreviewModel> _hydrateAuthors(ArticlePreviewModel article, {required bool refresh}) async {
    if (article.authorIds.isEmpty) {
      return article;
    }

    final authorsById = await authorStore.fetchMany(article.authorIds, refresh: refresh);
    final authorNames = article.authorIds
        .map((authorId) => authorsById[authorId]?.displayName)
        .whereType<String>()
        .toList(growable: false);

    if (authorNames.isEmpty) {
      return article;
    }

    return article.copyWith(authorNames: authorNames);
  }
}
