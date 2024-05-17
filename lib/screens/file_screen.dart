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
  late String filePath = "";
  late String fileName = "";
  late int fileSize = 0;
  late String accessToken = "";
  late String tokenExp = "";
  FilePickerResult? result;

  Future<void> setFilePathAndBytes() async {
    result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) {
      logger.i("No file selected");
    } else {
      final PlatformFile file = result!.files.first;
      setState(() {
        if (!kIsWeb) {
          filePath = file.path!;
          fileName = file.name;
          logger.w("Getting file using File Path. Path: $filePath");
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
                          'Selected file: $fileName',
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await setFilePathAndBytes();
                      },
                      child: const Text("File Picker"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (kIsWeb) {
                          context.go('/pdf', extra: fileBytes);
                        } else {
                          context.go('/pdf', extra: filePath);
                        }
                      },
                      child: const Text("PDF"),
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
