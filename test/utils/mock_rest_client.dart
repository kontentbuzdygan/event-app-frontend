import "package:event_app/api/json.dart";
import "package:event_app/api/rest_client.dart";

class MockRestClient extends RestClient {
  final List<RequestMock> _requestMocks = [];

  void add(RequestMock mock) {
    _requestMocks.add(mock);
  }

  @override
  Future<JsonObject> get(List<dynamic> path) {
    return Future.value(_performRequest("GET", path, {}));
  }

  @override
  Future<JsonObject> post(
    List<dynamic> path, [
    JsonObject body = const {},
  ]) {
    return Future.value(_performRequest("POST", path, body));
  }

  @override
  Future<JsonObject> delete(
    List<dynamic> path, [
    JsonObject body = const {},
  ]) {
    return Future.value(_performRequest("DELETE", path, body));
  }

  JsonObject _performRequest(
      String method, List<dynamic> path, JsonObject body) {
    final mock =
        _requestMocks.firstWhere((element) => element.matches(method, path));
    return mock.response(body);
  }
}

class RequestMock {
  final String method;
  final List<dynamic> path;
  final JsonObject Function(JsonObject requestBody) response;

  const RequestMock(this.method, this.path, this.response);

  bool matches(String method, List<dynamic> path) =>
      method.toLowerCase() == this.method.toLowerCase() &&
      path.join("/") == this.path.join("/");
}
