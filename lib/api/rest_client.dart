import "dart:convert";
import "dart:io";
import "package:event_app/api/exceptions.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:event_app/api/json.dart";
import "package:event_app/main.dart";
import "package:event_app/utils.dart";
import "package:http/http.dart" as http;

class RestClient {
  static Future<JsonObject> post(List<dynamic> path, [JsonObject body = const {}]) async {
    final baseUrl = dotenv.get("API_URL");
    final res = await http.post(
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

  static Future<JsonObject> get(List<dynamic> path) async {
    final baseUrl = dotenv.get("API_URL");
    final res = await http.get(
      Uri.parse("$baseUrl/${path.join("/")}"),
      headers: _headers(),
    );

    try {
      return res.json();
    } on Unauthorized {
      App.authState.deleteUserToken();
      rethrow;
    }
  }

  static Future<JsonObject> delete(List<dynamic> path, [JsonObject body = const {}]) async {
    final baseUrl = dotenv.get("API_URL");
    final res = await http.delete(
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

  static Map<String, String> _headers() => {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.acceptHeader: "application/json",
        if (App.authState.loggedIn)
          HttpHeaders.authorizationHeader: "Bearer ${App.authState.userToken}"
      };
}
