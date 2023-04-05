import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";

class EventViewScreen extends StatefulWidget {
  const EventViewScreen({super.key, required this.id});

  final int id;

  @override
  State<EventViewScreen> createState() => _EventViewScreenState();
}

class _EventViewScreenState extends State<EventViewScreen> {
  late final event = Event.find(widget.id).then((event) => event.fetchAuthor());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder(
      future: event,
      builder: (builder, snapshot) => Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data?.title ?? ""),
        ),
        body: () {
          if (snapshot.hasData) return EventView(event: snapshot.data!);

          return Center(
            child: snapshot.hasError
                ? Text(l10n.eventNotFound)
                : const CircularProgressIndicator(),
          );
        }(),
      ),
    );
  }
}

class EventView extends StatelessWidget {
  const EventView({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(
              l10n.createdBy(""),
              style: TextStyle(color: Colors.grey[600]),
            ),
            TextButton(
              onPressed: () => context.push("/profiles/${event.authorId}"),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                maximumSize: Size.infinite,
              ),
              child: Text(
                event.author!.displayName,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ]),
          Text(
            event.endsAt != null
                ? l10n.eventFromTo(event.startsAt, event.endsAt!)
                : l10n.startsAtDate(event.startsAt),
            style: TextStyle(color: Colors.blue[700]),
          ),
          const SizedBox(height: 5.0),
          Text(event.description),
        ],
      ),
    );
  }
}
