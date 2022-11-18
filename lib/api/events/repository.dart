import "package:flutter/material.dart";
import "package:event_app/api/events/model.dart";
import "package:event_app/api/json.dart";
import "package:event_app/api/repository.dart";
import "package:event_app/api/rest_client.dart";

class EventRepository extends ChangeNotifier implements Repository {
  static const String _path = "events";

  Future<Event> create(NewEvent newEvent) async {
    final createdJson = await RestClient.post(_path, newEvent.toJson());
    notifyListeners();
    return Event.fromJson(createdJson);
  }

  Future<Iterable<Event>> findAll() async {
    try {
      // TODO: Fix the backend to return an object with `events` instead of a raw array
      final json = List<JsonObject>.from(await RestClient.get(_path));
      return json.map(Event.fromJson);
    } catch (e) {
      return Future.error(e);
    }
  }
}
