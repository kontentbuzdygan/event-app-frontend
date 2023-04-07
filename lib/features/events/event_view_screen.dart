import "package:event_app/api/models/event.dart";
import "package:event_app/features/auth/auth_state.dart";
import "package:event_app/main.dart";
import "package:event_app/router.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class EventViewScreen extends StatefulWidget {
  const EventViewScreen({super.key, required this.id});

  static navigate(int id) {
    App.router.pushNamed(
      "eventView",
      params: {"id": id.toString()},
    );
  }
  final int id;

  @override
  State<EventViewScreen> createState() => _EventViewScreenState();
}

class _EventViewScreenState extends State<EventViewScreen> {
  late final event = Event.find(widget.id).then((event) => event.fetchAuthor());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder(
      future: event,
      builder: (builder, snapshot) => Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data?.title ?? ""),
          actions: !snapshot.hasData ? null : [
            PopupMenu(snapshot: snapshot)
          ],
        ),
        body: () {
          if (snapshot.hasData) return EventView(event: snapshot.data!);

          return Center(
            child: snapshot.hasError
                ? Text(l10n.eventNotFound)
                : const CircularProgressIndicator(),
          );
        }(),
      ),
    );
  }
}

class PopupMenu extends StatelessWidget {
  final AsyncSnapshot<Event> snapshot;
  const PopupMenu({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(itemBuilder: (itemBuilder){
      return [
        const PopupMenuItem<String>(
          value: "hello",
          child: Text("Hello"),
        ),
        if(App.authState.myId == snapshot.data!.authorId) ...[
          const PopupMenuItem(
            value: "delete",
            child: Text("Delete event"),
          ),
        ],
      ];
    },
    onSelected: (value){
      switch(value){
        case "hello": 
          print("hello"); break;
        case "delete":
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: const Text("Delete event"),
              content: const Text("Are you sure you want to delete your awesome event?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    print("delete");
                    //TODO: API call
                  },
                  child: const Text("Delete"),
                ),
              ],
            );
          });
          break;
        }
      },
    );
  }
}

class EventView extends StatelessWidget {
  const EventView({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(
              l10n.createdBy(""),
              style: TextStyle(color: Colors.grey[600]),
            ),
            TextButton(
              onPressed: () => ProfileViewRoute(id: event.authorId).push(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                maximumSize: Size.infinite,
              ),
              child: Text(
                event.author!.displayName,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ]),
          Text(
            event.endsAt != null
                ? l10n.eventFromTo(event.startsAt, event.endsAt!)
                : l10n.startsAtDate(event.startsAt),
            style: TextStyle(color: Colors.blue[700]),
          ),
          const SizedBox(height: 5.0),
          Text(event.description),
        ],
      ),
    );
  }
}
