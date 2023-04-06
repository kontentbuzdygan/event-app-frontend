import "package:event_app/api/locator.dart";
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

class _DiscoverScreenState extends State<DiscoverScreen> {
  final mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: userLatLng(),
          builder: (context, locationSnapshot) {
            if (locationSnapshot.connectionState == ConnectionState.done &&
                locationSnapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                mapController.move(locationSnapshot.requireData, 8);
              });
            }

            return FutureBuilder(
              future: Event.findAll(),
              builder: (context, eventsSnapshot) => Stack(
                children: [
                  EventsMap(
                    controller: mapController,
                    eventsSnapshot: eventsSnapshot,
                  ),
                  DraggableEventList(snapshot: eventsSnapshot),
                  const TopBar(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
