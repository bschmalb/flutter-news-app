import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/pages/home/widgets/components/app_network_image.dart';
import 'package:ksta/pages/home/widgets/components/article_meta_row.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_placeholder_article.dart';
import 'package:ksta/pages/home/widgets/components/image_fallback.dart';
import 'package:ksta/router/router.dart';
import 'package:ksta/widgets/article_title_prefix_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomepageTeaserListTile extends StatelessWidget {
  const HomepageTeaserListTile({
    required this.teaserId,
    required this.article,
    required this.isLoading,
    required this.label,
    super.key,
  });

  final int teaserId;
  final ArticlePreviewModel? article;
  final bool isLoading;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shouldShowSkeleton = article == null && isLoading;
    final displayArticle = article ?? (shouldShowSkeleton ? buildHomepageTeaserPlaceholderArticle(teaserId) : null);
    final canOpenArticle = article != null;

    return InkWell(
      onTap: canOpenArticle
          ? () => ArticleDetailRoute(
              slug: article!.routeSlug,
              id: article!.id,
            ).push<void>(context)
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Skeletonizer(
        enabled: shouldShowSkeleton,
        ignoreContainers: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              if (displayArticle?.image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 96,
                    height: 72,
                    child: Skeleton.replace(
                      replace: shouldShowSkeleton,
                      replacement: const SizedBox.expand(child: Bone()),
                      child: AppNetworkImage(
                        imagePath: displayArticle!.image!.path,
                        variant: AppNetworkImageVariant.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return ImageFallback(
                            icon: Icons.image_not_supported_outlined,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              if (displayArticle?.image != null) const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (displayArticle?.titlePrefix case final titlePrefix?) ...[
                      ArticleTitlePrefixText(
                        text: titlePrefix,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      displayArticle?.title ?? 'Story #$teaserId',
                      style: theme.textTheme.titleMedium,
                    ),
                    if (displayArticle?.description != null || isLoading) ...[
                      const SizedBox(height: 4),
                      Text(
                        displayArticle?.description ??
                            (isLoading ? 'Loading article preview...' : 'Article preview unavailable.'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    ArticleMetaRow(
                      label: label,
                      article: displayArticle,
                      labelColor: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
