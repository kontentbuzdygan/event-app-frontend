import "package:event_app/api/models/user.dart";
import "package:flutter/material.dart";

class AuthState extends ChangeNotifier {
  String? get userToken => _userToken;
  String? _userToken;

  bool get loading => _loading;
  bool _loading = false;

  bool get canLogIn => _userToken == null && !_loading;
  bool get loggedIn => _userToken != null;

  Future<void> signIn(String email, String password) => _transition(() async {
        _userToken = await User.signIn(email, password);
      });

  Future<void> signUp(String email, String password) =>
      _transition(() => NewUser(email: email, password: password).signUp());

  // FIXME: Do not clear _userToken before the router finishes transitioning
  // to the signed-out state. On logout, this causes an attempt to refetch data
  // when the token has already been cleared.
  Future<void> signOut() => _transition(() async {
        if (_userToken == null) return;
        await User.signOut();
        _userToken = null;
      });

  Future<void> refreshToken() => _transition(() async {
        if (_userToken == null) return;
        _userToken = await User.refreshToken();
      });

  Future<bool> userExists(String email) =>
      _transition(() => User.exists(email));

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
