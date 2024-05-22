import 'dart:convert';

import 'package:digital_signer/utils/log.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class RestHandler {
  final dio = Dio();

  Future<http.Response> postData(String url, Map<String, String> data) async {
    String encodedData = "";
    data.forEach((key, value) =>
        encodedData += "$key=${Uri.encodeQueryComponent(value)}&");
    encodedData = encodedData.substring(0, encodedData.length - 1);

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: encodedData,
    );

    return response;
  }

  Future<http.Response> getTokenData() async {
    String url = "https://cloud.bry.com.br/token-service/jwt";
    Map<String, String> data = {
      "grant_type": "client_credentials",
      "client_id": "4573e45d-cc3b-4e71-982d-5c65199863a4",
      "client_secret":
          "X6fVgrj4zqBYpYtuKvUK1rCKq7Lpk8wx9yQy2oJhgyePeiCTmRoJZw=="
    };

    // final response = await postData(url, data);
    //return response;

    // Instance level
    dio.options.contentType = Headers.formUrlEncodedContentType;
    // or only works once
    final response = await dio.post(
      url,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return response.data;
  }

  Future<String> sendDocument(
      String token, String documentPath, String imagePath, String texto) async {
    String uriHub = "https://hub2.bry.com.br";
    String service = "/fw/v1/pdf/kms/lote/assinaturas";

    String documento = documentPath;
    String perfil = "TIMESTAMP";
    String algoritmoHash = "SHA256";
    String kmsType = "BRYKMS";

    String pin = "UjA3N3czaWwzciE=";
    String user = "27172605870";
    String uuidCert = "c62691d9-26c5-4494-8e40-fdfa33a569f3";

    String imagem = imagePath;
    String pagina = "PRIMEIRA";
    int largura = 100;
    int altura = 100;
    String coordenadaX = "-10";
    String coordenadaY = "10";

    String posicao = "INFERIOR_DIREITO";

    var request = http.MultipartRequest('POST', Uri.parse(uriHub + service));
    request.headers['accept'] = "application/json";
    request.headers['Content-Type'] = "multipart/form-data";
    request.headers['Authorization'] = token;
    request.headers['kms_type'] = kmsType;

    request.files
        .add(await http.MultipartFile.fromPath('documento', documento));
    request.files.add(await http.MultipartFile.fromPath('imagem', imagem));

    var dadosAssinatura = jsonEncode({
      "perfil": perfil,
      "algoritmoHash": algoritmoHash,
      "kms_data": {
        "pin": pin,
        "uuid_cert": uuidCert,
        "user": user,
      },
    });

    var configuracaoImagem = jsonEncode({
      "altura": altura,
      "largura": largura,
      "coordenadaX": coordenadaX,
      "coordenadaY": coordenadaY,
      "posicao": posicao,
      "pagina": pagina,
    });

    var configuracaoTexto = jsonEncode({
      "texto": texto,
      "fonte": "COURIER",
      "tamanhoFonte": 12,
    });

    request.fields['configuracao_imagem'] = configuracaoImagem;
    request.fields['configuracao_texto'] = configuracaoTexto;
    request.fields['dados_assinatura'] = dadosAssinatura;

    logger.d("reques headers: ${request.headers}");
    logger.d("reques files: ${request.files.asMap()}");
    logger.d("reques fields: ${request.fields}");

    final response = await request.send();

    // Extract String from Streamed Response
    var responseString = await response.stream.bytesToString();
    return responseString;
  }
}
