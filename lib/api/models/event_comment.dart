import "dart:math";

import "package:event_app/api/json.dart";
import "package:event_app/api/models/profile.dart";

final _random = Random();
final _comments = [
  "siema",
  "fajny ten event app",
  "będę z ciocią",
  "ekstraśnie 😃",
  "kiedy połowinki?",
  "o północy otwieramy szampona",
  "gdzie wf?",
  "HOKEJ MAMY JAK COŚ",
  "przekładamy polski?",
  "gdzie wyniki z egzaminu sprawdzić xD",
  "Natalię jakiś koń goni"
];

class EventComment {
  final int id, authorId;
  final String content;
  final DateTime createdAt;

  Profile? author;

  EventComment._({
    required this.id,
    required this.authorId,
    required this.content,
    required this.createdAt,
  });

  factory EventComment.fromJson(JsonObject json) => EventComment._(
        id: json["id"],
        authorId: json["author_id"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Future<EventComment> fetchAuthor() async {
    author = await Profile.find(authorId);
    return this;
  }
}

Future<List<EventComment>> findEventComments(int eventId) async {
  return List.generate(
      2 + _random.nextInt(5),
      (i) => EventComment._(
          id: i,
          authorId: 19 + i,
          content: _comments[_random.nextInt(_comments.length)],
          createdAt: DateTime(2024, 6, 14 + i)));
  // return EventComment.fromJson(await rest.get([_apiPath, id]));
}
