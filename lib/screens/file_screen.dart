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
  late Uint8List? fileBytes;
  late String? filePath;

  FilePickerResult? result;

  Future<void> setFilePathAndBytes() async {
    result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) {
      logger.i("No file selected");
    } else {
      final PlatformFile file = result!.files.first;
      String? filePath = "";
      Uint8List? fileBytes = Uint8List(0);
      if (!kIsWeb) {
        filePath = file.path;
      } else {
        fileBytes = file.bytes;
      }
      logger.d(filePath);
      logger.w(fileBytes);
      setState(() {
        this.filePath = filePath;
        this.fileBytes = fileBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("File picker demo"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (result != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Selected file:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: result?.files.length ?? 0,
                        itemBuilder: (context, index) {
                          return Text(result?.files[index].name ?? '',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold));
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 5,
                          );
                        },
                      )
                    ],
                  ),
                ),
              const Spacer(),
              Center(
                child: Row(
                  children: [
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
                          logger.w(">>> $filePath");
                          context.go('/pdf', extra: filePath);
                        }
                      },
                      child: const Text("PDF"),
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
            ],
          ),
        ),
      ),
    );
  }
}
