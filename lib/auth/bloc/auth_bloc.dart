import "dart:async";

import "package:auth_repository/auth_repository.dart";
import "package:bloc/bloc.dart";

part "auth_event.dart";
part "auth_state.dart";

class AuthBloc extends Bloc<AuthEvent, AuthState> { 
  
  final AuthRepository _authRepository;
  late StreamSubscription<AuthStatus> _authStatusSubscription;

  AuthBloc({
    required AuthRepository authenticationRepository,
  }) : _authRepository = authenticationRepository,
    super(AuthUnknown()) 
  {
    on<_AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);

    _authStatusSubscription = _authRepository.status.listen(
      (status) => add(_AuthStatusChanged(status)),
    );
  }

  Future<void> _onAuthStatusChanged(
    _AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
      switch (event.status) {
        case AuthStatus.authenticated: emit(AuthAuthenticated());
        case AuthStatus.unauthenticated: emit(AuthUnauthenticated());
        case _: await _authRepository.restoreAndResfreshToken(); 
      }
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) => _authRepository.signOut();

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }
}
