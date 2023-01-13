import "package:event_app/features/auth/auth_state.dart";
import "package:flutter/material.dart";
import "package:form_validator/form_validator.dart";
import "package:provider/provider.dart";

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

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() {
    return _State();
  }
}

class _State extends State<SignInScreen>
    with TickerProviderStateMixin {
  static const transitionTime = Duration(milliseconds: 300);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final form = GlobalKey<FormState>();

  late final AnimationController sizeAnimationController = AnimationController(
    duration: transitionTime,
    vsync: this,
  );
  late final Animation<double> sizeAnimation = CurvedAnimation(
    parent: sizeAnimationController,
    curve: Curves.fastOutSlowIn,
  );

  bool autoValidate = false;
  bool showPassword = false;

  AuthFormAction formAction = UserExists();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> withSnackbar(
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
      withSnackbar(() async => await authState.signIn(email, password));
    }

    Future<void> signUp(String email, String password) async {
      withSnackbar(
        () async {
          await authState.signUp(email, password);
          await authState.signIn(email, password);
        },
        onFail: () => setState(() {
          autoValidate = true;
        }),
      );
    }

    Future<void> userExists(String email) async {
      withSnackbar(() async {
        final userExists = await authState.userExists(email);
        setState(() {
          formAction = userExists ? SignIn() : SignUp();
        });
        sizeAnimationController.forward();
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          autovalidateMode:
              autoValidate ? AutovalidateMode.onUserInteraction : null,
          key: form,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 350),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildEmailField(),
                  SizeTransition(
                    sizeFactor: sizeAnimation,
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        buildPasswordField(authState),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    children: [
                      AnimatedOpacity(
                        duration: transitionTime,
                        opacity: formAction is UserExists ? 0.0 : 1.0,
                        child: AnimatedAlign(
                          curve: Curves.fastOutSlowIn,
                          alignment: formAction is UserExists
                              ? Alignment.center
                              : Alignment.centerLeft,
                          duration: transitionTime,
                          child: SizedBox(
                            child: buildGoBackButton(),
                          ),
                        ),
                      ),
                      AnimatedAlign(
                        curve: Curves.fastOutSlowIn,
                        alignment: formAction is UserExists
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
        ),
      ),
    );
  }

  GestureDetector buildGoBackButton() {
    void goBack() {
      setState(() {
        formAction = UserExists();
        autoValidate = false;
      });
      sizeAnimationController.reverse();
    }

    return GestureDetector(
      onTap: formAction is! UserExists ? goBack : null,
      child: const Icon(
        Icons.arrow_back_rounded,
        size: 30,
      ),
    );
  }

  ElevatedButton buildContinueButton(
    AuthState authState,
    Future<void> Function(String email) userExists,
    Future<void> Function(String email, String password) signIn,
    Future<void> Function(String email, String password) signUp,
  ) {
    void handleClick() {
      if (form.currentState!.validate()) {
        if (formAction is UserExists) {
          userExists(emailController.text);
        }

        if (formAction is SignIn) {
          signIn(emailController.text, passwordController.text);
        }

        if (formAction is SignUp) {
          signUp(emailController.text, passwordController.text);
        }
      }
    }

    return ElevatedButton(
        onPressed: authState.canLogIn ? handleClick : null,
        child: Text(formAction.buttonText));
  }

  TextFormField buildPasswordField(AuthState authState) {
    return TextFormField(
      obscureText: !showPassword,
      controller: passwordController,
      enabled: authState.canLogIn,
      style: !authState.canLogIn ? const TextStyle(color: Colors.grey) : null,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            showPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => setState(() {
            showPassword = !showPassword;
          }),
        ),
        border: const OutlineInputBorder(),
        labelText: "Password",
      ),
      validator: formAction is SignUp
          ? ValidationBuilder()
              .minLength(8, "Password should be at least 8 characters long")
              .build()
          : null,
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      enabled: formAction is UserExists,
      style: formAction is! UserExists
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
