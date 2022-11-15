import "package:event_app/features/auth/auth_state.dart";
import "package:event_app/features/auth/auth_screen.dart";
import "package:event_app/features/home/home_screen.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";

void main() => runApp(App());

class App extends StatelessWidget {
  App({super.key});

  static const String title = "Event App";
  final AuthState _authState = AuthState();

  late final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: "/",
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(title: "Dom"),
      ),
      GoRoute(
        path: "/auth",
        builder: (BuildContext context, GoRouterState state) =>
            const SignInScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      if (!_authState.loggedIn) return "/auth";
      if (state.subloc == "/auth") return "/";
      return null;
    },
    refreshListenable: _authState,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthState>.value(
      value: _authState,
      child: MaterialApp.router(
        routerConfig: _router,
        title: title,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}