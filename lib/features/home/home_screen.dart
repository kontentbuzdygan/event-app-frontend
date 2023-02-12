import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:event_app/features/auth/auth_state.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _State();
}

class _State extends State<HomeScreen> {
  final Future<Iterable<Event>> allEvents = Event.findAll();

  @override
  Widget build(BuildContext context) {
    final AuthState authState = context.watch<AuthState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed"),
        actions: <Widget>[
          IconButton(
            onPressed: authState.signOut,
            tooltip: "Log out",
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: FutureBuilder(
          future: allEvents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return eventsListView(snapshot.requireData);
            }

            return const Text("Loading...");
          }),
    );
  }

  Widget eventsListView(Iterable<Event> events) {
    return ListView(
      children: events.map(eventListItem).toList(),
    );
  }

  Widget eventListItem(Event event) {
    final formatter = DateFormat("yyyy-MM-dd");

    return MaterialButton(
        // TODO: Handle hardcoded links :(
        onPressed: () => context.push("/event/${event.id}"),
        child: Container(
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.topLeft,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(event.title,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold)),
              Text(
                  event.endsAt != null
                      ? "from ${formatter.format(event.startsAt)} to ${formatter.format(event.endsAt!)}"
                      : "starts at ${formatter.format(event.startsAt)}",
                  style: TextStyle(color: Colors.blue[700])),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Text(event.description),
              ),
            ])));
  }
}
