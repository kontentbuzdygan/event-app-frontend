part of "login_bloc.dart";

enum LoginFormStatus { checkingEmail, signingIn, signingUp }

final class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.formState = LoginFormStatus.checkingEmail,
    this.isValid = false,
    this.obscurePassword = true,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final LoginFormStatus formState;
  final bool isValid;
  final String? errorMessage;
  final bool obscurePassword;

  @override
  List<Object?> get props => [email, password, status, isValid, errorMessage, formState];

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
    LoginFormStatus? formState,
    bool? obscurePassword,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      formState: formState ?? this.formState,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}