import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/features/shared/loading_screen.dart";
import "package:event_app/features/shared/not_found_screen.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";


class EventData {
  Event event;
  Profile author;

  EventData({required this.event, required this.author});
}

class EventViewScreen extends StatelessWidget {
  const EventViewScreen({super.key, required this.id});

  final int id;

  Future<EventData> fetchEventData() async {
    final event = await Event.find(id);
    final author = await Profile.find(event.authorId);

    return EventData(event: event, author: author);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchEventData(),
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

        final event = snapshot.data!.event;
        final author = snapshot.data!.author;

        return Scaffold(
          appBar: AppBar(
            title: Text(event.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  infoRow("Author display name: ", author.displayName),
                  infoRow(
                    "starts at ",
                    formatter.format(event.startsAt),
                    TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  if (event.endsAt != null)
                    infoRow(
                      "Ends At: ",
                      formatter.format(event.endsAt!),
                    ),
                  infoRow("Description: ", event.description),
                ],
              ),
            ),
          ),
        );
      },
    );
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
