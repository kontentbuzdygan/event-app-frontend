
import "package:auto_route/auto_route.dart";
import "package:event_app/api/models/event.dart";
import "package:event_app/features/auth/auth_screen.dart";
import "package:event_app/features/discover/discover_screen.dart";
import "package:event_app/features/events/comments/comments_view_screen.dart";
import "package:event_app/features/events/create_event_page.dart";
import "package:event_app/features/events/event_view_page.dart";
import "package:event_app/features/events/feed_page.dart";
import "package:event_app/features/profile/profile_edit_page.dart";
import "package:event_app/features/profile/profile_view_page.dart";
import "package:event_app/router/main_stack.dart";
import "package:event_app/router/authentication_stack.dart";
import "package:event_app/router/loading_page.dart";
import "package:flutter/material.dart";

part "router.gr.dart"; 

@AutoRouterConfig()
class AppRouter extends _$AppRouter {    
  @override      
  List<AutoRoute> get routes => [   
    AutoRoute(
      path: "/",
      page: MainStackRoute.page, 
      children: [
        AutoRoute(                    
          path: "",                    
          page: MainRoute.page,
          children: [
            AutoRoute(path: "", page: FeedRoute.page),
            AutoRoute(path: "discover", page: DiscoverRoute.page),
            AutoRoute(path: "profiles/me", page: ProfileViewRoute.page),
          ]                            
        ),
        AutoRoute(path: "profiles/:id", page: ProfileViewRoute.page),
        AutoRoute(path: "profiles/me/edit", page: ProfileEditRoute.page),
        AutoRoute(path: "events/create", page: CreateEventRoute.page),
        AutoRoute(path: "events/:id", page: EventViewRoute.page), 
        AutoRoute(path: "events/:id/comments", page: EventCommentsViewRoute.page),  
      ]
    ),              
    AutoRoute(
      path: "/",
      page: AuthenticationStackRoute.page, 
      children: [
        AutoRoute(path: "", page: AuthRoute.page),
      ]
    ),  
    AutoRoute(path: "/", page: LoadingRoute.page)     
  ];      
}