import "package:event_app/api/models/event.dart";
import "package:event_app/features/shared/loading_screen.dart";
import "package:event_app/features/shared/not_found_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class EventViewScreen extends StatelessWidget {
  EventViewScreen({super.key, required int id}) {
    event = Event.find(id).then((event) => event.fetchAuthor());
  }

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
        final event = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(event.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  infoRow(l10n.author, event.author!.displayName),
                  infoRow(
                    l10n.startsAt,
                    l10n.date(event.startsAt),
                    TextStyle(
                      color: Colors.blue[700],
                    ),
                  ),
                  if (event.endsAt != null)
                    infoRow(
                      l10n.endsAt,
                      l10n.date(event.endsAt!),
                      TextStyle(
                        color: Colors.blue[700],
                      ),
                    ),
                  infoRow(l10n.description, event.description),
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
