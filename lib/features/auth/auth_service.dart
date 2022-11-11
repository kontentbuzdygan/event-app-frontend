class AuthService {
  static Future<String> signIn(String username, String password) {
    return Future.delayed(const Duration(seconds: 2))
        .then((value) => "user_token");
  }
}
