import 'dart:io';

import 'package:digital_signer/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

class PdfScreen extends StatelessWidget {
  final String? filePath;

  const PdfScreen({super.key, this.filePath});

  Future<Uint8List> pdfToDoc(String filePath) async {
    File pdf = File(filePath);
    return pdf.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    logger.d(filePath);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("PDF"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: Column(
            children: [
              Expanded(
                child: PdfPreview(
                  build: (format) async => await pdfToDoc(filePath!),
                  allowPrinting: false,
                  allowSharing: false,
                  canChangeOrientation: false,
                  canChangePageFormat: false,
                  actionBarTheme:
                      const PdfActionBarTheme(backgroundColor: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  context.go('/start');
                },
                child: const Text("Start"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
