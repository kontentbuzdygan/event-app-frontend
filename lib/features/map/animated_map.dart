import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";

extension AnimatedMap on MapController {
  void animatedMapMove(
    TickerProvider tickerProvider,
    LatLng destLocation,
    double destZoom,
  ) {
    final latTween = Tween<double>(
      begin: center.latitude,
      end: destLocation.latitude,
    );

    final lngTween = Tween<double>(
      begin: center.longitude,
      end: destLocation.longitude,
    );

    final zoomTween = Tween<double>(begin: zoom, end: destZoom);

    late final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: tickerProvider,
    );

    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    );

    controller.addListener(() {
      move(
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
}
