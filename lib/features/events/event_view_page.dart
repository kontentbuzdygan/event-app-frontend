import "package:auto_route/auto_route.dart";
import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import "event_view/event_view.dart";

@RoutePage()
class EventViewPage extends StatefulWidget {
  const EventViewPage({
    super.key, 
    @pathParam required this.id, 
    this.event
  });

  final int id;
  final Event? event;

  @override
  State<EventViewPage> createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {
  late final Future<Event> event;
  late bool hasBanner;

  @override
  void initState() {
    super.initState();
    event = Event.find(widget.id).then((event) => event.fetchAuthor());
    hasBanner = widget.event == null ? true : widget.event!.banner != null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder(
      future: event,
      builder: (builder, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(l10n.eventNotFound));
        }

        final elo =
            hasBanner && !snapshot.hasData || snapshot.data?.banner != null;

        return Scaffold(
          extendBodyBehindAppBar: elo,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: !elo ? Text(snapshot.requireData.title) : null,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            label: Text(
              "Attend",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            icon: const Icon(Icons.back_hand_outlined),
          ),
          body:
              EventView(event: snapshot.hasData ? snapshot.data : widget.event),
        );
      },
    );
  }
}
