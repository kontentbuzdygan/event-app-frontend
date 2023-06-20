import "package:auto_route/annotations.dart";
import "package:event_app/api/models/event.dart";
import "package:event_app/features/events/comments/comment.dart";
import "package:event_app/features/events/comments/comment_input.dart";
import "package:event_app/features/events/comments/comment_skeleton.dart";
import "package:flutter/material.dart";

@RoutePage()
class EventCommentsViewPage extends StatefulWidget {
  const EventCommentsViewPage({
    super.key,
    @PathParam("id") required this.eventId,
    this.event,
  });

  final int eventId;
  final Event? event;

  @override
  State<EventCommentsViewPage> createState() => _EventCommentsViewPageState();
}

class _EventCommentsViewPageState extends State<EventCommentsViewPage> {
  late Future<Event> event;

  @override
  void initState() {
    super.initState();
    event =
        Event.find(widget.eventId).then((e) => e.fetchCommentsWithAuthors());
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: event,
        builder: (context, snapshot) => Scaffold(
          appBar: AppBar(
            title: Text(
              snapshot.data?.title != null
                  ? snapshot.data!.title
                  : widget.event?.title != null
                      ? widget.event!.title
                      : "",
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(builder: (context) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }

                  if (snapshot.hasData) {
                    return ListView.separated(
                      itemCount: snapshot.data!.comments!.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                      itemBuilder: (context, i) => Comment(
                        snapshot.data!.comments![i],
                      ),
                    );
                  }

                  if (widget.event?.comments != null) {
                    return ListView.separated(
                      itemCount: widget.event!.comments!.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                      itemBuilder: (context, i) =>
                          Comment(widget.event!.comments![i]),
                    );
                  }

                  return ListView.separated(
                    itemCount: 10,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    itemBuilder: (context, i) => const CommentSkeleton(),
                  );
                }),
                // const SizedBox(height: 30),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: CommentInput(onSubmit: () {}),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
