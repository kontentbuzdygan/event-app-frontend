import "package:event_app/features/auth/auth_screen.dart";
import "package:event_app/features/events/event_view_screen.dart";
import "package:event_app/features/events/feed_screen.dart";
import "package:event_app/features/profile/profile_view_screen.dart";
import "package:event_app/features/events/create_event_screen.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

part "router.g.dart";

@TypedGoRoute<AuthRoute>(path: "/auth")
class AuthRoute extends GoRouteData {
  @override
  Widget build(context, state) => const AuthScreen();
}

@TypedGoRoute<HomeRoute>(path: "/", routes: [
  TypedGoRoute<EventViewRoute>(path: "events/:id"),
  TypedGoRoute<MyProfileViewRoute>(path: "profiles/me"),
  TypedGoRoute<ProfileViewRoute>(path: "profiles/:id"),
  TypedGoRoute<CreateEventRoute>(path: "create"),
])
class HomeRoute extends GoRouteData {
  @override
  Widget build(context, state) => const FeedScreen();
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

class CreateEventRoute extends GoRouteData {
  @override
  Widget build(context, state) => const CreateEventScreen();
}

