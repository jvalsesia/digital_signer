import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RestHandler {
  Future<Response> getTokenData() async {
    final dio = Dio();
    String url = "https://cloud.bry.com.br/token-service/jwt";
    Map<String, String> data = {
      "grant_type": "client_credentials",
      "client_id": "4573e45d-cc3b-4e71-982d-5c65199863a4",
      "client_secret":
          "X6fVgrj4zqBYpYtuKvUK1rCKq7Lpk8wx9yQy2oJhgyePeiCTmRoJZw=="
    };

    // Instance level
    dio.options.contentType = Headers.formUrlEncodedContentType;
    // or only works once
    final response = await dio.post(
      url,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return response;
  }

  Future<dynamic> sendDocument(
      String token, String documentPath, String imagePath, String texto) async {
    final dio = Dio();
    String uriHub = "https://hub2.bry.com.br";
    String endPoint = "/fw/v1/pdf/kms/lote/assinaturas";

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

    dio.options.headers['accept'] = "application/json";
    dio.options.headers['Content-Type'] = "multipart/form-data";
    dio.options.headers['Authorization'] = token;
    dio.options.headers['kms_type'] = kmsType;

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

    final formData = FormData.fromMap({
      'configuracao_imagem': configuracaoImagem,
      'configuracao_texto': configuracaoTexto,
      'dados_assinatura': dadosAssinatura,
      'documento':
          await MultipartFile.fromFile(documento, filename: 'documento'),
      'imagem': await MultipartFile.fromFile(imagem, filename: 'imagem'),
    });

    final Response response = await dio.post(uriHub + endPoint, data: formData);

    return response.data;
  }

  Future<dynamic> sendDocumentAsBytes(String token, Uint8List documentPath,
      Uint8List imagePath, String texto) async {
    final dio = Dio();
    String uriHub = "https://hub2.bry.com.br";
    String endPoint = "/fw/v1/pdf/kms/lote/assinaturas";

    Uint8List documento = documentPath;
    String perfil = "TIMESTAMP";
    String algoritmoHash = "SHA256";
    String kmsType = "BRYKMS";

    String pin = "UjA3N3czaWwzciE=";
    String user = "27172605870";
    String uuidCert = "c62691d9-26c5-4494-8e40-fdfa33a569f3";

    Uint8List imagem = imagePath;
    String pagina = "PRIMEIRA";
    int largura = 100;
    int altura = 100;
    String coordenadaX = "-10";
    String coordenadaY = "10";

    String posicao = "INFERIOR_DIREITO";

    dio.options.headers['accept'] = "application/json";
    dio.options.headers['Content-Type'] = "multipart/form-data";
    dio.options.headers['Authorization'] = token;
    dio.options.headers['kms_type'] = kmsType;

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

    final formData = FormData.fromMap({
      'configuracao_imagem': configuracaoImagem,
      'configuracao_texto': configuracaoTexto,
      'dados_assinatura': dadosAssinatura,
      'documento': MultipartFile.fromBytes(documento, filename: 'documento'),
      'imagem': MultipartFile.fromBytes(imagem, filename: 'imagem'),
    });

    final Response response = await dio.post(uriHub + endPoint, data: formData);

    return response.data;
  }
}
