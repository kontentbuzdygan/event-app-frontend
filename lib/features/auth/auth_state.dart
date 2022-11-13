import 'package:event_app/features/auth/auth_service.dart';
import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  String? get userToken => _userToken;
  String? _userToken;

  bool get loading => _loading;
  bool _loading = false;

  bool get canLogIn => _userToken == null && !_loading;
  bool get loggedIn => _userToken != null;

  Future<void> signIn(String email, String password) => _transition(() async {
        _userToken = await AuthService.signIn(email, password);
      });

  Future<void> signUp(String email, String password) =>
      _transition(() => AuthService.signUp(email, password));

  Future<void> signOut() => _transition(() async {
        if (_userToken == null) return;
        await AuthService.signOut(_userToken!);
        _userToken = null;
      });

  Future<void> refreshToken() => _transition(() async {
        if (_userToken == null) return;
        _userToken = await AuthService.refreshToken(_userToken!);
      });

  Future<bool> userExists(String email) =>
      _transition(() => AuthService.userExists(email));

  Future<T> _transition<T>(Future<T> Function() f) async {
    _loading = true;
    notifyListeners();

    try {
      return await f();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
