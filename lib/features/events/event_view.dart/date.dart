import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:skeletons/skeletons.dart";

class EventViewDate extends StatelessWidget {
  const EventViewDate({
    super.key,
    required this.startsAt,
    required this.endsAt,
  });

  final DateTime? startsAt;
  final DateTime? endsAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (startsAt == null) {
      return const EventViewDateSkeleton();
    }

    return Row(children: [
      Icon(Icons.calendar_month, color: theme.colorScheme.primary),
      const SizedBox(width: 10),
      Text(
        endsAt != null
            ? l10n.eventFromTo(startsAt!, endsAt!)
            : l10n.startsAtDate(startsAt!),
        style: TextStyle(color: theme.colorScheme.primary),
      ),
    ]);
  }
}

class EventViewDateSkeleton extends StatelessWidget {
  const EventViewDateSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SkeletonLine(
      style: SkeletonLineStyle(width: 240, height: 20),
    );
  }
}
