// GENERATED CODE - DO NOT MODIFY BY HAND

part of "router.dart";

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<GoRoute> get $appRoutes => [
      $authRoute,
      $homeRoute,
    ];

GoRoute get $authRoute => GoRouteData.$route(
      path: "/auth",
      factory: $AuthRouteExtension._fromState,
    );

extension $AuthRouteExtension on AuthRoute {
  static AuthRoute _fromState(GoRouterState state) => AuthRoute();

  String get location => GoRouteData.$location(
        "/auth",
      );

  void go(BuildContext context) => context.go(location);

  void push(BuildContext context) => context.push(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

GoRoute get $homeRoute => GoRouteData.$route(
      path: "/",
      factory: $HomeRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: "events/:id",
          factory: $EventViewRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: "profiles/me",
          factory: $MyProfileViewRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: "profiles/:id",
          factory: $ProfileViewRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: "create",
          factory: $CreateEventRouteExtension._fromState,
        ),
      ],
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute();

  String get location => GoRouteData.$location(
        "/",
      );

  void go(BuildContext context) => context.go(location);

  void push(BuildContext context) => context.push(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $EventViewRouteExtension on EventViewRoute {
  static EventViewRoute _fromState(GoRouterState state) => EventViewRoute(
        id: int.parse(state.params["id"]!),
      );

  String get location => GoRouteData.$location(
        "/events/${Uri.encodeComponent(id.toString())}",
      );

  void go(BuildContext context) => context.go(location);

  void push(BuildContext context) => context.push(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $MyProfileViewRouteExtension on MyProfileViewRoute {
  static MyProfileViewRoute _fromState(GoRouterState state) =>
      MyProfileViewRoute();

  String get location => GoRouteData.$location(
        "/profiles/me",
      );

  void go(BuildContext context) => context.go(location);

  void push(BuildContext context) => context.push(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $ProfileViewRouteExtension on ProfileViewRoute {
  static ProfileViewRoute _fromState(GoRouterState state) => ProfileViewRoute(
        id: int.parse(state.params["id"]!),
      );

  String get location => GoRouteData.$location(
        "/profiles/${Uri.encodeComponent(id.toString())}",
      );

  void go(BuildContext context) => context.go(location);

  void push(BuildContext context) => context.push(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $CreateEventRouteExtension on CreateEventRoute {
  static CreateEventRoute _fromState(GoRouterState state) => CreateEventRoute();

  String get location => GoRouteData.$location(
        "/create",
      );

  void go(BuildContext context) => context.go(location);

  void push(BuildContext context) => context.push(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}
