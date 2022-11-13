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
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    _handleStatus(res.statusCode);

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["token"];
    }

    throw UnexpectedException();
  }

  static Future<void> signUp(String email, String password) async {
    final res = await http.post(
      _endpoint("sign-up"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    _handleStatus(res.statusCode);

    if (res.statusCode == 201) {
      return;
    }

    throw UnexpectedException();
  }

  static Future<void> signOut(String token) async {
    final res = await http.delete(
      _endpoint("sign-out"),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    _handleStatus(res.statusCode);

    if (res.statusCode == 200) {
      return;
    }

    throw UnexpectedException();
  }

  static void _handleStatus(int statusCode) {
    if (statusCode == 401) {
      throw InvalidCredentials();
    }
  }
}
