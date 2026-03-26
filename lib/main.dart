import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:ksta/app/app.dart';
import 'package:ksta/app/app_dependencies.dart';
import 'package:ksta/config/app_config.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  usePathUrlStrategy();

  AppConfig.validateRequired();
  final appDependencies = await initializeAppDependencies();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(App(themeManager: appDependencies.themeManager));
}
