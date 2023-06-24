import "package:equatable/equatable.dart";
import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";

enum AuthFormAction { checkingEmail, signingIn, signingUp }

class AuthFormState extends Equatable {
  AuthFormState({
    this.loading = false,
    this.formState = AuthFormAction.checkingEmail,
    GlobalKey<FormBuilderState>? formKey,
  }) : formKey = formKey ?? GlobalKey<FormBuilderState>();

  final bool loading;
  final AuthFormAction formState;
  final GlobalKey<FormBuilderState> formKey;

  @override
  List<Object?> get props => [loading, formState];

  AuthFormState copyWith({
    bool? loading,
    AuthFormAction? formState,
  }) {
    return AuthFormState(
      loading: loading ?? this.loading,
      formState: formState ?? this.formState,
      formKey: formKey,
    );
  }
}