import "package:event_app/api/models/event.dart";
import "package:event_app/features/events/event_card.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:skeletons/skeletons.dart";

class DraggableEventList extends StatelessWidget {
  const DraggableEventList({
    super.key,
    required this.controller,
    required this.snapshot,
  });

  final AsyncSnapshot<List<Event>> snapshot;
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
                eventsList,
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

  Widget get eventsList => !snapshot.hasData
      ? eventListSkeleton
      : ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) => GestureDetector(
            onTap: () => context.push(
              "/events/${snapshot.data![i].id}",
            ),
            child: EventCard(event: snapshot.data![i]),
          ),
        );

  Widget get eventListSkeleton => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: SkeletonItem(
          child: Column(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 180,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              const SizedBox(height: 10),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 140,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              const SizedBox(height: 10),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 100,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              const SizedBox(height: 10),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 140,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
}
