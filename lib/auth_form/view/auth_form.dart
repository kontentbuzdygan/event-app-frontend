
import "package:event_app/auth_form/bloc/auth_form_bloc.dart";
import "package:event_app/auth_form/bloc/auth_form_event.dart";
import "package:event_app/auth_form/bloc/auth_form_state.dart";
import "package:event_app/auth_form/view/slide_buttons.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:form_validator/form_validator.dart";

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with TickerProviderStateMixin {
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
    return BlocListener<AuthFormBloc, AuthFormState>(
      listenWhen: (previous, current) => previous.formState != current.formState,
      listener: (context, state) {
        if (state.formState != AuthFormAction.checkingEmail) {
          sizeAnimationController.forward();
        } else {
          sizeAnimationController.reverse();
        }
      },
      child: AutofillGroup(
        child: BlocSelector<AuthFormBloc, AuthFormState, GlobalKey<FormBuilderState>>(
          selector: (state) => state.formKey,
          builder: (context, key) => FormBuilder(
            key: key,
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
    return BlocBuilder<AuthFormBloc, AuthFormState>(
      builder: (context, state) {
        final bloc = context.read<AuthFormBloc>();

        return SlideButtons(
          transitionTime: transitionTime,
          expanded: state.formState != AuthFormAction.checkingEmail,
          leftChild: IconButton(
            onPressed: () => bloc.add(AuthFromGoBack()),
            icon: const Icon(Icons.arrow_back_outlined),
            iconSize: 30,
            padding: EdgeInsets.zero,
          ),
          rightChild: FilledButton(
            onPressed: !state.loading ?
              () => bloc.add(AuthFormSubmitted())
              : null,
            child: Text(
              switch (state.formState) {
                AuthFormAction.signingIn => "Sign In",
                AuthFormAction.signingUp => "Sign Up",
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
    return BlocBuilder<AuthFormBloc, AuthFormState>(
      builder: (context, state) => FormBuilderTextField(
        name: "email",
        enabled: state.formState == AuthFormAction.checkingEmail && !state.loading,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "E-mail",
        ),
        validator: ValidationBuilder().email().build(),
        onSubmitted: (_) => context.read<AuthFormBloc>().add(AuthFormSubmitted()),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthFormBloc, AuthFormState>(
      builder: (context, state) {
        final bloc = context.read<AuthFormBloc>();

        return FormBuilderTextField(
          name: "password",
          obscureText: true,
          enabled: state.formState != AuthFormAction.checkingEmail && !state.loading,
          decoration: const InputDecoration(
            // suffixIcon: IconButton(
            //   icon: Icon(
            //     state.obscurePassword
            //         ? Icons.visibility_off_outlined
            //         : Icons.visibility_outlined,
            //   ),
            //   onPressed: () => bloc.add(LoginToggleObscurePassowrd()),
            // ),
            labelText: "Password",
            border: OutlineInputBorder(),
          ),
          validator: state.formState == AuthFormAction.signingUp
            ? ValidationBuilder().minLength(8).build()
            : state.formState == AuthFormAction.signingIn 
              ? ValidationBuilder().required().build()
              : null,
          onSubmitted: (value) => bloc.add(AuthFormSubmitted()),
        );
      },
    );
  }
}