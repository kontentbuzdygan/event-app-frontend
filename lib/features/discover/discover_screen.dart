import "package:event_app/api/models/event.dart";
import "package:event_app/api/rest_client.dart";
import "package:event_app/features/discover/discover_screen_notifier.dart";
import "package:event_app/features/discover/draggable_event_list.dart";
import "package:event_app/features/discover/events_map.dart";
import "package:event_app/features/discover/top_bar.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:provider/provider.dart";

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with TickerProviderStateMixin {
  late DraggableScrollableController sheetController;
  late Future<List<Event>> events;
  late MapController mapController;

  @override
  void initState() {
    super.initState();

    sheetController = DraggableScrollableController();
    mapController = MapController();
    events = () async {
      final events = (await Event.findAll()).toList();
      await RestClient.runCached(
        () => Future.wait(
          events.map((event) => event.fetchAuthor()),
        ),
      );
      return events;
    }();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: events,
          builder: (context, eventsSnapshot) => ChangeNotifierProvider(
            create: (_) => DiscoverScreenNotifier(),
            child: Column(
              children: [
                const TopBar(),
                Expanded(
                  child: Stack(
                    children: [
                      EventsMap(
                        controller: mapController,
                        eventsSnapshot: eventsSnapshot,
                      ),
                      DraggableEventList(snapshot: eventsSnapshot)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
