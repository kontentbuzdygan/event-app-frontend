import "package:auto_route/auto_route.dart";
import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/api/models/story.dart";
import "package:event_app/features/events/event_list.dart";
import "package:event_app/features/profile/profile_header.dart";
import "package:event_app/features/profile/tickets.dart";
import "package:event_app/main.dart";
import "package:event_app/router.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

@RoutePage()
class ProfileViewPage extends StatefulWidget {
  const ProfileViewPage({super.key, @pathParam this.id});

  final int? id;

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage>
    with SingleTickerProviderStateMixin {
  late final Future<Profile> profile =
      widget.id != null ? Profile.find(widget.id!) : Profile.me();
  late final Future<List<Story>> allStories;

  @override
  void initState() {
    super.initState();

    allStories = () async {
      final stories = await fetchRandomStoriesByAuthorId(widget.id ?? 0);
      await Future.wait(stories.map((story) => story.fetchAuthor()));
      await Future.wait(stories.map((story) => story.fetchEvent()));
      return stories;
    }();
  }

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
                    onPressed: () => context.pushRoute(const ProfileEditRoute()),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: EventList(
                events: Event.findAll(),
              ),
            ),
            const Tickets(),
          ]),
        ),
      ),
    );
  }
}
