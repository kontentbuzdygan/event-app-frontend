import "package:event_app/api/models/event.dart";
import "package:event_app/features/events/event_view/banner.dart";
import "package:event_app/features/events/event_view/comments.dart";
import "package:event_app/features/events/event_view/date.dart";
import "package:event_app/features/events/event_view/description.dart";
import "package:event_app/features/events/event_view/map.dart";
import "package:event_app/features/events/tags/tags.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class EventView extends StatefulWidget {
  const EventView({super.key, required this.event});

  final Event? event;

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  Future<Event>? comments;
  late bool hasBanner;

  @override
  void initState() {
    super.initState();
    comments = widget.event?.fetchCommentsWithAuthors();
    hasBanner = true;
  }

  @override
  void didUpdateWidget(old) {
    super.didUpdateWidget(old);
    comments ??= widget.event?.fetchCommentsWithAuthors();
    hasBanner = widget.event == null ? true : widget.event!.banner != null;
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return ListView(
      padding: const EdgeInsets.only(top: 0),
      children: [
        if (hasBanner)
          EventViewBanner(
            title: event?.title,
            banner: event?.banner,
          ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (event != null) ...[
                Tags(event: event, short: false),
                const SizedBox(height: 16),
              ],
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
                builder: (context, snapshot) => InkWell(
                  onTap: event == null
                      ? null
                      : () => context.push(
                            "/events/${event.id}/comments",
                            extra: snapshot.data,
                          ),
                  child: EventViewComments(
                    commentCount: event?.commentCount,
                    comments:
                        snapshot.hasData ? snapshot.requireData.comments : null,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
