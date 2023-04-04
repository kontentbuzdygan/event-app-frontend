import "package:event_app/errors.dart";
import "package:event_app/features/auth/auth_screen.dart";
import "package:event_app/features/auth/auth_state.dart";
import "package:event_app/features/events/create_event_screen.dart";
import "package:event_app/features/events/event_view_screen.dart";
import "package:event_app/features/events/feed_screen.dart";
import "package:event_app/features/profile/profile_edit_screen.dart";
import "package:event_app/features/profile/profile_view_screen.dart";
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
        routes: [
          GoRoute(
            path: "/auth",
            builder: (context, state) => const AuthScreen(),
          ),
          StatefulShellRoute(
            builder: (context, state, child) => BottomNavigation(
              state: state,
              child: child,
            ),
            branches: [
              StatefulShellBranch(routes: [
                GoRoute(
                  path: "/",
                  builder: (context, state) => const FeedScreen(),
                ),
                GoRoute(
                  name: "createEvent",
                  path: "/events/create",
                  builder: (context, state) => const CreateEventScreen(),
                ),
                GoRoute(
                  path: "/events/:eventId",
                  builder: (context, state) => EventViewScreen(
                    id: int.parse(state.params["eventId"] ?? "0"),
                  ),
                ),
                GoRoute(
                  path: "/profiles/:profileId",
                  builder: (context, state) => ProfileViewScreen(
                    id: int.tryParse(state.params["profileId"] ?? "0") ?? 0,
                  ),
                )
              ]),
              StatefulShellBranch(routes: [
                GoRoute(
                  path: "/me",
                  builder: (context, state) => const ProfileViewScreen(),
                ),
                GoRoute(
                  path: "/me/edit",
                  builder: (context, state) => const ProfileEditScreen(),
                )
              ]),
            ],
          )
        ],
      ),
    ],
    redirect: (_, state) {
      if (!authState.loggedIn) return "/auth";
      if (state.subloc == "/auth") {
        return "/";
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
        theme: ThemeData(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        routerConfig: _router,
        title: "Event App",
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
