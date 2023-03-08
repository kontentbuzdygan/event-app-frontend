import "package:event_app/errors.dart";
import "package:event_app/features/auth/auth_state.dart";
import "package:event_app/router.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerAppErrorHandler(App._errorNotifier);

  await dotenv.load();
  await App.authState.restoreAndRefreshToken();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  static const storage = FlutterSecureStorage();
  static final authState = AuthState();

  static final _errorNotifier = ErrorNotifier();

  static final _router = GoRouter(
    initialLocation: "/auth",
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final errorNotifier = context.watch<ErrorNotifier>();

          final error = errorNotifier.consumeError();
          if (error != null) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error.toString())),
                );
              },
            );
          }

          return child;
        },
        routes: $appRoutes,
      ),
    ],
    redirect: (_, state) {
      if (!authState.loggedIn) return AuthRoute().location;

      if (state.subloc == AuthRoute().location) {
        return HomeRoute().location;
      }

      return null;
    },
    refreshListenable: authState,
  );

  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authState),
        ChangeNotifierProvider.value(value: _errorNotifier),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        title: "Event App",
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
