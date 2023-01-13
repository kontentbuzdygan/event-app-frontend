import "package:flutter/material.dart";

class SlideOutButtons extends StatelessWidget {
  final Duration transitionTime;
  final bool expanded;
  final Widget leftChild, rightChild;

  const SlideOutButtons(
      {super.key,
      required this.transitionTime,
      required this.expanded,
      required this.leftChild,
      required this.rightChild});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          duration: transitionTime,
          opacity: expanded ? 1.0 : 0.0,
          child: Positioned.fill(
            child: AnimatedAlign(
              curve: Curves.fastOutSlowIn,
              alignment: expanded ? Alignment.centerLeft : Alignment.center,
              duration: transitionTime,
              child: leftChild,
            ),
          ),
        ),
        Positioned.fill(
          child: AnimatedAlign(
            curve: Curves.fastOutSlowIn,
            alignment: expanded ? Alignment.centerRight : Alignment.center,
            duration: transitionTime,
            child: rightChild,
          ),
        ),
      ],
    );
  }
}
