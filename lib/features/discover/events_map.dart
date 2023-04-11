import "dart:math";

import "package:event_app/api/locator.dart";
import "package:event_app/api/models/event.dart";
import "package:event_app/features/discover/discover_screen_notifier.dart";
import "package:event_app/features/events/event_compact.dart";
import "package:event_app/features/map/animated_map.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:provider/provider.dart";

class EventsMap extends StatefulWidget {
  const EventsMap({super.key, required this.controller});

  final MapController controller;

  @override
  State<EventsMap> createState() => _EventsMapState();
}

class _EventsMapState extends State<EventsMap> with TickerProviderStateMixin {
  late Future<LatLng> userLocation;
  late final state = context.watch<DiscoverScreenNotifier>();

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
    final state = context.watch<DiscoverScreenNotifier>();

    return FutureBuilder(
      future: userLocation,
      builder: (context, snapshot) => Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: widget.controller,
              options: MapOptions(
                minZoom: 4,
                maxZoom: 18,
                zoom: 10,
                enableScrollWheel: true,
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
                if (state.events != null)
                  MarkerLayer(
                    markers: state.events!.map(eventMarker).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Marker eventMarker(Event event) {
    return Marker(
      point: event.location,
      builder: (_) => InkWell(
        onTap: () async {
          final center = widget.controller.center;
          final zoom = widget.controller.zoom;

          await showModalBottomSheet<void>(
            barrierColor: Colors.transparent,
            context: context,
            builder: (context) {
              widget.controller
                  .animatedMapMove(this, event.location, max(11, zoom));
              return EventCompact(event: event);
            },
          );

          widget.controller.animatedMapMove(this, center, zoom);
        },
        child: Icon(
          Icons.location_on,
          size: 48,
          color: state.filterEvent(event)
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.background.withOpacity(0.3),
        ),
      ),
    );
  }
}
