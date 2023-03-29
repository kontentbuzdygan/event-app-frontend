import "dart:ffi";

import "package:event_app/api/exceptions.dart";
import "package:event_app/api/models/user.dart";
import "package:event_app/secure_storage.dart";
import "package:flutter/material.dart";
import "package:event_app/api/models/profile.dart";

const userTokenStorageKey = "event-app-user-token";

class AuthState extends ChangeNotifier {
  String? get userToken => _userToken;
  String? _userToken;

  int? myId;

  bool get loading => _loading;
  bool _loading = false;

  bool get canLogIn => _userToken == null && !_loading;
  bool get loggedIn => _userToken != null;

  Future<void> restoreAndRefreshToken() => _transition(() async {
        _userToken = await secureStorage.read(key: userTokenStorageKey);
        try {
          await refreshToken();
        } on Unauthorized {
          await _setUserToken(null);
          return;
        }
        
        myId = (await Profile.me()).id;
      });

  Future<void> signIn(String email, String password) =>
      _transition(() => User.signIn(email, password).then(_setUserToken));

  Future<void> signUp(String email, String password) =>
      _transition(() => NewUser(email: email, password: password).signUp());

  // FIXME: Do not clear _userToken before the router finishes transitioning
  // to the signed-out state. On logout, this causes an attempt to refetch data
  // when the token has already been cleared.
  Future<void> signOut() => _transition(() async {
        if (_userToken == null) return;
        await User.signOut();
        _setUserToken(null);
      });

  Future<void> refreshToken() =>
      _transition(() => User.refreshToken().then(_setUserToken));

  Future<bool> userExists(String email) =>
      _transition(() => User.exists(email));

  Future<void> deleteUserToken() => _transition(() => _setUserToken(null));

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

  Future<void> _setUserToken(String? userToken) async {
    _userToken = userToken;
    if (userToken == null) {
      await secureStorage.delete(key: userTokenStorageKey);
    } else {
      await secureStorage.write(key: userTokenStorageKey, value: _userToken);
    }
  }
}
