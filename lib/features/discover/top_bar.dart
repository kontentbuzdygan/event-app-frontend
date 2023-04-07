import "package:event_app/features/discover/search_field.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class TopBar extends StatefulWidget {
  const TopBar({
    super.key,
    required this.searchFieldController,
    this.mapOnClick,
    required this.mapOpened,
  });

  final TextEditingController? searchFieldController;
  final void Function()? mapOnClick;
  final bool mapOpened;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  late final l10n = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchField(
              controller: widget.searchFieldController,
              suffix: IconButton(
                tooltip: l10n.showMap,
                icon: Icon(widget.mapOpened ? Icons.map : Icons.map_outlined),
                isSelected: widget.mapOpened,
                onPressed: () {
                  if (widget.mapOnClick != null) {
                    widget.mapOnClick!();
                  }
                },
              ),
            ),
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
