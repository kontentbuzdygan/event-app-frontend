import "dart:math";
import "package:event_app/api/json.dart";

final _random = Random();
final _tags = [
  "😎 siema",
  "🍀 dealerka",
  "💰 pranie pieniędzy",
  "👔 biznes",
  "🏡 domówka"
];

class EventTag {
  final int id;
  final String content;

  EventTag._({
    required this.id,
    required this.content,
  });

  factory EventTag.fromJson(JsonObject json) =>
      EventTag._(id: json["id"], content: json["content"]);
}

Future<List<EventTag>> findEventTags(int eventId) async {
  return List.generate(
    _random.nextInt(5) + 1,
    (i) => EventTag._(
      id: i,
      content: _tags[i],
    ),
  );
}
