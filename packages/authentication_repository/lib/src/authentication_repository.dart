import "dart:async";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:rest_client/rest_client.dart";

const String _apiPath = "auth";
const String _tokenStorageKey = "event-app-user-token";

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final _storage = FlutterSecureStorage();

  Future<void> setToken(String? token) async {
    await _storage.write(key: _tokenStorageKey, value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenStorageKey);
  }

  Future<String?> readToken() => _storage.read(key: _tokenStorageKey);

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<bool> exists(String email) async {
    final res =
        await restClient.post([_apiPath, "user-exists"], {"email": email});
    return res["user_exists"];
  }

  Future<void> refreshToken() async {
    final token = await readToken();

    if (token == null) {
      _controller.add(AuthenticationStatus.unauthenticated);
      return;
    }

    final res = await restClient.post([_apiPath, "refresh"]);
    await setToken(token);

    restClient.setAuthorizationHeader(res["token"]);
    _controller.add(AuthenticationStatus.authenticated);
  }

  Future<void> signOut() async {
    await restClient.delete([_apiPath, "sign-out"]);
    await deleteToken();

    restClient.setAuthorizationHeader(null);
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> signIn(String email, String password) async {
    final res = await restClient.post([
      _apiPath,
      "sign-in"
    ], {
      "email": email,
      "password": password,
    });

    setToken(res["token"]);
    restClient.setAuthorizationHeader(res["token"]);
    _controller.add(AuthenticationStatus.authenticated);
  }
}
