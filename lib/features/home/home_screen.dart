import "package:event_app/api/models/event.dart";
import "package:event_app/api/rest_client.dart";
import "package:event_app/errors.dart";
import "package:event_app/features/event/event_view_screen.dart";
import "package:event_app/features/profile/profile_view_screen.dart";
import "package:event_app/main.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static navigate() {
    App.router.goNamed("home");
  }

  @override
  State<HomeScreen> createState() => _State();
}

class _State extends State<HomeScreen> {
  final allEvents = () async {
    final events = (await Event.findAll()).toList();
    await RestClient.runCached(
      () => Future.wait(
        events.map((event) => event.fetchAuthor()),
      ),
    );
    return events;
  }();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.feedTitle),
        actions: [
          IconButton(
            onPressed: () => throw const ApplicationException(message: "Kurwa"),
            tooltip: "Throw",
            icon: const Icon(Icons.sports_basketball),
          ),
          IconButton(
            onPressed: ProfileViewScreen.navigateMe,
            tooltip: l10n.logOut,
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: FutureBuilder(
        future: allEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return eventsListView(snapshot.requireData);
          }

          return Text(l10n.loading);
        },
      ),
    );
  }

  Widget eventsListView(Iterable<Event> events) {
    return ListView(
      children: events.map(eventListItem).toList(),
    );
  }

  Widget eventListItem(Event event) {
    final l10n = AppLocalizations.of(context)!;

    return MaterialButton(
      onPressed: () => EventViewScreen.navigate(event.id),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              l10n.createdBy(event.author?.displayName ?? ""),
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 5.0),
            Text(
              event.endsAt != null
                  ? l10n.eventFromTo(event.startsAt, event.endsAt!)
                  : l10n.startsAtDate(event.startsAt),
              style: TextStyle(color: Colors.blue[700]),
            ),
            const SizedBox(height: 5.0),
            Text(event.description),
          ],
        ),
      ),
    );
  }
}
