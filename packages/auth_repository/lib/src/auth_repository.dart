import "dart:async";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:rest_client/rest_client.dart";

part "auth_status.dart";

const String _apiPath = "auth";
const String _accessTokenStroageKey = "event-app-access-token";

class AuthRepository {
  final FlutterSecureStorage _storage;
  final RestClient _restClient;
  final _controller =  StreamController<AuthStatus>();

  Stream<AuthStatus> get status async* {
    yield AuthStatus.unknown;
    yield* _controller.stream;
  }

  AuthRepository({required RestClient restClient, required FlutterSecureStorage storage}) 
    : _restClient = restClient,
    _storage = storage;

  Future<bool> exists({required String email}) async {
    final res = await _restClient.post(
      [_apiPath, "user-exists"], 
      {"email": email},
    );
    return res["user_exists"];
  }

  Future<void> restoreAndResfreshToken() async {
    final token = await _storage.read(key: _accessTokenStroageKey);
    _restClient.accessToken = token;
    final res = await _restClient.post([_apiPath, "refresh"]);
    _saveToken(res["token"]);
  }

  Future<void> signIn({required String email, required String password}) async {
    final res = await _restClient.post(
      [_apiPath,"sign-in"], 
      {"email": email,"password": password}
    );
    _saveToken(res["token"]);
  }

  Future<void> signUp({required String email, required String password}) async {
    final res = await _restClient.post(
      [_apiPath, "sign-up"], 
      {"email": email,"password": password},
    );
    _saveToken(res["token"]);
  }

  Future<void> signOut() async {
    await _restClient.delete([_apiPath, "sign-out"]);
    clearToken();
  }

  void clearToken() {
    _restClient.accessToken = null;
    _storage.delete(key: _accessTokenStroageKey);
    _controller.add(AuthStatus.unauthenticated);
  }

  void _saveToken(String token) {
    _restClient.accessToken = token;
    _storage.write(key: _accessTokenStroageKey, value: token);
    _controller.add(AuthStatus.authenticated);
  }

  void dispose() => _controller.close();
}
