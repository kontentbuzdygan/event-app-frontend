import "dart:math";

import "package:auto_route/auto_route.dart";
import "package:event_app/api/models/event.dart";
import "package:event_app/features/events/event_compact.dart";
import "package:event_app/router.dart";
import "package:flutter/material.dart";
import "package:skeletons/skeletons.dart";

final _random = Random();

class EventList extends StatefulWidget {
  const EventList({super.key, required this.events});

  final Future<List<Event>> events;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData) {
          return eventListSkeleton();
        }

        final data = snapshot.requireData;

        return ListView.separated(
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) => Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              onTap: () => context.pushRoute(
                EventViewRoute(id: data[index].id, event: data[index])
              ),
              child: EventCompact(event: snapshot.data![index]),
            ),
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        );
      },
    );
  }
}

Widget eventListSkeleton() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    child: SkeletonItem(
      child: Column(
        children: List.generate(
          5,
          (index) => Column(children: [
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 100.0 + _random.nextInt(100),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            const SizedBox(height: 10),
          ]),
        ),
      ),
    ),
  );
}
