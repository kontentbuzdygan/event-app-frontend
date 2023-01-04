import "dart:convert";
import "dart:io";
import "package:event_app/api/exceptions.dart";
import "package:event_app/config.dart";
import "package:event_app/api/json.dart";
import "package:event_app/main.dart";
import "package:http/http.dart" as http;

class RestClient {
  static Future<JsonObject> post(List<dynamic> path, JsonObject body) async {
    final res = await http.post(
      Uri.parse("$baseUri/${path.join("/")}"),
      headers: _headers(),
      body: jsonEncode(body),
    );

    if (res.statusCode == HttpStatus.created) {
      return jsonDecode(res.body);
    }

    throw InvalidResponseStatus.of(res.statusCode);
  }

  static Future<JsonObject> get(List<dynamic> path) async {
    final res = await http.get(
      Uri.parse("$baseUri/${path.join("/")}"),
      headers: _headers(),
    );

    if (res.statusCode == HttpStatus.ok) {
      return jsonDecode(res.body);
    }

    throw InvalidResponseStatus.of(res.statusCode);
  }

  static Map<String, String> _headers() => {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.acceptHeader: "application/json",
        if (App.authState.loggedIn)
          HttpHeaders.authorizationHeader: "Bearer ${App.authState.userToken}"
      };
}
