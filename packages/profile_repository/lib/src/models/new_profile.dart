
import "package:json_annotation/json_annotation.dart";
import "package:rest_client/rest_client.dart";

part "new_profile.g.dart";

@JsonSerializable()
class NewProfile {
  const NewProfile({required this.displayName, this.bio});

  final String? displayName;
  final String? bio;

  JsonObject toJson() => _$NewProfileToJson(this);
}
