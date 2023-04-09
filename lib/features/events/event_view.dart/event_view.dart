import "package:event_app/api/models/event.dart";
import "package:event_app/features/events/event_view.dart/banner.dart";
import "package:event_app/features/events/event_view.dart/comments.dart";
import "package:event_app/features/events/event_view.dart/date.dart";
import "package:event_app/features/events/event_view.dart/description.dart";
import "package:event_app/features/events/event_view.dart/map.dart";
import "package:flutter/material.dart";

class EventView extends StatefulWidget {
  const EventView({super.key, required this.event});

  final Event? event;

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  Future<Event>? comments;
  Future<Event>? banner;

  @override
  void initState() {
    super.initState();
    comments = widget.event?.fetchComments();
    banner = widget.event?.fetchBanner();
  }

  @override
  void didUpdateWidget(old) {
    super.didUpdateWidget(old);

    banner ??= widget.event?.fetchBanner();
    comments ??= widget.event?.fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return ListView(
      padding: const EdgeInsets.only(top: 0),
      children: [
        if (event?.hasBanner ?? true)
          FutureBuilder(
            future: banner,
            builder: (context, snapshot) => EventViewBaner(
              title: event?.title,
              banner: snapshot.data?.banner,
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EventViewDate(
                startsAt: event?.startsAt,
                endsAt: event?.endsAt,
              ),
              const SizedBox(height: 16),
              EventViewDescription(
                description: event?.description,
                author: event?.author,
              ),
              const SizedBox(height: 16),
              EventViewMap(
                location: event?.location,
                locationString: "Mickey's house",
              ),
              const SizedBox(height: 16),
              FutureBuilder(
                future: comments,
                builder: (context, snapshot) => EventViewComments(
                  commentCount: event?.commentCount,
                  comments:
                      snapshot.hasData ? snapshot.requireData.comments : null,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
