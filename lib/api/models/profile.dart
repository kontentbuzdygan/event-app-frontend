import "package:event_app/api/json.dart";
import "package:event_app/api/rest_client.dart";

const String _apiPath = "profiles";

class Profile {
  final int id;
  final String displayName;
  final String? bio;

  const Profile._({
    required this.id,
    required this.displayName,
    this.bio,
  });

  factory Profile.fromJson(JsonObject json) => Profile._(
        id: json["id"],
        displayName: json["display_name"],
        bio: json["bio"],
      );

  static Future<Profile> find(int id) async {
    return Profile.fromJson(await rest.get([_apiPath, id]));
  }

  static Future<Profile> me() async {
    return Profile.fromJson(await rest.get([_apiPath, "me"]));
  }
}
