import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (event.banner != null) banner(context),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                l10n.startsAtDate(event.startsAt),
                style: Theme.of(context).textTheme.labelSmall!.merge(
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
              ),
              const SizedBox(height: 12),
              Text(event.description),
            ],
          ),
        ),
      ],
    );
  }

  Container banner(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      height: 150,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        child: Image.network(event.banner!.small.toString(), fit: BoxFit.cover),
      ),
    );
  }
}
