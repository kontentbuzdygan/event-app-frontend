import "package:auto_route/auto_route.dart";
import "package:event_app/main.dart";
import "package:event_app/router/router.dart";
import "package:event_repository/event_repository.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";


@RoutePage(name: "MainStackRoute")
class MainStack extends StatelessWidget {
  const MainStack({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => EventRepository(restClient: restClient),
      child: const AutoRouter()
    );
  }
}

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