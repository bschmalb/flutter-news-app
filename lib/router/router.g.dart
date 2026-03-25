// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$feedRoute];

RouteBase get $feedRoute => GoRouteData.$route(
  path: '/',
  factory: $FeedRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'articles/:slug-:id',
      factory: $ArticleDetailRoute._fromState,
    ),
  ],
);

mixin $FeedRoute on GoRouteData {
  static FeedRoute _fromState(GoRouterState state) => const FeedRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ArticleDetailRoute on GoRouteData {
  static ArticleDetailRoute _fromState(GoRouterState state) =>
      ArticleDetailRoute(
        slug: state.pathParameters['slug']!,
        id: int.parse(state.pathParameters['id']!),
      );

  ArticleDetailRoute get _self => this as ArticleDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/articles/${Uri.encodeComponent(_self.slug)}-${Uri.encodeComponent(_self.id.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
