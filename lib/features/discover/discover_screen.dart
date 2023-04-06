import "dart:math";

import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/api/osm_nominatim_dlient.dart";
import "package:event_app/features/discover/event_map.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_map/flutter_map.dart";

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

// TODO: Translate this file
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
                  EventMap(
                    controller: mapController,
                    eventsSnapshot: eventsSnapshot,
                  ),
                  draggableEventList(eventsSnapshot),
                  const SearchBar(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget draggableEventList(AsyncSnapshot<Iterable<Event>> snapshot) {
    return DraggableScrollableSheet(
      maxChildSize: 0.84,
      minChildSize: 0.035,
      initialChildSize: 0.035,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            color: Theme.of(context).colorScheme.background,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  height: 5,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                if (snapshot.hasData)
                  ListView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 10,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      ...snapshot.data!.map(eventCard).toList(),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget eventCard(event) => GestureDetector(
        onTap: () => mapController.move(event.location, mapController.zoom),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(event.description),
              ],
            ),
          ),
        ),
      );
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 60,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              margin: EdgeInsets.zero,
              elevation: 5,
              child: Center(
                child: TextFormField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search here",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                Chip(label: Text("🎉 Party")),
                SizedBox(width: 10),
                Chip(label: Text("🏋️ Gym")),
                SizedBox(width: 10),
                Chip(label: Text("🏌️ Golf")),
                SizedBox(width: 10),
                Chip(label: Text("👻 Movie night")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
