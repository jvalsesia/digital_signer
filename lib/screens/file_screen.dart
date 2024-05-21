import 'dart:convert';

import 'package:digital_signer/handlers/file_handler.dart';
import 'package:digital_signer/handlers/rest_handler.dart';
import 'package:digital_signer/handlers/token_handler.dart';
import 'package:digital_signer/utils/log.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FileScreen extends StatelessWidget {
  const FileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File picker demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FilePickerWidget(title: 'File picker demo'),
    );
  }
}

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({super.key, required this.title});

  final String title;

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget>
    with SingleTickerProviderStateMixin {
  late Uint8List fileBytes = Uint8List(0);
  late String documentFilePath = "";
  late String documentFileName = "";
  late String signatureFilePath = "";
  late String signatureFileName = "";

  late int fileSize = 0;
  late String accessToken = "";
  late String tokenExp = "";
  FilePickerResult? result;

  late String signedDocumentLink = "";
  late String signedDocumentFilePath = "";

  Future<void> setFilePathAndBytes(FileType fileType) async {
    result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: fileType);
    if (result == null) {
      logger.i("No file selected");
    } else {
      final PlatformFile file = result!.files.first;
      setState(() {
        if (!kIsWeb) {
          if (fileType == FileType.image) {
            signatureFilePath = file.path!;
            signatureFileName = file.name;
            logger.w(
                "Getting signature using Image Path. Path: $signatureFilePath");
          } else {
            documentFilePath = file.path!;
            documentFileName = file.name;
            logger.w("Getting file using File Path. Path: $documentFilePath");
          }
        } else {
          fileBytes = file.bytes!;
          logger.w("Getting file using File Bytes");
        }
        fileSize = file.size;
        logger.w("File size: $fileSize bytes");
      });
    }
  }

  Future<void> getAccessToken() async {
    final accessToken = await TokenHandler().getAccessToken();
    final tokenExp = await TokenHandler().getTokenExpirationDate(accessToken);

    setState(() {
      this.accessToken = accessToken;
      this.tokenExp = tokenExp;
    });
  }

  Future<void> signDocument() async {
    String documentPath = documentFilePath;
    String imagePath = signatureFilePath;
    String texto = "Digitally signed by BRY";
    final signResponse = await RestHandler()
        .sendDocument(accessToken, documentPath, imagePath, texto);
    var data = jsonDecode(signResponse);
    logger.w("$data");

    var link = data['documentos'][0]['links'][0]['href'];
    signedDocumentLink = link;
    logger.w(signedDocumentLink);
    FileHandler fileHandler = FileHandler();
    var file = await fileHandler.loadPdfFromNetwork(signedDocumentLink);
    signedDocumentFilePath = file.path;

    logger.w(signedDocumentFilePath);
  }

  @override
  initState() {
    super.initState();
    logger.i("initState Called");
    getAccessToken();
  }

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
                  "File",
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Container(
              height: 300.0,
              width: 300.0,
              color: Colors.grey,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Token expires at: $tokenExp',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Selected file: $documentFileName',
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await setFilePathAndBytes(FileType.any);
                      },
                      child: const Text("PDF"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await setFilePathAndBytes(FileType.image);
                        await signDocument();
                      },
                      child: const Text("Signature"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (kIsWeb) {
                          context.go('/pdf', extra: fileBytes);
                        } else {
                          context.go('/pdf', extra: signedDocumentFilePath);
                        }
                      },
                      child: const Text("Check PDF"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                context.go('/start');
              },
              child: const Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}
