import 'package:flutter/material.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';
import 'package:ksta/pages/home/controllers/homepage_block_controller.dart';
import 'package:ksta/pages/home/widgets/blocks/home_block_error_body.dart';
import 'package:ksta/pages/home/widgets/blocks/home_carousel_block_body.dart';
import 'package:ksta/pages/home/widgets/blocks/home_embed_block_body.dart';
import 'package:ksta/pages/home/widgets/blocks/home_generic_block_body.dart';
import 'package:ksta/pages/home/widgets/blocks/home_hero_block_body.dart';
import 'package:ksta/pages/home/widgets/blocks/home_mixed_block_body.dart';
import 'package:ksta/pages/home/widgets/blocks/home_ranked_block_body.dart';
import 'package:ksta/pages/home/widgets/blocks/home_three_up_block_body.dart';
import 'package:ksta/pages/home/widgets/components/home_section_footer.dart';
import 'package:ksta/pages/home/widgets/components/home_section_header.dart';
import 'package:ksta/utils/app_breakpoint.dart';

class HomepageBlockSection extends StatefulWidget {
  const HomepageBlockSection({required this.controller, super.key});

  final HomepageBlockController controller;

  @override
  State<HomepageBlockSection> createState() => _HomepageBlockSectionState();
}

class _HomepageBlockSectionState extends State<HomepageBlockSection> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  void didUpdateWidget(covariant HomepageBlockSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        final block = widget.controller.block;
        final showError = widget.controller.errorMessage != null && !widget.controller.hasAnyResolvedArticles;
        final breakpoint = context.breakpoint;
        final blockSpacing = breakpoint.blockSpacing;

        return Padding(
          padding: breakpoint.sectionPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomepageSectionHeader(block: block),
              SizedBox(height: blockSpacing),
              if (showError)
                HomepageBlockErrorBody(
                  message: widget.controller.errorMessage!,
                  onRetry: widget.controller.reload,
                )
              else
                switch (block) {
                  final HeroHomepageBlockModel hero => HomepageHeroBlockBody(
                    block: hero,
                    controller: widget.controller,
                  ),
                  final ThreeUpHomepageBlockModel threeUp => HomepageThreeUpBlockBody(
                    block: threeUp,
                    controller: widget.controller,
                  ),
                  final RankedHomepageBlockModel ranked => HomepageRankedBlockBody(
                    block: ranked,
                    controller: widget.controller,
                  ),
                  final CarouselHomepageBlockModel carousel => HomepageCarouselBlockBody(
                    block: carousel,
                    controller: widget.controller,
                  ),
                  final MixedHomepageBlockModel mixed => HomepageMixedBlockBody(
                    block: mixed,
                    controller: widget.controller,
                  ),
                  final EmbedHomepageBlockModel embed => HomepageEmbedBlockBody(block: embed),
                  final GenericHomepageBlockModel generic => HomepageGenericBlockBody(
                    block: generic,
                    controller: widget.controller,
                  ),
                },
              if (block.sourceLayout != null || block.targetUrl != null) ...[
                SizedBox(height: blockSpacing),
                HomepageSectionFooter(block: block),
              ],
            ],
          ),
        );
      },
    );
  }
}
