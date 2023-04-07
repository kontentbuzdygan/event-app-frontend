import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";

void animatedMapMove(
  Widget elo,
  MapController mapController,
  AnimationController animationController,
  LatLng destLocation,
  double destZoom,
) {
  final latTween = Tween<double>(
    begin: mapController.center.latitude,
    end: destLocation.latitude,
  );

  final lngTween = Tween<double>(
    begin: mapController.center.longitude,
    end: destLocation.longitude,
  );

  final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

  final Animation<double> animation = CurvedAnimation(
    parent: animationController,
    curve: Curves.fastOutSlowIn,
  );

  animationController.addListener(() {
    mapController.move(
      LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
      zoomTween.evaluate(animation),
    );
  });

  animation.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      animationController.dispose();
    } else if (status == AnimationStatus.dismissed) {
      animationController.dispose();
    }
  });

  animationController.forward();
}
