import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/pages/article_detail/article_detail_helpers.dart';
import 'package:ksta/pages/article_detail/widgets/article_action.dart';
import 'package:ksta/utils/app_breakpoint.dart';
import 'package:ksta/widgets/article_title_prefix_text.dart';

class ArticleHeader extends StatelessWidget {
  const ArticleHeader({super.key, required this.article, required this.breakpoint});

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
          crossAxisAlignment: .start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final crumb in articleDetailBreadcrumbs(article.urlPath))
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
              crossAxisAlignment: .center,
              children: [
                if (article.publishDate != null)
                  Text(articleDetailFormatPublishedAt(context, article.publishDate!), style: metaLabelStyle),
                Text('${articleDetailEstimatedReadMinutes(article)} min', style: metaLabelStyle),
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
