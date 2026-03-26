import 'package:flutter/material.dart';
import 'package:ksta/app/app_repository_globals.dart';
import 'package:ksta/data/news/models/article_preview_content_block_model.dart';
import 'package:ksta/data/news/models/article_preview_image_model.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/pages/home/widgets/components/app_network_image.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_list_tile.dart';
import 'package:ksta/utils/app_breakpoint.dart';
import 'package:ksta/widgets/article_title_prefix_text.dart';
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isLoading && article == null) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 96),
                          child: Center(child: CircularProgressIndicator.adaptive()),
                        ),
                      ] else if (article == null) ...[
                        Padding(
                          padding: const .symmetric(vertical: 96),
                          child: Column(
                            children: [
                              Text(
                                _errorMessage ?? 'Article not found.',
                                style: theme.textTheme.titleMedium,
                                textAlign: .center,
                              ),
                              const SizedBox(height: 16),
                              FilledButton(
                                onPressed: () => _loadArticleIfNeeded(refresh: true),
                                child: const Text('Try again'),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        _ArticleHeader(article: article, breakpoint: breakpoint),
                        const SizedBox(height: 32),
                        if (article.image != null) _ArticleLeadImage(image: article.image!, breakpoint: breakpoint),
                        if (article.introText case final intro?)
                          Align(
                            alignment: .centerLeft,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 760),
                              child: Padding(
                                padding: const .only(top: 28, bottom: 12),
                                child: Text(
                                  _stripHtml(intro),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildContentBlocks(context, article),
                            ),
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

  List<Widget> _buildContentBlocks(BuildContext context, ArticlePreviewModel article) {
    final theme = Theme.of(context);

    return [
      for (final block in article.contentBlocks) ...[
        switch (block.type) {
          ArticlePreviewContentBlockType.paragraph => Padding(
            padding: const .only(bottom: 22),
            child: Text(_stripHtml(block.text ?? ''), style: theme.textTheme.bodyLarge?.copyWith(height: 1.8)),
          ),
          ArticlePreviewContentBlockType.image => Padding(
            padding: const .symmetric(vertical: 16),
            child: _ArticleInlineImage(image: block.image!),
          ),
          ArticlePreviewContentBlockType.relatedArticle => Padding(
            padding: const .symmetric(vertical: 16),
            child: _ArticleRelatedModule(
              article: _relatedArticles[block.relatedArticleId],
              relatedArticleId: block.relatedArticleId!,
            ),
          ),
        },
      ],
    ];
  }
}

class _ArticleHeader extends StatelessWidget {
  const _ArticleHeader({required this.article, required this.breakpoint});

  final ArticlePreviewModel article;
  final AppBreakpoint breakpoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metaLabelStyle = theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    return Align(
      alignment: .centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final crumb in _breadcrumbs(article.urlPath))
                  Text(crumb, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 20),
            if (article.titlePrefix case final prefix?) ArticleTitlePrefixText(text: prefix, prominent: true),
            const SizedBox(height: 6),
            Text(
              article.title,
              style: switch (breakpoint) {
                AppBreakpoint.compact => theme.textTheme.headlineMedium,
                AppBreakpoint.medium => theme.textTheme.displaySmall,
                AppBreakpoint.expanded => theme.textTheme.displayMedium,
              }?.copyWith(height: 1.05),
            ),
            if (article.primaryAuthorName != null) ...[
              const SizedBox(height: 14),
              Text(
                'Von ${article.primaryAuthorName!}',
                style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurface),
              ),
            ],
            const SizedBox(height: 18),
            Wrap(
              spacing: 16,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (article.publishDate != null)
                  Text(_formatPublishedAt(context, article.publishDate!), style: metaLabelStyle),
                Text('${_estimatedReadMinutes(article)} min', style: metaLabelStyle),
                if (article.isPaid)
                  Text(
                    'KStA Plus',
                    style: metaLabelStyle?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w700),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            const Wrap(
              spacing: 18,
              runSpacing: 10,
              children: [
                _ArticleAction(label: 'Anhören'),
                _ArticleAction(label: 'Merken'),
                _ArticleAction(label: 'Drucken'),
                _ArticleAction(label: 'Teilen'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleLeadImage extends StatelessWidget {
  const _ArticleLeadImage({required this.image, required this.breakpoint});

  final ArticlePreviewImageModel image;
  final AppBreakpoint breakpoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: .circular(18),
          child: AspectRatio(
            aspectRatio: breakpoint == AppBreakpoint.compact ? 4 / 3 : 16 / 9,
            child: AppNetworkImage(imagePath: image.path, variant: AppNetworkImageVariant.featured, fit: BoxFit.cover),
          ),
        ),
        if (image.caption != null || image.copyrights != null) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              if (image.caption != null) Text(image.caption!, style: theme.textTheme.bodySmall),
              if (image.copyrights != null)
                Text(
                  image.copyrights!,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ArticleInlineImage extends StatelessWidget {
  const _ArticleInlineImage({required this.image});

  final ArticlePreviewImageModel image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: .circular(16),
          child: AspectRatio(
            aspectRatio: (image.width != null && image.height != null) ? image.width! / image.height! : 16 / 9,
            child: AppNetworkImage(imagePath: image.path, fit: BoxFit.cover),
          ),
        ),
        if (image.caption != null || image.copyrights != null) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 4,
            children: [
              if (image.caption != null) Text(image.caption!, style: theme.textTheme.bodySmall),
              if (image.copyrights != null)
                Text(
                  image.copyrights!,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ArticleRelatedModule extends StatelessWidget {
  const _ArticleRelatedModule({required this.article, required this.relatedArticleId});

  final ArticlePreviewModel? article;
  final int relatedArticleId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final relatedArticle = article;

    if (relatedArticle == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lesen Sie auch',
            style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          Text('Verwandter Artikel $relatedArticleId wird geladen ...', style: theme.textTheme.bodyMedium),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lesen Sie auch', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 12),
        HomepageTeaserListTile(
          teaserId: relatedArticle.id,
          article: relatedArticle,
          isLoading: false,
          label: 'Empfohlen',
        ),
      ],
    );
  }
}

class _ArticleAction extends StatelessWidget {
  const _ArticleAction({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant));
  }
}

List<String> _breadcrumbs(String? urlPath) {
  if (urlPath == null || urlPath.isEmpty) {
    return const ['Startseite', 'Artikel'];
  }

  final segments = urlPath
      .replaceAll(RegExp(r'^/+|/+\$'), '')
      .split('/')
      .where((segment) => segment.isNotEmpty)
      .toList(growable: false);

  if (segments.isEmpty) {
    return const ['Startseite', 'Artikel'];
  }

  final crumbs = <String>['Startseite'];
  for (final segment in segments.take(segments.length - 1)) {
    crumbs.add(_startCase(segment));
  }

  return crumbs;
}

String _startCase(String value) {
  return value
      .split('-')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

String _formatPublishedAt(BuildContext context, DateTime dateTime) {
  final localizations = MaterialLocalizations.of(context);
  final date = localizations.formatMediumDate(dateTime);
  final time = localizations.formatTimeOfDay(TimeOfDay.fromDateTime(dateTime), alwaysUse24HourFormat: true);

  return '$date, $time Uhr';
}

int _estimatedReadMinutes(ArticlePreviewModel article) {
  final paragraphText = article.contentBlocks
      .where((block) => block.type == ArticlePreviewContentBlockType.paragraph)
      .map((block) => _stripHtml(block.text ?? ''))
      .join(' ');
  final wordCount = paragraphText.split(RegExp(r'\s+')).where((part) => part.isNotEmpty).length;

  return (wordCount / 180).ceil().clamp(1, 99);
}

String _stripHtml(String value) => value
    .replaceAll(RegExp('<[^>]+>'), '')
    .replaceAll('&nbsp;', ' ')
    .replaceAll('&amp;', '&')
    .replaceAll('&quot;', '"')
    .replaceAll('&#39;', "'")
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();
