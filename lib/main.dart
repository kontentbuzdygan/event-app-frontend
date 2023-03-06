import "package:event_app/errors.dart";
import "package:event_app/features/auth/auth_screen.dart";
import "package:event_app/features/auth/auth_state.dart";
import "package:event_app/features/event/event_view_screen.dart";
import "package:event_app/features/home/home_screen.dart";
import "package:event_app/features/profile/profile_view_screen.dart";
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

  static final router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final errorNotifier = context.watch<ErrorNotifier>();

          final error = errorNotifier.consumeError();
          if (error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.toString())),
              );
            });
          }

          return Scaffold(body: child);
        },
        routes: [
          GoRoute(
            name: "home",
            path: "/",
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            name: "auth",
            path: "/auth",
            builder: (_, __) => const AuthScreen(),
          ),
          GoRoute(
            name: "eventView",
            path: "/events/:id",
            builder: (__, state) => EventViewScreen(
              id: int.tryParse(state.params["id"]!) ?? 0,
            ),
          ),
          GoRoute(
            name: "myProfileView",
            path: "/profiles/me",
            builder: (_, __) => const ProfileViewScreen(),
          ),
          GoRoute(
            name: "profileView",
            path: "/profiles/:id",
            builder: (_, state) => ProfileViewScreen(
              id: int.tryParse(state.params["id"]!) ?? 0,
            ),
          ),
        ],
      ),
    ],
    redirect: (_, state) {
      if (!authState.loggedIn) return "/auth";
      if (state.subloc == "/auth") return "/";
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
        routerConfig: router,
        title: "Event App",
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
