import "package:event_app/api/models/profile.dart";
import "package:event_app/features/events/feed_screen.dart";
import "package:event_app/features/profile/profile_header.dart";
import "package:event_app/features/profile/tickets.dart";
import "package:event_app/main.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key, this.id});

  final int? id;

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen>
    with SingleTickerProviderStateMixin {
  late final Future<Profile> profile =
      widget.id != null ? Profile.find(widget.id!) : Profile.me();

  static const List<Tab> _tabs = [
    Tab(
      text: "User",
      icon: Icon(Icons.person_outlined),
    ),
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
  Widget build(context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder(
      future: profile,
      builder: (context, snapshot) => DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: AppBar(
              title: Text(widget.id == null ? l10n.yourProfile : "Profile"),
              bottom: const TabBar(tabs: _tabs),
              actions: [
                if (widget.id == null) ...[
                  IconButton(
                    onPressed: () => context.pushNamed("editProfile"),
                    tooltip: l10n.editProfile,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: App.authState.signOut,
                    tooltip: l10n.logOut,
                    icon: const Icon(Icons.logout_outlined),
                  ),
                ]
              ]),
          body: TabBarView(children: [
            (snapshot.hasData)
                ? ProfileHeader(profile: snapshot.data!)
                : Center(
                    child: snapshot.hasError
                        ? Text(snapshot.error.toString())
                        : const CircularProgressIndicator(),
                  ),
            const FeedScreen(),
            const Tickets(),
          ]),
        ),
      ),
    );
  }
}
