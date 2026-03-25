import 'package:go_router/go_router.dart';
import 'package:ksta/pages/home/home_page.dart';

class AppRouter {
  AppRouter()
    : router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
        ],
      );

  final GoRouter router;
}
