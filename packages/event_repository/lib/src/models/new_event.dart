import "package:json_annotation/json_annotation.dart";
import "package:rest_client/rest_client.dart";

part "new_event.g.dart";

@JsonSerializable()
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

  JsonObject toJson() => _$NewEventToJson(this);
}