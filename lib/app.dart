import "package:authentication_repository/authentication_repository.dart";
import "package:event_app/app_bloc_observer.dart";
import "package:event_app/authentication/bloc/authentication_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();

    _authenticationRepository = AuthenticationRepository();
    _authenticationBloc =
        AuthenticationBloc(authenticationRepository: _authenticationRepository);

    Bloc.observer = AppBlocObserver(authenticationBloc: _authenticationBloc);
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider.value(
        value: _authenticationBloc,
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp();
  }
}
