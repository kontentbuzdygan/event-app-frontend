import 'package:event_app/features/auth/auth_service.dart';
import 'package:event_app/services/http.dart';
import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  String? get userToken => _userToken;
  String? _userToken;

  bool get loading => _loading;
  bool _loading = false;

  bool get canLogIn => _userToken == null && !_loading;
  bool get loggedIn => _userToken != null;

  Future<void> signIn(String email, String password) async {
    _loading = true;
    notifyListeners();

    final loginResponse = await AuthService.signIn(email, password);

    _loading = false;
    notifyListeners();

    if (loginResponse is SignInSuccess) {
      _userToken = loginResponse.authToken;
      notifyListeners();
    } else if (loginResponse is InvalidCredentials) {
      throw Exception("Invalid login credentials");
    } else {
      throw Exception("Unexpected exception");
    }
  }

  void signOut(String token) async {
    _loading = true;
    notifyListeners();

    final signOutResponse = await AuthService.signOut(token);

    if (signOutResponse is SignOutSuccess) {
      _userToken = null;
    } else {
      throw Exception("Unexpected exception");
    }

    _loading = false;
    notifyListeners();
  }
}
