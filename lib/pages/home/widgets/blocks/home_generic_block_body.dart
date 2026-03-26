import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';
import 'package:ksta/pages/home/controllers/homepage_block_controller.dart';
import 'package:ksta/pages/home/widgets/components/home_empty_section_body.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_panel.dart';
import 'package:ksta/utils/app_breakpoint.dart';

class HomepageGenericBlockBody extends StatelessWidget {
  const HomepageGenericBlockBody({
    required this.block,
    required this.controller,
    super.key,
  });

  final GenericHomepageBlockModel block;
  final HomepageBlockController controller;

  @override
  Widget build(BuildContext context) {
    final breakpoint = context.breakpoint;

    if (block.teaserIds.isEmpty) {
      return const HomepageEmptySectionBody(
        message: 'This section has no teaser IDs. It may be a utility or social module.',
      );
    }

    if (breakpoint == AppBreakpoint.compact) {
      return Column(
        children: [
          for (var index = 0; index < block.teaserIds.length; index++) ...[
            HomepageTeaserPanel(
              teaserId: block.teaserIds[index],
              article: controller.articleFor(block.teaserIds[index]),
              isLoading: controller.isLoading,
              label: 'Generic item',
            ),
            if (index != block.teaserIds.length - 1) const SizedBox(height: 12),
          ],
        ],
      );
    }

    final columns = breakpoint.contentColumns;

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final teaserId in block.teaserIds)
              SizedBox(
                width: itemWidth,
                child: HomepageTeaserPanel(
                  teaserId: teaserId,
                  article: controller.articleFor(teaserId),
                  isLoading: controller.isLoading,
                  label: 'Generic item',
                ),
              ),
          ],
        );
      },
    );
  }
}
