import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/article_preview_image_model.dart';
import 'package:ksta/pages/home/widgets/components/app_network_image.dart';
import 'package:ksta/utils/app_breakpoint.dart';

class ArticleLeadImage extends StatelessWidget {
  const ArticleLeadImage({super.key, required this.image});

  final ArticlePreviewImageModel image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        ClipRRect(
          borderRadius: .circular(18),
          child: AspectRatio(
            aspectRatio: context.breakpoint == AppBreakpoint.compact ? 4 / 3 : 16 / 9,
            child: AppNetworkImage(imagePath: image.path, variant: AppNetworkImageVariant.featured, fit: .cover),
          ),
        ),
        if (image.caption != null || image.copyrights != null) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              if (image.caption != null) Text(image.caption!, style: Theme.of(context).textTheme.bodySmall),
              if (image.copyrights != null)
                Text(
                  image.copyrights!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
