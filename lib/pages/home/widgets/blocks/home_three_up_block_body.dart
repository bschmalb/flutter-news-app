import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';
import 'package:ksta/pages/home/controllers/homepage_block_controller.dart';
import 'package:ksta/pages/home/widgets/components/home_empty_section_body.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_panel.dart';
import 'package:ksta/utils/app_breakpoint.dart';

class HomepageThreeUpBlockBody extends StatelessWidget {
  const HomepageThreeUpBlockBody({
    required this.block,
    required this.controller,
    super.key,
  });

  final ThreeUpHomepageBlockModel block;
  final HomepageBlockController controller;

  @override
  Widget build(BuildContext context) {
    final ids = block.teaserIds.take(3).toList(growable: false);
    final breakpoint = context.breakpoint;

    if (ids.isEmpty) {
      return const HomepageEmptySectionBody();
    }

    if (breakpoint == AppBreakpoint.compact) {
      return Column(
        children: [
          for (var index = 0; index < ids.length; index++) ...[
            HomepageTeaserPanel(
              teaserId: ids[index],
              article: controller.articleFor(ids[index]),
              isLoading: controller.isLoading,
            ),
            if (index != ids.length - 1) const SizedBox(height: 12),
          ],
        ],
      );
    }

    final columns = breakpoint == AppBreakpoint.medium ? 2 : 3;

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final teaserId in ids)
              SizedBox(
                width: itemWidth,
                child: HomepageTeaserPanel(
                  teaserId: teaserId,
                  article: controller.articleFor(teaserId),
                  isLoading: controller.isLoading,
                ),
              ),
          ],
        );
      },
    );
  }
}
