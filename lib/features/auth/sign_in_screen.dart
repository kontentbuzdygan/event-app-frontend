import 'package:event_app/features/auth/auth_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  /// Creates a [SignInScreen].
  const SignInScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // log a user in, letting all the listeners know
                  context.read<AuthState>().login('test-user');

                  // router will automatically redirect from /login to / using
                  // refreshListenable
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
}
