import 'package:digital_signer/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

class PdfWebScreen extends StatelessWidget {
  final Uint8List? fileBytes;

  const PdfWebScreen({super.key, this.fileBytes});

  Future<Uint8List> pdfBytesToDoc(Uint8List fileBytes) async {
    return fileBytes;
  }

  @override
  Widget build(BuildContext context) {
    logger.d(fileBytes);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Start"),
      ),
      body: PdfPreview(
        build: (format) async => await pdfBytesToDoc(fileBytes!),
        actionBarTheme: const PdfActionBarTheme(backgroundColor: Colors.grey),
      ),
    );
  }
}
