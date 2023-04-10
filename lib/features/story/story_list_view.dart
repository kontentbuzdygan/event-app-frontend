import "package:camera/camera.dart";
import "package:event_app/api/models/event.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/api/models/story.dart";
import "package:event_app/features/story/story_item_layout.dart";
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
            return storyItem(stories[e.key], stories, e.key);
          }).toList()
        ]));
  }

  Widget storyItem(Story story, List<Story> stories, int startingIndex) {
    return GestureDetector(
      onTap: () => context.push("/stories",
          extra: StoryData._(stories: stories, startingIndex: startingIndex)),
      child: StoryItemLayout(
        children: [
          circularImageWithBorder(story.event?.banner!.thumb.toString() ??
              story.author!.profilePicture!.thumb.toString()),
          captionUnderStory(story.event?.title ?? story.author!.displayName)
        ],
      ),
    );
  }

  Widget addNewStoryItem() {
    return GestureDetector(
        onTap: () async => await availableCameras()
            .then((cameras) => context.push("/photo", extra: cameras.first)),
        child: StoryItemLayout(
          children: [
            circularAddNewStory(),
            captionUnderStory("Your story"),
          ],
        ));
  }

  Widget captionUnderStory(String caption) {
    final theme = Theme.of(context);

    return RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
            text: caption,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onBackground,
            )));
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

  Widget circularAddNewStory() {
    final theme = Theme.of(context);

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: theme.colorScheme.secondary),
      alignment: Alignment.center,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

class StoryData {
  List<Story> stories;
  int startingIndex;

  StoryData._({required this.stories, required this.startingIndex});
}
