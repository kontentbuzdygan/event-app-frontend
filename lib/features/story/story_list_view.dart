import "dart:ffi";

import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/api/models/story.dart";
import "package:event_app/features/story/story_view_screen.dart";
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
            return storiesList(snapshot.requireData);
          }

          return Center(
            child: snapshot.hasError
                ? const Text("pizda")
                : const CircularProgressIndicator(),
          );
        });
  }

  Widget storiesList(List<Story> stories) {
    return Row(children: [
      Expanded(
        child: SizedBox(
          height: 100,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            itemBuilder: (context, index) {
              return profileItem(
                  stories[index].author!, stories, index);
            },
          ),
        ),
      ),
    ]);
  }

  Widget profileItem(Profile author, List<Story> stories, int startingIndex) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(9),
      child: GestureDetector(
        onTap: () => context.push("/stories", extra: StoryData._(stories: stories, startingIndex: startingIndex)),
        child: Expanded(
          child: SizedBox(
            width: 64,
            child: Column(children: [
              CircleAvatar(
                backgroundColor: Colors.accents.first,
                radius: 32,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.background,
                  child: CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(author.profilePicture!.thumb.toString()),
                  ),
                ),
              ),
              RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      text: author.displayName,
                      style: const TextStyle(
                        fontSize: 14,
                      )))
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

class StoryData {
  List<Story> stories;
  int startingIndex;

  StoryData._({
    required this.stories,
    required this.startingIndex
  });
}