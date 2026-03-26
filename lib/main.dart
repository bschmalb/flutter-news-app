import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksta/app/app.dart';
import 'package:ksta/app/app_dependencies.dart';
import 'package:ksta/config/app_config.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  AppConfig.validateRequired();
  initializeAppDependencies();

  await SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
  await SystemChrome.setPreferredOrientations([.portraitUp]);

  runApp(const App());
}
