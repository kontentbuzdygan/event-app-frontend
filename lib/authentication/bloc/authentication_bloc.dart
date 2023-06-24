import "dart:async";

import "package:bloc/bloc.dart";
import "package:authentication_repository/authentication_repository.dart";

part "authentication_event.dart";
part "authentication_state.dart";

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> { 
  
  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  AuthenticationBloc({required AuthenticationRepository authenticationRepository})  
    : _authenticationRepository = authenticationRepository,
    super(AuthenticationUnknown()) 
  {
    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    on<AuthenticationLogoutForced>(_onAuthenticationLogoutForced);

    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(_AuthenticationStatusChanged(status)),
    );
    _authenticationRepository.restoreAndRefreshToken(); 
  }

  Future<void> _onAuthenticationStatusChanged(
    _AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async =>
      switch (event.status) {
        AuthenticationStatus.authenticated => emit(AuthenticationAuthenticated()),
        AuthenticationStatus.unauthenticated => emit(AuthenticationUnauthenticated()),
        _ => _authenticationRepository.restoreAndRefreshToken()
      };

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) => _authenticationRepository.signOut();

  void _onAuthenticationLogoutForced(
    AuthenticationLogoutForced event,
    Emitter<AuthenticationState> emit,
  ) => _authenticationRepository.clearToken();

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }
}
