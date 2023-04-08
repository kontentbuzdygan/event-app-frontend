import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";

Future<LatLng> userLatLng() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return Future.error("Location services are disabled.");
  }

  var permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error("Location permissions are denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      "Location permissions are permanently denied, we cannot request permissions.",
    );
  }

  final position = await Geolocator.getCurrentPosition();
  return LatLng(position.latitude, position.longitude);
}
