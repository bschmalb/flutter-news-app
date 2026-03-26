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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            block.displayTitle,
            style: theme.textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
