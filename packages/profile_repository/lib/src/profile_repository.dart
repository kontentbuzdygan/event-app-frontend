import "package:profile_repository/src/models/models.dart";
import "package:rest_client/rest_client.dart";

const String _apiPath = "profiles";

class ProfileRepository {
  Future<void> update(NewProfile profile) async {
    await restClient.patch([_apiPath, "me"], profile.toJson());
  }

  Future<Profile> find(int id) async {
    return Profile.fromJson(await restClient.get([_apiPath, id]));
  }

  Future<List<Profile>> search(String name) async {
    JsonObject json;

    try {
      json = await restClient.get([_apiPath, "?name=$name"]);
    } on NotFound {
      return [];
    }

    return (json["profiles"] as Iterable<dynamic>)
        .cast<JsonObject>()
        .map(Profile.fromJson)
        .toList();
  }

  Future<Profile> me() async {
    return Profile.fromJson(await restClient.get([_apiPath, "me"]));
  }
}
