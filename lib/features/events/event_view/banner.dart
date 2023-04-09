import "package:flutter/material.dart";
import "package:skeletons/skeletons.dart";
import "package:unsplash_client/unsplash_client.dart";

class EventViewBanner extends StatelessWidget {
  const EventViewBanner({
    super.key,
    required this.banner,
    required this.title,
  });

  final PhotoUrls? banner;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (banner == null) {
      return EventViewBannerSkeleton(title: title);
    }

    return Material(
      elevation: 10,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(banner!.small.toString()),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(
              title ?? "",
              style: theme.textTheme.displayMedium,
            ),
          ),
        ),
      ),
    );
  }
}

class EventViewBannerSkeleton extends StatelessWidget {
  const EventViewBannerSkeleton({
    super.key,
    required this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 10,
      child: SizedBox(
        height: 250,
        child: Stack(children: [
          const SkeletonLine(
            style: SkeletonLineStyle(height: 250),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Text(
                title ?? "",
                style: theme.textTheme.displayMedium,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
