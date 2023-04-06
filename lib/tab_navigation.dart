import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key, required this.state, required this.child});

  final StatefulShellRouteState state;
  final Widget child;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: "Discover",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          )
        ],
      ),
    );
  }
}
