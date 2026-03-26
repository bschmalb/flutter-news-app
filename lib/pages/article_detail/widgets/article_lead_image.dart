import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_image_model.dart';
import 'package:ksta/pages/home/widgets/components/app_network_image.dart';
import 'package:ksta/utils/app_breakpoint.dart';

class ArticleLeadImage extends StatelessWidget {
  const ArticleLeadImage({super.key, required this.image, required this.breakpoint});

  final ArticlePreviewImageModel image;
  final AppBreakpoint breakpoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: .start,
      children: [
        ClipRRect(
          borderRadius: .circular(18),
          child: AspectRatio(
            aspectRatio: breakpoint == AppBreakpoint.compact ? 4 / 3 : 16 / 9,
            child: AppNetworkImage(imagePath: image.path, variant: AppNetworkImageVariant.featured, fit: .cover),
          ),
        ),
        if (image.caption != null || image.copyrights != null) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              if (image.caption != null) Text(image.caption!, style: theme.textTheme.bodySmall),
              if (image.copyrights != null)
                Text(
                  image.copyrights!,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
