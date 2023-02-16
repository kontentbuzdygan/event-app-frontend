import "package:event_app/api/exceptions.dart";
import "package:event_app/features/auth/auth_state.dart";
import "package:event_app/features/auth/slide_out_buttons.dart";
import "package:event_app/main.dart";
import "package:flutter/material.dart";
import "package:form_validator/form_validator.dart";
import "package:provider/provider.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _State();
  }
}

enum _FormState {
  enteringEmail("Continue", false),
  signingIn("Sign In", true),
  signingUp("Sign Up", true);

  final String buttonText;
  final bool canGoBack;
  const _FormState(this.buttonText, this.canGoBack);
}

class _State extends State<AuthScreen> with TickerProviderStateMixin {
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

  _FormState formState = _FormState.enteringEmail;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn(String email, String password) async {
    await App.authState.signIn(email, password);
  }

  Future<void> signUp(String email, String password) async {
    await App.authState.signUp(email, password);
    await App.authState.signIn(email, password);
  }

  Future<void> userExists(String email) async {
    final userExists = await App.authState.userExists(email);
    setState(() {
      formState = userExists ? _FormState.signingIn : _FormState.signingUp;
    });
    sizeAnimationController.forward();
  }

  void advanceFormState() {
    if (form.currentState!.validate()) {
      switch (formState) {
        case _FormState.enteringEmail:
          userExists(emailController.text);
          break;
        case _FormState.signingIn:
          signIn(emailController.text, passwordController.text);
          break;
        case _FormState.signingUp:
          signUp(emailController.text, passwordController.text);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();

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
                        passwordField(authState),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SlideOutButtons(
                    transitionTime: transitionTime,
                    expanded: formState.canGoBack,
                    leftChild: goBackButton,
                    rightChild: continueButton(authState),
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
      enabled: formState == _FormState.enteringEmail,
      style: formState != _FormState.enteringEmail
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

  Widget passwordField(AuthState authState) {
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
      onFieldSubmitted: (value) => advanceFormState(),
      validator: formState == _FormState.signingUp
          ? ValidationBuilder()
              .minLength(8, "Password should be at least 8 characters long")
              .build()
          : null,
    );
  }

  Widget continueButton(AuthState authState) {
    return ElevatedButton(
      onPressed: authState.canLogIn ? advanceFormState : null,
      child: Text(formState.buttonText),
    );
  }

  Widget get goBackButton {
    void goBack() {
      setState(() {
        formState = _FormState.enteringEmail;
        autoValidate = false;
      });
      sizeAnimationController.reverse();
    }

    return IconButton(
      onPressed: formState.canGoBack ? goBack : null,
      icon: const Icon(Icons.arrow_back_rounded),
      iconSize: 30,
      splashRadius: 20,
      padding: EdgeInsets.zero,
    );
  }
}
