import "package:event_app/features/discover/search_field.dart";
import "package:flutter/material.dart";

class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.searchFieldController});

  final TextEditingController? searchFieldController;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchField(controller: searchFieldController),
            const SizedBox(height: 16),
            filters,
          ],
        ),
      );

  Widget get filters => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        // TODO: Load these from the db?
        child: Row(
          children: const [
            Chip(label: Text("🎉 Party")),
            SizedBox(width: 10),
            Chip(label: Text("🏋️ Gym")),
            SizedBox(width: 10),
            Chip(label: Text("🏌️ Golf")),
            SizedBox(width: 10),
            Chip(label: Text("👻 Movie night")),
          ],
        ),
      );
}
