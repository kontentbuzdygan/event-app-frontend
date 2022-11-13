import 'dart:convert';
import 'dart:io';
import 'package:event_app/services/config.dart';
import 'package:event_app/services/http_exceptions.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Uri _endpoint(String? endpoint) {
    return Uri.parse("$baseUri/auth/$endpoint");
  }

  static Future<String> signIn(String email, String password) async {
    final res = await http.post(
      _endpoint("sign-in"),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["token"];
    }

    _handleStatus(res.statusCode);
    throw UnexpectedException();
  }

  static Future<void> signUp(String email, String password) async {
    final res = await http.post(
      _endpoint("sign-up"),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (res.statusCode == 201) return;

    if (res.statusCode == 409) {
      throw InvalidCredentials(
        message: "An account with this email already exists",
      );
    }

    _handleStatus(res.statusCode);
    throw UnexpectedException();
  }

  static Future<void> signOut(String token) async {
    final res = await http.delete(
      _endpoint("sign-out"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    if (res.statusCode == 200) return;

    _handleStatus(res.statusCode);
    throw UnexpectedException();
  }

  static Future<String> refreshToken(String token) async {
    final res = await http.post(
      _endpoint("refresh"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["token"];
    }

    _handleStatus(res.statusCode);
    throw UnexpectedException();
  }

  static Future<bool> userExists(String email) async {
    final res = await http.post(
      _endpoint("user-exists"),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "email": email,
      }),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["user_exists"];
    }

    _handleStatus(res.statusCode);
    throw UnexpectedException();
  }

  static void _handleStatus(int statusCode) {
    if (statusCode == 401) {
      throw InvalidCredentials();
    }
  }
}
