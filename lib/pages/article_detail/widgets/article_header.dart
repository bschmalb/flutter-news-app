import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/pages/article_detail/article_detail_helpers.dart';
import 'package:ksta/pages/article_detail/widgets/article_action.dart';
import 'package:ksta/utils/app_breakpoint.dart';
import 'package:ksta/widgets/article_title_prefix_text.dart';

class ArticleHeader extends StatelessWidget {
  const ArticleHeader({super.key, required this.article});

  final ArticlePreviewModel article;

  @override
  Widget build(BuildContext context) {
    final metaLabelStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

    return Align(
      alignment: .centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final crumb in articleDetailBreadcrumbs(article.urlPath))
                  Text(
                    crumb,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (article.titlePrefix case final prefix?) ArticleTitlePrefixText(text: prefix, prominent: true),
            const SizedBox(height: 6),
            Text(
              article.title,
              style: switch (context.breakpoint) {
                AppBreakpoint.compact => Theme.of(context).textTheme.headlineMedium,
                AppBreakpoint.medium => Theme.of(context).textTheme.displaySmall,
                AppBreakpoint.expanded => Theme.of(context).textTheme.displayMedium,
              }?.copyWith(height: 1.05),
            ),
            if (article.primaryAuthorName != null) ...[
              const SizedBox(height: 14),
              Text(
                'Von ${article.primaryAuthorName!}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
            const SizedBox(height: 18),
            Wrap(
              spacing: 16,
              runSpacing: 10,
              crossAxisAlignment: .center,
              children: [
                if (article.publishDate != null)
                  Text(articleDetailFormatPublishedAt(context, article.publishDate!), style: metaLabelStyle),
                Text('${articleDetailEstimatedReadMinutes(article)} min', style: metaLabelStyle),
                if (article.isPaid)
                  Text(
                    'KStA Plus',
                    style: metaLabelStyle?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            const Wrap(
              spacing: 18,
              runSpacing: 10,
              children: [
                ArticleAction(label: 'Anhören'),
                ArticleAction(label: 'Merken'),
                ArticleAction(label: 'Drucken'),
                ArticleAction(label: 'Teilen'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
