import "dart:async";
import "dart:convert";
import "dart:developer";
import "dart:io";
import "package:event_app/api/exceptions.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:event_app/api/json.dart";
import "package:event_app/utils.dart";
import "package:http/http.dart" as http;

const _logSourceName = "event_app/api/rest_client";

RestClient _rest = RestClient();
RestClient get rest => _rest;

void overrideRestClient(RestClient value) {
  _rest = value;
}

typedef Cache = Map<String, Completer<JsonObject>>;

class RestClient {
  /// Runs the given callback while caching all GET requests made by any RestClient
  /// instance. Meant to be used in the scope of a single view or widget, where
  /// you might perform many requests to the same endpoint within a short period
  /// of time.
  ///
  /// The same cache is inherited by nested calls to this function.
  static R runCached<R>(R Function() body) {
    final Cache cache = Zone.current[#_restClientCache] ?? {};
    return runZoned(body, zoneValues: {#_restClientCache: cache});
  }

  Future<JsonObject> get(dynamic pathOrParts) {
    final path =
        pathOrParts is List ? joinPath(pathOrParts) : pathOrParts.toString();
    return _runCached("GET $path", () => request("GET", path));
  }

  Future<JsonObject> post(dynamic pathOrParts, [JsonObject body = const {}]) =>
      request("POST", pathOrParts, body);

  Future<JsonObject> patch(dynamic pathOrParts, [JsonObject body = const {}]) =>
      request("PATCH", pathOrParts, body);

  Future<JsonObject> delete(
    dynamic pathOrParts, [
    JsonObject body = const {},
  ]) =>
      request("DELETE", pathOrParts, body);

  Future<JsonObject> request(
    String method,
    dynamic pathOrParts, [
    JsonObject? body,
  ]) async {
    final path =
        pathOrParts is List ? joinPath(pathOrParts) : pathOrParts.toString();

    final baseUrl = dotenv.get("API_URL");
    final uri = Uri.parse("$baseUrl/$path");

    final request = http.Request(method, uri);
    request.headers.addAll(_headers);
    request.body = jsonEncode(body);

    log("$method $uri", name: _logSourceName);
    final response = await http.Client().send(request);

    try {
      return await response.json();
    } on Unauthorized {
      // App.authState.deleteUserToken();
      rethrow;
    }
  }

  Future<JsonObject> _runCached(
    String endpoint,
    Future<JsonObject> Function() body,
  ) async {
    final Cache? cache = Zone.current[#_restClientCache];

    if (cache == null) return await body();

    if (cache.containsKey(endpoint)) {
      final message = cache[endpoint]!.isCompleted
          ? "cache hit"
          : "cache hit (already running)";
      log("$message: $endpoint", name: _logSourceName);

      return await cache[endpoint]!.future;
    }

    return await (cache[endpoint] = wrapInCompleter(body())).future;
  }

  Map<String, String> get _headers => {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.acceptHeader: "application/json",
        // if (App.authState.loggedIn)
        //   HttpHeaders.authorizationHeader: "Bearer ${App.authState.userToken}"
      };
}
