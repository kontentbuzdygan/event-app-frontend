import "package:flutter/material.dart";

class ProfileTabs extends StatefulWidget {
  const ProfileTabs({super.key});

  @override
  State<ProfileTabs> createState() => _ProfileTabsState();
}

class _ProfileTabsState extends State<ProfileTabs>
    with SingleTickerProviderStateMixin {
  static const List<Tab> _tabs = [
    Tab(
      text: "Events",
      icon: Icon(Icons.celebration_outlined),
    ),
    Tab(
      text: "Tickets",
      icon: Icon(Icons.confirmation_number_outlined),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(bottom: const TabBar(tabs: _tabs)),
        body: TabBarView(
          children: _tabs.map((tab) {
            return Center(child: Text(tab.text!));
          }).toList(),
        ),
      ),
    );
  }
}
