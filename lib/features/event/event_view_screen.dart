import "package:event_app/api/models/event.dart";
import "package:event_app/features/shared/loading_screen.dart";
import "package:event_app/features/shared/not_found_screen.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class EventViewScreen extends StatelessWidget {
  EventViewScreen({super.key, required this.id});

  final String id;
  late final Future<Event> event = Event.find(id);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: event,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return NotFoundScreen("Seems like this event does not exist");
          }

          // TODO: Make this a skeleton loading?
          if (!snapshot.hasData) {
            return const LoadingScreen();
          }

          final DateFormat formatter = DateFormat("yyyy-MM-dd");

          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data!.title),
            ),
            body: Center(
              child: Column(
                children: [
                  Text(snapshot.data!.authorId.toString()),
                  Text(formatter.format(snapshot.data!.startsAt)),
                  if (snapshot.data!.endsAt != null)
                    Text(snapshot.data!.endsAt.toString()),
                  Text(snapshot.data!.description),
                ],
              ),
            ),
          );
        });
  }
}
