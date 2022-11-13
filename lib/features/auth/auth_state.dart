import 'package:event_app/features/auth/auth_service.dart';
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

    try {
      _userToken = await AuthService.signIn(email, password);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    _loading = true;
    notifyListeners();

    try {
      await AuthService.signUp(email, password);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signOut(String token) async {
    _loading = true;
    notifyListeners();

    try {
      await AuthService.signOut(token);
      _userToken = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshToken(String token) async {
    _loading = true;
    notifyListeners();

    try {
      _userToken = await AuthService.refreshToken(token);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> userExists(String email) async {
    _loading = true;
    notifyListeners();

    try {
      return await AuthService.userExists(email);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
