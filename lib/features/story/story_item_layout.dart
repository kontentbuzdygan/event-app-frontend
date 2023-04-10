import "package:flutter/material.dart";

class StoryItemLayout extends StatefulWidget {
  const StoryItemLayout({super.key, required this.children});

  final List<Widget> children;
  @override
  State<StoryItemLayout> createState() => _StoryItemLayout();
}

class _StoryItemLayout extends State<StoryItemLayout> {
  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 64,
        child: Column(children: widget.children),
      ),
    );
  }
}
