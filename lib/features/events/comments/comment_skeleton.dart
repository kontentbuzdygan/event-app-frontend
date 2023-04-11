import "package:flutter/material.dart";
import "package:skeletons/skeletons.dart";

class CommentSkeleton extends StatelessWidget {
  const CommentSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Row(children: [
        SkeletonLine(
          style: SkeletonLineStyle(
            width: 50.0,
            height: 50.0,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 30.0,
            ),
          ),
        ),
      ]);
}
