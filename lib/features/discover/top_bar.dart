import "package:event_app/features/discover/discover_screen_notifier.dart";
import "package:event_app/features/discover/search_field.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  late final state = context.watch<DiscoverScreenNotifier>();
  late final l10n = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SearchField(),
          const SizedBox(height: 16),
          filters,
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget get filters => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          // TODO: Load these from the db
          children: ["🎉 Party", "🏋️ Gym", "🏌️ Golf", "👻 Movie night"]
              .map((tag) => Row(children: [
                    FilterChip(
                      selected: state.filterTags.contains(tag),
                      label: Text(tag),
                      onSelected: (selected) => !selected
                          ? state.removeFilterTag(tag)
                          : state.addFilterTag(tag),
                    ),
                    const SizedBox(width: 10)
                  ]))
              .toList(),
        ),
      );
}
