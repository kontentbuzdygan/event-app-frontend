import "package:event_app/api/models/event_comment.dart";
import "package:flutter/material.dart";

class Comment extends StatelessWidget {
  const Comment(this.comments, {super.key});

  final EventComment comments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 10),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              comments.author?.displayName ?? "",
              style: theme.textTheme.titleMedium,
            ),
            Text(
              comments.content,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    ]);
  }
}
