import 'package:digital_signer/utils/log.dart';
import 'package:digital_signer/handlers/rest_handler.dart';
import 'package:digital_signer/handlers/store_handler.dart';
import 'package:digital_signer/models/token_data.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenHandler {
  Future<bool> isTokenExpired(String token) async {
    bool isExpired = JwtDecoder.isExpired(token);
    return isExpired;
  }

  Future<String> getTokenExpirationDate(String token) async {
    DateTime expirationDate = JwtDecoder.getExpirationDate(token);
    return expirationDate.toString();
  }

  Future<int> getTokenDuration(String token) async {
    Duration tokenTime = JwtDecoder.getTokenTime(token);
    return tokenTime.inMinutes;
  }

  Future<String> getToken() async {
    logger.i("fetching accessToken from server...");
    String accessToken = "";
    final response = await RestHandler().getTokenData();
    if (response.statusCode == 200) {
      logger.i("response.data: ${response.data}");
      // Map<String, dynamic> tokenResponse =
      //     jsonDecode(response.data) as Map<String, dynamic>;
      TokenData tokenData = TokenData.fromJson(response.data);
      accessToken = tokenData.accessToken;
    } else {
      // Handle error
      logger.i("could not fetch accessToken from server...");
    }
    return accessToken;
  }

  Future<String> getAccessToken() async {
    var accessToken = await StoreHandler().readData('accessToken');
    if (accessToken.isEmpty) {
      logger.i("accessToken not found in the storage!");
      accessToken = await getToken();
      StoreHandler().saveData('accessToken', accessToken);
    } else {
      logger.i("accessToken found in the storage");
      final isExpired = await isTokenExpired(accessToken);
      final expiration = await getTokenExpirationDate(accessToken);
      if (isExpired) {
        logger.i("accessToken has expired at: $expiration");
        accessToken = await getToken();
        StoreHandler().saveData('accessToken', accessToken);
      } else {
        logger.i("accessToken will expire at: $expiration");
      }
    }
    logger.d("accessToken: $accessToken");

    return accessToken;
  }
}
