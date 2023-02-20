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

  bool showPassword = false;

  late final ValueNotifier<_FormState> formState = ValueNotifier(_FormState.enteringEmail)
    ..addListener(() {
      if (formState.value == _FormState.enteringEmail) {
        sizeAnimationController.reverse();
      } else {
        sizeAnimationController.forward();
      }
    });

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
      formState.value =
          userExists ? _FormState.signingIn : _FormState.signingUp;
    });
  }

  void advanceFormState() {
    if (form.currentState!.validate()) {
      switch (formState.value) {
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
          key: form,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 350),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  emailField(authState),
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
                    expanded: formState.value.canGoBack,
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

  Widget emailField(AuthState authState) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      enabled:
          formState.value == _FormState.enteringEmail && authState.canLogIn,
      style: formState.value != _FormState.enteringEmail && authState.canLogIn
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
      validator: formState.value == _FormState.signingUp
          ? ValidationBuilder()
              .minLength(8, "Password should be at least 8 characters long")
              .build()
          : null,
    );
  }

  Widget continueButton(AuthState authState) {
    return ElevatedButton(
      onPressed: authState.canLogIn ? advanceFormState : null,
      child: Text(formState.value.buttonText),
    );
  }

  Widget get goBackButton {
    void goBack() {
      setState(() {
        formState.value = _FormState.enteringEmail;
      });
    }

    return IconButton(
      onPressed: formState.value.canGoBack ? goBack : null,
      icon: const Icon(Icons.arrow_back_rounded),
      iconSize: 30,
      splashRadius: 20,
      padding: EdgeInsets.zero,
    );
  }
}
