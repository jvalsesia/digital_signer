import 'package:digital_signer/screens/input_screen.dart';
import 'package:digital_signer/utils/constants.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: kAppBackgroundColor,
        ),
        scaffoldBackgroundColor: kAppBackgroundColor,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const InputScreen(),
        '/result': (context) => const InputScreen(),
      },
    );
  }
}
