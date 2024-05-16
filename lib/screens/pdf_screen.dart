import 'dart:io';

import 'package:digital_signer/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        title: const Text("Start"),
      ),
      body: PdfPreview(
        build: (format) async => await pdfToDoc(filePath!),
        allowPrinting: false,
        allowSharing: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        actionBarTheme: const PdfActionBarTheme(backgroundColor: Colors.grey),
      ),
    );
  }
}
