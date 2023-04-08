import "package:event_app/api/models/event.dart";
import "package:event_app/features/discover/discover_screen_notifier.dart";
import "package:event_app/features/events/event_card.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";
import "package:skeletons/skeletons.dart";

class DraggableEventList extends StatelessWidget {
  const DraggableEventList({super.key, required this.snapshot});

  final AsyncSnapshot<List<Event>> snapshot;

  @override
  Widget build(BuildContext context) {
    final state = context.read<DiscoverScreenNotifier>();
    final controller = state.sheetController;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent >= notification.maxExtent - 0.1) {
          state.mapOpened = false;
        }

        if (notification.extent <= notification.minExtent + 0.1) {
          state.mapOpened = true;
        }
        return false;
      },
      child: DraggableScrollableSheet(
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
                  eventsList(state.filterEvent),
                ],
              ),
            ),
          );
        },
      ),
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

  Widget eventsList(bool Function(Event) filter) => !snapshot.hasData
      ? eventListSkeleton
      : Builder(builder: (context) {
          final events = snapshot.requireData.where(filter).toList();

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => context.push(
                "/events/${events[i].id}",
              ),
              child: EventCard(event: events[i]),
            ),
          );
        });

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
