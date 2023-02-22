import "dart:convert";

import "package:event_app/api/exceptions.dart";
import "package:http/http.dart";

/// Converts the given elements to strings and joins them with slashes, ensuring
/// there is no consecutive or leading/trailing slashes
String joinPath(List<dynamic> parts) =>
  parts
    .expand((part) => part
      .toString()
      .split("/")
      .where((innerPart) => innerPart.isNotEmpty))
    .join("/");

extension StatusClasses on BaseResponse {
  /// True for 2xx status codes
  bool get isSuccess => 200 <= statusCode && statusCode < 300;
}

extension JsonDecodeBody on Response {
  /// Calls [jsonDecode] on the request body if the status code is `2xx`, otherwise
  /// throws [InvalidResponseStatus]
  dynamic json() {
    if (isSuccess) return jsonDecode(body);
    throw InvalidResponseStatus.of(statusCode);
  }
}

extension JsonDecodeBodyStreamed on StreamedResponse {
  /// Calls [jsonDecode] on the request body if the status code is `2xx`, otherwise
  /// throws [InvalidResponseStatus]
  Future<dynamic> json() async {
    if (isSuccess) return jsonDecode(await stream.bytesToString());
    throw InvalidResponseStatus.of(statusCode);
  }
}
