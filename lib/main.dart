import 'package:digital_signer/screens/file_screen.dart';
import 'package:digital_signer/screens/pdf_screen.dart';
import 'package:digital_signer/screens/pdfweb_screen.dart';
import 'package:digital_signer/screens/start_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const StartScreen(),
        ),
        GoRoute(
          path: '/start',
          builder: (context, state) => const StartScreen(),
        ),
        GoRoute(
          path: '/file',
          builder: (context, state) => const FileScreen(),
        ),
        GoRoute(
          path: '/pdf',
          builder: (BuildContext context, GoRouterState state) {
            if (kIsWeb) {
              final pdfFileBytes = state.extra! as Uint8List;
              return PdfWebScreen(
                fileBytes: pdfFileBytes,
              );
            } else {
              final pdfFilePath = state.extra! as String;
              return PDFScreen(
                signedDocumentFilePath: pdfFilePath,
              );
            }
          },
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
