import "package:event_app/api/models/event_comment.dart";
import "package:flutter/material.dart";

class EventViewComments extends StatelessWidget {
  const EventViewComments({
    super.key,
    required this.commentCount,
    required this.comments,
  });

  final int? commentCount;
  final List<EventComment>? comments;

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
              Text(
                "Comments ",
                style: theme.textTheme.titleMedium,
              ),
              Text(commentCount.toString())
            ]),
            const SizedBox(height: 5),
            Row(children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  comments?[0].content ?? "",
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
