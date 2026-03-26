class ArticlePreviewImageModel {
  const ArticlePreviewImageModel({
    required this.path,
    required this.width,
    required this.height,
    required this.altText,
    required this.caption,
    required this.copyrights,
  });

  static ArticlePreviewImageModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final imagePath = json['baseUrl'] as String?;
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    return ArticlePreviewImageModel(
      path: imagePath,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      altText: json['altText'] as String?,
      caption: json['caption'] as String?,
      copyrights: json['copyrights'] as String?,
    );
  }

  final String path;
  final int? width;
  final int? height;
  final String? altText;
  final String? caption;
  final String? copyrights;
}
