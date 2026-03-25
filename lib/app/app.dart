import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ksta/router/pages/scaffold_error_page.dart';
import 'package:ksta/router/router.dart';
import 'package:ksta/theme/dark_theme.dart';
import 'package:ksta/theme/light_theme.dart';
import 'package:ksta/utils/inputs/scroll_behaviour.dart';

final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        title: 'KSTA',
        themeMode: .light,
        theme: lightTheme,
        darkTheme: darkTheme,
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        routerConfig: _appRouter.router,
        scrollBehavior: AppScrollBehavior(),
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('de'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        builder: (context, child) {
          return MediaQuery.withNoTextScaling(
            child: child ?? const ScaffoldErrorPage(message: 'Error, no child provided'),
          );
        },
      ),
    );
  }
}
