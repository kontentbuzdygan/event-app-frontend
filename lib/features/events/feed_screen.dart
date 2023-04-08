import "package:event_app/api/models/event.dart";
import "package:event_app/api/rest_client.dart";
import "package:event_app/errors.dart";
import "package:event_app/features/events/tags/tags.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _State();
}

class _State extends State<FeedScreen> {
  late Future<List<Event>> allEvents;

  @override
  void initState() {
    super.initState();

    allEvents = () async {
      final events = (await Event.findAll()).toList();
      await RestClient.runCached(
        () => Future.wait(
          events.map((event) => event.fetchAuthor()),
        ),
      );
      return events;
    }();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.feedTitle),
        actions: [
          IconButton(
            onPressed: () => throw const ApplicationException(message: "Kurwa"),
            tooltip: "Throw",
            icon: const Icon(Icons.sports_basketball_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_outlined),
        onPressed: () => context.pushNamed("createEvent"),
      ),
      body: FutureBuilder(
        future: allEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return eventsListView(snapshot.requireData);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget eventsListView(Iterable<Event> events) {
    return ListView(
      children: events.map(eventListItem).toList(),
    );
  }

  Widget eventListItem(Event event) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return MaterialButton(
      onPressed: () => context.push("/events/${event.id}"),
      child: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 5),
            Text(l10n.createdBy(event.author!.displayName)),
            const SizedBox(height: 5),
            Text(
              event.endsAt != null
                  ? l10n.eventFromTo(event.startsAt, event.endsAt!)
                  : l10n.startsAtDate(event.startsAt),
              style: TextStyle(color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 5),
            Text(event.description),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.comment_outlined, size: 16),
                    label: Text(event.commentCount.toString())),
                const SizedBox(width: 8),
                Tags(
                  event: event,
                  short: true,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
