import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

// TODO: Translate this file
class _DiscoverScreenState extends State<DiscoverScreen> {
  Future<Iterable<Event>> events = Future.value([]);
  Future<Iterable<Profile>> profiles = Future.value([]);

  void search(String value) {
    setState(() {
      events = Event.findAll();
      profiles = Profile.find(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Discover")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                // suffixIcon: Icon(Icons.clear),
              ),
              onSubmitted: search,
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: Future.wait([events, profiles]),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text(snapshot.error!.toString());
                }

                final events = (snapshot.data![0] as Iterable<Event>)
                    .map(listItemEvent)
                    .toList();

                final profiles = (snapshot.data![1] as Iterable<Profile>)
                    .map(listItemProfile)
                    .toList();

                final listItems = profiles + events;

                return Expanded(
                  child: ListView.separated(
                    itemCount: listItems.length,
                    itemBuilder: (context, index) => listItems[index],
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget listItemEvent(Event event) => GestureDetector(
        onTap: () => context.push("/events/${event.id}"),
        child: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.centerLeft,
          child: Column(children: [
            Text(
              event.title,
              style: Theme.of(context).primaryTextTheme.titleMedium,
            )
          ]),
        ),
      );

  Widget listItemProfile(Profile profile) => GestureDetector(
        onTap: () => context.push("/profiles/${profile.id}"),
        child: Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.centerLeft,
          child: Column(children: [
            Text(
              profile.displayName,
              style: Theme.of(context).primaryTextTheme.titleMedium,
            )
          ]),
        ),
      );
}
