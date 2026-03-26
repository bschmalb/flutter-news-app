import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_content_block_model.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/pages/article_detail/article_detail_helpers.dart';
import 'package:ksta/pages/article_detail/widgets/article_inline_image.dart';
import 'package:ksta/pages/article_detail/widgets/article_related_module.dart';

class ArticleContentBlocks extends StatelessWidget {
  const ArticleContentBlocks({super.key, required this.article, required this.relatedArticles});

  final ArticlePreviewModel article;
  final Map<int, ArticlePreviewModel?> relatedArticles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: .start,
      children: [
        for (final block in article.contentBlocks) ...[
          switch (block.type) {
            ArticlePreviewContentBlockType.paragraph => Padding(
              padding: const .only(bottom: 22),
              child: Text(
                articleDetailStripHtml(block.text ?? ''),
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.8),
              ),
            ),
            ArticlePreviewContentBlockType.image => Padding(
              padding: const .symmetric(vertical: 16),
              child: ArticleInlineImage(image: block.image!),
            ),
            ArticlePreviewContentBlockType.relatedArticle => Padding(
              padding: const .symmetric(vertical: 16),
              child: ArticleRelatedModule(
                article: relatedArticles[block.relatedArticleId],
                relatedArticleId: block.relatedArticleId!,
              ),
            ),
          },
        ],
      ],
    );
  }
}
