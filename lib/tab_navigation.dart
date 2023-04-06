import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key, required this.state, required this.child});

  final StatefulShellRouteState state;
  final Widget child;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late final l10n = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: widget.child,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.state.currentIndex,
        onDestinationSelected: (i) => widget.state.goBranch(index: i),
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
      ),
    );
  }
}
