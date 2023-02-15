import "package:event_app/features/event/event_view_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:event_app/features/auth/auth_state.dart";
import "package:event_app/features/auth/auth_screen.dart";
import "package:event_app/features/home/home_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await App.authState.restoreAndRefreshToken();

  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  static const title = "Event App";
  static const storage = FlutterSecureStorage();
  static final authState = AuthState();

  late final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        name: "home",
        path: "/",
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        name: "auth",
        path: "/auth",
        builder: (BuildContext context, GoRouterState state) =>
            const AuthScreen(),
      ),
      GoRoute(
        name: "eventView",
        path: "/event/:eventId",
        builder: (context, state) =>
            EventViewScreen(id: int.tryParse(state.params["eventId"]!) ?? 0),
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
