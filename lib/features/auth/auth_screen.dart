import "package:event_app/features/auth/auth_state.dart";
import "package:flutter/material.dart";
import "package:form_validator/form_validator.dart";
import "package:provider/provider.dart";

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() {
    return SignInScreenState();
  }
}

abstract class AuthFormAction {
  String get buttonText;
}

class SignIn implements AuthFormAction {
  @override
  String buttonText = "Sign In";
}

class SignUp implements AuthFormAction {
  @override
  String buttonText = "Sign Up";
}

class UserExists implements AuthFormAction {
  @override
  String buttonText = "Continue";
}

class SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  static const _transitionTime = Duration(milliseconds: 300);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();

  late final AnimationController _sizeAnimationController = AnimationController(
    duration: _transitionTime,
    vsync: this,
  );
  late final Animation<double> _sizeAnimation = CurvedAnimation(
    parent: _sizeAnimationController,
    curve: Curves.fastOutSlowIn,
  );

  bool _autoValidate = false;
  bool _showPassword = false;

  AuthFormAction _formAction = UserExists();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _withSnackbar(
    Future<void> Function() fn, {
    void Function()? onFail,
  }) async {
    try {
      await fn();
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));

      if (onFail != null) onFail();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();

    Future<void> signIn(String email, String password) async {
      _withSnackbar(() async => await authState.signIn(email, password));
    }

    Future<void> signUp(String email, String password) async {
      _withSnackbar(
        () async {
          await authState.signUp(email, password);
          await authState.signIn(email, password);
        },
        onFail: () => setState(() {
          _autoValidate = true;
        }),
      );
    }

    Future<void> userExists(String email) async {
      _withSnackbar(() async {
        final userExists = await authState.userExists(email);
        setState(() {
          _formAction = userExists ? SignIn() : SignUp();
        });
        _sizeAnimationController.forward();
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          autovalidateMode:
              _autoValidate ? AutovalidateMode.onUserInteraction : null,
          key: _form,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 350),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildEmailField(),
                  SizeTransition(
                    sizeFactor: _sizeAnimation,
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        _buildPasswordField(authState),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    children: [
                      AnimatedOpacity(
                        duration: _transitionTime,
                        opacity: _formAction is UserExists ? 0.0 : 1.0,
                        child: AnimatedAlign(
                          curve: Curves.fastOutSlowIn,
                          alignment: _formAction is UserExists
                              ? Alignment.center
                              : Alignment.centerLeft,
                          duration: _transitionTime,
                          child: SizedBox(
                            child: _buildGoBackButton(),
                          ),
                        ),
                      ),
                      AnimatedAlign(
                        curve: Curves.fastOutSlowIn,
                        alignment: _formAction is UserExists
                            ? Alignment.center
                            : Alignment.centerRight,
                        duration: _transitionTime,
                        child: _buildContinueButton(
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
        ),
      ),
    );
  }

  GestureDetector _buildGoBackButton() {
    void goBack() {
      setState(() {
        _formAction = UserExists();
        _autoValidate = false;
      });
      _sizeAnimationController.reverse();
    }

    return GestureDetector(
      onTap: _formAction is! UserExists ? goBack : null,
      child: const Icon(
        Icons.arrow_back_rounded,
        size: 30,
      ),
    );
  }

  ElevatedButton _buildContinueButton(
    AuthState authState,
    Future<void> Function(String email) userExists,
    Future<void> Function(String email, String password) signIn,
    Future<void> Function(String email, String password) signUp,
  ) {
    void handleClick() {
      if (_form.currentState!.validate()) {
        if (_formAction is UserExists) {
          userExists(_emailController.text);
        }

        if (_formAction is SignIn) {
          signIn(_emailController.text, _passwordController.text);
        }

        if (_formAction is SignUp) {
          signUp(_emailController.text, _passwordController.text);
        }
      }
    }

    return ElevatedButton(
        onPressed: authState.canLogIn ? handleClick : null,
        child: Text(_formAction.buttonText));
  }

  TextFormField _buildPasswordField(AuthState authState) {
    return TextFormField(
      obscureText: !_showPassword,
      controller: _passwordController,
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
      validator: _formAction is SignUp
          ? ValidationBuilder()
              .minLength(8, "Password should be at least 8 characters long")
              .build()
          : null,
    );
  }

  TextFormField _buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      enabled: _formAction is UserExists,
      style: _formAction is! UserExists
          ? const TextStyle(color: Colors.grey)
          : null,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Email",
      ),
      validator: ValidationBuilder().email("Invalid email").build(),
    );
  }
}
