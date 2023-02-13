import "package:event_app/api/models/event.dart";
import "package:event_app/features/shared/loading_screen.dart";
import "package:event_app/features/shared/not_found_screen.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class EventViewScreen extends StatelessWidget {
  EventViewScreen({super.key, required int id}) {
    event = Event.find(id);
  }

  // TODO: Chain event fetching with author profile fetching
  late final Future<Event> event;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: event,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const NotFoundScreen(
              message: "Seems like this event does not exist",
            );
          }

          if (!snapshot.hasData) {
            return const LoadingScreen();
          }

          final DateFormat formatter = DateFormat("yyyy-MM-dd");

          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data!.title),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: [
                    infoRow("Author ID: ", snapshot.data!.authorId.toString()),
                    infoRow(
                      "starts at ",
                      formatter.format(snapshot.data!.startsAt),
                      TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    if (snapshot.data!.endsAt != null)
                      infoRow(
                        "Ends At: ",
                        formatter.format(snapshot.data!.endsAt!),
                      ),
                    infoRow("Description: ", snapshot.data!.description),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget infoRow(String label, String info, [TextStyle? style]) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)
              .merge(style),
        ),
        Text(info, style: style),
      ],
    );
  }
}
