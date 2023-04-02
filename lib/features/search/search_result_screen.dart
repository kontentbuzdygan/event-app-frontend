// import "package:flutter/widgets"

import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/api/rest_client.dart";
import "package:flutter/material.dart";

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key, required this.query});

  final String query;

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {

  late Future<List<Event>> events;
  late Future<Iterable<Profile>> profiles;

  @override
  void initState() {
    super.initState();

    events = () async {
      final events = (await Event.findAll()).toList();
      await RestClient.runCached(
        () => Future.wait(
          events.map((event) => event.fetchAuthor()),
        ),
      );
      return events;
    }();

    profiles = Profile.find(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([profiles]),
      builder: (context, snapshot) { 
                
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // final events   = snapshot.requireData[0] as Iterable<Event>;
        final profiles = snapshot.requireData[0];

        // validEvent(Event e) => e.title.contains(widget.query);
        validProfile(Profile p) => p.displayName.contains(widget.query);

        return ListView(
          children:  profiles.where(validProfile).map(searchResultProfileItem).toList()
        );
      }
    );
  }

    
  Widget searchResultProfileItem(Profile profile) {
    return Text(profile.displayName);
  }

  Widget searchResultEventItem(Event event) {
    return Text(event.title);
  }
}