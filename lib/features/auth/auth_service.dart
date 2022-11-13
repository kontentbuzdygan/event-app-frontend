import "dart:convert";
import "dart:io";
import "package:event_app/config.dart";
import "package:event_app/api/exceptions.dart";
import "package:http/http.dart" as http;

class AuthService {
  static const _defaultHeaders = {
    HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    HttpHeaders.acceptHeader: "application/json",
  };

  static Uri _endpoint(String? path) {
    return Uri.parse("$baseUri/auth/$path");
  }

  static Future<String> signIn(String email, String password) async {
    final res = await http.post(
      _endpoint("sign-in"),
      headers: _defaultHeaders,
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["token"];
    }

    throw InvalidResponseStatus.of(res.statusCode);
  }

  static Future<void> signUp(String email, String password) async {
    final res = await http.post(
      _endpoint("sign-up"),
      headers: _defaultHeaders,
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (res.statusCode == 201) return;

    if (res.statusCode == 409) {
      throw const AlreadyExists(
        message: "An account with this email already exists",
      );
    }

    throw InvalidResponseStatus.of(res.statusCode);
  }

  static Future<void> signOut(String token) async {
    final res = await http.delete(
      _endpoint("sign-out"),
      headers: {
        ..._defaultHeaders,
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    if (res.statusCode == 200) return;

    throw InvalidResponseStatus.of(res.statusCode);
  }

  static Future<String> refreshToken(String token) async {
    final res = await http.post(
      _endpoint("refresh"),
      headers: {
        ..._defaultHeaders,
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["token"];
    }

    throw InvalidResponseStatus.of(res.statusCode);
  }

  static Future<bool> userExists(String email) async {
    final res = await http.post(
      _endpoint("user-exists"),
      headers: _defaultHeaders,
      body: jsonEncode({
        "email": email,
      }),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["user_exists"];
    }

    throw InvalidResponseStatus.of(res.statusCode);
  }
}
