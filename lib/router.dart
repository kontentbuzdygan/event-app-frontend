
import "package:auto_route/auto_route.dart";
import "package:event_app/features/auth/auth_screen.dart";
import "package:event_app/features/discover/discover_screen.dart";
import "package:event_app/features/events/feed_screen.dart";
import "package:event_app/features/profile/profile_view_screen.dart";
import "package:event_app/main.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

part "router.gr.dart"; 

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override      
  Widget build(BuildContext context) {   
    late final l10n = AppLocalizations.of(context)!;   

    return AutoTabsScaffold(      
      routes: [      
        const FeedRoute(),    
        const DiscoverRoute(),
        ProfileViewRoute(),
      ],   
      bottomNavigationBuilder: (_, tabsRouter) {      
        return NavigationBar(      
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: tabsRouter.setActiveIndex,      
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: l10n.homeTabLabel,
            ),
            NavigationDestination(
              icon: const Icon(Icons.map_outlined),
              selectedIcon: const Icon(Icons.map),
              label: l10n.discoverTabLabel,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outlined),
              selectedIcon: const Icon(Icons.person),
              label: l10n.profileTabLabel,
            )
          ],
        );      
      },         
    );      
  }      
}

@AutoRouterConfig()
class AppRouter extends _$AppRouter {    
  @override      
  List<AutoRoute> get routes => [                  
    AutoRoute(                    
      path: "/",                    
      page: MainRoute.page,
      guards: [AuthenticatedGuard()],  
      children: [
        AutoRoute(page: FeedRoute.page, path: ""),
        AutoRoute(page: DiscoverRoute.page, path: "discover"),
        AutoRoute(page: ProfileViewRoute.page, path: "profile"),
      ]                                
    ),                
    AutoRoute(
      path: "/auth", 
      page: AuthRoute.page, 
      guards: [UnauthenticatedGuard()],
    )                
  ];      
}

class AuthenticatedGuard extends AutoRouteGuard {
  @override
  void onNavigation(resolver, router) {
    if (App.authState.loggedIn) {
      resolver.next();
      return;
    }
    resolver.next(false);

    resolver.redirect(
      const AuthRoute(),
    );
  }
}

class UnauthenticatedGuard extends AutoRouteGuard {
  @override
  void onNavigation(resolver, router) {
    if (!App.authState.loggedIn) {
      resolver.next();
      return;
    }
    resolver.next(false);

    resolver.redirect(
      const MainRoute(),
    );
  }
}
