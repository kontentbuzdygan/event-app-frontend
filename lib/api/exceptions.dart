abstract class ApiException implements Exception {
  final String message;

  const ApiException({required this.message});

  @override
  String toString() => message;
}

class InvalidResponseStatus extends ApiException {
  final int code;

  const InvalidResponseStatus({required this.code, String? message})
      : super(message: message ?? "Invalid response status");

  factory InvalidResponseStatus.of(int code) {
    if (code == 401) return const Unauthorized();
    if (code == 409) return const AlreadyExists();
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
