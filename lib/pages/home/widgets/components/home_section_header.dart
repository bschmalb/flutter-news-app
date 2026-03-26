import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';

class HomepageSectionHeader extends StatelessWidget {
  const HomepageSectionHeader({
    required this.block,
    super.key,
  });

  final HomepageBlockModel block;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showBadge = block.emphasis > 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                block.displayTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                _presentationLabel(block.presentation),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (showBadge)
          Chip(
            label: Text('Emphasis ${block.emphasis}'),
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }
}

String _presentationLabel(HomepageBlockPresentation presentation) {
  return switch (presentation) {
    HomepageBlockPresentation.hero => 'Lead hero section',
    HomepageBlockPresentation.mixed => 'Mixed editorial stack',
    HomepageBlockPresentation.threeUp => 'Three-story module',
    HomepageBlockPresentation.ranked => 'Ranked list',
    HomepageBlockPresentation.carousel => 'Swipeable collection',
    HomepageBlockPresentation.embed => 'External embed',
    HomepageBlockPresentation.generic => 'Generic CMS section',
  };
}
