import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  String? get userName => _userName;
  String? _userName;

  bool get loggedIn => _userName != null;

  void login(String userName) {
    _userName = userName;
    notifyListeners();
  }

  void logout() {
    _userName = null;
    notifyListeners();
  }
}
