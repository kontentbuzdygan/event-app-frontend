import "package:event_app/features/auth/auth_state.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() {
    return SignInScreenState();
  }
}

class SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  bool? proceedSignIn;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

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

    Future<void> signUp(String email, String password) async {
      try {
        await authState.signUp(email, password);
        await authState.signIn(email, password);
      } catch (e) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    Future<void> userExists(String email) async {
      try {
        final userExists = await authState.userExists(email);
        setState(() {
          proceedSignIn = userExists;
        });
        _controller.forward();
      } catch (e) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _email,
                  enabled: proceedSignIn == null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "email",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter some text";
                    }

                    final bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value);

                    if (!emailValid) {
                      return "Invalid email";
                    }

                    return null;
                  },
                ),
                SizeTransition(
                  sizeFactor: _animation,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      TextFormField(
                        obscureText: true,
                        controller: _password,
                        enabled: authState.canLogIn,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "password",
                        ),
                        validator: (value) {
                          if (proceedSignIn != null) {
                            if (value == null || value.isEmpty) {
                              return "Please enter some text";
                            }

                            if (value.length < 8) {
                              return "Password should be at least 8 characters long";
                            }
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Positioned(
                      child: AnimatedAlign(
                        curve: Curves.fastOutSlowIn,
                        alignment: proceedSignIn == null
                            ? Alignment.center
                            : Alignment.centerLeft,
                        duration: const Duration(milliseconds: 300),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                proceedSignIn = null;
                              });
                              _controller.reverse();
                            },
                            icon: const Icon(Icons.arrow_back, size: 18)),
                      ),
                    ),
                    Positioned(
                      child: AnimatedAlign(
                        curve: Curves.fastOutSlowIn,
                        alignment: proceedSignIn == null
                            ? Alignment.center
                            : Alignment.centerRight,
                        duration: const Duration(milliseconds: 300),
                        child: ElevatedButton(
                          onPressed: authState.canLogIn
                              ? () {
                                  if (_form.currentState!.validate()) {
                                    if (proceedSignIn == null) {
                                      userExists(_email.text);
                                    }

                                    if (proceedSignIn == true) {
                                      signIn(_email.text, _password.text);
                                    }

                                    if (proceedSignIn == false) {
                                      signUp(_email.text, _password.text);
                                    }
                                  }
                                }
                              : null,
                          child: (proceedSignIn == null)
                              ? const Text("Continue")
                              : proceedSignIn!
                                  ? const Text("Sign In")
                                  : const Text("Sign Up"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
