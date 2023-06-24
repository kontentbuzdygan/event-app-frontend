import "package:event_app/app.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

void main() async {
  await dotenv.load();
  runApp(const App());
}
