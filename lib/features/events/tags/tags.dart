import "dart:math";

import "package:event_app/api/models/event.dart";
import "package:event_app/features/events/tags/tag.dart";
import "package:flutter/material.dart";

class Tags extends StatefulWidget {
  const Tags({super.key, required this.event, required this.short});

  final Event event;
  final bool short;

  @override
  State<Tags> createState() => _State();
}

class _State extends State<Tags> {
  late var eventTags = () async {
    final event = await widget.event.fetchTags();
    return event.tags;
  }();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: eventTags,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        return Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: widget.short
              ? [
                  Tag(
                      tag: snapshot.data!
                          .elementAt(Random().nextInt(snapshot.data!.length)))
                ]
              : [...snapshot.data!.map((tag) => Tag(tag: tag)).toList()],
        );
      },
    );
  }
}
