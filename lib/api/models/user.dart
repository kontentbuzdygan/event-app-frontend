import "package:event_app/api/json.dart";
import "package:event_app/api/rest_client.dart";

const String _apiPath = "auth";

class User {
  static Future<bool> exists(String email) async {
    try {
      final res =
          await RestClient.post([_apiPath, "user-exists"], {"email": email});
      return res["user_exists"];
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<String> refreshToken() async {
    try {
      final res = await RestClient.post([_apiPath, "refresh-token"]);
      return res["token"];
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<void> signOut() async {
    try {
      await RestClient.delete([_apiPath, "sign-out"]);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<String> signIn(String email, String password) async {
    try {
      final res = await RestClient.post(
          [_apiPath, "sign-in"], {"email": email, "password": password});
      return res["token"];
    } catch (e) {
      return Future.error(e);
    }
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
    try {
      await RestClient.post([_apiPath, "sign-up"], toJson());
    } catch (e) {
      return Future.error(e);
    }
  }
}
