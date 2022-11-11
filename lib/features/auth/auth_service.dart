class AuthService {
  static Future<String> signIn(String username, String password) =>
      Future.delayed(const Duration(seconds: 2)).then((_) => "user_token");
}
