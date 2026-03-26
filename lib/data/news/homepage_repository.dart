import 'dart:convert';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/data/news/models/author_profile_model.dart';
import 'package:ksta/data/news/models/news_homepage_response_model.dart';
import 'package:ksta/data/utils/api_exception.dart';
import 'package:ksta/data/utils/http_request.dart';

class HomepageRepository extends HttpRequest {
  HomepageRepository(super.api);

  Future<NewsHomepageResponseModel> fetchHomepage() async {
    final uri = Uri.parse(url).resolve('v5/homepage');
    final response = await get(uri);

    if (response.isStatusCodeGood) {
      final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
      return NewsHomepageResponseModel.fromJson(decodedBody);
    }

    throw ApiException.fromResponse(response);
  }

  Future<ArticlePreviewModel> fetchArticlePreview(int articleId) async {
    final uri = Uri.parse(url).resolve('v5/articles/$articleId');
    final response = await get(uri);

    if (response.isStatusCodeGood) {
      final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;

      return ArticlePreviewModel.fromJson(decodedBody, fallbackId: articleId);
    }

    throw ApiException.fromResponse(response);
  }

  Future<AuthorProfileModel> fetchAuthorProfile(int authorId) async {
    final uri = Uri.parse(url).resolve('v5/authors/$authorId');
    final response = await get(uri);

    if (response.isStatusCodeGood) {
      final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthorProfileModel.fromJson(decodedBody);
    }

    throw ApiException.fromResponse(response);
  }
}
