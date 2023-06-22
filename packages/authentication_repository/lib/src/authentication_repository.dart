import "dart:async";

import "package:api_client/api_client.dart";
import "package:authentication_repository/src/authentication_status.dart";

const String _apiPath = "auth";

class AuthRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield Unknown();
    yield* _controller.stream;
  }

  Future<bool> exists(String email) async {
    final res = await rest.post([_apiPath, "user-exists"], {"email": email});
    return res["user_exists"];
  }

  Future<void> refreshToken() async {
    final res = await rest.post([_apiPath, "refresh"]);
    _controller.add(Authenticated(token: res["token"]));
  }

  Future<void> signOut() async {
    await rest.delete([_apiPath, "sign-out"]);
    _controller.add(Unauthenticated());
  }

  Future<void> signIn(String email, String password) async {
    final res = await rest.post([
      _apiPath,
      "sign-in"
    ], {
      "email": email,
      "password": password,
    });
    _controller.add(Authenticated(token: res["token"]));
  }
}
