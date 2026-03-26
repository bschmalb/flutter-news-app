import 'package:ksta/data/news/models/homepage_content_item_model.dart';
import 'package:ksta/data/news/models/news_homepage_analytics_model.dart';

class NewsHomepageResponseModel {
  const NewsHomepageResponseModel({required this.contentItems, required this.analytics});

  factory NewsHomepageResponseModel.fromJson(Map<String, dynamic> json) {
    final contentItemsJson = json['contentItems'] as List<dynamic>? ?? const [];
    final analyticsJson = json['analytics'] as Map<String, dynamic>? ?? const {};

    return NewsHomepageResponseModel(
      contentItems: contentItemsJson
          .whereType<Map<String, dynamic>>()
          .map(HomepageContentItemModel.fromJson)
          .toList(growable: false),
      analytics: NewsHomepageAnalyticsModel.fromJson(analyticsJson),
    );
  }

  final List<HomepageContentItemModel> contentItems;
  final NewsHomepageAnalyticsModel analytics;
}
