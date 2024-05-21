class ImageConfigData {
  late String altura;
  late String largura;
  late String posicao;
  late String pagina;
  ImageConfigData({altura, largura, posicao, pagina});

  factory ImageConfigData.fromJson(Map<String, dynamic> json) {
    return ImageConfigData(
        altura: json['altura'],
        largura: json['largura'],
        posicao: json['posicao'],
        pagina: json['pagina']);
  }

  // ImageConfigData.fromJson(Map<String, dynamic> json)
  //     : altura = json['altura'] as String,
  //       largura = json['largura'] as String,
  //       posicao = json['posicao'] as String,
  //       pagina = json['pagina'] as String;

  // Map<String, dynamic> toJson() => {
  //       'altura': altura,
  //       'largura': largura,
  //       'posicao': posicao,
  //       'pagina': pagina,
  //     };
}
