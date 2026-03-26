import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';
import 'package:ksta/pages/home/controllers/homepage_block_controller.dart';
import 'package:ksta/pages/home/widgets/components/home_empty_section_body.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_list_tile.dart';

class HomepageRankedBlockBody extends StatelessWidget {
  const HomepageRankedBlockBody({
    required this.block,
    required this.controller,
    super.key,
  });

  final RankedHomepageBlockModel block;
  final HomepageBlockController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (block.teaserIds.isEmpty) {
      return const HomepageEmptySectionBody();
    }

    return Column(
      children: [
        for (var index = 0; index < block.teaserIds.length; index++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
                child: Text('${index + 1}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: HomepageTeaserListTile(
                  teaserId: block.teaserIds[index],
                  article: controller.articleFor(block.teaserIds[index]),
                  isLoading: controller.isLoading,
                  label: 'Popular item',
                ),
              ),
            ],
          ),
          if (index != block.teaserIds.length - 1) const SizedBox(height: 20),
        ],
      ],
    );
  }
}
