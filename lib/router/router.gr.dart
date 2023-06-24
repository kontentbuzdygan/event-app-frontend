// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthPage(),
      );
    },
    DiscoverRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DiscoverPage(),
      );
    },
    EventCommentsViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EventCommentsViewRouteArgs>(
          orElse: () =>
              EventCommentsViewRouteArgs(eventId: pathParams.getInt('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EventCommentsViewPage(
          key: args.key,
          eventId: args.eventId,
          event: args.event,
        ),
      );
    },
    CreateEventRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreateEventPage(),
      );
    },
    EventViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EventViewRouteArgs>(
          orElse: () => EventViewRouteArgs(id: pathParams.getInt('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EventViewPage(
          key: args.key,
          id: args.id,
          event: args.event,
        ),
      );
    },
    FeedRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FeedPage(),
      );
    },
    ProfileEditRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileEditPage(),
      );
    },
    ProfileViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProfileViewRouteArgs>(
          orElse: () => ProfileViewRouteArgs(id: pathParams.optInt('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfileViewPage(
          key: args.key,
          id: args.id,
        ),
      );
    },
    LoadingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoadingPage(),
      );
    },
    MainStackRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainStack(),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainPage(),
      );
    },
    AuthStackRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthStack(),
      );
    },
  };
}

/// generated route for
/// [AuthPage]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
      : super(
          AuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DiscoverPage]
class DiscoverRoute extends PageRouteInfo<void> {
  const DiscoverRoute({List<PageRouteInfo>? children})
      : super(
          DiscoverRoute.name,
          initialChildren: children,
        );

  static const String name = 'DiscoverRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EventCommentsViewPage]
class EventCommentsViewRoute extends PageRouteInfo<EventCommentsViewRouteArgs> {
  EventCommentsViewRoute({
    Key? key,
    required int eventId,
    Event? event,
    List<PageRouteInfo>? children,
  }) : super(
          EventCommentsViewRoute.name,
          args: EventCommentsViewRouteArgs(
            key: key,
            eventId: eventId,
            event: event,
          ),
          rawPathParams: {'id': eventId},
          initialChildren: children,
        );

  static const String name = 'EventCommentsViewRoute';

  static const PageInfo<EventCommentsViewRouteArgs> page =
      PageInfo<EventCommentsViewRouteArgs>(name);
}

class EventCommentsViewRouteArgs {
  const EventCommentsViewRouteArgs({
    this.key,
    required this.eventId,
    this.event,
  });

  final Key? key;

  final int eventId;

  final Event? event;

  @override
  String toString() {
    return 'EventCommentsViewRouteArgs{key: $key, eventId: $eventId, event: $event}';
  }
}

/// generated route for
/// [CreateEventPage]
class CreateEventRoute extends PageRouteInfo<void> {
  const CreateEventRoute({List<PageRouteInfo>? children})
      : super(
          CreateEventRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateEventRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EventViewPage]
class EventViewRoute extends PageRouteInfo<EventViewRouteArgs> {
  EventViewRoute({
    Key? key,
    required int id,
    Event? event,
    List<PageRouteInfo>? children,
  }) : super(
          EventViewRoute.name,
          args: EventViewRouteArgs(
            key: key,
            id: id,
            event: event,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'EventViewRoute';

  static const PageInfo<EventViewRouteArgs> page =
      PageInfo<EventViewRouteArgs>(name);
}

class EventViewRouteArgs {
  const EventViewRouteArgs({
    this.key,
    required this.id,
    this.event,
  });

  final Key? key;

  final int id;

  final Event? event;

  @override
  String toString() {
    return 'EventViewRouteArgs{key: $key, id: $id, event: $event}';
  }
}

/// generated route for
/// [FeedPage]
class FeedRoute extends PageRouteInfo<void> {
  const FeedRoute({List<PageRouteInfo>? children})
      : super(
          FeedRoute.name,
          initialChildren: children,
        );

  static const String name = 'FeedRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileEditPage]
class ProfileEditRoute extends PageRouteInfo<void> {
  const ProfileEditRoute({List<PageRouteInfo>? children})
      : super(
          ProfileEditRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileEditRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileViewPage]
class ProfileViewRoute extends PageRouteInfo<ProfileViewRouteArgs> {
  ProfileViewRoute({
    Key? key,
    int? id,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileViewRoute.name,
          args: ProfileViewRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ProfileViewRoute';

  static const PageInfo<ProfileViewRouteArgs> page =
      PageInfo<ProfileViewRouteArgs>(name);
}

class ProfileViewRouteArgs {
  const ProfileViewRouteArgs({
    this.key,
    this.id,
  });

  final Key? key;

  final int? id;

  @override
  String toString() {
    return 'ProfileViewRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [LoadingPage]
class LoadingRoute extends PageRouteInfo<void> {
  const LoadingRoute({List<PageRouteInfo>? children})
      : super(
          LoadingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainStack]
class MainStackRoute extends PageRouteInfo<void> {
  const MainStackRoute({List<PageRouteInfo>? children})
      : super(
          MainStackRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainStackRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AuthStack]
class AuthStackRoute extends PageRouteInfo<void> {
  const AuthStackRoute({List<PageRouteInfo>? children})
      : super(
          AuthStackRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthStackRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
