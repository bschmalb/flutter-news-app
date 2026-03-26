enum HomepageBlockPresentation { hero, mixed, threeUp, ranked, carousel, embed, generic }

sealed class HomepageBlockModel {
  const HomepageBlockModel({
    required this.presentation,
    required this.sourceLayout,
    required this.title,
    required this.targetUrl,
    required this.teaserIds,
    required this.emphasis,
  });

  final HomepageBlockPresentation presentation;
  final String? sourceLayout;
  final String? title;
  final String? targetUrl;
  final List<int> teaserIds;
  final int emphasis;

  String get displayTitle => title ?? _defaultTitle;

  String get _defaultTitle => switch (presentation) {
    HomepageBlockPresentation.hero => 'Top Stories',
    HomepageBlockPresentation.mixed => 'More Stories',
    HomepageBlockPresentation.threeUp => 'Highlights',
    HomepageBlockPresentation.ranked => 'Most Read',
    HomepageBlockPresentation.carousel => 'Featured Collection',
    HomepageBlockPresentation.embed => 'Embedded Content',
    HomepageBlockPresentation.generic => 'News Section',
  };
}

final class HeroHomepageBlockModel extends HomepageBlockModel {
  const HeroHomepageBlockModel({
    required super.sourceLayout,
    required super.title,
    required super.targetUrl,
    required super.teaserIds,
    required super.emphasis,
  }) : super(presentation: HomepageBlockPresentation.hero);
}

final class MixedHomepageBlockModel extends HomepageBlockModel {
  const MixedHomepageBlockModel({
    required super.sourceLayout,
    required super.title,
    required super.targetUrl,
    required super.teaserIds,
    required super.emphasis,
  }) : super(presentation: HomepageBlockPresentation.mixed);
}

final class ThreeUpHomepageBlockModel extends HomepageBlockModel {
  const ThreeUpHomepageBlockModel({
    required super.sourceLayout,
    required super.title,
    required super.targetUrl,
    required super.teaserIds,
    required super.emphasis,
  }) : super(presentation: HomepageBlockPresentation.threeUp);
}

final class RankedHomepageBlockModel extends HomepageBlockModel {
  const RankedHomepageBlockModel({
    required super.sourceLayout,
    required super.title,
    required super.targetUrl,
    required super.teaserIds,
    required super.emphasis,
  }) : super(presentation: HomepageBlockPresentation.ranked);
}

final class CarouselHomepageBlockModel extends HomepageBlockModel {
  const CarouselHomepageBlockModel({
    required super.sourceLayout,
    required super.title,
    required super.targetUrl,
    required super.teaserIds,
    required super.emphasis,
    required this.mobileSwipeableEnabled,
  }) : super(presentation: HomepageBlockPresentation.carousel);

  final bool mobileSwipeableEnabled;
}

final class EmbedHomepageBlockModel extends HomepageBlockModel {
  const EmbedHomepageBlockModel({
    required super.sourceLayout,
    required super.title,
    required super.targetUrl,
    required super.emphasis,
    required this.providerName,
    required this.html,
    required this.requiresConsent,
  }) : super(presentation: HomepageBlockPresentation.embed, teaserIds: const []);

  final String? providerName;
  final String? html;
  final bool requiresConsent;
}

final class GenericHomepageBlockModel extends HomepageBlockModel {
  const GenericHomepageBlockModel({
    required super.sourceLayout,
    required super.title,
    required super.targetUrl,
    required super.teaserIds,
    required super.emphasis,
  }) : super(presentation: HomepageBlockPresentation.generic);
}
