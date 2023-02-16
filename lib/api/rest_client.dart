import "dart:convert";
import "dart:io";
import "package:event_app/api/exceptions.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:event_app/api/json.dart";
import "package:event_app/main.dart";
import "package:event_app/utils.dart";
import "package:http/http.dart" as http;

RestClient _rest = RestClient();
RestClient get rest => _rest;

void overrideRestClient(RestClient value) {
  _rest = value;
}

class RestClient {
  final _http = http.Client();

  Future<JsonObject> post(List<dynamic> path, [JsonObject body = const {}]) =>
      makeRequest("POST", path, body);

  Future<JsonObject> get(List<dynamic> path) => makeRequest("GET", path);

  Future<JsonObject> delete(List<dynamic> path, [JsonObject body = const {}]) =>
      makeRequest("DELETE", path, body);

  Future<JsonObject> makeRequest(
    String method,
    List<dynamic> path, [
    JsonObject? body,
  ]) async {
    final baseUrl = dotenv.get("API_URL");

    final request =
        http.Request(method, Uri.parse("$baseUrl/${path.join("/")}"));
    request.headers.addAll(_headers);
    request.body = jsonEncode(body);

    final res = await _http.send(request);
    try {
      return await res.json();
    } on Unauthorized {
      App.authState.deleteUserToken();
      rethrow;
    }
  }

  Map<String, String> get _headers => {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.acceptHeader: "application/json",
        if (App.authState.loggedIn)
          HttpHeaders.authorizationHeader: "Bearer ${App.authState.userToken}"
      };
}
