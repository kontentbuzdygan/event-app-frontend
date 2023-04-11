import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:skeletons/skeletons.dart";

class EventViewMap extends StatefulWidget {
  const EventViewMap({
    super.key,
    required this.location,
    required this.locationString,
  });

  final LatLng? location;
  final String? locationString;

  @override
  State<EventViewMap> createState() => _EventViewMapState();
}

class _EventViewMapState extends State<EventViewMap> {
  late MapController map;

  @override
  void initState() {
    super.initState();
    map = MapController();
  }

  // TODO: Fix this
  // @override
  // void didUpdateWidget(oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   // if (widget.location != null) {
  //   //   map.move(widget.location!, map.zoom);
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.location == null)
            const EventViewMapSkeleton()
          else
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.5),
              ),
              child: SizedBox(
                height: 200,
                child: FlutterMap(
                  mapController: map,
                  options: MapOptions(
                    zoom: 15,
                    center: widget.location,
                  ),
                  nonRotatedChildren: [
                    AttributionWidget.defaultWidget(
                      source: "OpenStreetMap contributors",
                    ),
                  ],
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png",
                    ),
                    MarkerLayer(markers: [
                      if (widget.location != null)
                        Marker(
                          point: widget.location!,
                          builder: (_) => Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.background,
                            size: 48,
                          ),
                        )
                    ]),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 10),
              widget.locationString != null
                  ? Text(
                      widget.locationString!,
                      style: Theme.of(context).textTheme.titleSmall,
                    )
                  : const SkeletonLine(
                      style: SkeletonLineStyle(width: 60, height: 30),
                    ),
            ]),
          ),
        ],
      ),
    );
  }
}

class EventViewMapSkeleton extends StatelessWidget {
  const EventViewMapSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.5),
        ),
        child: SkeletonLine(
          style: SkeletonLineStyle(height: 200),
        ),
      );
}
