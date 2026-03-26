import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/pages/home/widgets/components/app_network_image.dart';
import 'package:ksta/pages/home/widgets/components/article_meta_row.dart';
import 'package:ksta/pages/home/widgets/components/image_fallback.dart';
import 'package:ksta/router/router.dart';

class HomepageTeaserPanel extends StatelessWidget {
  const HomepageTeaserPanel({
    required this.teaserId,
    required this.article,
    required this.isLoading,
    this.label = 'Story',
    this.variant = HomepageTeaserPanelVariant.standard,
    super.key,
  });

  final int teaserId;
  final ArticlePreviewModel? article;
  final bool isLoading;
  final String label;
  final HomepageTeaserPanelVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFeatured = variant == HomepageTeaserPanelVariant.featured;
    final titleColor = theme.colorScheme.onSurface;
    final fallbackColor = theme.colorScheme.surfaceContainerHighest;
    final canOpenArticle = article != null;

    return InkWell(
      onTap: canOpenArticle
          ? () => ArticleDetailRoute(slug: article!.routeSlug, id: article!.id).push<void>(context)
          : null,
      borderRadius: BorderRadius.circular(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hasBoundedHeight = constraints.maxHeight.isFinite;
          final titleMaxLines = hasBoundedHeight ? (isFeatured ? 3 : 2) : null;
          final titlePrefixMaxLines = hasBoundedHeight ? 2 : null;
          final descriptionText =
              article?.description ?? (isLoading ? 'Loading article preview...' : 'Article preview unavailable.');

          final textContent = Padding(
            padding: EdgeInsets.only(
              top: 14,
              bottom: isFeatured ? 8 : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: hasBoundedHeight ? MainAxisSize.max : MainAxisSize.min,
              children: [
                ArticleMetaRow(
                  label: label,
                  article: article,
                  labelColor: theme.colorScheme.onSurfaceVariant,
                  compact: hasBoundedHeight,
                ),
                const SizedBox(height: 8),
                Text(
                  article?.title ?? 'Story #$teaserId',
                  maxLines: hasBoundedHeight ? (isFeatured ? 2 : 2) : titleMaxLines,
                  overflow: hasBoundedHeight ? TextOverflow.ellipsis : null,
                  style: (isFeatured ? theme.textTheme.headlineSmall : theme.textTheme.titleMedium)?.copyWith(
                    color: titleColor,
                  ),
                ),
                if (article?.titlePrefix case final titlePrefix?)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      titlePrefix,
                      maxLines: hasBoundedHeight ? 1 : titlePrefixMaxLines,
                      overflow: hasBoundedHeight ? TextOverflow.ellipsis : null,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                if (hasBoundedHeight)
                  Flexible(
                    child: Text(
                      descriptionText,
                      maxLines: isFeatured ? 2 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                else
                  Text(
                    descriptionText,
                    maxLines: isFeatured ? 4 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          );

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article?.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: isFeatured ? 16 / 9 : 4 / 3,
                      child: AppNetworkImage(
                        imagePath: article!.image!.path,
                        variant: isFeatured ? AppNetworkImageVariant.featured : AppNetworkImageVariant.card,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return ImageFallback(
                            icon: Icons.image_not_supported_outlined,
                            backgroundColor: fallbackColor,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return ImageFallback(
                            icon: Icons.image_outlined,
                            backgroundColor: fallbackColor,
                          );
                        },
                      ),
                    ),
                  ),
                if (hasBoundedHeight) Expanded(child: textContent) else textContent,
              ],
            ),
          );
        },
      ),
    );
  }
}

enum HomepageTeaserPanelVariant {
  standard,
  featured,
}
