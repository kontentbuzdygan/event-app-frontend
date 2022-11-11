import 'package:event_app/features/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final bool loading = Provider.of<AuthState>(context).loading;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: !loading
                  ? () => context.read<AuthState>().login("test", "test")
                  : null,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
