import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ksta/router/pages/scaffold_error_page.dart';
import 'package:ksta/router/router.dart';
import 'package:ksta/theme/app_colors.dart';
import 'package:ksta/theme/dark_theme.dart';
import 'package:ksta/theme/light_theme.dart';
import 'package:ksta/theme/theme_manager.dart';
import 'package:ksta/theme/theme_manager_scope.dart';
import 'package:ksta/utils/inputs/scroll_behaviour.dart';

final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends StatefulWidget {
  const App({super.key, required this.themeManager});

  final ThemeManager themeManager;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter _appRouter;

  SystemUiOverlayStyle _statusBarStyleForTheme(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    );
  }

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
  }

  @override
  void dispose() {
    widget.themeManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeManagerScope(
      themeManager: widget.themeManager,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListenableBuilder(
          listenable: widget.themeManager,
          builder: (context, _) {
            return MaterialApp.router(
              title: 'KSTA',
              themeMode: widget.themeManager.themeMode,
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
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: _statusBarStyleForTheme(Theme.of(context)),
                  child: MediaQuery.withNoTextScaling(
                    child: child ?? const ScaffoldErrorPage(message: 'Error, no child provided'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
