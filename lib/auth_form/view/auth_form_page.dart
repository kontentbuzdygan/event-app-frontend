import "package:auth_repository/auth_repository.dart";
import "package:auto_route/auto_route.dart";
import "package:event_app/auth_form/auth_form.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "auth_form.dart";

@RoutePage()
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: BlocProvider(
            create: (context) => AuthFormBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context)
            ),
            child: const AuthForm()
          ),
        )
      ),
    );
  }
}