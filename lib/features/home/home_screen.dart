import "package:event_app/api/models/event.dart";
import "package:event_app/errors.dart";
import "package:event_app/features/auth/auth_state.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _State();
}

class _State extends State<HomeScreen> {
  final allEvents = Event.findAll();

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.feedTitle),
        actions: <Widget>[
          IconButton(
            onPressed: () => throw const ApplicationException(message: "Kurwa"),
            tooltip: "Throw",
            icon: const Icon(Icons.sports_basketball),
          ),
          IconButton(
            onPressed: authState.signOut,
            tooltip: l10n.logOut,
            icon: const Icon(Icons.logout),
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
      // TODO: Handle hardcoded links :(
      onPressed: () => context.pushNamed(
        "eventView",
        params: {"eventId": event.id.toString()},
      ),
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
            Text(
              event.endsAt != null
                  ? l10n.eventTimeframe(event.startsAt, event.endsAt!)
                  : l10n.eventStartsAt(event.startsAt),
              style: TextStyle(color: Colors.blue[700]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(event.description),
            ),
          ],
        ),
      ),
    );
  }
}
