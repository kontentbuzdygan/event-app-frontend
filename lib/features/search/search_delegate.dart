import "package:event_app/features/search/search_result_screen.dart";
import "package:flutter/material.dart";

class EventsAndProfilesSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty) IconButton(
      onPressed: () => query = "", 
      icon: const Icon(Icons.clear)
    ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back)
  );

  @override
  Widget buildResults(BuildContext context) {
    return SearchResultScreen(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: Implement sugestions
    return ListView(children: const []);
  }
}