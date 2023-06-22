import "package:api_client/json.dart";
import "package:json_annotation/json_annotation.dart";

part "new_profile.g.dart";

@JsonSerializable()
class NewProfile {
  const NewProfile({required this.displayName, this.bio});

  final String? displayName;
  final String? bio;

  JsonObject toJson() => _$NewProfileToJson(this);
}
