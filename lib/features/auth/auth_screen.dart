import "package:event_app/features/auth/slide_out_buttons.dart";
import "package:event_app/main.dart";
import "package:flutter/material.dart";
import "package:form_validator/form_validator.dart";

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

class _State extends State<SignInScreen> with TickerProviderStateMixin {
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

      onFail?.call();
    }
  }

  Future<void> signIn(String email, String password) async {
    withSnackbar(() async => await App.authState.signIn(email, password));
  }

  Future<void> signUp(String email, String password) async {
    withSnackbar(
      () async {
        await App.authState.signUp(email, password);
        await App.authState.signIn(email, password);
      },
      onFail: () => setState(() {
        autoValidate = true;
      }),
    );
  }

  Future<void> userExists(String email) async {
    withSnackbar(() async {
      final userExists = await App.authState.userExists(email);
      setState(() {
        formAction = userExists ? SignIn() : SignUp();
      });
      sizeAnimationController.forward();
    });
  }

  void advanceFormState() {
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

  @override
  Widget build(BuildContext context) {
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
                  emailField,
                  SizeTransition(
                    sizeFactor: sizeAnimation,
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        passwordField,
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SlideOutButtons(
                    transitionTime: transitionTime,
                    expanded: formAction is! UserExists,
                    leftChild: goBackButton,
                    rightChild: continueButton,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get emailField {
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
      onFieldSubmitted: (value) => advanceFormState(),
      validator: ValidationBuilder().email("Invalid email").build(),
    );
  }

  Widget get passwordField {
    return TextFormField(
      obscureText: !showPassword,
      controller: passwordController,
      enabled: App.authState.canLogIn,
      style:
          !App.authState.canLogIn ? const TextStyle(color: Colors.grey) : null,
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
      onFieldSubmitted: (value) => advanceFormState(),
      validator: formAction is SignUp
          ? ValidationBuilder()
              .minLength(8, "Password should be at least 8 characters long")
              .build()
          : null,
    );
  }

  Widget get continueButton {
    return ElevatedButton(
      onPressed: App.authState.canLogIn ? advanceFormState : null,
      child: Text(formAction.buttonText),
    );
  }

  Widget get goBackButton {
    void goBack() {
      setState(() {
        formAction = UserExists();
        autoValidate = false;
      });
      sizeAnimationController.reverse();
    }

    return IconButton(
      onPressed: formAction is! UserExists ? goBack : null,
      icon: const Icon(Icons.arrow_back_rounded),
      iconSize: 30,
      splashRadius: 20,
      padding: EdgeInsets.zero,
    );
  }
}
