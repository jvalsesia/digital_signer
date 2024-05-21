class KmsData {
  late String pin;
  late String uuidCert;
  late String user;
  KmsData({pin, uuidCert, user});

  factory KmsData.fromJson(Map<String, dynamic> json) {
    return KmsData(
        pin: json['pin'], uuidCert: json['uuid_cert'], user: json['user']);
  }
}
