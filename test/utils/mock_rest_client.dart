import "package:event_app/api/json.dart";
import "package:event_app/api/rest_client.dart";
import "package:event_app/utils.dart";

/// Used to test interactions with the [RestClient]
///
/// ### Example
/// ```
/// final restMock = MockRestClient();
/// overrideRestClient(restMock);
/// final mockedEndpoint = restMock.mock(...);
///
/// // make some requests using the global `rest` client
///
/// expect(mockedEndpoint, hasBeenCalled);
/// ```
class MockRestClient extends RestClient {
  final List<RestMock> _mocks = [];

  RestMock mock(String method, List<dynamic> path, RestMockCallback callback) {
    final mock = RestMock._(method, path, callback);
    _mocks.add(mock);
    return mock;
  }

  @override
  Future<JsonObject> makeRequest(
    String method,
    List<dynamic> path, [
    JsonObject? body,
  ]) {
    final mock = _mocks.firstWhere((mock) => mock.matches(method, path));
    return Future.value(mock.call(body));
  }
}

typedef RestMockCallback = JsonObject Function(JsonObject? requestBody);

class RestMock {
  final String _method;
  final List<dynamic> _path;
  final JsonObject Function(JsonObject? requestBody) _callback;
  final List<MockedRequest> _requests = [];

  RestMock._(this._method, this._path, this._callback);

  bool matches(String method, List<dynamic> path) =>
      method.toLowerCase() == _method.toLowerCase() &&
      joinUrl(path) == joinUrl(_path);

  JsonObject call(JsonObject? requestBody) {
    final responseBody = _callback(requestBody);
    _requests.add(MockedRequest._(requestBody, responseBody));
    return responseBody;
  }

  @override
  String toString() {
    final url = joinUrl(_path);
    return "RestMock $_method $url";
  }
}

class MockedRequest {
  final JsonObject? body;
  final JsonObject response;

  MockedRequest._(this.body, this.response);
}
