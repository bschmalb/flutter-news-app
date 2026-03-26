import 'package:ksta/data/news/models/homepage_block_model.dart';
import 'package:ksta/data/news/models/homepage_content_item_model.dart';
import 'package:ksta/data/news/models/news_homepage_response_model.dart';
import 'package:ksta/data/news/utils/homepage_content_schema.dart';

extension NewsHomepageResponseMapper on NewsHomepageResponseModel {
  List<HomepageBlockModel> toHomepageBlocks() => contentItems.map(_mapContentItem).toList(growable: false);
}

HomepageBlockModel _mapContentItem(HomepageContentItemModel item) {
  final layout = item.layout;
  final emphasis = item.teaserClusterEmphasis ?? 0;

  if (item.parsedPageContentItemType == HomepagePageContentItemType.freeHtml ||
      item.parsedContentItemType == HomepageContentItemType.freeHtml) {
    return EmbedHomepageBlockModel(
      sourceLayout: layout,
      title: item.title,
      targetUrl: item.targetUrl,
      emphasis: emphasis,
      providerName: item.providerName,
      html: item.html,
      requiresConsent: item.consentLayer,
    );
  }

  return switch (item.parsedLayout) {
    HomepageLayout.homeAufmacher3 => HeroHomepageBlockModel(
      sourceLayout: layout,
      title: item.title,
      targetUrl: item.targetUrl,
      teaserIds: item.teasables,
      emphasis: emphasis,
    ),
    HomepageLayout.abc => ThreeUpHomepageBlockModel(
      sourceLayout: layout,
      title: item.title,
      targetUrl: item.targetUrl,
      teaserIds: item.teasables,
      emphasis: emphasis,
    ),
    HomepageLayout.singleTopbox => RankedHomepageBlockModel(
      sourceLayout: layout,
      title: item.title,
      targetUrl: item.targetUrl,
      teaserIds: item.teasables,
      emphasis: emphasis,
    ),
    HomepageLayout.abcdEfgh => CarouselHomepageBlockModel(
      sourceLayout: layout,
      title: item.title,
      targetUrl: item.targetUrl,
      teaserIds: item.teasables,
      emphasis: emphasis,
      mobileSwipeableEnabled: item.mobileSwipeableEnabled,
    ),
    HomepageLayout.homemix || HomepageLayout.abAc || HomepageLayout.abAbCde => MixedHomepageBlockModel(
      sourceLayout: layout,
      title: item.title,
      targetUrl: item.targetUrl,
      teaserIds: item.teasables,
      emphasis: emphasis,
    ),
    HomepageLayout.unknown => GenericHomepageBlockModel(
      sourceLayout: layout,
      title: item.title,
      targetUrl: item.targetUrl,
      teaserIds: item.teasables,
      emphasis: emphasis,
    ),
  };
}
