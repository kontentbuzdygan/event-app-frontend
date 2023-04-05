import "package:event_app/api/models/event.dart";
import "package:event_app/api/rest_client.dart";
import "package:event_app/features/events/comments/comment.dart";
import "package:event_app/features/events/comments/comment_input.dart";
import "package:flutter/material.dart";

class Comments extends StatefulWidget {
  const Comments({super.key, required this.event});

  final Event event;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  late var comments = () async {
    final event = await widget.event.fetchComments();
    await RestClient.runCached(
      () => Future.wait(
        event.comments!.map((comment) => comment.fetchAuthor()),
      ),
    );
    return event.comments;
  }();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: comments,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            ...snapshot.data!
                .map((comment) => Comment(comment: comment))
                .toList(),
            CommentInput(onSubmit: () {}) // TODO: make an API request
          ],
        );
      },
    );
  }
}
