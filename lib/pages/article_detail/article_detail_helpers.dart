import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_content_block_model.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';

List<String> articleDetailBreadcrumbs(String? urlPath) {
  if (urlPath == null || urlPath.isEmpty) {
    return const ['Startseite', 'Artikel'];
  }

  final segments = urlPath
      .replaceAll(RegExp(r'^/+|/+$'), '')
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

String articleDetailFormatPublishedAt(BuildContext context, DateTime dateTime) {
  final localizations = MaterialLocalizations.of(context);
  final date = localizations.formatMediumDate(dateTime);
  final time = localizations.formatTimeOfDay(TimeOfDay.fromDateTime(dateTime), alwaysUse24HourFormat: true);

  return '$date, $time Uhr';
}

int articleDetailEstimatedReadMinutes(ArticlePreviewModel article) {
  final paragraphText = article.contentBlocks
      .where((block) => block.type == ArticlePreviewContentBlockType.paragraph)
      .map((block) => articleDetailStripHtml(block.text ?? ''))
      .join(' ');
  final wordCount = paragraphText.split(RegExp(r'\s+')).where((part) => part.isNotEmpty).length;

  return (wordCount / 180).ceil().clamp(1, 99);
}

String articleDetailStripHtml(String value) => value
    .replaceAll(RegExp('<[^>]+>'), '')
    .replaceAll('&nbsp;', ' ')
    .replaceAll('&amp;', '&')
    .replaceAll('&quot;', '"')
    .replaceAll('&#39;', "'")
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

String _startCase(String value) {
  return value
      .split('-')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
