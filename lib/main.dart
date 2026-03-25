import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ksta/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
  await SystemChrome.setPreferredOrientations([.portraitUp]);

  runApp(const App());
}
