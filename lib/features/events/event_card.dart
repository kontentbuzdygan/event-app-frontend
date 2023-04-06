import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(event.description),
          ],
        ),
      ),
    );
  }
}
