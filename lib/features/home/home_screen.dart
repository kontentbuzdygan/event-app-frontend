import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:event_app/features/auth/auth_state.dart";

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _State();
}

class _State extends State<HomeScreen> {
  final Future<Iterable<Event>> allEvents = Event.findAll();
  Future<Event> currentEvent = Event.find(1);

  @override
  Widget build(BuildContext context) {
    final AuthState authState = context.watch<AuthState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: authState.signOut,
            tooltip: "Logout: ${authState.userToken}",
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(children: [
          allEventsCountWidget,
          currentEventWidget,
          ElevatedButton(
              onPressed: () async {
                final createdEvent = await NewEvent(
                        title: "New event at ${DateTime.now()}",
                        description: "Lorem ipsum",
                        startsAt: DateTime.now())
                    .save();

                setState(() {
                  currentEvent = Future.value(createdEvent);
                });
              },
              child: const Text("Create another event")),
        ]),
      ),
    );
  }

  FutureBuilder<Iterable<Event>> get allEventsCountWidget {
    return FutureBuilder(
        future: allEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final events = snapshot.data!;
            return Text(events.length.toString());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return const Text("Loading...");
          }
        });
  }

  FutureBuilder<Event> get currentEventWidget {
    return FutureBuilder(
        future: currentEvent,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final event = snapshot.data!;
            return Text(event.title);
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return const Text("Loading...");
          }
        });
  }
}
