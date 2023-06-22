import "package:equatable/equatable.dart";
import "package:json_annotation/json_annotation.dart";
import "package:rest_client/rest_client.dart";

part "profile.g.dart";

@JsonSerializable(createToJson: false)
class Profile extends Equatable {
  const Profile({required this.id, required this.displayName, this.bio});

  final int id;
  final String displayName;
  final String? bio;

  factory Profile.fromJson(JsonObject json) => _$ProfileFromJson(json);

  @override
  List<Object> get props => [id, displayName];
}
