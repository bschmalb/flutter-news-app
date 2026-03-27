import 'package:flutter/foundation.dart';
import 'package:ksta/app/service_locator.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';

class HomepageBlockController extends ChangeNotifier {
  HomepageBlockController({required this.block, bool refreshOnFirstLoad = false})
    : _refreshOnFirstLoad = refreshOnFirstLoad;

  final HomepageBlockModel block;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  bool get hasAttemptedLoad => _hasAttemptedLoad;
  bool _hasAttemptedLoad = false;

  String? get errorMessage => _errorMessage;
  String? _errorMessage;

  bool get hasAnyResolvedArticles => _articlesById.values.any((article) => article != null);
  Map<int, ArticlePreviewModel?> _articlesById = {};

  // When the homepage is explicitly reloaded we want each section to bypass any
  // cached article previews the first time it hydrates.
  bool _refreshOnFirstLoad;

  ArticlePreviewModel? articleFor(int teaserId) {
    return _articlesById[teaserId] ?? articlePreviewStore.peek(teaserId);
  }

  Future<void> load() async {
    // Sections lazily hydrate only once during normal rendering; subsequent
    // refreshes should go through reload().
    if (_isLoading || _hasAttemptedLoad) return;

    final refresh = _refreshOnFirstLoad;
    _refreshOnFirstLoad = false;
    await _hydrate(refresh: refresh);
  }

  Future<void> reload() async => _hydrate(refresh: true);

  Future<void> _hydrate({bool refresh = false}) async {
    final teaserIds = block.teaserIds.toSet().toList(growable: false);
    _hasAttemptedLoad = true;
    _errorMessage = null;

    if (teaserIds.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Seed the section with anything already cached so the UI can render known
    // article previews immediately while only fetching the missing entries.
    final cachedArticles = refresh ? <int, ArticlePreviewModel?>{} : articlePreviewStore.peekMany(teaserIds);

    _articlesById = {for (final teaserId in teaserIds) teaserId: cachedArticles[teaserId]};

    final missingTeaserIds = refresh
        ? teaserIds
        : teaserIds.where((teaserId) => cachedArticles[teaserId] == null).toList(growable: false);

    if (missingTeaserIds.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    // Fetch only unresolved teasers unless the caller requested a full refresh.
    final fetchedArticles = await articlePreviewStore.fetchMany(missingTeaserIds, refresh: refresh);

    _articlesById = {..._articlesById, ...fetchedArticles};
    _isLoading = false;

    if (_articlesById.values.every((article) => article == null)) {
      _errorMessage = 'Failed to load articles for this section.';
    }

    notifyListeners();
  }
}
