import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksta/app/app.dart';
import 'package:ksta/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.validateRequired();

  await SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
  await SystemChrome.setPreferredOrientations([.portraitUp]);

  runApp(const App());
}
