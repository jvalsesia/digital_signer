import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:go_router/go_router.dart';

class PdfWebScreen extends StatelessWidget {
  final Uint8List? fileBytes;

  const PdfWebScreen({super.key, this.fileBytes});

  Future<Uint8List> pdfBytesToDoc(Uint8List fileBytes) async {
    return fileBytes;
  }

  @override
  Widget build(BuildContext context) {
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
                  build: (format) async => await pdfBytesToDoc(fileBytes!),
                  allowPrinting: false,
                  allowSharing: false,
                  canChangeOrientation: false,
                  canChangePageFormat: false,
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
