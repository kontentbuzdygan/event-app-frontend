import "package:event_app/features/discover/discover_screen_notifier.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<DiscoverPageNotifier>();

    return SizedBox(
      height: 60,
      child: Row(children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            margin: EdgeInsets.zero,
            elevation: 5,
            child: Center(
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(Icons.search_outlined),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => state.setFilterText(value),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: l10n.searchHint,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: l10n.showMap,
          icon: Icon(
            size: 30,
            state.mapOpened ? Icons.map : Icons.map_outlined,
          ),
          isSelected: state.mapOpened,
          onPressed: state.toggleList,
        ),
      ]),
    );
  }
}
