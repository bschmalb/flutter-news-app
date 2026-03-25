import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksta/screens/detail/article_detail_page.dart';
import 'package:ksta/screens/feed.dart';

part 'router.g.dart';

class AppRouter {
  AppRouter()
    : router = GoRouter(
        initialLocation: const FeedRoute().location,
        routes: $appRoutes,
      );

  final GoRouter router;
}

@TypedGoRoute<FeedRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ArticleDetailRoute>(
      path: '${ArticleDetailPage.rootName}/:slug-:id',
    ),
  ],
)
@immutable
class FeedRoute extends GoRouteData with $FeedRoute {
  const FeedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FeedScreen();
  }
}

@immutable
class ArticleDetailRoute extends GoRouteData with $ArticleDetailRoute {
  const ArticleDetailRoute({required this.slug, required this.id});

  final String slug;
  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ArticleDetailPage(
      slug: slug,
      id: id,
    );
  }
}
