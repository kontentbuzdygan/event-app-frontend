import "package:event_app/api/json.dart";
import "package:event_app/api/models/event_comment.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/api/rest_client.dart";

const String _apiPath = "events";

class Event {
  final int id, authorId;
  final String title, description;
  final DateTime startsAt;
  final DateTime? endsAt;

  Profile? author;
  List? comments;

  Event._({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.startsAt,
    this.endsAt,
  });

  factory Event.fromJson(JsonObject json) => Event._(
        id: json["id"],
        authorId: json["author_id"],
        title: json["title"],
        description: json["description"],
        startsAt: DateTime.parse(json["starts_at"]),
        endsAt:
            json["ends_at"] != null ? DateTime.parse(json["ends_at"]) : null,
      );

  static Future<Event> find(int id) async {
    return Event.fromJson(await rest.get([_apiPath, id]));
  }

  /// NOTE: It's important to collect the returned iterable, for example by
  /// calling `toList()`, if you want to use mutating methods like `fetchAuthor()`.
  /// Otherwise the actual `Event` objects yielded from the iterable will be regenerated
  /// on every iteration due to laziness, and so their non-serialized state will
  /// not be persisted.
  static Future<Iterable<Event>> findAll({int page = 0}) async {
    final json = await rest.get([_apiPath, "?page=$page"]);
    return (json["events"] as Iterable<dynamic>)
        .cast<JsonObject>()
        .map(Event.fromJson);
  }

  Future<Event> fetchAuthor() async {
    author = await Profile.find(authorId);
    return this;
  }

  Future<Event> fetchComments() async {
    comments = await findEventComments(id);
    return this;
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
    final createdJson = await rest.post([_apiPath], toJson());
    return Event.fromJson(createdJson);
  }
}
