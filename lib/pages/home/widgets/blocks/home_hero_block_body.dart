import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';
import 'package:ksta/pages/home/controllers/homepage_block_controller.dart';
import 'package:ksta/pages/home/widgets/components/home_empty_section_body.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_list_tile.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_panel.dart';
import 'package:ksta/utils/app_breakpoint.dart';

class HomepageHeroBlockBody extends StatelessWidget {
  const HomepageHeroBlockBody({
    required this.block,
    required this.controller,
    super.key,
  });

  final HeroHomepageBlockModel block;
  final HomepageBlockController controller;

  @override
  Widget build(BuildContext context) {
    final ids = block.teaserIds;
    final breakpoint = context.breakpoint;
    final spacing = breakpoint.sectionSpacing;

    if (ids.isEmpty) {
      return const HomepageEmptySectionBody();
    }

    final featured = ids.first;
    final secondary = ids.skip(1).take(2).toList(growable: false);

    if (breakpoint == AppBreakpoint.expanded && secondary.isNotEmpty) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 8,
              child: HomepageTeaserPanel(
                teaserId: featured,
                article: controller.articleFor(featured),
                isLoading: controller.isLoading,
                variant: HomepageTeaserPanelVariant.featured,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < secondary.length; index++) ...[
                    Expanded(
                      child: _HomepageHeroSideTeaser(
                        teaserId: secondary[index],
                        article: controller.articleFor(secondary[index]),
                        isLoading: controller.isLoading,
                      ),
                    ),
                    if (index != secondary.length - 1) SizedBox(height: spacing),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomepageTeaserPanel(
          teaserId: featured,
          article: controller.articleFor(featured),
          isLoading: controller.isLoading,
          variant: HomepageTeaserPanelVariant.featured,
        ),
        if (secondary.isNotEmpty) ...[
          SizedBox(height: spacing),
          if (breakpoint == AppBreakpoint.compact)
            Column(
              children: [
                for (var index = 0; index < secondary.length; index++) ...[
                  HomepageTeaserPanel(
                    teaserId: secondary[index],
                    article: controller.articleFor(secondary[index]),
                    isLoading: controller.isLoading,
                  ),
                  if (index != secondary.length - 1) SizedBox(height: spacing),
                ],
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < secondary.length; index++) ...[
                  Expanded(
                    child: HomepageTeaserPanel(
                      teaserId: secondary[index],
                      article: controller.articleFor(secondary[index]),
                      isLoading: controller.isLoading,
                    ),
                  ),
                  if (index != secondary.length - 1) SizedBox(width: spacing),
                ],
              ],
            ),
        ],
      ],
    );
  }
}

class _HomepageHeroSideTeaser extends StatelessWidget {
  const _HomepageHeroSideTeaser({
    required this.teaserId,
    required this.article,
    required this.isLoading,
  });

  final int teaserId;
  final ArticlePreviewModel? article;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final breakpoint = context.breakpoint;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: breakpoint == AppBreakpoint.expanded ? 12 : 8,
      ),
      child: HomepageTeaserListTile(
        teaserId: teaserId,
        article: article,
        isLoading: isLoading,
        label: 'Story',
      ),
    );
  }
}
