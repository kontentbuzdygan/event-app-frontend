import "package:authentication_repository/authentication_repository.dart";
import "package:auto_route/auto_route.dart";
import "package:event_app/login/bloc/login_bloc.dart";
import "package:event_app/login/view/login_form.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
            authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
          ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: const LoginForm(),
          )
        ),
      ),
    );
  }
}