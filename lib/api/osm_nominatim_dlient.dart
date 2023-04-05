import "package:event_app/errors.dart";
import "package:event_app/utils.dart";
import "package:http/http.dart";
import "package:latlong2/latlong.dart";

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

// https://nominatim.openstreetmap.org/search?q=${location}&format=json