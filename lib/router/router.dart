import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksta/pages/article_detail/article_detail_page.dart';
import 'package:ksta/pages/home/home_page.dart';

part 'router.g.dart';

class AppRouter {
  AppRouter()
    : router = GoRouter(
        initialLocation: const HomepageRoute().location,
        routes: $appRoutes,
      );

  final GoRouter router;
}

@TypedGoRoute<HomepageRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ArticleDetailRoute>(
      path: '${ArticleDetailPage.rootName}/:slug-:id',
    ),
  ],
)
@immutable
class HomepageRoute extends GoRouteData with $HomepageRoute {
  const HomepageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomepageScreen();
}

@immutable
class ArticleDetailRoute extends GoRouteData with $ArticleDetailRoute {
  const ArticleDetailRoute({required this.slug, required this.id});

  final String slug;
  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) => ArticleDetailPage(slug: slug, id: id);
}
