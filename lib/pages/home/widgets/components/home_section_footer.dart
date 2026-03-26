import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';

class HomepageSectionFooter extends StatelessWidget {
  const HomepageSectionFooter({
    required this.block,
    super.key,
  });

  final HomepageBlockModel block;

  @override
  Widget build(BuildContext context) {
    if (block.sourceLayout == null && block.targetUrl == null) {
      return const SizedBox.shrink();
    }

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 6,
        children: [
          if (block.sourceLayout != null) Text('Layout: ${block.sourceLayout}'),
          if (block.targetUrl != null) Text('More: ${block.targetUrl}'),
        ],
      ),
    );
  }
}
