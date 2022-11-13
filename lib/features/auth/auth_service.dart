import 'dart:convert';
import 'dart:io';
import 'package:event_app/services/http.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Uri _endpoint(String? endpoint) {
    return Uri.parse("$baseUri/auth/$endpoint");
  }

  static Future<HttpResponse> signIn(String email, String password) async {
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

    if (res.statusCode == 200) {
      return SignInSuccess.fromJson(jsonDecode(res.body));
    }

    return _handleStatus(res.statusCode);
  }

  static Future<HttpResponse> signUp(String email, String password) async {
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

    if (res.statusCode == 201) {
      return const SignUpSuccess();
    }

    return _handleStatus(res.statusCode);
  }

  static Future<HttpResponse> signOut(String token) async {
    final res = await http.delete(
      _endpoint("sign-out"),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      return const SignOutSuccess();
    }

    return _handleStatus(res.statusCode);
  }

  static HttpResponse _handleStatus(int statusCode) {
    if (statusCode == 401) {
      return const InvalidCredentials();
    }

    return const UnexpectedException();
  }
}

class SignInSuccess implements ResponseSuccess {
  final String authToken;
  const SignInSuccess(this.authToken);

  factory SignInSuccess.fromJson(Map<String, dynamic> json) {
    return SignInSuccess(json["token"]);
  }
}

class SignUpSuccess implements ResponseSuccess {
  const SignUpSuccess();
}

class SignOutSuccess implements ResponseSuccess {
  const SignOutSuccess();
}
