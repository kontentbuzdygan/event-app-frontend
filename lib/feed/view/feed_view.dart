import "package:auto_route/auto_route.dart";
import "package:event_app/feed/bloc/feed_bloc.dart";
import "package:event_app/router/router.dart";
import "package:event_repository/event_repository.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.feedTitle),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_outlined),
        onPressed: () => context.pushRoute(const CreateEventRoute()),
      ),
      body: BlocBuilder<FeedBloc, FeedState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) => ListView(
          children: [
            ...(state.events ?? [])
              .map((event) => EventListItem(event: event))
              .toList(),

            if (state.status is FeedLoading) const Center(
              child: CircularProgressIndicator(),
            ),

            if (state.status is FeedFailure) const Center(
              child: Text("Failed to fetch events :("),
            )
          ]      
        ),
      ),
    );
  }
}


class EventListItem extends StatelessWidget {
  final Event event;

  const EventListItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      // onTap: () => context.pushRoute(EventViewRoute(id: event.id)),
      child: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title, style: theme.textTheme.titleLarge),
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
                    label: Text(event.commentCount.toString())
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}