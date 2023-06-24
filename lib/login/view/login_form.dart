
import "package:event_app/login/bloc/login_bloc.dart";
import "package:event_app/login/view/slide_buttons.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:formz/formz.dart";

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  static const transitionTime = Duration(milliseconds: 300);

  late final AnimationController sizeAnimationController;
  late final Animation<double> sizeAnimation;

  @override
  void initState() {
    super.initState();

    sizeAnimationController = AnimationController(
      duration: transitionTime,
      vsync: this,
    );

    sizeAnimation = CurvedAnimation(
      parent: sizeAnimationController,
      curve: Curves.fastOutSlowIn,
    );
  }
  
  @override
  void dispose() {
    sizeAnimationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.formState != LoginFormStatus.checkingEmail) {
          sizeAnimationController.forward();
        } else {
          sizeAnimationController.reverse();
        }
      },
      child: AutofillGroup(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const _EmailField(),
            SizeTransition(
              sizeFactor: sizeAnimation,
              child:  const Column(
                children: [
                  SizedBox(height: 12),
                  _PasswordField(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const _FormControls(transitionTime: transitionTime),
          ],
        ),
      ),
    );
  }
}

class _FormControls extends StatelessWidget {
  const _FormControls({
    required this.transitionTime,
  });

  final Duration transitionTime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final bloc = context.read<LoginBloc>();

        return SlideButtons(
          transitionTime: transitionTime,
          expanded: state.formState != LoginFormStatus.checkingEmail,
          leftChild: IconButton(
            onPressed: () => bloc.add(const LoginGoBack()),
            icon: const Icon(Icons.arrow_back_outlined),
            iconSize: 30,
            padding: EdgeInsets.zero,
          ),
          rightChild: FilledButton(
            onPressed: () => bloc.add(const LoginSubmitted()),
            child: Text(
              switch (state.formState) {
                LoginFormStatus.signingIn => "Sign In",
                LoginFormStatus.signingUp => "Sign Up",
                _ => "Continue"
              }
            ),
          ),
        );
      }
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => 
        previous.email != current.email || 
        previous.formState != current.formState,
      builder: (context, state) => TextFormField(
        enabled: 
          state.formState == LoginFormStatus.checkingEmail && 
          !(state.status == FormzSubmissionStatus.inProgress),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: "E-mail",
          errorText: state.email.displayError != null ? "Invalid email" : null,
        ),
        onChanged: (email) => context.read<LoginBloc>().add(LoginEmailChanged(email)),
        onFieldSubmitted: (_) => context.read<LoginBloc>().add(const LoginSubmitted()),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final bloc = context.read<LoginBloc>();

        return TextFormField(
          obscureText: state.obscurePassword,
          enabled: state.formState != LoginFormStatus.checkingEmail && state.status != FormzSubmissionStatus.inProgress,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                state.obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () => bloc.add(LoginToggleObscurePassowrd()),
            ),
            border: const OutlineInputBorder(),
            errorText: state.password.displayError != null ? (state.errorMessage) : null,
          ),
          onChanged: (password) => bloc.add(LoginPasswordChanged(password)),
          onFieldSubmitted: (value) => bloc.add(const LoginSubmitted()),
        );
      },
    );
  }
}