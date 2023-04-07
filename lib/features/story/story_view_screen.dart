import "package:event_app/api/models/story.dart";
import "package:flutter/material.dart";
import "package:story/story.dart";

class StoryViewScreen extends StatefulWidget {
  const StoryViewScreen({super.key, required this.stories});

  final List<Story> stories;

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  @override
  Widget build(context) {
    return Scaffold(
      body: StoryPageView(
      itemBuilder: (context, pageIndex, storyIndex) {
        return Center(
          child: Text(
              "Index of PageView: $pageIndex Index of story on each page: $storyIndex"),
        );
      },
      storyLength: (pageIndex) {
        return widget.stories[pageIndex].media.length;
      },
      pageLength: widget.stories.length,
      onPageLimitReached: () {
        Navigator.pop(context);
      },
    ));
  }
}