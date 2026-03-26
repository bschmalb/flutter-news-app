import 'package:ksta/data/news/models/article_preview_content_block_model.dart';
import 'package:ksta/data/news/models/article_preview_image_model.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';

ArticlePreviewModel buildHomepageTeaserPlaceholderArticle(int teaserId) {
  return ArticlePreviewModel(
    id: teaserId,
    urlPath: null,
    seoTitle: 'Loading story',
    title: 'Loading story headline for teaser $teaserId',
    titlePrefix: 'Latest coverage',
    description: 'Loading article preview summary for this section.',
    publishDate: DateTime(2026, 1, 1, 12),
    image: const ArticlePreviewImageModel(
      path: 'placeholder://homepage-teaser-image',
      width: 1280,
      height: 720,
      altText: 'Loading image',
      caption: null,
      copyrights: null,
    ),
    authorIds: const [],
    authorNames: const ['KSTA Redaktion'],
    introText: 'Loading article preview summary for this section.',
    contentBlocks: const <ArticlePreviewContentBlockModel>[],
    contentRestriction: null,
  );
}
