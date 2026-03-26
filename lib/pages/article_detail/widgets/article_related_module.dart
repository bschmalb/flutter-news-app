import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_list_tile.dart';

class ArticleRelatedModule extends StatelessWidget {
  const ArticleRelatedModule({super.key, required this.article, required this.relatedArticleId});

  final ArticlePreviewModel? article;
  final int relatedArticleId;

  @override
  Widget build(BuildContext context) {
    if (article == null) {
      return Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'Lesen Sie auch',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          Text('Verwandter Artikel $relatedArticleId wird geladen ...', style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
    }

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'Lesen Sie auch',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        HomepageTeaserListTile(teaserId: article!.id, article: article, isLoading: false, label: 'Empfohlen'),
      ],
    );
  }
}
