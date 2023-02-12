import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";
import "package:event_app/features/auth/auth_state.dart";
import "package:event_app/features/auth/auth_screen.dart";
import "package:event_app/features/home/home_screen.dart";

void main() => runApp(App());

class App extends StatelessWidget {
  App({super.key});

  static const String title = "Event App";
  static final AuthState authState = AuthState();

  late final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: "/",
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: "/auth",
        builder: (BuildContext context, GoRouterState state) =>
            const AuthScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      if (!authState.loggedIn) return "/auth";
      if (state.subloc == "/auth") return "/";
      return null;
    },
    refreshListenable: authState,
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authState),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        title: title,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
