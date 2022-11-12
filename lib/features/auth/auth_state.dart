import "package:event_app/features/auth/auth_service.dart";
import "package:flutter/material.dart";

class AuthState extends ChangeNotifier {
  String? get userToken => _userToken;
  String? _userToken;

  bool get loading => _loading;
  bool _loading = false;

  String? get error => _error;
  String? _error;

  bool get canLogIn => _userToken == null && !_loading;
  bool get loggedIn => _userToken != null;

  void signIn(String email, String password) async {
    _loading = true;
    notifyListeners();

    final loginResponse = await AuthService.signIn(email, password);

    if (loginResponse is SignInSuccess) {
      _userToken = loginResponse.authToken;
    } else if (loginResponse is AuthInvalidCredentials) {
      _error = "Invalid login credentials";
    } else if (loginResponse is AuthUnexpectedException) {
      // _error = loginResponse.exception.toString();
    } else {
      throw ArgumentError.value(
        loginResponse,
        "loginResponse",
        "Unexpected subtype of LoginResponse",
      );
    }

    _loading = false;
    notifyListeners();
  }

  void signOut(String token) async {
    _loading = true;
    notifyListeners();

    final signOutResponse = await AuthService.signOut(token);

    if (signOutResponse is SignOutSuccess) {
      _userToken = null;
    } else {
      // elo
    }

    _loading = false;
    notifyListeners();
  }
}
