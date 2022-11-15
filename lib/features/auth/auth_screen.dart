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

  static const transitionTime = Duration(milliseconds: 300);

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
  bool _autovalidate = false;
  bool _showPassword = false;

  @override
  void dispose() {
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

        setState(() {
          _autovalidate = true;
        });
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          autovalidateMode:
              _autovalidate ? AutovalidateMode.onUserInteraction : null,
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildEmail(),
              SizeTransition(
                sizeFactor: _animation,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    buildPassword(authState),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Stack(
                children: [
                  AnimatedOpacity(
                    duration: transitionTime,
                    opacity: proceedSignIn == null ? 0.0 : 1.0,
                    child: AnimatedAlign(
                      curve: Curves.fastOutSlowIn,
                      alignment: proceedSignIn == null
                          ? Alignment.center
                          : Alignment.centerLeft,
                      duration: transitionTime,
                      child: buildGoBackButton(),
                    ),
                  ),
                  AnimatedAlign(
                    curve: Curves.fastOutSlowIn,
                    alignment: proceedSignIn == null
                        ? Alignment.center
                        : Alignment.centerRight,
                    duration: transitionTime,
                    child: buildContinueButton(
                      authState,
                      userExists,
                      signIn,
                      signUp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconButton buildGoBackButton() {
    void goBack() {
      setState(() {
        proceedSignIn = null;
      });
      _controller.reverse();
    }

    return IconButton(
      onPressed: proceedSignIn != null ? goBack : null,
      icon: const Icon(Icons.arrow_back_rounded),
      // color: Colors.blue,
    );
  }

  ElevatedButton buildContinueButton(
    AuthState authState,
    Future<void> Function(String email) userExists,
    Future<void> Function(String email, String password) signIn,
    Future<void> Function(String email, String password) signUp,
  ) {
    void handleClick() {
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

    return ElevatedButton(
      onPressed: authState.canLogIn ? handleClick : null,
      child: (proceedSignIn == null)
          ? const Text("Continue")
          : proceedSignIn!
              ? const Text("Sign In")
              : const Text("Sign Up"),
    );
  }

  TextFormField buildPassword(AuthState authState) {
    String? validate(String? value) {
      if (proceedSignIn != null) {
        if (value == null || value.isEmpty) {
          return "Please enter some text";
        }
        if (value.length < 8) {
          return "Password should be at least 8 characters long";
        }
      }
      return null;
    }

    return TextFormField(
      obscureText: !_showPassword,
      controller: _password,
      enabled: authState.canLogIn,
      style: !authState.canLogIn ? const TextStyle(color: Colors.grey) : null,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => setState(() {
            _showPassword = !_showPassword;
          }),
        ),
        border: const OutlineInputBorder(),
        labelText: "Password",
      ),
      validator: (value) => proceedSignIn == true ? null : validate(value),
    );
  }

  TextFormField buildEmail() {
    String? validate(String? value) {
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
    }

    return TextFormField(
      controller: _email,
      enabled: proceedSignIn == null,
      style: proceedSignIn != null ? const TextStyle(color: Colors.grey) : null,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Email",
      ),
      validator: (value) => validate(value),
    );
  }
}
