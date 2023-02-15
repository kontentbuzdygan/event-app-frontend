import "dart:convert";
import "dart:io";
import "package:event_app/config.dart";
import "package:event_app/api/json.dart";
import "package:event_app/main.dart";
import "package:event_app/utils.dart";
import "package:http/http.dart" as http;

class RestClient {
  static Future<JsonObject> post(List<dynamic> path, [JsonObject body = const {}]) async {
    final res = await http.post(
      Uri.parse("$baseUri/${path.join("/")}"),
      headers: _headers(),
      body: jsonEncode(body),
    );

    return res.json();
  }

  static Future<JsonObject> get(List<dynamic> path) async {
    final res = await http.get(
      Uri.parse("$baseUri/${path.join("/")}"),
      headers: _headers(),
    );

    return res.json();
  }

  static Future<JsonObject> delete(List<dynamic> path, [JsonObject body = const {}]) async {
    final res = await http.delete(
      Uri.parse("$baseUri/${path.join("/")}"),
      headers: _headers(),
      body: jsonEncode(body),
    );

    return res.json();
  }

  static Map<String, String> _headers() => {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.acceptHeader: "application/json",
        if (App.authState.loggedIn)
          HttpHeaders.authorizationHeader: "Bearer ${App.authState.userToken}"
      };
}
