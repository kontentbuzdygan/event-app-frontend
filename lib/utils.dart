import "dart:convert";

import "package:event_app/api/exceptions.dart";
import "package:http/http.dart";

extension StatusClasses on Response {
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
