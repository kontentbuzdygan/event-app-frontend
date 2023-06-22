import "package:api_client/api_client.dart";
import "package:api_client/exceptions.dart";
import "package:api_client/json.dart";
import "package:user_repository/src/models/models.dart";
import "package:user_repository/src/models/new_profile.dart";

const String _apiPath = "profiles";

class ProfileRepository {
  Future<void> update(NewProfile profile) async {
    await rest.patch([_apiPath, "me"], profile.toJson());
  }

  Future<Profile> find(int id) async {
    return Profile.fromJson(await rest.get([_apiPath, id]));
  }

  Future<List<Profile>> search(String name) async {
    JsonObject json;

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

  Future<Profile> me() async {
    return Profile.fromJson(await rest.get([_apiPath, "me"]));
  }
}
