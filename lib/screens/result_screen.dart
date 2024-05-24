import 'dart:io';

import 'package:digital_signer/screens/input_screen.dart';
import 'package:digital_signer/utils/constants.dart';
import 'package:digital_signer/utils/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ResultScreen extends StatelessWidget {
  final String signedDocumentFilePath;

  const ResultScreen({super.key, required this.signedDocumentFilePath});

  @override
  Widget build(BuildContext context) {
    logger.i(signedDocumentFilePath);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASSINATURA', style: kLargeButtonTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: kIsWeb
                    ? SfPdfViewer.network(signedDocumentFilePath)
                    : SfPdfViewer.file(File(signedDocumentFilePath))),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InputScreen(),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    //color: kBottomContainerColor,
                    margin: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      color: kBottomContainerColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: double.infinity,
                    height: kBottomContainerHeight,
                    child: const Center(
                      child: Text('VOLTAR', style: kLargeButtonTextStyle),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
