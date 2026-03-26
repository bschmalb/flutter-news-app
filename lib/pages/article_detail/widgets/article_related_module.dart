import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_list_tile.dart';

class ArticleRelatedModule extends StatelessWidget {
  const ArticleRelatedModule({super.key, required this.article, required this.relatedArticleId});

  final ArticlePreviewModel? article;
  final int relatedArticleId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final relatedArticle = article;

    if (relatedArticle == null) {
      return Column(
        crossAxisAlignment: .start,
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
      crossAxisAlignment: .start,
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
