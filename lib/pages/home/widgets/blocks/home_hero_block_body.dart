import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';
import 'package:ksta/pages/home/controllers/homepage_block_controller.dart';
import 'package:ksta/pages/home/widgets/components/home_empty_section_body.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_panel.dart';
import 'package:ksta/utils/app_breakpoint.dart';

class HomepageHeroBlockBody extends StatelessWidget {
  const HomepageHeroBlockBody({super.key, required this.block, required this.controller});

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
    final useHorizontalHero = breakpoint != AppBreakpoint.compact;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing,
      children: [
        HomepageTeaserPanel(
          teaserId: featured,
          article: controller.articleFor(featured),
          isLoading: controller.isLoading,
          variant: HomepageTeaserPanelVariant.featured,
          layout: useHorizontalHero ? HomepageTeaserPanelLayout.horizontal : HomepageTeaserPanelLayout.vertical,
        ),
        if (secondary.isNotEmpty) ...[
          if (breakpoint == AppBreakpoint.compact)
            Column(
              spacing: spacing,
              children: [
                for (var index = 0; index < secondary.length; index++)
                  HomepageTeaserPanel(
                    teaserId: secondary[index],
                    article: controller.articleFor(secondary[index]),
                    isLoading: controller.isLoading,
                  ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacing,
              children: [
                for (var index = 0; index < secondary.length; index++)
                  Expanded(
                    child: HomepageTeaserPanel(
                      teaserId: secondary[index],
                      article: controller.articleFor(secondary[index]),
                      isLoading: controller.isLoading,
                      layout: HomepageTeaserPanelLayout.horizontal,
                    ),
                  ),
              ],
            ),
        ],
      ],
    );
  }
}
