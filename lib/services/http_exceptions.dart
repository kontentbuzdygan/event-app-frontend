class NoInternet implements Exception {
  @override
  String toString() {
    return "No internet connection";
  }
}

class InvalidCredentials implements Exception {
  @override
  String toString() {
    return "Invalid credentials";
  }
}

class UnexpectedException implements Exception {
  @override
  String toString() {
    return "Unexpected exception";
  }
}
