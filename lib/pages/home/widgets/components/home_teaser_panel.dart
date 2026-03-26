import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_model.dart';
import 'package:ksta/pages/home/widgets/components/app_network_image.dart';
import 'package:ksta/pages/home/widgets/components/article_meta_row.dart';
import 'package:ksta/pages/home/widgets/components/home_teaser_placeholder_article.dart';
import 'package:ksta/pages/home/widgets/components/image_fallback.dart';
import 'package:ksta/router/router.dart';
import 'package:ksta/widgets/article_title_prefix_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomepageTeaserPanel extends StatelessWidget {
  const HomepageTeaserPanel({
    super.key,
    required this.teaserId,
    required this.article,
    required this.isLoading,
    this.label = 'Story',
    this.variant = HomepageTeaserPanelVariant.standard,
    this.layout = HomepageTeaserPanelLayout.vertical,
    this.useCompactLayout = false,
  });

  final int teaserId;
  final ArticlePreviewModel? article;
  final bool isLoading;
  final String label;
  final HomepageTeaserPanelVariant variant;
  final HomepageTeaserPanelLayout layout;
  final bool useCompactLayout;

  @override
  Widget build(BuildContext context) {
    final isFeatured = variant == HomepageTeaserPanelVariant.featured;
    final shouldShowSkeleton = article == null && isLoading;
    final displayArticle = article ?? (shouldShowSkeleton ? homepageTeaserPlaceholderArticle : null);
    final titleColor = Theme.of(context).colorScheme.onSurface;
    final fallbackColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return InkWell(
      onTap: article != null ? () => ArticleDetailRoute(slug: article!.routeSlug, id: article!.id).go(context) : null,
      borderRadius: .circular(12),
      child: Skeletonizer(
        enabled: shouldShowSkeleton,
        ignoreContainers: true,
        child: Padding(
          padding: const .symmetric(vertical: 4),
          child: switch (layout) {
            HomepageTeaserPanelLayout.vertical => _HomepageTeaserPanelVerticalLayout(
              teaserId: teaserId,
              article: displayArticle,
              isLoading: isLoading,
              shouldShowSkeleton: shouldShowSkeleton,
              label: label,
              isFeatured: isFeatured,
              titleColor: titleColor,
              fallbackColor: fallbackColor,
              useCompactLayout: useCompactLayout,
            ),
            HomepageTeaserPanelLayout.horizontal => _HomepageTeaserPanelHorizontalLayout(
              teaserId: teaserId,
              article: displayArticle,
              isLoading: isLoading,
              shouldShowSkeleton: shouldShowSkeleton,
              label: label,
              isFeatured: isFeatured,
              titleColor: titleColor,
              fallbackColor: fallbackColor,
            ),
          },
        ),
      ),
    );
  }
}

class _HomepageTeaserPanelVerticalLayout extends StatelessWidget {
  const _HomepageTeaserPanelVerticalLayout({
    required this.teaserId,
    required this.article,
    required this.isLoading,
    required this.shouldShowSkeleton,
    required this.label,
    required this.isFeatured,
    required this.titleColor,
    required this.fallbackColor,
    required this.useCompactLayout,
  });

  final int teaserId;
  final ArticlePreviewModel? article;
  final bool isLoading;
  final bool shouldShowSkeleton;
  final String label;
  final bool isFeatured;
  final Color titleColor;
  final Color fallbackColor;
  final bool useCompactLayout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: useCompactLayout ? .max : .min,
      children: [
        if (article?.image != null)
          _HomepageTeaserPanelImage(
            imagePath: article!.image!.path,
            shouldShowSkeleton: shouldShowSkeleton,
            fallbackColor: fallbackColor,
            variant: isFeatured ? AppNetworkImageVariant.featured : AppNetworkImageVariant.card,
            aspectRatio: isFeatured ? 16 / 9 : 4 / 3,
          ),
        if (useCompactLayout)
          Expanded(
            child: _HomepageTeaserPanelTextContent(
              teaserId: teaserId,
              article: article,
              isLoading: isLoading,
              label: label,
              isFeatured: isFeatured,
              titleColor: titleColor,
              useCompactLayout: true,
              padding: EdgeInsets.only(top: 14, bottom: isFeatured ? 8 : 0),
            ),
          )
        else
          _HomepageTeaserPanelTextContent(
            teaserId: teaserId,
            article: article,
            isLoading: isLoading,
            label: label,
            isFeatured: isFeatured,
            titleColor: titleColor,
            useCompactLayout: false,
            padding: EdgeInsets.only(top: 14, bottom: isFeatured ? 8 : 0),
          ),
      ],
    );
  }
}

