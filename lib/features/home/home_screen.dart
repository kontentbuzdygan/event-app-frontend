import "package:event_app/api/events/model.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:event_app/api/events/repository.dart";
import "package:event_app/features/auth/auth_state.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final AuthState authState = context.watch<AuthState>();
    final eventRepository = context.watch<EventRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
          _eventDisplay(eventRepository),
          ElevatedButton(
              onPressed: () async {
                await eventRepository.create(NewEvent(
                    title: "New event at ${DateTime.now()}",
                    description: "Lorem ipsum",
                    startsAt: DateTime.now()));
              },
              child: const Text("Create another event")),
        ]),
      ),
    );
  }

  FutureBuilder<Iterable<Event>> _eventDisplay(
      EventRepository eventRepository) {
    return FutureBuilder(
        future: eventRepository.findAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            try {
              final event = snapshot.data!.last;
              return Text(event.title);
            } on StateError catch (_) {
              return const Text("No events");
            }
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return const Text("Loading...");
          }
        });
  }
}
