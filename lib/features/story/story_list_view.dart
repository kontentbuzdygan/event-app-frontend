import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/api/models/story.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:go_router/go_router.dart";

class StoryListView extends StatefulWidget {
  const StoryListView({super.key, required this.stories});

  final Future<List<Story>> stories;
  @override
  State<StoryListView> createState() => _StoryListViewState();
}

class _StoryListViewState extends State<StoryListView> {
  @override
  Widget build(context) {
    return FutureBuilder(
        future: widget.stories,
        builder: (builder, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
                child: SizedBox(
                  height: 80.0,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: snapshot.requireData.map((story) {
              return story.author != null ? 
                profileItem(story.author!, snapshot.requireData) : 
                eventItem(story.event!, snapshot.requireData);
              }).toList()))));
          }

          return Center(
            child: snapshot.hasError
                ? const Text("pizda")
                : const CircularProgressIndicator(),
          );
        });
  }

  Widget profileItem(Profile author, List<Story> stories) {
    return Center(
        child: SizedBox(
          width: 84,
          child: GestureDetector(
            onTap: () => context.push("/stories", extra: stories),
            child: Flexible(
              child: Column(
                children: [
                  const CircleAvatar (
                    radius: 32,
                    backgroundColor: Colors.cyan,
                ),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    text: author.displayName
                  )
                ),
              ]),
            ),
          ),
        ),
      );
  }

  Widget eventItem(Event event, List<Story> stories) {
    return GestureDetector(
      onTap: () => context.push("/stories", extra: stories),
      child: CircleAvatar(
        backgroundColor: Colors.red,
        child: Text(event.title),
      ),
    );
  }
}