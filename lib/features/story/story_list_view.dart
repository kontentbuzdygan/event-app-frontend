import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/api/models/story.dart";
import "package:event_app/features/story/story_list_skeleton.dart";
import "package:flutter/material.dart";
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

          return snapshot.hasError
              ? const Text("pizda") // TODO: translation
              : const StoryListSkeleton();
        });
  }

  Widget storiesList(List<Story> stories) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Row(children: [
          addNewStoryItem(),
          ...stories.asMap().entries.map((e) {
            return profileItem(stories[e.key].author!, stories, e.key);
          }).toList()
        ]));
  }

  Widget profileItem(Profile author, List<Story> stories, int startingIndex) {
    return GestureDetector(
      onTap: () => context.push("/stories",
          extra: StoryData._(stories: stories, startingIndex: startingIndex)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            circularImageWithBorder(author.profilePicture!.thumb.toString()),
            RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: author.displayName,
                    style: const TextStyle(
                      fontSize: 14,
                    )))
          ],
        ),
      ),
    );
  }

  Widget addNewStoryItem() {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => "",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: theme.colorScheme.secondary),
              alignment: Alignment.center,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            RichText(
                overflow: TextOverflow.ellipsis,
                text: const TextSpan(
                    text: "Your story",
                    style: TextStyle(
                      fontSize: 14,
                    )))
          ],
        ),
      ),
    );
  }

  Widget circularImageWithBorder(String url) {
    final theme = Theme.of(context);

    return CircleAvatar(
      backgroundColor: Colors.accents.first,
      radius: 32,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: theme.colorScheme.background,
        child: CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage(url),
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

  StoryData._({required this.stories, required this.startingIndex});
}
