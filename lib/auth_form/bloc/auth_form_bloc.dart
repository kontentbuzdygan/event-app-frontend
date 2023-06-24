import "dart:async";

import "package:auth_repository/auth_repository.dart";
import "package:bloc/bloc.dart";
import "package:event_app/auth_form/bloc/auth_form_event.dart";
import "package:event_app/auth_form/bloc/auth_form_state.dart";


class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> { 
  final AuthRepository _authRepository;

  AuthFormBloc({required AuthRepository authRepository})  
    : _authRepository = authRepository,
    super(AuthFormState()) 
  {
    on<AuthFormSubmitted>(_onSubmitted);
    on<AuthFromGoBack>(_goBack);
  }

  Future<void> _onSubmitted(AuthFormSubmitted event, Emitter<AuthFormState> emit) async {
    if (state.formKey.currentState?.validate() ?? false) {
      emit(state.copyWith(loading: true) );

      final email = state.formKey.currentState!.fields["email"]!.value;
      final password = state.formKey.currentState!.fields["password"]!.value;

      try {
        switch (state.formState) {
          case AuthFormAction.checkingEmail:
            final exists = await _authRepository.exists(email: email);
            emit(state.copyWith(
              loading: false,
              formState: exists ? AuthFormAction.signingIn : AuthFormAction.signingUp
            ));

          case AuthFormAction.signingIn: 
            await _authRepository.signIn(email:  email, password: password);
        
          case AuthFormAction.signingUp: 
            await _authRepository.signUp(email: email, password: password);       
        }
      } catch (e) {
        state.formKey.currentState!.fields["password"]!.invalidate(e.toString());
        emit(state.copyWith(loading: false));
      }
    }
  }

  void _goBack(AuthFromGoBack event, Emitter<AuthFormState> emit) {
    state.formKey.currentState!.fields["password"]!.reset();
    emit(state.copyWith(formState: AuthFormAction.checkingEmail));
  }
}