class _HomepageTeaserPanelHorizontalLayout extends StatelessWidget {
  const _HomepageTeaserPanelHorizontalLayout({
    required this.teaserId,
    required this.article,
    required this.isLoading,
    required this.shouldShowSkeleton,
    required this.label,
    required this.isFeatured,
    required this.titleColor,
    required this.fallbackColor,
  });

  final int teaserId;
  final ArticlePreviewModel? article;
  final bool isLoading;
  final bool shouldShowSkeleton;
  final String label;
  final bool isFeatured;
  final Color titleColor;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    final imageWidget = article?.image != null
        ? _HomepageTeaserPanelImage(
            imagePath: article!.image!.path,
            shouldShowSkeleton: shouldShowSkeleton,
            fallbackColor: fallbackColor,
            variant: isFeatured ? AppNetworkImageVariant.featured : AppNetworkImageVariant.card,
            aspectRatio: isFeatured ? 16 / 10 : 4 / 3,
          )
        : null;

    return Row(
      spacing: 20,
      children: [
        if (imageWidget != null) Expanded(flex: isFeatured ? 7 : 5, child: imageWidget),
        Expanded(
          flex: isFeatured ? 5 : 6,
          child: _HomepageTeaserPanelTextContent(
            teaserId: teaserId,
            article: article,
            isLoading: isLoading,
            label: label,
            isFeatured: isFeatured,
            titleColor: titleColor,
            useCompactLayout: false,
            padding: EdgeInsets.only(bottom: isFeatured ? 8 : 0),
          ),
        ),
      ],
    );
  }
}

class _HomepageTeaserPanelImage extends StatelessWidget {
  const _HomepageTeaserPanelImage({
    required this.imagePath,
    required this.shouldShowSkeleton,
    required this.fallbackColor,
    required this.variant,
    required this.aspectRatio,
  });

  final String imagePath;
  final bool shouldShowSkeleton;
  final Color fallbackColor;
  final AppNetworkImageVariant variant;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: .circular(12),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Skeleton.replace(
          replace: shouldShowSkeleton,
          replacement: const SizedBox.expand(child: Bone()),
          child: AppNetworkImage(
            imagePath: imagePath,
            variant: variant,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return ImageFallback(icon: Icons.image_not_supported_outlined, backgroundColor: fallbackColor);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return ImageFallback(icon: Icons.image_outlined, backgroundColor: fallbackColor);
            },
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
    required this.padding,
  });

  final int teaserId;
  final ArticlePreviewModel? article;
  final bool isLoading;
  final String label;
  final bool isFeatured;
  final Color titleColor;
  final bool useCompactLayout;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final descriptionText =
        article?.description ?? (isLoading ? 'Loading article preview...' : 'Article preview unavailable.');

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: useCompactLayout ? .max : .min,
        spacing: 8,
        children: [
          if (article?.titlePrefix case final titlePrefix?)
            ArticleTitlePrefixText(text: titlePrefix, prominent: isFeatured, maxLines: useCompactLayout ? 1 : 2),
          Text(
            article?.title ?? 'Story #$teaserId',
            maxLines: useCompactLayout ? 2 : null,
            overflow: useCompactLayout ? .ellipsis : null,
            style: (isFeatured ? Theme.of(context).textTheme.headlineSmall : Theme.of(context).textTheme.titleMedium)
                ?.copyWith(color: titleColor),
          ),
          if (useCompactLayout)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    descriptionText,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const Spacer(),
                  ArticleMetaRow(
                    label: label,
                    article: article,
                    labelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    compact: true,
                  ),
                ],
              ),
            )
          else ...[
            Text(
              descriptionText,
              maxLines: isFeatured ? 4 : 3,
              overflow: .ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            ArticleMetaRow(label: label, article: article, labelColor: Theme.of(context).colorScheme.onSurfaceVariant),
          ],
        ],
      ),
    );
  }
}

enum HomepageTeaserPanelVariant { standard, featured }

enum HomepageTeaserPanelLayout { vertical, horizontal }
