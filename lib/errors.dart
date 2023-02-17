import "package:flutter/foundation.dart";

void registerAppErrorHandler(ErrorNotifier errorNotifier) {
  FlutterError.onError = (error) {
    if (error.exception is ApplicationException) {
      errorNotifier.error = error.exception as Exception;
    } else {
      throw error;
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (error is ApplicationException) {
      errorNotifier.error = error;
      return true;
    }

    return false;
  };
}

class ApplicationException implements Exception {
  final String message;

  const ApplicationException({required this.message});

  @override
  String toString() => message;
}

class ErrorNotifier extends ChangeNotifier {
  Exception? _error;

  set error(Exception error) {
    _error = error;
    notifyListeners();
  }

  Exception? consumeError() {
    final error = _error;
    _error = null;
    return error;
  }
}
