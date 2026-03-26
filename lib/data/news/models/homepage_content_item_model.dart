import 'package:ksta/data/news/utils/homepage_content_schema.dart';

class HomepageContentItemModel {
  const HomepageContentItemModel({
    required this.contentItemType,
    required this.pageContentItemType,
    required this.layout,
    required this.title,
    required this.targetUrl,
    required this.recoBoxId,
    required this.menuHandle,
    required this.teaserClusterEmphasis,
    required this.mobileSwipeableEnabled,
    required this.providerName,
    required this.html,
    required this.consentLayer,
    required this.teasables,
  });

  factory HomepageContentItemModel.fromJson(Map<String, dynamic> json) {
    final teasablesJson = json['teasables'] as List<dynamic>? ?? const [];

    return HomepageContentItemModel(
      contentItemType: json['contentItemType'] as String?,
      pageContentItemType: json['pageContentItemType'] as String?,
      layout: json['layout'] as String?,
      title: json['title'] as String?,
      targetUrl: json['targetUrlPathOrUrl'] as String?,
      recoBoxId: json['recoBoxId'] as String?,
      menuHandle: json['menuHandle'] as String?,
      teaserClusterEmphasis: int.tryParse(
        json['teaserClusterEmphasis']?.toString() ?? '',
      ),
      mobileSwipeableEnabled: json['mobileSwipeableEnabled'] as bool? ?? false,
      providerName: json['providerName'] as String?,
      html: json['html'] as String?,
      consentLayer: json['consentLayer'] as bool? ?? false,
      teasables: teasablesJson.whereType<num>().map((item) => item.toInt()).toList(growable: false),
    );
  }

  final String? contentItemType;
  final String? pageContentItemType;
  final String? layout;
  final String? title;
  final String? targetUrl;
  final String? recoBoxId;
  final String? menuHandle;
  final int? teaserClusterEmphasis;
  final bool mobileSwipeableEnabled;
  final String? providerName;
  final String? html;
  final bool consentLayer;
  final List<int> teasables;

  HomepageContentItemType get parsedContentItemType => HomepageContentItemType.fromWire(contentItemType);

  HomepagePageContentItemType get parsedPageContentItemType =>
      HomepagePageContentItemType.fromWire(pageContentItemType);

  HomepageLayout get parsedLayout => HomepageLayout.fromWire(layout);
}
