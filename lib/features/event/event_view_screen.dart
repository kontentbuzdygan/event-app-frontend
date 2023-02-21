import "package:event_app/api/models/event.dart";
import "package:event_app/features/shared/loading_screen.dart";
import "package:event_app/features/shared/not_found_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class EventViewScreen extends StatelessWidget {
  EventViewScreen({super.key, required int id}) {
    event = Event.find(id);
  }

  // TODO: Chain event fetching with author profile fetching
  late final Future<Event> event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder(
      future: event,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return NotFoundScreen(
            message: l10n.eventNotFound,
          );
        }

        if (!snapshot.hasData) {
          return const LoadingScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data!.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  infoRow(l10n.creator, snapshot.data!.authorId.toString()),
                  infoRow(
                    l10n.startsAt,
                    l10n.date(snapshot.data!.startsAt),
                    TextStyle(
                      color: Colors.blue[700],
                    ),
                  ),
                  if (snapshot.data!.endsAt != null)
                    infoRow(
                      l10n.endsAt,
                      l10n.date(snapshot.data!.startsAt),
                      TextStyle(
                        color: Colors.blue[700],
                      ),
                    ),
                  infoRow(l10n.description, snapshot.data!.description),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget infoRow(String label, String info, [TextStyle? style]) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600)
              .merge(style),
        ),
        Text(info, style: style),
      ],
    );
  }
}
