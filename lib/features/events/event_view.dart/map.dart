import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:skeletons/skeletons.dart";

class EventViewMap extends StatelessWidget {
  const EventViewMap({
    super.key,
    required this.location,
    required this.locationString,
  });

  final LatLng? location;
  final String? locationString;

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.5),
              ),
              child: SizedBox(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    zoom: 15,
                    absorbPanEventsOnScrollables: true,
                    center: location,
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
                      if (location != null)
                        Marker(
                          point: location!,
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
                locationString != null
                    ? Text(
                        locationString!,
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
