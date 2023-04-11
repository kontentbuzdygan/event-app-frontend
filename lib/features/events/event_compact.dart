import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class EventCompact extends StatelessWidget {
  const EventCompact({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (event.banner != null)
          SizedBox(
            height: 150,
            child: Image.network(
              event.banner!.regular.toString(),
              fit: BoxFit.cover,
            ),
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
    );
  }
}
