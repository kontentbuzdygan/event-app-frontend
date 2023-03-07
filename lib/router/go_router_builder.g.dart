// GENERATED CODE - DO NOT MODIFY BY HAND

part of "go_router_builder.dart";

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<GoRoute> get $appRoutes => [
      $feedRoute,
    ];

GoRoute get $feedRoute => GoRouteData.$route(
      path: "/",
      factory: $FeedRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: "auth",
          factory: $AuthRouteExtension._fromState,
        ),
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
      ],
    );

extension $FeedRouteExtension on FeedRoute {
  static FeedRoute _fromState(GoRouterState state) => FeedRoute();

  String get location => GoRouteData.$location(
        "/",
      );

  void go(BuildContext context) => context.go(location);

  void push(BuildContext context) => context.push(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

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
