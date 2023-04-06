import "package:event_app/api/models/event.dart";
import "package:event_app/api/rest_client.dart";
import "package:event_app/errors.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _State();
}

class _State extends State<FeedScreen> {
  List<Event> allEvents = List.empty(growable: true);
  late Future<List<Event>> _future;
  late ScrollController _scrollController;
  bool moreLoading = false;
  int page = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !moreLoading) {
        setState(() {
          moreLoading = true;
          _future = loadEvents();
          moreLoading = false;
        });
      }
    });

    _future = loadEvents(); 
  }

  @override
  void dispose() {
    _scrollController.removeListener(loadEvents);
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<Event>> loadEvents() async {
      final events = (await Event.findAll(page:page)).toList();
      await RestClient.runCached(
        () => Future.wait(
          events.map((event) => event.fetchAuthor()),
        ),
      );

      if (events.isEmpty) return allEvents;

      page++;
      allEvents.addAll(events);
      return allEvents;
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
        future: _future,
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
        controller: _scrollController,
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
            OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.comment_outlined, size: 16),
                label: Text(event.commentCount.toString()))
          ],
        ),
      ),
    );
  }
}
