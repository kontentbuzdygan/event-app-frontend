import "dart:math";

import "package:event_app/api/json.dart";
import "package:event_app/api/models/event_comment.dart";
import "package:event_app/api/models/event_tag.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/api/rest_client.dart";
import "package:latlong2/latlong.dart";
import "package:event_app/utils.dart";
import "package:unsplash_client/unsplash_client.dart";

const String _apiPath = "events";
final _random = Random();

class Event {
  final int id, authorId;
  final String title, description;
  final DateTime startsAt;
  final DateTime? endsAt;
  final LatLng location;
  final int commentCount;

  Profile? author;
  List? comments;
  PhotoUrls? banner;
  List? tags;

  Event._({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.startsAt,
    required this.location,
    this.endsAt,
    required this.commentCount,
  });

  factory Event.fromJson(JsonObject json) => Event._(
        id: json["id"],
        authorId: json["author_id"],
        title: json["title"],
        description: json["description"],
        startsAt: DateTime.parse(json["starts_at"]),
        // TODO: parse from json
        location: LatLng(
          50 + _random.nextDouble() * 4.5,
          16 + _random.nextDouble() * 6,
        ),
        endsAt:
            json["ends_at"] != null ? DateTime.parse(json["ends_at"]) : null,
        commentCount: 2 + _random.nextInt(5),
      );

  static Future<Event> find(int id) async {
    return Event.fromJson(await rest.get([_apiPath, id]));
  }

  /// NOTE: It's important to collect the returned iterable, for example by
  /// calling `toList()`, if you want to use mutating methods like `fetchAuthor()`.
  /// Otherwise the actual `Event` objects yielded from the iterable will be regenerated
  /// on every iteration due to laziness, and so their non-serialized state will
  /// not be persisted.
  static Future<Iterable<Event>> findAll() async {
    final json = await rest.get([_apiPath]);
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

  Future<Event> fetchBanner() async {
    banner = await fetchMockImage("party");
    return this;
  }

  Future<Event> fetchTags() async {
    tags = await findEventTags(id);
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
