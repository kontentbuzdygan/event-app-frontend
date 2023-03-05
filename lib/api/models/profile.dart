import "package:event_app/api/json.dart";
import "package:event_app/api/rest_client.dart";

const String _apiPath = "profiles";

class Profile {
  final int id;
  final String displayName;
  final String? avatar;
  final String? bio;

  const Profile._({
    required this.id,
    required this.displayName,
    required this.avatar,
    this.bio,
  });

  factory Profile.fromJson(JsonObject json) => Profile._(
        id: json["id"],
        avatar: json["avatar"],
        displayName: json["display_name"],
        bio: json["bio"],
      );

  static Future<Profile> find(int id) async {
    return Profile.fromJson(await rest.get([_apiPath, id]));
  }
}
