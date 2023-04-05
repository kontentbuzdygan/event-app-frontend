import "package:event_app/api/models/event_comment.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";

class Comment extends StatefulWidget {
  const Comment({super.key, required this.comment});

  final EventComment comment;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final authorProfile = "/profiles/${widget.comment.authorId}";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () => context.push(authorProfile),
              icon: const Icon(Icons.account_circle_outlined)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => context.push(authorProfile),
                    child: Text(
                      widget.comment.author!.displayName,
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                  const Text(" "),
                  Text(
                    l10n.date(widget.comment.createdAt),
                    style: theme.textTheme.labelSmall!.merge(
                      TextStyle(color: theme.hintColor),
                    ),
                  )
                ],
              ),
              Text(widget.comment.content)
            ],
          )
        ],
      ),
    );
  }
}
