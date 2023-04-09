import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "event_view/event_view.dart";

class EventViewScreen extends StatefulWidget {
  const EventViewScreen({super.key, required this.id, this.event});

  final int id;
  final Event? event;

  @override
  State<EventViewScreen> createState() => _EventViewScreenState();
}

class _EventViewScreenState extends State<EventViewScreen> {
  late final Future<Event> event;

  @override
  void initState() {
    super.initState();
    event = widget.event != null
        ? widget.event!.fetchAuthor()
        : Event.find(widget.id).then((event) => event.fetchAuthor());
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

        return Scaffold(
          extendBodyBehindAppBar: snapshot.data?.hasBanner ?? true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: !(snapshot.data?.hasBanner ?? true)
                ? Text(snapshot.requireData.title)
                : null,
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
