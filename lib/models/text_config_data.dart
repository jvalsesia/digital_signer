class TextConfigData {
  late String texto;

  TextConfigData({texto});

  factory TextConfigData.fromJson(Map<String, dynamic> json) {
    return TextConfigData(texto: json['texto']);
  }
}
