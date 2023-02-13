import "package:flutter/material.dart";

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("404"),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}
