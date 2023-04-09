import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: EventLayout(event: event),
    );
  }
}

class EventLayout extends StatelessWidget {
  const EventLayout({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => context.push(
        "/events/${event.id}",
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              event.banner!.regular.toString(),
              height: 150,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.titleLarge,
                  ),
                  Text(
                    l10n.startsAtDate(event.startsAt),
                    style: theme.textTheme.labelSmall!.merge(
                      TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(event.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
