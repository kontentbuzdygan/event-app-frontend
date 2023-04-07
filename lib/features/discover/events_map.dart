import "dart:math";

import "package:event_app/api/locator.dart";
import "package:event_app/api/models/event.dart";
import "package:event_app/features/events/event_card.dart";
import "package:event_app/features/map/animated_map.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";

class EventsMap extends StatefulWidget {
  const EventsMap({
    super.key,
    required this.controller,
    required this.eventsSnapshot,
  });

  final MapController controller;
  final AsyncSnapshot<Iterable<Event>> eventsSnapshot;

  @override
  State<EventsMap> createState() => _EventsMapState();
}

class _EventsMapState extends State<EventsMap> with TickerProviderStateMixin {
  late Future<LatLng> userLocation;

  @override
  void initState() {
    super.initState();
    userLocation = userLatLng()
      ..then(
        (location) => widget.controller.animatedMapMove(this, location, 10),
      );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userLocation,
      builder: (context, snapshot) => FlutterMap(
        mapController: widget.controller,
        options: MapOptions(
          minZoom: 8,
          maxZoom: 18,
          zoom: 10,
        ),
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: "OpenStreetMap contributors",
            onSourceTapped: null,
            alignment: Alignment.topRight,
          ),
        ],
        children: [
          TileLayer(
            urlTemplate:
                "https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png",
          ),
          if (widget.eventsSnapshot.hasData)
            MarkerLayer(
              markers: widget.eventsSnapshot.data!.map(eventMarker).toList(),
            ),
        ],
      ),
    );
  }

  Marker eventMarker(Event event) {
    return Marker(
      point: event.location,
      builder: (_) => GestureDetector(
        onTap: () async {
          final center = widget.controller.center;
          final zoom = widget.controller.zoom;

          // FIXME: Use a wigdet that will resize map to
          // keep the pin visible after zooming
          await showModalBottomSheet(
            barrierColor: Colors.transparent,
            context: context,
            builder: (context) {
              widget.controller
                  .animatedMapMove(this, event.location, max(11, zoom));
              return EventLayout(event: event);
            },
          );

          widget.controller.animatedMapMove(this, center, zoom);
        },
        child: Icon(
          Icons.location_on,
          color: Theme.of(context).colorScheme.background,
          size: 48,
        ),
      ),
    );
  }
}
