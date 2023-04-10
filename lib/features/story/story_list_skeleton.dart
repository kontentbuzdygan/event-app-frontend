import "package:flutter/material.dart";
import "package:skeletons/skeletons.dart";

class StoryListSkeleton extends StatelessWidget {
  const StoryListSkeleton({super.key});

  final userCount = 10;

  @override
  Widget build(context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(children: List.generate(userCount, (index) => skeletonUser())),
    );
  }

  Widget skeletonUser() {
    const avatarSize = 64.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const SkeletonAvatar(
            style: SkeletonAvatarStyle(
                shape: BoxShape.circle, width: avatarSize, height: avatarSize),
          ),
          SkeletonParagraph(
              style: const SkeletonParagraphStyle(
                  lines: 1,
                  lineStyle: SkeletonLineStyle(
                    height: 10,
                    width: avatarSize,
                  )))
        ],
      ),
    );
  }
}
