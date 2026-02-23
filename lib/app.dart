import 'package:flutter/material.dart';
import 'router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BuildMyPC',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
    );
  }
}
