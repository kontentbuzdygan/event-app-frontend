import "package:event_app/api/models/event.dart";
import "package:event_app/features/discover/draggable_event_list.dart";
import "package:event_app/features/discover/events_map.dart";
import "package:event_app/features/discover/top_bar.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with TickerProviderStateMixin {
  late bool mapOpened;
  late DraggableScrollableController sheetController;
  late Future<List<Event>> events;
  late MapController mapController;
  late TextEditingController searchField;

  @override
  void initState() {
    super.initState();

    events = () async {
      final events = await Event.findAll();
      await Future.wait(events.map((event) async => await event.fetchBanner()));
      return events;
    }();
    sheetController = DraggableScrollableController();
    mapController = MapController();
    mapOpened = false;
    searchField = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: events,
          builder: (context, eventsSnapshot) => Column(
            children: [
              TopBar(
                searchFieldController: searchField,
                mapOpened: mapOpened,
                mapOnClick: () {
                  sheetController.animateTo(
                    mapOpened ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
              ),
              Expanded(
                child: Stack(
                  children: [
                    EventsMap(
                      controller: mapController,
                      eventsSnapshot: eventsSnapshot,
                    ),
                    NotificationListener<DraggableScrollableNotification>(
                      child: DraggableEventList(
                        controller: sheetController,
                        events: events,
                      ),
                      onNotification: (notification) {
                        if (notification.extent >=
                            notification.maxExtent - 0.1) {
                          setState(() => mapOpened = false);
                        }

                        if (notification.extent <=
                            notification.minExtent + 0.1) {
                          setState(() => mapOpened = true);
                        }
                        return false;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
