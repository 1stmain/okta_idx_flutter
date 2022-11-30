class OktaResponse {
  final String? id;
  final String? accessToken;
  final bool reEnroll;
  final bool codeSentFor2FA;

  OktaResponse(
      {required this.id,
      required this.accessToken,
      required this.reEnroll,
      required this.codeSentFor2FA});

  factory OktaResponse.parse(Map? map) {
    if (map == null) {
      throw Exception('Empty Okta Result');
    }
    return OktaResponse(
      id: map['userId'] != null ? map['userId'] as String : null,
      accessToken:
          map['accessToken'] != null ? map['accessToken'] as String : null,
      reEnroll: map['reEnroll'] != null ? true : false,
      codeSentFor2FA: map['codeSentFor2FA'] != null ? true : false,
    );
  }
}
