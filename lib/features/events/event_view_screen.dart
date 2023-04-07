import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";

import "comments/comments.dart";

class EventViewScreen extends StatefulWidget {
  const EventViewScreen({super.key, required this.id});

  final int id;

  @override
  State<EventViewScreen> createState() => _EventViewScreenState();
}

class _EventViewScreenState extends State<EventViewScreen> {
  late var event = Event.find(widget.id)
      .then((event) => event.fetchAuthor())
      .then((event) => event.fetchBanner());

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

class EventView extends StatefulWidget {
  const EventView({super.key, required this.event});

  final Event event;

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          if (widget.event.banner != null)
            Expanded(child: Image.network(widget.event.banner!)),
          Row(children: [
            Text(
              l10n.createdBy(""),
              style: TextStyle(color: theme.hintColor),
            ),
            TextButton(
              onPressed: () =>
                  context.push("/profiles/${widget.event.authorId}"),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Text(
                widget.event.author!.displayName,
                style: TextStyle(color: theme.hintColor),
              ),
            ),
          ]),
          Text(
            widget.event.endsAt != null
                ? l10n.eventFromTo(widget.event.startsAt, widget.event.endsAt!)
                : l10n.startsAtDate(widget.event.startsAt),
            style: TextStyle(color: theme.colorScheme.primary),
          ),
          Text(widget.event.description),
          Text("Comments", style: theme.textTheme.headlineMedium),
          Comments(event: widget.event),
        ],
      ),
    );
  }
}
