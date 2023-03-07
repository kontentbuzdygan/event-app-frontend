

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
    TypedGoRoute<MyProfileViewRoute>(path: "profiles/me"),
    TypedGoRoute<ProfileViewRoute>(path: "profiles/:id"),
  ],
)

class FeedRoute extends GoRouteData {
  @override
  Widget build(context, state) => const FeedScreen();
}

class AuthRoute extends GoRouteData {
  @override
  Widget build(context, state) => const AuthScreen();
}

class EventViewRoute extends GoRouteData {
  EventViewRoute({required this.id});

  final int id;

  @override
  Widget build(context, state) => EventViewScreen(id: id);
}

class MyProfileViewRoute extends GoRouteData {
  @override
  Widget build(context, state) => const ProfileViewScreen();
}

class ProfileViewRoute extends GoRouteData {
  ProfileViewRoute({required this.id});

  final int id;

  @override
  Widget build(context, state) => ProfileViewScreen(id: id);
}
