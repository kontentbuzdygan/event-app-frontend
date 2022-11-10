import 'package:event_app/features/auth/auth_state_notifier.dart';
import 'package:event_app/features/auth/sign_in_screen.dart';
import 'package:event_app/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final AuthState _authState = AuthState();
  static const String title = 'Event App';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<AuthState>.value(
        value: _authState,
        child: MaterialApp.router(
          routerConfig: _router,
          title: title,
          debugShowCheckedModeBanner: false,
        ),
      );

  late final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(title: "Dom"),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const SignInScreen(title: "Sign In Screen"),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = _authState.loggedIn;
      final bool loggingIn = state.subloc == '/login';

      if (!loggedIn) return '/login';

      if (loggingIn) return '/';

      return null;
    },
    refreshListenable: _authState,
  );
}
