import 'package:ksta/data/news/models/article_preview_image_model.dart';

enum ArticlePreviewContentBlockType {
  paragraph,
  image,
  relatedArticle,
}

class ArticlePreviewContentBlockModel {
  const ArticlePreviewContentBlockModel._({
    required this.type,
    this.text,
    this.image,
    this.relatedArticleId,
  });

  factory ArticlePreviewContentBlockModel.paragraph(String text) {
    return ArticlePreviewContentBlockModel._(
      type: ArticlePreviewContentBlockType.paragraph,
      text: text,
    );
  }

  factory ArticlePreviewContentBlockModel.image(ArticlePreviewImageModel image) {
    return ArticlePreviewContentBlockModel._(
      type: ArticlePreviewContentBlockType.image,
      image: image,
    );
  }

  factory ArticlePreviewContentBlockModel.relatedArticle(int articleId) {
    return ArticlePreviewContentBlockModel._(
      type: ArticlePreviewContentBlockType.relatedArticle,
      relatedArticleId: articleId,
    );
  }

  final ArticlePreviewContentBlockType type;
  final String? text;
  final ArticlePreviewImageModel? image;
  final int? relatedArticleId;

  static List<ArticlePreviewContentBlockModel> fromJsonList(List<dynamic>? json) {
    if (json == null) {
      return const [];
    }

    final blocks = <ArticlePreviewContentBlockModel>[];

    for (final rawBlock in json.whereType<Map<String, dynamic>>()) {
      final identifier = rawBlock['identifier'] as String?;
      final content = rawBlock['content'] as Map<String, dynamic>?;

      switch (identifier) {
        case 'p':
          final text = content?['text'] as String?;
          if (text != null && text.isNotEmpty) {
            blocks.add(ArticlePreviewContentBlockModel.paragraph(text));
          }
        case 'normal':
          final image = ArticlePreviewImageModel.fromJson(
            content?['image'] as Map<String, dynamic>?,
          );
          if (image != null) {
            blocks.add(
              ArticlePreviewContentBlockModel.image(
                ArticlePreviewImageModel(
                  path: image.path,
                  width: image.width,
                  height: image.height,
                  altText: content?['altText'] as String? ?? image.altText,
                  caption: content?['caption'] as String? ?? image.caption,
                  copyrights: content?['copyrights'] as String? ?? image.copyrights,
                ),
              ),
            );
          }
        case 'embedded-article':
          final articleId =
              ((content?['embedded-article'] as Map<String, dynamic>?)?['params']
                      as Map<String, dynamic>?)?['documentId']
                  as num?;
          if (articleId != null) {
            blocks.add(
              ArticlePreviewContentBlockModel.relatedArticle(articleId.toInt()),
            );
          }
      }
    }

    return blocks;
  }
}
