class NewsHomepageAnalyticsModel {
  const NewsHomepageAnalyticsModel({
    required this.site,
    required this.pageName,
    required this.categoryName,
    required this.pageType,
    required this.contentType,
    required this.environment,
    required this.mandator,
  });

  factory NewsHomepageAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return NewsHomepageAnalyticsModel(
      site: json['site'] as String?,
      pageName: json['pageName'] as String?,
      categoryName: json['categoryName'] as String?,
      pageType: json['pageType'] as String?,
      contentType: json['contentType'] as String?,
      environment: json['environment'] as String?,
      mandator: json['mandator'] as String?,
    );
  }

  final String? site;
  final String? pageName;
  final String? categoryName;
  final String? pageType;
  final String? contentType;
  final String? environment;
  final String? mandator;
}
