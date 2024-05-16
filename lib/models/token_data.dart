class TokenData {
// {
// "access_token": "valor_access_token",
// "expires_in": tempo_de_expiracao_access_token,
// "refresh_expires_in": tempo_de_expiracao_refresh_token,
// "refresh_token": "valor_refresh_token",
// "token_type": "bearer",
// "not-before-policy": tempo_antes_que_nao_deve_ser_aceito_o_token,
// "session_state": "valor_estado_de_sessao",
// "scope": "valor_escopo"
// }

  final String accessToken;
  final int expiresIn;
  final int refreshExpiresIn;
  final String refreshToken;
  final String tokenType;
  final int notBeforePolicy;
  final String sessionState;
  final String scope;
  TokenData(
      this.accessToken,
      this.expiresIn,
      this.refreshExpiresIn,
      this.refreshToken,
      this.tokenType,
      this.notBeforePolicy,
      this.sessionState,
      this.scope);

  TokenData.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'] as String,
        expiresIn = json['expires_in'] as int,
        refreshExpiresIn = json['refresh_expires_in'] as int,
        refreshToken = json['refresh_token'] as String,
        tokenType = json['token_type'] as String,
        notBeforePolicy = json['not-before-policy'] as int,
        sessionState = json['session_state'] as String,
        scope = json['scope'] as String;

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'expires_in': expiresIn,
        'refresh_expires_in': refreshExpiresIn,
        'refresh_token': refreshToken,
        'token_type': tokenType,
        'not-before-policy': notBeforePolicy,
        'session_state': sessionState,
        'scope': scope,
      };
}
