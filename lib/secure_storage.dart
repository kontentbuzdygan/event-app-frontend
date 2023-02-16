import "package:flutter_secure_storage/flutter_secure_storage.dart";

FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
FlutterSecureStorage get secureStorage => _secureStorage;

void overrideSecureStorage(FlutterSecureStorage secureStorage) {
  _secureStorage = secureStorage;
}
