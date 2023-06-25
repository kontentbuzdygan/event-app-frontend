
import "package:auth_repository/auth_repository.dart";
import "package:auto_route/auto_route.dart";
import "package:event_app/api/exceptions.dart";
import "package:event_app/auth/auth.dart";
import "package:event_app/main.dart";
import "package:event_app/router/router.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class _AppBlocObserver extends BlocObserver {
  final AuthRepository _authRepository;

  _AppBlocObserver({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  void onError(bloc, error, stackTrace) {
    if (error.toString() == const Unauthorized().message) {
      _authRepository.clearToken();
    }
    super.onError(bloc, error, stackTrace);
  }
}


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthRepository _authRepository;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    
    _authRepository = AuthRepository(
      restClient: restClient, 
      storage: storage
    );

    Bloc.observer = _AppBlocObserver(
      authRepository: _authRepository
    );

    _authBloc = AuthBloc(
      authenticationRepository: _authRepository,
    );
  }

  @override
  void dispose() {
    _authRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: BlocProvider.value(
        value: _authBloc,
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
  late AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
  }

  List<PageRouteInfo<dynamic>> stateToRoute(AuthState state) => [
    switch (state) {
      AuthAuthenticated() => const MainStackRoute(),
      AuthUnauthenticated() => const AuthStackRoute(),
      _ => const LoadingRoute()
    }
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) => _appRouter.updateDeclarativeRoutes(stateToRoute(state)),
      builder: (context, state) => MaterialApp.router(
          title: "Event App",
          theme: ThemeData(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          routeInformationProvider: _appRouter.routeInfoProvider(),
          routeInformationParser: _appRouter.defaultRouteParser(),
          routerDelegate: _appRouter.declarativeDelegate(
            routes: (_) => stateToRoute(state)
          ),
        ),
    );
  }
}
