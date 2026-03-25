import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksta/app/app.dart';
import 'package:ksta/config/app_config_field.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfigField.validateRequired();

  await SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
  await SystemChrome.setPreferredOrientations([.portraitUp]);

  runApp(const App());
}
