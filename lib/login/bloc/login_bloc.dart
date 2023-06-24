import "package:authentication_repository/authentication_repository.dart";
import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:formz/formz.dart";

import "../models/email.dart";
import "../models/password.dart";

part "login_event.dart";
part "login_state.dart";

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginBloc({ required AuthenticationRepository authenticationRepository }) 
    : _authenticationRepository = authenticationRepository, 
    super(const LoginState())
  {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginGoBack>(_goBack);
    on<LoginToggleObscurePassowrd>(_toggleObscurePassword);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = Email.dirty(event.email);

    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([state.password, email]),
      ),
    );
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    final password = Password.dirty(event.password);

    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.email])
      ),
    );
  }

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.email.isValid && (state.password.isValid || state.formState == LoginFormStatus.checkingEmail)) {

      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final email = state.email.value;
      final password = state.password.value;

      try {
        switch (state.formState) {
          case LoginFormStatus.checkingEmail:
            final exists = await _authenticationRepository.exists(email: email);
            emit(state.copyWith(
              status: FormzSubmissionStatus.initial,
              formState: exists ? LoginFormStatus.signingIn : LoginFormStatus.signingUp
            ));

          case LoginFormStatus.signingIn: 
            await _authenticationRepository.signIn(email: email, password: password);
            // emit(state.copyWith(
            //   status: FormzSubmissionStatus.success
            // ));
        
          case LoginFormStatus.signingUp: 
            await _authenticationRepository.signUp(email: email, password: password);
            // emit(state.copyWith(status: FormzSubmissionStatus.success));
          
        }
      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }

  void _goBack(LoginGoBack event, Emitter<LoginState> emit) {
    emit(const LoginState().copyWith(email: state.email));
  }

  void _toggleObscurePassword(LoginToggleObscurePassowrd event, Emitter<LoginState> emit) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    // TODO: implement onTransition
    super.onTransition(transition);
    print(transition);
  }
}