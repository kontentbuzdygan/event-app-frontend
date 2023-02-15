import "package:event_app/api/models/user.dart";
import "package:event_app/main.dart";
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

const userTokenStorageKey = "event-app-user-token";

class AuthState extends ChangeNotifier {
  Future<void> restoreToken() async {
    _userToken = await storage.read(key: userTokenStorageKey);
    notifyListeners();
  }

  String? get userToken => _userToken;
  String? _userToken;

  bool get loading => _loading;
  bool _loading = false;

  bool get canLogIn => _userToken == null && !_loading;
  bool get loggedIn => _userToken != null;

  Future<void> signIn(String email, String password) => _transition(() async {
        _userToken = await User.signIn(email, password);
        const storage = FlutterSecureStorage();
        await storage.write(key: userTokenStorageKey, value: _userToken);
      });

  Future<void> signUp(String email, String password) =>
      _transition(() => NewUser(email: email, password: password).signUp());

  // FIXME: Do not clear _userToken before the router finishes transitioning
  // to the signed-out state. On logout, this causes an attempt to refetch data
  // when the token has already been cleared.
  Future<void> signOut() => _transition(() async {
        if (_userToken == null) return;
        await User.signOut();
        await storage.delete(key: userTokenStorageKey);
        _userToken = null;
      });

  Future<void> refreshToken() => _transition(() async {
        if (_userToken == null) return;
        const storage = FlutterSecureStorage();
        await storage.write(key: userTokenStorageKey, value: _userToken);
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
