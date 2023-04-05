import "package:event_app/api/models/event_comment.dart";
import "package:flutter/material.dart";
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
    return Row(
      children: [
        IconButton(
            onPressed: () =>
                context.push("/profiles/${widget.comment.authorId}"),
            icon: const Icon(Icons.account_circle_outlined)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "${widget.comment.author!.displayName} on ${widget.comment.createdAt.toString()}"),
            Text(widget.comment.content)
          ],
        )
      ],
    );
  }
}
