sealed class AuthenticationStatus {}

final class Unauthenticated extends AuthenticationStatus {}

final class Unknown extends AuthenticationStatus {}

final class Authenticated extends AuthenticationStatus {
  final String _token;
  String get token => _token;

  Authenticated({required String token}) : _token = token;
}
