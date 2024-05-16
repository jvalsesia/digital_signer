import 'package:http/http.dart' as http;

class RestHandler {
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

    final response = await postData(url, data);
    return response;
  }
}
