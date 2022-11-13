import "package:event_app/features/auth/auth_state.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();

    Future<void> signIn(String email, String password) async {
      try {
        await authState.signIn(email, password);
      } catch (e) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: authState.canLogIn
                  ? () async => await signIn("test@example.com", "test1234")
                  : null,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
