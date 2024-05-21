import 'package:digital_signer/models/image_config_data.dart';
import 'package:digital_signer/models/kms_data.dart';
import 'package:digital_signer/models/text_config_data.dart';

class SignatureData {
  late String perfil;
  late String algoritmoHash;
  late KmsData kmsData;
  late TextConfigData configuracaoTexto;
  late ImageConfigData configuracaoImagem;

  SignatureData(
      {perfil, algoritmoHash, kmsData, configuracaoTexto, configuracaoImagem});

  factory SignatureData.fromJson(Map<String, dynamic> json) {
    return SignatureData(
      perfil: json['perfil'],
      algoritmoHash: json['algoritmoHash'],
      kmsData: json['kms_data'],
      configuracaoTexto: json['configuracao_texto'],
      configuracaoImagem: json['configuracao_imagem'],
    );
  }
}
