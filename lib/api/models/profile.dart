import "package:event_app/api/exceptions.dart";
import "package:event_app/api/json.dart";
import "package:event_app/api/rest_client.dart";
import "package:event_app/utils.dart";
import "package:unsplash_client/unsplash_client.dart";
import 'package:username_gen/username_gen.dart';

const String _apiPath = "profiles";

class Profile {
  final int id;
  String displayName;
  String? bio;
  PhotoUrls? profilePicture;

  Profile._(
      {required this.id,
      required this.displayName,
      this.bio,
      this.profilePicture});

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

  static Future<List<Profile>> search(String name) async {
    var json;

    try {
      json = await rest.get([_apiPath, "?name=$name"]);
    } on NotFound {
      return [];
    }

    return (json["profiles"] as Iterable<dynamic>)
        .cast<JsonObject>()
        .map(Profile.fromJson)
        .toList();
  }

  static Future<Profile> me() async {
    return Profile.fromJson(await rest.get([_apiPath, "me"]));
  }
}

Future<Profile> randomProfile(int id) async {
  return Future.value(Profile._(
      id: id,
      displayName: UsernameGen().generate(),
      profilePicture: await fetchMockImage("face")));
}
