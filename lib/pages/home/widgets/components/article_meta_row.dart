import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';

class ArticleMetaRow extends StatelessWidget {
  const ArticleMetaRow({
    super.key,
    required this.label,
    required this.article,
    required this.labelColor,
    this.compact = false,
  });

  final String label;
  final ArticlePreviewModel? article;
  final Color labelColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final metadata = <String>[
      if (article?.primaryAuthorName?.isNotEmpty ?? false) 'Von ${article!.primaryAuthorName!}' else label,
      if (article?.publishDate != null) _formatArticleTimestamp(context, article!.publishDate!),
      if (article?.isPaid ?? false) 'PLUS',
    ];
    final labelStyle = Theme.of(context).textTheme.labelMedium?.copyWith(color: labelColor);

    if (compact) {
      return Text(metadata.join('  •  '), maxLines: 1, overflow: .ellipsis, style: labelStyle);
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final item in metadata)
          Text(item, style: item == 'PLUS' ? labelStyle?.copyWith(fontWeight: FontWeight.w700) : labelStyle),
      ],
    );
  }
}

String _formatArticleTimestamp(BuildContext context, DateTime dateTime) {
  final localizations = MaterialLocalizations.of(context);
  final date = localizations.formatShortDate(dateTime);
  final time = localizations.formatTimeOfDay(TimeOfDay.fromDateTime(dateTime), alwaysUse24HourFormat: true);

  return '$date, $time';
}
