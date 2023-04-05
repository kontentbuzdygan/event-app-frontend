import "package:event_app/errors.dart";
import "package:event_app/utils.dart";
import "package:http/http.dart";
import "package:latlong2/latlong.dart";
import "package:geolocator/geolocator.dart";

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

class NominatimClient {
  static Future<LatLng> locationFromString(String location) async {
    try {
      final res = await get(Uri.parse(
        "https://nominatim.openstreetmap.org/search?q=$location&format=json",
      ));
      final json = res.json()[0];
      return LatLng(double.parse(json["lat"]), double.parse(json["lon"]));
    } on Exception {
      throw const ApplicationException(message: "cos zle");
    }
  }
}
