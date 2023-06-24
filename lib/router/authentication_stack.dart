import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";

@RoutePage(name: "AuthenticationStackRoute")
class AuthenticationStack extends StatelessWidget {
  const AuthenticationStack({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}

