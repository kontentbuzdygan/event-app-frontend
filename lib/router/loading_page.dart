import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";

@RoutePage()
class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator())
    );
  }
}