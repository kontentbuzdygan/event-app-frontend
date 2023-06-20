import "package:auto_route/auto_route.dart";
import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/features/discover/discover_screen_notifier.dart";
import "package:event_app/features/discover/draggable_event_list.dart";
import "package:event_app/features/discover/events_map.dart";
import "package:event_app/features/discover/top_bar.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:provider/provider.dart";

@RoutePage()
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with TickerProviderStateMixin {
  late DraggableScrollableController sheetController;
  late Future<List<Event>> events;
  late Future<List<Profile>> profiles;
  late MapController mapController;

  @override
  void initState() {
    super.initState();

    events = Event.findAll();
    sheetController = DraggableScrollableController();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: ChangeNotifierProvider(
          create: (context) => DiscoverPageNotifier(),
          child: Column(
            children: [
              const TopBar(),
              Expanded(
                child: Stack(children: [
                  EventsMap(controller: mapController),
                  const DraggableEventList(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
