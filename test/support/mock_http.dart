import "package:http/http.dart" as http;

class MockHttp extends http.BaseClient {
  final Future<String> Function(http.BaseRequest) _callback;

  MockHttp(this._callback);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = await _callback(request);
    return http.StreamedResponse(Stream.value(body.codeUnits), 200);
  }
}
