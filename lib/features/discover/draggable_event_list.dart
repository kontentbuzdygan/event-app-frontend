import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/features/discover/discover_screen_notifier.dart";
import "package:event_app/features/events/event_compact.dart";
import "package:event_app/features/profile/profile_compact.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";
import "package:skeletons/skeletons.dart";

class DraggableEventList extends StatefulWidget {
  const DraggableEventList({super.key});

  @override
  State<DraggableEventList> createState() => _DraggableEventListState();
}

class _DraggableEventListState extends State<DraggableEventList> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<DiscoverScreenNotifier>();
    final controller = state.sheetController;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent >= notification.maxExtent) {
          state.mapOpened = false;
        }

        if (notification.extent <= notification.minExtent) {
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
        expand: true,
        builder: (context, scrollController) {
          return Container(
            color: Theme.of(context).colorScheme.background,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 13),
                  Center(child: dragHandle(context)),
                  list()
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

  Widget list() {
    final widgets = profileList() + eventList();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widgets.length,
        // separatorBuilder: (context, i) => const SizedBox(height: 4),
        itemBuilder: (context, i) => widgets[i],
      ),
    );
  }

  List<Widget> eventList() {
    final state = context.read<DiscoverScreenNotifier>();
    final events = state.events ?? <Event>[];
    return events.where(state.filterEvent).map(eventListItem).toList();
  }

  List<Widget> profileList() {
    final profiles = context.read<DiscoverScreenNotifier>().profiles;
    if (profiles == null) {
      return const [
        Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        )
      ];
    }
    if (profiles.isEmpty) {
      return const [SizedBox()];
    }
    return profiles.map(profileListItem).toList();
  }

  Widget profileListItem(Profile profile) => InkWell(
        onTap: () => context.push("/profiles/${profile.id}"),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProfileCompact(profile: profile),
          ),
        ),
      );

  Widget eventListItem(Event event) => InkWell(
        onTap: () => context.push("/events/${event.id}"),
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: EventCompact(event: event),
        ),
      );

  //   return ListView.separated(
  Widget get eventListSkeleton => SkeletonItem(
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
      );
}
