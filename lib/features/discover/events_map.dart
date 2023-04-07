import "package:event_app/api/models/event.dart";
import "package:event_app/features/events/event_card.dart";
import "package:event_app/features/map/animated_map_controller.dart";
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
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final mapController = widget.controller;

    final latTween = Tween<double>(
      begin: mapController.center.latitude,
      end: destLocation.latitude,
    );

    final lngTween = Tween<double>(
      begin: mapController.center.longitude,
      end: destLocation.longitude,
    );

    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    final controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
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
    );
  }

  Marker eventMarker(Event event) {
    return Marker(
      point: event.location,
      builder: (_) => GestureDetector(
        onTap: () => showModalBottomSheet(
          context: context,
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _animatedMapMove(event.location, 11);
            });

            return EventLayout(event: event);
          },
        ),
        child: Icon(
          Icons.location_on,
          color: Theme.of(context).colorScheme.background,
          size: 48,
        ),
      ),
    );
  }
}
