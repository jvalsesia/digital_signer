import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Start"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              style: style,
              onPressed: () {
                context.go('/file');
              },
              child: const Text('File'),
            ),
          ],
        ),
      ),
    );
  }
}
