class AuthToken {
  static final AuthToken _instance = AuthToken._internal();

  factory AuthToken() {
    return _instance;
  }

  AuthToken._internal();

  String? accessToken;
}