import "dart:convert";
import "dart:io";
import "package:event_app/api/exceptions.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:event_app/api/json.dart";
import "package:event_app/main.dart";
import "package:event_app/utils.dart";
import "package:http/http.dart" as http;

typedef HttpMethod = Future<http.Response> Function (Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding});

class RestClient {

  static Future<http.Response> _get(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding})
    => http.get(url, headers: headers);

  static Future<JsonObject> _request(HttpMethod f, List<dynamic> path, [JsonObject body = const {}]) async {
    final baseUrl = dotenv.get("API_URL");

    final res = await f(
      Uri.parse("$baseUrl/${path.join("/")}"),
      headers: _headers(),
      body: jsonEncode(body),
    );

    try {
      return res.json();
    } on Unauthorized {
      App.authState.deleteUserToken();
      rethrow;
    }
  }

  static Future<JsonObject> get(List<dynamic> path, [JsonObject body = const {}])
    => _request(_get, path, body);

  static Future<JsonObject> post(List<dynamic> path, [JsonObject body = const {}])
    => _request(http.post, path, body);

  static Future<JsonObject> delete(List<dynamic> path, [JsonObject body = const {}])
    => _request(http.delete, path, body);

  static Future<JsonObject> patch(List<dynamic> path, [JsonObject body = const {}])
    => _request(http.patch, path, body);

  static Map<String, String> _headers() => {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.acceptHeader: "application/json",
        if (App.authState.loggedIn)
          HttpHeaders.authorizationHeader: "Bearer ${App.authState.userToken}"
      };
}
