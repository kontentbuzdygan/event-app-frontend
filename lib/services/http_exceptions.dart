class NoInternet implements Exception {
  @override
  String toString() {
    return "No internet connection";
  }
}

class InvalidCredentials implements Exception {
  String? message;

  InvalidCredentials({this.message});

  @override
  String toString() {
    return message ?? "Invalid credentials";
  }
}

class UnexpectedException implements Exception {
  @override
  String toString() {
    return "Unexpected exception";
  }
}
