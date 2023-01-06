import "package:event_app/api/events/event.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:event_app/api/events/event_repository.dart";
import "package:event_app/features/auth/auth_state.dart";

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _State();
}

class _State extends State<HomeScreen> {
  int _lastInsertedId = 1;

  @override
  Widget build(BuildContext context) {
    final AuthState authState = context.watch<AuthState>();
    final eventRepository = context.watch<EventRepository>();

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
          _eventCount(eventRepository),
          _eventDisplay(eventRepository),
          ElevatedButton(
              onPressed: () async {
                final createdEvent = await eventRepository.create(NewEvent(
                    title: "New event at ${DateTime.now()}",
                    description: "Lorem ipsum",
                    startsAt: DateTime.now()));

                setState(() {
                  _lastInsertedId = createdEvent.id;
                });
              },
              child: const Text("Create another event")),
        ]),
      ),
    );
  }

  FutureBuilder<Iterable<Event>> _eventCount(EventRepository eventRepository) {
    return FutureBuilder(
        future: eventRepository.findAll(),
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

  FutureBuilder<Event> _eventDisplay(EventRepository eventRepository) {
    return FutureBuilder(
        future: eventRepository.find(_lastInsertedId),
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
