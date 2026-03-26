import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ksta/app/app.dart';
import 'package:ksta/app/app_dependencies.dart';
import 'package:ksta/config/app_config.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  AppConfig.validateRequired();
  final appDependencies = await initializeAppDependencies();

  runApp(App(themeManager: appDependencies.themeManager));
}
