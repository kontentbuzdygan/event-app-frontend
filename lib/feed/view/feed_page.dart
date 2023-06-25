import "package:auto_route/auto_route.dart";
import "package:event_app/feed/bloc/feed_bloc.dart";
import "package:event_app/feed/view/feed_view.dart";
import "package:event_repository/event_repository.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

@RoutePage()
class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedBloc(eventRepository: context.read<EventRepository>()),
      child: const FeedView(),
    );
  }
}
