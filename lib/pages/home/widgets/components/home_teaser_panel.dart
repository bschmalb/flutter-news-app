import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/pages/home/widgets/components/app_network_image.dart';
import 'package:ksta/pages/home/widgets/components/article_meta_row.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_placeholder_article.dart';
import 'package:ksta/pages/home/widgets/components/image_fallback.dart';
import 'package:ksta/router/router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomepageTeaserPanel extends StatelessWidget {
  const HomepageTeaserPanel({
    required this.teaserId,
    required this.article,
    required this.isLoading,
    this.label = 'Story',
    this.variant = HomepageTeaserPanelVariant.standard,
    this.useCompactLayout = false,
    super.key,
  });

  final int teaserId;
  final ArticlePreviewModel? article;
  final bool isLoading;
  final String label;
  final HomepageTeaserPanelVariant variant;
  final bool useCompactLayout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFeatured = variant == HomepageTeaserPanelVariant.featured;
    final shouldShowSkeleton = article == null && isLoading;
    final displayArticle = article ?? (shouldShowSkeleton ? buildHomepageTeaserPlaceholderArticle(teaserId) : null);
    final titleColor = theme.colorScheme.onSurface;
    final fallbackColor = theme.colorScheme.surfaceContainerHighest;
    final canOpenArticle = article != null;

    return InkWell(
      onTap: canOpenArticle
          ? () => ArticleDetailRoute(slug: article!.routeSlug, id: article!.id).push<void>(context)
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Skeletonizer(
        enabled: shouldShowSkeleton,
        ignoreContainers: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: useCompactLayout ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (displayArticle?.image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: isFeatured ? 16 / 9 : 4 / 3,
                    child: Skeleton.replace(
                      replace: shouldShowSkeleton,
                      replacement: const SizedBox.expand(child: Bone()),
                      child: AppNetworkImage(
                        imagePath: displayArticle!.image!.path,
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
                ),
              if (useCompactLayout)
                Expanded(
                  child: _HomepageTeaserPanelTextContent(
                    teaserId: teaserId,
                    article: displayArticle,
                    isLoading: isLoading,
                    label: label,
                    isFeatured: isFeatured,
                    titleColor: titleColor,
                    useCompactLayout: true,
                  ),
                )
              else
                _HomepageTeaserPanelTextContent(
                  teaserId: teaserId,
                  article: displayArticle,
                  isLoading: isLoading,
                  label: label,
                  isFeatured: isFeatured,
                  titleColor: titleColor,
                  useCompactLayout: false,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomepageTeaserPanelTextContent extends StatelessWidget {
  const _HomepageTeaserPanelTextContent({
    required this.teaserId,
    required this.article,
    required this.isLoading,
    required this.label,
    required this.isFeatured,
    required this.titleColor,
    required this.useCompactLayout,
  });

  final int teaserId;
  final ArticlePreviewModel? article;
  final bool isLoading;
  final String label;
  final bool isFeatured;
  final Color titleColor;
  final bool useCompactLayout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final descriptionText =
        article?.description ?? (isLoading ? 'Loading article preview...' : 'Article preview unavailable.');

    return Padding(
      padding: EdgeInsets.only(
        top: 14,
        bottom: isFeatured ? 8 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: useCompactLayout ? MainAxisSize.max : MainAxisSize.min,
        children: [
          ArticleMetaRow(
            label: label,
            article: article,
            labelColor: theme.colorScheme.onSurfaceVariant,
            compact: useCompactLayout,
          ),
          const SizedBox(height: 8),
          Text(
            article?.title ?? 'Story #$teaserId',
            maxLines: useCompactLayout ? 2 : null,
            overflow: useCompactLayout ? TextOverflow.ellipsis : null,
            style: (isFeatured ? theme.textTheme.headlineSmall : theme.textTheme.titleMedium)?.copyWith(
              color: titleColor,
            ),
          ),
          if (article?.titlePrefix case final titlePrefix?)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                titlePrefix,
                maxLines: useCompactLayout ? 1 : null,
                overflow: useCompactLayout ? TextOverflow.ellipsis : null,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          const SizedBox(height: 8),
          if (useCompactLayout)
            Flexible(
              child: Text(
                descriptionText,
                maxLines: 2,
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
  }
}

enum HomepageTeaserPanelVariant {
  standard,
  featured,
}
