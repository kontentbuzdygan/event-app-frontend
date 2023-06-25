import "package:json_annotation/json_annotation.dart";
import "package:rest_client/rest_client.dart";

part "event.g.dart";

@JsonSerializable(constructor: "_", createToJson: false)
class Event {
  final int id;
  final String title, description;
  final DateTime startsAt;
  final DateTime? endsAt;
  final int commentCount;
  // final Profile author;
  
  Event._({
    required this.id,
    // required this.author,
    required this.title,
    required this.description,
    required this.commentCount,
    required this.startsAt,
    this.endsAt,
  });

  factory Event.fromJson(JsonObject json) => _$EventFromJson(json);
}
