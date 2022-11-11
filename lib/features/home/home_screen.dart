import 'package:event_app/features/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final AuthState authState = context.read<AuthState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            onPressed: authState.logout,
            tooltip: "Logout: ${authState.userToken}",
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(
        child: Text("HomeScreen"),
      ),
    );
  }
}
