import "package:event_app/api/models/event.dart";
import "package:event_app/features/events/event_list.dart";
import "package:flutter/material.dart";

class DraggableEventList extends StatelessWidget {
  const DraggableEventList({
    super.key,
    required this.controller,
    required this.events,
  });

  final Future<List<Event>> events;
  final DraggableScrollableController controller;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: controller,
      maxChildSize: 1,
      minChildSize: 0.05,
      initialChildSize: 1,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 13),
                dragHandle(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: EventList(events: events),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Container dragHandle(BuildContext context) {
    return Container(
      height: 5,
      width: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
