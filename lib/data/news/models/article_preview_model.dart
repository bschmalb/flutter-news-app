import 'package:ksta/data/news/models/article_preview_content_block_model.dart';
import 'package:ksta/data/news/models/article_preview_image_model.dart';

class ArticlePreviewModel {
  const ArticlePreviewModel({
    required this.id,
    required this.urlPath,
    required this.seoTitle,
    required this.title,
    required this.titlePrefix,
    required this.description,
    required this.publishDate,
    required this.image,
    required this.authorIds,
    required this.authorNames,
    required this.introText,
    required this.contentBlocks,
    required this.contentRestriction,
  });

  factory ArticlePreviewModel.fromJson(
    Map<String, dynamic> json, {
    int? fallbackId,
  }) {
    return ArticlePreviewModel(
      id: (json['id'] as num?)?.toInt() ?? fallbackId ?? 0,
      urlPath: json['urlPath'] as String?,
      seoTitle: json['seoTitle'] as String?,
      title: (json['title'] as String?) ?? (json['seoTitle'] as String?) ?? 'Untitled article',
      titlePrefix: json['titlePrefix'] as String?,
      description: json['description'] as String? ?? json['introTextHtml'] as String?,
      publishDate: DateTime.tryParse(json['publishDate'] as String? ?? ''),
      image: ArticlePreviewImageModel.fromJson(json['img'] as Map<String, dynamic>?),
      authorIds: (json['authors'] as List<dynamic>? ?? const [])
          .map((value) => (value as num).toInt())
          .toList(growable: false),
      authorNames: const [],
      introText: json['introTextHtml'] as String? ?? json['description'] as String?,
      contentBlocks: ArticlePreviewContentBlockModel.fromJsonList(
        json['contentItems'] as List<dynamic>?,
      ),
      contentRestriction: json['contentRestriction'] as String?,
    );
  }

  final int id;
  final String? urlPath;
  final String? seoTitle;
  final String title;
  final String? titlePrefix;
  final String? description;
  final DateTime? publishDate;
  final ArticlePreviewImageModel? image;
  final List<int> authorIds;
  final List<String> authorNames;
  final String? introText;
  final List<ArticlePreviewContentBlockModel> contentBlocks;
  final String? contentRestriction;

  bool get isPaid => contentRestriction == 'paid';
  String? get primaryAuthorName => authorNames.isEmpty ? null : authorNames.first;

  ArticlePreviewModel copyWith({
    List<String>? authorNames,
  }) {
    return ArticlePreviewModel(
      id: id,
      urlPath: urlPath,
      seoTitle: seoTitle,
      title: title,
      titlePrefix: titlePrefix,
      description: description,
      publishDate: publishDate,
      image: image,
      authorIds: authorIds,
      authorNames: authorNames ?? this.authorNames,
      introText: introText,
      contentBlocks: contentBlocks,
      contentRestriction: contentRestriction,
    );
  }

  String get routeSlug {
    final rawSlug = urlPath?.trim();
    if (rawSlug != null && rawSlug.isNotEmpty) {
      final cleanedPath = rawSlug
          .replaceAll(RegExp(r'^/+|/+$'), '')
          .split('/')
          .where((segment) => segment.isNotEmpty)
          .lastOrNull;
      if (cleanedPath != null && cleanedPath.isNotEmpty) {
        return cleanedPath;
      }
    }

    return _slugify(seoTitle ?? title);
  }

  static String _slugify(String value) {
    final normalized = value.toLowerCase().replaceAll(RegExp('[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');

    return normalized.isEmpty ? 'article' : normalized;
  }
}
