import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";

class EventViewScreen extends StatelessWidget {
  EventViewScreen({super.key, required this.id});

  final String id;
  late final Future<Event> event = Event.find(id);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: event,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text(snapshot.data!.title),
              ),
              body: Center(
                child: Text(snapshot.data!.description),
              ),
            );
          }

          if (snapshot.hasError) {
            // TODO: Make this a separate 404Screen
            return Scaffold(
              appBar: AppBar(
                title: const Text("404"),
              ),
              body: const Center(
                child: Text("Seems like this event does not exist"),
              ),
            );
          }

          // TODO: Make this a separate Loading screen
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
