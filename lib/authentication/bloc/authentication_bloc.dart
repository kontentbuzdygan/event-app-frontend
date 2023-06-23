import "dart:async";

import "package:bloc/bloc.dart";
import "package:authentication_repository/authentication_repository.dart";
import "package:equatable/equatable.dart";

part "authentication_event.dart";
part "authentication_state.dart";

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
      
    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<AuthenticationLogoutForced>(_onAuthenticationLogoutForced);

    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(_AuthenticationStatusChanged(status)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    _AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async =>
      switch (event.status) {
        AuthenticationStatus.authenticated =>
          emit(const AuthenticationState.authenticated()),
        AuthenticationStatus.unauthenticated =>
          emit(const AuthenticationState.unauthenticated()),
        _ => emit(const AuthenticationState.unknown())
      };

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.signOut();
  }

  void _onAuthenticationLogoutForced(
    AuthenticationLogoutForced event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.clearToken();
  }
}
