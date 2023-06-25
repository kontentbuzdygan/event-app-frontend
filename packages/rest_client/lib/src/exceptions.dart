
class ApplicationException implements Exception {
  final String message;

  const ApplicationException({required this.message});

  @override
  String toString() => message;
}

abstract class ApiException extends ApplicationException {
  const ApiException({required super.message});
}

class InvalidResponseStatus extends ApiException {
  final int code;

  const InvalidResponseStatus({required this.code, String? message})
      : super(message: message ?? "Invalid response status");

  factory InvalidResponseStatus.of(int code) {
    if (code == 401) return const Unauthorized();
    if (code == 409) return const AlreadyExists();
    if (code == 404) return const NotFound();
    return InvalidResponseStatus(code: code);
  }
}

class Unauthorized extends InvalidResponseStatus {
  const Unauthorized({String? message})
      : super(code: 401, message: message ?? "Invalid token or credentials");
}

class AlreadyExists extends InvalidResponseStatus {
  const AlreadyExists({String? message})
      : super(code: 409, message: message ?? "Record already exists");
}

class NotFound extends InvalidResponseStatus {
  const NotFound({String? message})
      : super(code: 404, message: message ?? "Resource not found");
}
