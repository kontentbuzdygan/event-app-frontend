import "dart:async";

import "package:bloc/bloc.dart";
import "package:authentication_repository/authentication_repository.dart";
import "package:profile_repository/profile_repository.dart";

part "authentication_event.dart";

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationStatus> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required ProfileRepository profileRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(AuthenticationStatus.unknown) {
    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
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
    Emitter<AuthenticationStatus> emit,
  ) async =>
      emit(event.status);

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationStatus> emit,
  ) {
    _authenticationRepository.signOut();
  }
}
