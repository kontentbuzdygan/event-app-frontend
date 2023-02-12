import "package:event_app/api/models/event.dart";
import "package:event_app/features/shared/loading_screen.dart";
import "package:event_app/features/shared/not_found_screen.dart";
import "package:flutter/material.dart";

class EventViewScreen extends StatelessWidget {
  EventViewScreen({super.key, required this.id});

  final String id;
  late final Future<Event> event = Event.find(id);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 3), () => event),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return NotFoundScreen("Seems like this event does not exist");
          }

          // TODO: Make this a skeleton loading?
          if (!snapshot.hasData) {
            return const LoadingScreen();
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data!.title),
            ),
            body: Center(
              child: Text(snapshot.data!.description),
            ),
          );
        });
  }
}
