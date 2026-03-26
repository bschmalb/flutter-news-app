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
    super.key,
    required this.teaserId,
    required this.article,
    required this.isLoading,
    required this.label,
  });

  final int teaserId;
  final ArticlePreviewModel? article;
  final bool isLoading;
  final String label;

  @override
  Widget build(BuildContext context) {
    final shouldShowSkeleton = article == null && isLoading;
    final displayArticle = article ?? (shouldShowSkeleton ? homepageTeaserPlaceholderArticle : null);

    return InkWell(
      onTap: article != null ? () => ArticleDetailRoute(slug: article!.routeSlug, id: article!.id).push<void>(context) : null,
      borderRadius: .circular(12),
      child: Skeletonizer(
        enabled: shouldShowSkeleton,
        ignoreContainers: true,
        child: Padding(
          padding: const .symmetric(vertical: 2),
          child: Row(
            spacing: 12,
            children: [
              if (displayArticle?.image != null)
                ClipRRect(
                  borderRadius: .circular(12),
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
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    if (displayArticle?.titlePrefix case final titlePrefix?)
                      ArticleTitlePrefixText(text: titlePrefix, maxLines: 1),
                    Text(displayArticle?.title ?? 'Story #$teaserId', style: Theme.of(context).textTheme.titleMedium),
                    if (displayArticle?.description != null || isLoading)
                      Text(
                        displayArticle?.description ??
                            (isLoading ? 'Loading article preview...' : 'Article preview unavailable.'),
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ArticleMetaRow(
                      label: label,
                      article: displayArticle,
                      labelColor: Theme.of(context).colorScheme.onSurfaceVariant,
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
