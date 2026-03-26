import 'package:flutter/material.dart';
import 'package:ksta/pages/article_detail/article_detail_helpers.dart';
import 'package:ksta/pages/article_detail/controllers/article_detail_controller.dart';
import 'package:ksta/pages/article_detail/widgets/article_content_blocks.dart';
import 'package:ksta/pages/article_detail/widgets/article_error_state.dart';
import 'package:ksta/pages/article_detail/widgets/article_header.dart';
import 'package:ksta/pages/article_detail/widgets/article_lead_image.dart';
import 'package:ksta/utils/app_breakpoint.dart';
import 'package:ksta/widgets/ksta_sliver_app_bar.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({super.key, required this.slug, required this.id});

  static const routeName = 'articles';

  final String slug;
  final int id;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late final ArticleDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ArticleDetailController(articleId: widget.id)..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final article = _controller.article;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              const KstaSliverAppBar(floating: true, snap: true, automaticallyImplyLeading: true),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: context.breakpoint.horizontalPadding),
                sliver: SliverToBoxAdapter(
                  child: Align(
                    alignment: .topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: context.breakpoint.articleDetailMaxContentWidth),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          if (_controller.isLoading && article == null)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 96),
                              child: Center(child: CircularProgressIndicator.adaptive()),
                            )
                          else if (article == null)
                            ArticleErrorState(
                              message: _controller.errorMessage ?? 'Article not found.',
                              onRetry: _controller.reload,
                            )
                          else ...[
                            ArticleHeader(article: article),
                            const SizedBox(height: 32),
                            if (article.image != null) ArticleLeadImage(image: article.image!),
                            if (article.introText case final intro?)
                              Align(
                                alignment: .centerLeft,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 760),
                                  child: Padding(
                                    padding: const .only(top: 28, bottom: 12),
                                    child: Text(
                                      articleDetailStripHtml(intro),
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontSize: 24,
                                        height: 1.45,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Align(
                              alignment: .centerLeft,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 760),
                                child: ArticleContentBlocks(
                                  article: article,
                                  relatedArticles: _controller.relatedArticles,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
          ),
        );
      },
    );
  }
}
