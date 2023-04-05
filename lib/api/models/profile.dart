import "package:event_app/api/json.dart";
import "package:event_app/api/rest_client.dart";

const String _apiPath = "profiles";

class Profile {
  final int id;
  String displayName;
  String? bio;

  Profile._({
    required this.id,
    required this.displayName,
    this.bio,
  });

  factory Profile.fromJson(JsonObject json) => Profile._(
        id: json["id"],
        displayName: json["display_name"],
        bio: json["bio"],
      );

  JsonObject toJson() => {
        "display_name": displayName,
        "bio": bio,
      };

  Future<void> update() async {
    await rest.patch([_apiPath, "me"], toJson());
  }

  static Future<Profile> find(int id) async {
    return Profile.fromJson(await rest.get([_apiPath, id]));
  }

  static Future<Iterable<Profile>> search(String name) async {
    final json = await rest.get([_apiPath, "?name=$name"]);
    return (json["profiles"] as Iterable<dynamic>)
        .cast<JsonObject>()
        .map(Profile.fromJson);
  }

  static Future<Profile> me() async {
    return Profile.fromJson(await rest.get([_apiPath, "me"]));
  }
}
