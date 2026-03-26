import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';

class HomepageEmbedBlockBody extends StatelessWidget {
  const HomepageEmbedBlockBody({
    required this.block,
    super.key,
  });

  final EmbedHomepageBlockModel block;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preview = block.html == null
        ? 'No embed payload provided.'
        : block.html!.replaceAll(RegExp(r'\s+'), ' ').trim();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            block.providerName ?? 'External provider',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            block.requiresConsent
                ? 'This embed should only load after user consent.'
                : 'This block should map to a controlled native widget or WebView.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            preview,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
