import 'package:digital_signer/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

class PdfScreen extends StatelessWidget {
  final String? filePath;

  const PdfScreen({super.key, this.filePath});

  Future<Uint8List> pdfToDoc(String filePath) async {
    final pdf = await rootBundle.load(filePath);
    return pdf.buffer.asUint8List();
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
        actionBarTheme: const PdfActionBarTheme(backgroundColor: Colors.grey),
      ),
    );
  }
}
