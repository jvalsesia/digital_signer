import 'dart:io';
import 'package:digital_signer/utils/log.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileHandler {
  Future<File> loadPdfFromNetwork(String url) async {
    final dio = Dio();
    // final response = await dio.get(url);
    // print(response.data);
    //final dir = await getApplicationDocumentsDirectory();
    //getDownloadsDirectory
    final dir = await getDownloadsDirectory();
    final filename = path.basename(url);
    final File file = File('${dir?.path}/$filename.pdf');
    final response = await dio.download(
      url,
      file.path,
    );

    logger.d(response.statusCode);
    return file;
  }
}
