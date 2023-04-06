import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:go_router/go_router.dart";

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

class _EventsMapState extends State<EventsMap> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.controller,
      options: MapOptions(
        minZoom: 8,
        maxZoom: 18,
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
    );
  }

  Marker eventMarker(Event event) {
    return Marker(
      point: event.location,
      builder: (_) => GestureDetector(
        onTap: () => context.push("/events/${event.id}"),
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 48,
        ),
      ),
    );
  }
}
