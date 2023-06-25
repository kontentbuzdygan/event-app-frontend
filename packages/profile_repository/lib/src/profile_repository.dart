import "package:profile_repository/src/models/models.dart";
import "package:rest_client/rest_client.dart";

const String _apiPath = "profiles";

class ProfileRepository {
  final RestClient _restClient;

  ProfileRepository({ required RestClient restClient })  
    : _restClient = restClient;

  Future<void> update(NewProfile profile) async {
    await _restClient.patch([_apiPath, "me"], profile.toJson());
  }

  Future<Profile> find(int id) async {
    return Profile.fromJson(await _restClient.get([_apiPath, id]));
  }

  Future<List<Profile>> search(String name) async {
    JsonObject json;

    try {
      json = await _restClient.get([_apiPath, "?name=$name"]);
    } on NotFound {
      return [];
    }

    return (json["profiles"] as Iterable<dynamic>)
        .cast<JsonObject>()
        .map(Profile.fromJson)
        .toList();
  }

  Future<Profile> me() async {
    return Profile.fromJson(await _restClient.get([_apiPath, "me"]));
  }
}
