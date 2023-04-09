import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/story.dart";
import "package:event_app/api/rest_client.dart";
import "package:event_app/features/story/story_list_view.dart";
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
  late Future<List<Story>> allStories;

  @override
  void initState() {
    super.initState();

    allStories = () async {
      final stories = await fetchRandomStoriesByEventId(widget.event.id);
      await Future.wait(stories.map((story) => story.fetchAuthor()));
      return stories;
    }();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      children: [
        Row(
          children: [
            if (widget.event.banner != null)
              Expanded(
                  child: Image.network(widget.event.banner!.regular.toString(),
                      fit: BoxFit.fill)),
          ],
        ),
        StoryListView(stories: allStories),
        Row(children: [
          Text(
            l10n.createdBy(""),
            style: TextStyle(color: theme.hintColor),
          ),
          TextButton(
            onPressed: () => context.push("/profiles/${widget.event.authorId}"),
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
    );
  }
}
