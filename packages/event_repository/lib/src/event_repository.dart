import "package:event_repository/src/models/event.dart";
import "package:event_repository/src/models/new_event.dart";
import "package:rest_client/rest_client.dart";

const _apiPath = "events";

class EventRepository {
  final RestClient _restClient;

  EventRepository({required RestClient restClient}) 
    : _restClient = restClient;

  Future<Event> find(int id) async {
    return Event.fromJson(await _restClient.get([_apiPath, id]));
  }

  Future<List<Event>> findAll() async {
    final json = await _restClient.get([_apiPath]);
    return (json["events"] as Iterable<dynamic>)
        .cast<JsonObject>()
        .map(Event.fromJson)
        .toList();
  }

  Future<Event> save(NewEvent event) async {
    final createdJson = await _restClient.post([_apiPath], event.toJson());
    return Event.fromJson(createdJson);
  }
}