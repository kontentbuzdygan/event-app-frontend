import "package:flutter/material.dart";
import "package:event_app/api/events/model.dart";
import "package:event_app/api/json.dart";
import "package:event_app/api/repository.dart";
import "package:event_app/api/rest_client.dart";

class EventRepository extends ChangeNotifier with Repository<Event> {
  @override
  final Duration cacheExpiresIn = const Duration(minutes: 1);
  static const String _path = "events";

  Future<Event> create(NewEvent newEvent) async {
    final createdJson = await RestClient.post([_path], newEvent.toJson());
    return cache(Event.fromJson(createdJson));
  }

  Future<Event> find(int id) async {
    try {
      return fetchCached(
          id, () async => Event.fromJson(await RestClient.get([_path, id])));
    } catch (e) {
      // We have to manually do this because throwing an error from a future isn't
      // the same as Future.error :(
      return Future.error(e);
    }
  }

  Future<Iterable<Event>> findAll() async {
    try {
      final ids = await fetchIdsCached(() async {
        final json = await RestClient.get([_path]);
        final events = (json["events"] as Iterable<dynamic>)
            .cast<JsonObject>()
            .map(Event.fromJson);

        return events.map((e) => cache(e).id).toList();
      });

      return Future.wait(ids.map(find));
    } catch (e) {
      return Future.error(e);
    }
  }
}
