import "package:event_app/api/events/event.dart";
import "package:event_app/api/json.dart";
import "package:event_app/api/repository.dart";
import "package:event_app/api/rest_client.dart";

class EventRepository extends Repository<Event> {
  @override
  final Duration cacheExpiresIn = const Duration(minutes: 1);
  static const String _path = "events";

  Future<Event> create(NewEvent newEvent) async {
    final createdJson = await RestClient.post([_path], newEvent.toJson());
    return cache(Event.fromJson(createdJson));
  }

  Future<Event> find(int id) async {
    try {
      return await fetchCached(
          id, () async => Event.fromJson(await RestClient.get([_path, id])));
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Iterable<Event>> findAll() async {
    try {
      return await fetchAllCached(() async {
        final json = await RestClient.get([_path]);
        return (json["events"] as Iterable<dynamic>)
            .cast<JsonObject>()
            .map(Event.fromJson);
      });
    } catch (e) {
      return Future.error(e);
    }
  }
}
