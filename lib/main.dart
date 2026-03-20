import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_web_plugins/url_strategy.dart';

import 'firebase_options.dart';
import 'app.dart';
import 'theme/language_global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    usePathUrlStrategy();
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await languageController.init();

  runApp(const App());
}
