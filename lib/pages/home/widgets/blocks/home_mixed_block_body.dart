import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';
import 'package:ksta/pages/home/controllers/homepage_block_controller.dart';
import 'package:ksta/pages/home/widgets/components/home_empty_section_body.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_list_tile.dart';

class HomepageMixedBlockBody extends StatelessWidget {
  const HomepageMixedBlockBody({
    required this.block,
    required this.controller,
    super.key,
  });

  final MixedHomepageBlockModel block;
  final HomepageBlockController controller;

  @override
  Widget build(BuildContext context) {
    if (block.teaserIds.isEmpty) {
      return const HomepageEmptySectionBody();
    }

    return Column(
      spacing: 24,
      children: [
        for (var index = 0; index < block.teaserIds.length; index++) ...[
          HomepageTeaserListTile(
            teaserId: block.teaserIds[index],
            article: controller.articleFor(block.teaserIds[index]),
            isLoading: controller.isLoading,
            label: index == 0 ? 'Lead story' : 'Story',
          ),
        ],
      ],
    );
  }
}
