import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";

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
          child: const AuthForm(),
        )
      ),
    );
  }
}