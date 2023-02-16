import "package:event_app/api/json.dart";
import "package:event_app/api/rest_client.dart";
import "package:event_app/utils.dart";
import "package:flutter_test/flutter_test.dart";

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
/// expect(mockedEndpoint, hasBeenCalled());
/// ```
class MockRestClient extends RestClient {
  final List<MockRestEndpoint> _mocks = [];

  MockRestEndpoint mock(String method, List<dynamic> path, MockRestEndpointCallback callback) {
    final mock = MockRestEndpoint._(method, path, callback);
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

typedef MockRestEndpointCallback = JsonObject Function(JsonObject? requestBody);

class MockRestEndpoint {
  final String _method;
  final List<dynamic> _path;
  final JsonObject Function(JsonObject? requestBody) _callback;
  final List<MockedRequest> _requests = [];

  MockedRequest? get lastRequest => _requests.isNotEmpty ? _requests.last : null;

  MockRestEndpoint._(this._method, this._path, this._callback);

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

/// A recorded mocked REST interaction
class MockedRequest {
  final JsonObject? body;
  final JsonObject response;

  MockedRequest._(this.body, this.response);
}

/// Tests whether a [MockRestEndpoint] has been called (optionally matches the
/// specific number of times it was called)
Matcher hasBeenCalled({int? times}) => _HasBeenCalledMatcher(times);

class _HasBeenCalledMatcher extends TypeMatcher<MockRestEndpoint> {
  final int? _times;

  _HasBeenCalledMatcher(this._times);

  @override
  bool matches(Object? item, Map matchState) =>
    super.matches(item, matchState) &&
    (_times == null
      ? (item as MockRestEndpoint)._requests.isNotEmpty
      : (item as MockRestEndpoint)._requests.length == _times);

  @override
  Description describe(Description description) {
    return super
      .describe(description)
      .add(" which has been called${_times != null ? " $_times times" : ""}");
  }

  @override
  Description describeMismatch(item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is MockRestEndpoint) {
      return mismatchDescription.add(
        item._requests.isEmpty
          ? "was never called"
          : "was called ${item._requests.length} times",
      );
    }

    return super.describeMismatch(item, mismatchDescription, matchState, verbose);
  }
}
