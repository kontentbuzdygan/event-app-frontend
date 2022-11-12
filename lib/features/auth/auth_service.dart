import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const domain = "localhost:8001";
const authBaseUrl = "/api/v0/auth";

class AuthService {
  static Future<AuthResponse> signIn(String email, String password) async {
    final url = Uri.http(domain, "$authBaseUrl/sign-in");
    final res = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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

  static Future<AuthResponse> signUp(String email, String password) async {
    final url = Uri.http(domain, "$authBaseUrl/sign-up");
    final res = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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

  static Future<AuthResponse> signOut(String token) async {
    final url = Uri.http(domain, "$authBaseUrl/sign-out");
    final res = await http.delete(
      url,
      headers: <String, String>{
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      return const SignOutSuccess();
    }

    return _handleStatus(res.statusCode);
  }

  static AuthResponse _handleStatus(int statusCode) {
    if (statusCode == 401) {
      return const AuthInvalidCredentials();
    }

    return const AuthUnexpectedException();
  }
}

abstract class AuthResponse {}

class AuthInvalidCredentials implements AuthResponse {
  const AuthInvalidCredentials();
}

class AuthNoInternetConnection implements AuthResponse {
  const AuthNoInternetConnection();
}

class AuthUnexpectedException implements AuthResponse {
  const AuthUnexpectedException();
}

class SignInSuccess implements AuthResponse {
  final String authToken;
  const SignInSuccess(this.authToken);

  factory SignInSuccess.fromJson(Map<String, dynamic> json) {
    return SignInSuccess(json["token"]);
  }
}

class SignUpSuccess implements AuthResponse {
  const SignUpSuccess();
}

class SignOutSuccess implements AuthResponse {
  const SignOutSuccess();
}
