import "package:event_app/api/json.dart";
import "package:event_app/api/rest_client.dart";

const String _apiPath = "auth";

class User {
  static Future<bool> exists(String email) async {
    final res = await rest.post([_apiPath, "user-exists"], {"email": email});
    return res["user_exists"];
  }

  static Future<String> refreshToken() async {
    final res = await rest.post([_apiPath, "refresh"]);
    return res["token"];
  }

  static Future<void> signOut() => rest.delete([_apiPath, "sign-out"]);

  static Future<String> signIn(String email, String password) async {
    final res = await rest.post([
      _apiPath,
      "sign-in"
    ], {
      "email": email,
      "password": password,
    });
    return res["token"];
  }
}

class NewUser {
  String email, password;

  NewUser({required this.email, required this.password});

  JsonObject toJson() => {
        "email": email,
        "password": password,
      };

  Future<void> signUp() async {
    await rest.post([_apiPath, "sign-up"], toJson());
  }
}
