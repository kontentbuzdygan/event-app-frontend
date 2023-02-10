import "package:event_app/api/json.dart";
import "package:event_app/api/rest_client.dart";

const String _apiPath = "events";

class Event {
  final int id, authorId;
  final String title, description;
  final DateTime startsAt;
  final DateTime? endsAt;

  const Event({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.startsAt,
    this.endsAt,
  });

  factory Event.fromJson(JsonObject json) => Event(
        id: json["id"],
        authorId: json["author_id"],
        title: json["title"],
        description: json["description"],
        startsAt: DateTime.parse(json["starts_at"]),
        endsAt:
            json["ends_at"] != null ? DateTime.parse(json["ends_at"]) : null,
      );

  static Future<Event> find(String id) async {
    try {
      return Event.fromJson(await RestClient.get([_apiPath, id]));
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Iterable<Event>> findAll() async {
    try {
      final json = await RestClient.get([_apiPath]);
      return (json["events"] as Iterable<dynamic>)
          .cast<JsonObject>()
          .map(Event.fromJson);
    } catch (e) {
      return Future.error(e);
    }
  }
}

class NewEvent {
  String title, description;
  DateTime startsAt;
  DateTime? endsAt;

  NewEvent({
    required this.title,
    required this.description,
    required this.startsAt,
    this.endsAt,
  });

  JsonObject toJson() => {
        "title": title,
        "description": description,
        "starts_at": startsAt.toUtc().toIso8601String(),
        "ends_at": endsAt?.toUtc().toIso8601String(),
      };

  Future<Event> save() async {
    final createdJson = await RestClient.post([_apiPath], toJson());
    return Event.fromJson(createdJson);
  }
}
