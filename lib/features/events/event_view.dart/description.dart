import "package:event_app/api/models/profile.dart";
import "package:flutter/material.dart";
import "package:skeletons/skeletons.dart";

class EventViewDescription extends StatelessWidget {
  const EventViewDescription({
    super.key,
    required this.description,
    required this.author,
  });

  final String? description;
  final Profile? author;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              author == null
                  ? const EventViewDisplayNameSkeleton()
                  : Flexible(
                      child: Text(
                        author!.displayName,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
            ]),
            const SizedBox(height: 16),
            description == null
                ? const EventViewDescriptionSkeleton()
                : Text(description!, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class EventViewDescriptionSkeleton extends StatelessWidget {
  const EventViewDescriptionSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SkeletonLine(
      style: SkeletonLineStyle(width: 1000, height: 100),
    );
  }
}

class EventViewDisplayNameSkeleton extends StatelessWidget {
  const EventViewDisplayNameSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SkeletonLine(
      style: SkeletonLineStyle(width: 200, height: 30),
    );
  }
}
