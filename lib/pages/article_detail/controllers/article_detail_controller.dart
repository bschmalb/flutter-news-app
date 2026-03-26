import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:ksta/app/app_repository_globals.dart';
import 'package:ksta/data/news/models/article_preview_content_block_model.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';

class ArticleDetailController extends ChangeNotifier {
  ArticleDetailController({required this.articleId});

  final int articleId;

  ArticlePreviewModel? get article => _article;
  ArticlePreviewModel? _article;

  Map<int, ArticlePreviewModel?> get relatedArticles => _relatedArticles;
  final Map<int, ArticlePreviewModel?> _relatedArticles = {};

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  String? _errorMessage;

  Future<void> load() async {
    if (_isLoading) return;

    _article = articlePreviewStore.peek(articleId);
    _primeRelatedArticles(_article);

    if (_article != null) return;

    await _fetchArticle();
  }

  Future<void> reload() async => _fetchArticle(refresh: true);

  Future<void> _fetchArticle({bool refresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final article = await articlePreviewStore.fetch(articleId, refresh: refresh);

    _article = article;
    _isLoading = false;
    _errorMessage = article == null ? 'Unable to load this article right now.' : null;
    notifyListeners();

    await _primeRelatedArticles(article, refresh: refresh);
  }

  Future<void> _primeRelatedArticles(ArticlePreviewModel? article, {bool refresh = false}) async {
    if (article == null) return;

    final relatedIds = article.contentBlocks
        .where((block) => block.type == ArticlePreviewContentBlockType.relatedArticle)
        .map((block) => block.relatedArticleId)
        .whereType<int>()
        .toSet()
        .toList(growable: false);

    if (relatedIds.isEmpty) return;

    final cachedRelated = refresh ? <int, ArticlePreviewModel?>{} : articlePreviewStore.peekMany(relatedIds);
    _relatedArticles.addAll(cachedRelated);
    notifyListeners();

    final missingIds =
        refresh ? relatedIds : relatedIds.where((id) => cachedRelated[id] == null).toList(growable: false);

    if (missingIds.isEmpty) return;

    try {
      final fetchedRelated = await articlePreviewStore.fetchMany(missingIds, refresh: refresh);
      _relatedArticles.addAll(fetchedRelated);
      notifyListeners();
    } catch (error, stackTrace) {
      log('Failed to prime related articles: $error', stackTrace: stackTrace);
    }
  }
}
