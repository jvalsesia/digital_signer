import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 150.0,
              width: 300.0,
              child: Align(
                child: Text(
                  "Welcome",
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Container(
              height: 150.0,
              width: 300.0,
              color: Colors.grey,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Open File",
                      style: TextStyle(fontSize: 15),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/file');
                      },
                      child: const Text('PDF'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 150.0,
              width: 150.0,
            ),
          ],
        ),
      ),
    );
  }
}
