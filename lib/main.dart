


import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:rest_client/rest_client.dart";
import "package:event_app/app.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

final restClient = RestClient();
const storage = FlutterSecureStorage();

void main() async {
  await dotenv.load();
  runApp(const App());
}
