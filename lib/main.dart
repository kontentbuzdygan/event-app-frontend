import "package:event_app/app.dart";
import "package:event_app/app_bloc_observer.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

void main() async {
  await dotenv.load();

  Bloc.observer = AppBlocObserver();

  runApp(const App());
}
