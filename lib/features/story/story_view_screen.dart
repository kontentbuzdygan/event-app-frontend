import "package:event_app/api/models/story.dart";
import "package:event_app/features/story/story_list_view.dart";
import "package:flutter/material.dart";
import "package:story/story.dart";

class StoryViewScreen extends StatefulWidget {
  const StoryViewScreen({super.key, required this.stories});

  final StoryData stories;

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  @override
  Widget build(context) {
    final int start = widget.stories.startingIndex;
    return Scaffold(
      body: StoryPageView(
        initialPage: start,
        itemBuilder: (context, pageIndex, storyIndex) {
          final storyEntry = widget.stories.stories[pageIndex];
          final story = storyEntry.media[storyIndex];
          final user = storyEntry.author;
          return Stack(children: [
            Positioned.fill(child: Container(color: Colors.black)),
            Positioned.fill(
                child:
                    Image.network(story.regular.toString(), fit: BoxFit.cover)),
            Padding(
                padding: const EdgeInsets.only(top: 44, left: 8),
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                user!.profilePicture!.thumb.toString()),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(user.displayName,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ))
          ]);
        },
        gestureItemBuilder: (context, pageIndex, storyIndex) {
          return Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ));
        },
        storyLength: (int pageIndex) {
          return widget.stories.stories[pageIndex].media.length;
        },
        pageLength: widget.stories.stories.length,
        onPageLimitReached: () {
          Navigator.pop(context);
        },
        showShadow: true,
      ),
    );
  }
}
