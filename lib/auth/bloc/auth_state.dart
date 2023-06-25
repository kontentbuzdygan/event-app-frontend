part of "auth_bloc.dart";

sealed class AuthState {}
final class AuthAuthenticated extends AuthState {}
final class AuthUnauthenticated extends AuthState {}
final class AuthUnknown extends AuthState {}
