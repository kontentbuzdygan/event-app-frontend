import "dart:async";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:rest_client/rest_client.dart";

const String _apiPath = "auth";
const String _tokenStorageKey = "event-app-user-token";

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final _storage = FlutterSecureStorage();

  Future<void> _writeToken(String? token) async {
    await _storage.write(key: _tokenStorageKey, value: token);
  }

  Future<void> _deleteToken() async {
    await _storage.delete(key: _tokenStorageKey);
  }

  Future<String?> readToken() => _storage.read(key: _tokenStorageKey);

  Stream<AuthenticationStatus> get status async* {
    yield* _controller.stream;
  }

  Future<bool> exists({required String email}) async {
    final res =
        await restClient.post([_apiPath, "user-exists"], {"email": email});
    return res["user_exists"];
  }

  Future<void> restoreAndRefreshToken() async {
    final token = null;

    if (token == null) {
      _controller.add(AuthenticationStatus.unauthenticated);
      return;
    }
    restClient.setAuthorizationHeader(token);
    final res = await restClient.post([_apiPath, "refresh"]);
    await _writeToken(token);
    print(res["token"]);
    restClient.setAuthorizationHeader(res["token"]);
    _controller.add(AuthenticationStatus.authenticated);
  }

  Future<void> signOut() async {
    await restClient.delete([_apiPath, "sign-out"]);
    await _deleteToken();

    restClient.setAuthorizationHeader(null);
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> signIn({required String email, required String password}) async {
    final res = await restClient.post([
      _apiPath,
      "sign-in"
    ], {
      "email": email,
      "password": password,
    });

    _writeToken(res["token"]);
    restClient.setAuthorizationHeader(res["token"]);
    _controller.add(AuthenticationStatus.authenticated);
  }

  Future<void> signUp({required String email, required String password}) async {
    final res = await restClient.post([
      _apiPath,
      "sign-up"
    ], {
      "email": email,
      "password": password,
    });

    _writeToken(res["token"]);
    print(res["token"]);
    restClient.setAuthorizationHeader(res["token"]);
    _controller.add(AuthenticationStatus.authenticated);
  }

  Future<void> clearToken() async {
    restClient.setAuthorizationHeader(null);
    await _deleteToken();
  }

  void dispose() => _controller.close();
}
