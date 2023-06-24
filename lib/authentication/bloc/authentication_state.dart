part of "authentication_bloc.dart";

sealed class AuthenticationState {}

final class AuthenticationAuthenticated extends AuthenticationState {}
final class AuthenticationUnauthenticated extends AuthenticationState {}
final class AuthenticationUnknown extends AuthenticationState {}
