import "package:event_app/api/json.dart";

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
}
