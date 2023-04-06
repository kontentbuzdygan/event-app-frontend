import "package:event_app/api/models/event.dart";
import "package:event_app/features/events/event_card.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class DraggableEventList extends StatelessWidget {
  const DraggableEventList({super.key, required this.snapshot});

  final AsyncSnapshot<Iterable<Event>> snapshot;

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(26),
      ),
      color: Theme.of(context).colorScheme.background,
    );

    return DraggableScrollableSheet(
      maxChildSize: 0.84,
      minChildSize: 0.035,
      initialChildSize: 0.035,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: boxDecoration,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 12),
                draggableHandle(context),
                if (snapshot.hasData) eventsList,
              ],
            ),
          ),
        );
      },
    );
  }

  Container draggableHandle(BuildContext context) => Container(
        height: 5,
        width: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
      );

  Widget get eventsList => ListView.separated(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 10,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: snapshot.data!.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => context.push("/events/${snapshot.data!.toList()[i].id}"),
          child: snapshot.data!.map(eventCard).toList()[i],
        ),
      );

  Widget eventCard(event) => GestureDetector(
        child: EventCard(event: event),
      );
}
