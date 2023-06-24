import "dart:async";

import "package:auth_repository/auth_repository.dart";
import "package:bloc/bloc.dart";

part "auth_event.dart";
part "auth_state.dart";

class AuthBloc extends Bloc<AuthEvent, AuthState> { 
  
  final AuthRepository _authenticationRepository;
  late StreamSubscription<AuthStatus> _authenticationStatusSubscription;

  AuthBloc({required AuthRepository authenticationRepository})  
    : _authenticationRepository = authenticationRepository,
    super(AuthUnknown()) 
  {
    on<_AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthLogoutForced>(_onAuthLogoutForced);

    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(_AuthStatusChanged(status)),
    );
    _authenticationRepository.restoreAndRefreshToken(); 
  }

  Future<void> _onAuthStatusChanged(
    _AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async =>
      switch (event.status) {
        AuthStatus.authenticated => emit(AuthAuthenticated()),
        AuthStatus.unauthenticated => emit(AuthUnauthenticated()),
        _ => _authenticationRepository.restoreAndRefreshToken()
      };

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) => _authenticationRepository.signOut();

  void _onAuthLogoutForced(
    AuthLogoutForced event,
    Emitter<AuthState> emit,
  ) => _authenticationRepository.clearToken();

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }
}
