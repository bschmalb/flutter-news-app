import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';
import 'package:ksta/pages/home/controllers/homepage_block_controller.dart';
import 'package:ksta/pages/home/widgets/components/home_empty_section_body.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_panel.dart';
import 'package:ksta/utils/app_breakpoint.dart';

class HomepageCarouselBlockBody extends StatelessWidget {
  const HomepageCarouselBlockBody({
    required this.block,
    required this.controller,
    super.key,
  });

  final CarouselHomepageBlockModel block;
  final HomepageBlockController controller;

  @override
  Widget build(BuildContext context) {
    final breakpoint = context.breakpoint;
    final blockSpacing = breakpoint.blockSpacing;

    if (block.teaserIds.isEmpty) {
      return const HomepageEmptySectionBody();
    }

    if (breakpoint == AppBreakpoint.compact) {
      return Column(
        children: [
          for (var index = 0; index < block.teaserIds.length; index++) ...[
            HomepageTeaserPanel(
              teaserId: block.teaserIds[index],
              article: controller.articleFor(block.teaserIds[index]),
              isLoading: controller.isLoading,
              label: block.mobileSwipeableEnabled ? 'Swipeable collection' : 'Collection item',
            ),
            if (index != block.teaserIds.length - 1) SizedBox(height: blockSpacing),
          ],
        ],
      );
    }

    final cardWidth = switch (breakpoint) {
      AppBreakpoint.medium => 280.0,
      AppBreakpoint.expanded => 320.0,
      AppBreakpoint.compact => 220.0,
    };
    final listHeight = switch (breakpoint) {
      AppBreakpoint.medium => 360.0,
      AppBreakpoint.expanded => 400.0,
      AppBreakpoint.compact => 260.0,
    };

    return SizedBox(
      height: listHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: block.teaserIds.length,
        separatorBuilder: (context, index) => SizedBox(width: blockSpacing),
        itemBuilder: (context, index) {
          final teaserId = block.teaserIds[index];

          return SizedBox(
            width: cardWidth,
            child: HomepageTeaserPanel(
              teaserId: teaserId,
              article: controller.articleFor(teaserId),
              isLoading: controller.isLoading,
              label: block.mobileSwipeableEnabled ? 'Swipeable collection' : 'Collection item',
              useCompactLayout: true,
            ),
          );
        },
      ),
    );
  }
}
