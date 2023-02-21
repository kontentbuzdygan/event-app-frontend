import "package:event_app/api/json.dart";
import "package:event_app/api/rest_client.dart";

const String _apiPath = "profiles";

class Profile {
  final int id;
  final String displayName;
  final String? bio;


  const Profile({
    required this.id,
    required this.displayName,
    this.bio,
  });

  factory Profile.fromJson(JsonObject json) => Profile(
        id: json["id"],
        displayName: json["display_name"],
        bio: json["bio"],
      );

  static Future<Profile> find(int id) async {
    return Profile.fromJson(await RestClient.get([_apiPath, id]));
  }
}

class NewProfile {
  String displayName;
  String? bio;

  NewProfile({
    required this.displayName,
    this.bio,
  });

  JsonObject toJson() => {
        "bio": bio,
        "display_name": displayName,
      };

  Future<Profile> save() async {
    final createdJson = await RestClient.patch([_apiPath], toJson());
    return Profile.fromJson(createdJson);
  }
}
