// {
//   "identificador": "ABC123",
//   "quantidadeAssinaturas": 1,
//   "documentos": [
//     {
//       "hash": "ABCDEF123456",
//       "nomeArquivo": "Nome do documento",
//       "links": [
//         {
//           "rel": "string",
//           "href": "https://link_para_recuperar_documento_Assinado"
//         }
//       ]
//     }
//   ]
// }

class Link {
  String? rel;
  String? href;
  Link({rel, href});
  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(rel: json['rel'], href: json['rel']);
  }

  Map<String, dynamic> toJson() => {
        'rel': rel,
        'href': href,
      };
}

class Documento {
  String? hash;
  String? nomeArquivo;
  List<Link>? links;
  Documento({hash, nomeArquivo, links});
  factory Documento.fromJson(Map<String, dynamic> json) {
    var list = json['links'] as List;
    List<Link> linksList = list.map((link) => Link.fromJson(link)).toList();
    return Documento(
        hash: json['hash'], nomeArquivo: json['nomeArquivo'], links: linksList);
  }

  Map<String, dynamic> toJson() => {
        'hash': hash,
        'nomeArquivo': nomeArquivo,
        'links': links,
      };
}

class SignatureResponseData {
  String? identificador;
  int? quantidadeAssinaturas;
  List<Documento>? documentos;

  SignatureResponseData({identificador, quantidadeAssinaturas, documentos});
  factory SignatureResponseData.fromJson(Map<String, dynamic> json) {
    var list = json['documentos'] as List;
    List<Documento> documentsList =
        list.map((documento) => Documento.fromJson(documento)).toList();
    return SignatureResponseData(
        identificador: json['identificador'],
        quantidadeAssinaturas: json['quantidadeAssinaturas'],
        documentos: documentsList);
  }

  Map<String, dynamic> toJson() => {
        'identificador': identificador,
        'quantidadeAssinaturas': quantidadeAssinaturas,
        'documentos': documentos,
      };
}
