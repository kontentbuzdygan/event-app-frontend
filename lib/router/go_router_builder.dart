

import "package:event_app/features/auth/auth_screen.dart";
import "package:event_app/features/events/event_view_screen.dart";
import "package:event_app/features/events/feed_screen.dart";
import "package:event_app/features/profile/profile_view_screen.dart";
import "package:flutter/cupertino.dart";
import "package:go_router/go_router.dart";

part "go_router_builder.g.dart";

@TypedGoRoute<FeedRoute>(
  path: "/",
  routes: [
    TypedGoRoute<AuthRoute>(path: "auth"),
    TypedGoRoute<EventViewRoute>(path: "events/:id"),
    TypedGoRoute<ProfileMeViewRoute>(
      path: "profiles",
      routes: [
        TypedGoRoute<ProfileViewRoute>(path: ":id"),
      ]
    ),
  ]
)

class FeedRoute extends GoRouteData {
  @override
  Widget build(context) => const FeedScreen();
}

class AuthRoute extends GoRouteData {
  @override
  Widget build(context) => const AuthScreen();
}

class EventViewRoute extends GoRouteData {
  EventViewRoute({required this.id});

  final int id;

  @override
  Widget build(context) => EventViewScreen(id: id);
}


class ProfileViewRoute extends GoRouteData {
  ProfileViewRoute({required this.id});

  final int id;

  @override
  Widget build(context) => ProfileViewScreen(id: id);
}

class ProfileMeViewRoute extends GoRouteData {
  @override
  Widget build(context) => const ProfileViewScreen();
}