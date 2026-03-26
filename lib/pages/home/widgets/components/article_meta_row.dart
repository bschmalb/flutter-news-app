import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';

class ArticleMetaRow extends StatelessWidget {
  const ArticleMetaRow({
    required this.label,
    required this.article,
    required this.labelColor,
    super.key,
  });

  final String label;
  final ArticlePreviewModel? article;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final metadata = <String>[
      if (article?.primaryAuthorName?.isNotEmpty ?? false) 'Von ${article!.primaryAuthorName!}' else label,
      if (article?.publishDate != null) _formatArticleTimestamp(context, article!.publishDate!),
    ];
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final item in metadata)
          Text(
            item,
            style: theme.textTheme.labelMedium?.copyWith(
              color: labelColor,
            ),
          ),
        if (article?.isPaid ?? false)
          Text(
            'PLUS',
            style: theme.textTheme.labelMedium?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

String _formatArticleTimestamp(BuildContext context, DateTime dateTime) {
  final localizations = MaterialLocalizations.of(context);
  final date = localizations.formatShortDate(dateTime);
  final time = localizations.formatTimeOfDay(
    TimeOfDay.fromDateTime(dateTime),
    alwaysUse24HourFormat: true,
  );

  return '$date, $time';
}
