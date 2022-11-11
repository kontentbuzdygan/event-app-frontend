import 'package:event_app/features/auth/auth_service.dart';
import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  String? get userToken => _userToken;
  String? _userToken;

  bool get loading => _loading;
  bool _loading = false;

  String? get error => _error;
  String? _error;

  bool get canLogIn => _userToken == null && !_loading;
  bool get loggedIn => _userToken != null;

  void login(String username, String password) async {
    _loading = true;
    notifyListeners();

    try {
      _userToken = await AuthService.signIn(username, password);
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  void logout() {
    _userToken = null;
    notifyListeners();
  }
}
