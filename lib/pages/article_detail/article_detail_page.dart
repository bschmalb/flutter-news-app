import 'package:flutter/material.dart';
import 'package:ksta/app/app_repository_globals.dart';
import 'package:ksta/data/news/models/article_preview_content_block_model.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/pages/article_detail/article_detail_helpers.dart';
import 'package:ksta/pages/article_detail/widgets/article_content_blocks.dart';
import 'package:ksta/pages/article_detail/widgets/article_error_state.dart';
import 'package:ksta/pages/article_detail/widgets/article_header.dart';
import 'package:ksta/pages/article_detail/widgets/article_lead_image.dart';
import 'package:ksta/utils/app_breakpoint.dart';
import 'package:ksta/widgets/ksta_sliver_app_bar.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({super.key, required this.slug, required this.id});

  static const rootName = 'articles';

  final String slug;
  final int id;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  ArticlePreviewModel? _article;

  final Map<int, ArticlePreviewModel?> _relatedArticles = {};

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _article = articlePreviewStore.peek(widget.id);
    _primeRelatedArticles(_article);
    _loadArticleIfNeeded();
  }

  Future<void> _loadArticleIfNeeded({bool refresh = false}) async {
    if (_isLoading) return;
    if (!refresh && _article != null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final article = await articlePreviewStore.fetch(widget.id, refresh: refresh);

    if (!mounted) return;

    setState(() {
      _article = article;
      _isLoading = false;
      _errorMessage = article == null ? 'Unable to load this article right now.' : null;
    });

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

    if (mounted) {
      setState(() {
        _relatedArticles.addAll(cachedRelated);
      });
    }

    final missingIds = refresh
        ? relatedIds
        : relatedIds.where((id) => cachedRelated[id] == null).toList(growable: false);

    if (missingIds.isEmpty) return;

    final fetchedRelated = await articlePreviewStore.fetchMany(missingIds, refresh: refresh);

    if (!mounted) return;

    setState(() {
      _relatedArticles.addAll(fetchedRelated);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final breakpoint = context.breakpoint;
    final article = _article;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const KstaSliverAppBar(floating: true, snap: true, automaticallyImplyLeading: true),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: breakpoint.horizontalPadding),
            sliver: SliverToBoxAdapter(
              child: Align(
                alignment: .topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: breakpoint.articleDetailMaxContentWidth),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      if (_isLoading && article == null) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 96),
                          child: Center(child: CircularProgressIndicator.adaptive()),
                        ),
                      ] else if (article == null) ...[
                        ArticleErrorState(
                          message: _errorMessage ?? 'Article not found.',
                          onRetry: () => _loadArticleIfNeeded(refresh: true),
                        ),
                      ] else ...[
                        ArticleHeader(article: article, breakpoint: breakpoint),
                        const SizedBox(height: 32),
                        if (article.image != null) ArticleLeadImage(image: article.image!, breakpoint: breakpoint),
                        if (article.introText case final intro?)
                          Align(
                            alignment: .centerLeft,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 760),
                              child: Padding(
                                padding: const .only(top: 28, bottom: 12),
                                child: Text(
                                  articleDetailStripHtml(intro),
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontSize: 24,
                                    height: 1.45,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Align(
                          alignment: .centerLeft,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 760),
                            child: ArticleContentBlocks(article: article, relatedArticles: _relatedArticles),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }
}
