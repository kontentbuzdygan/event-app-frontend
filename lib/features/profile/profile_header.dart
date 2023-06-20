import "package:auto_route/auto_route.dart";
import "package:event_app/api/models/profile.dart";
import "package:event_app/api/models/story.dart";
import "package:event_app/features/story/story_list_view.dart";
import "package:event_app/router.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key, required this.profile});

  final Profile profile;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  late Future<List<Story>> stories;

  @override
  void initState() {
    super.initState();

    stories = () async {
      final stories = await fetchRandomStoriesByAuthorId(widget.profile.id);
      await Future.wait(stories.map((story) => story.fetchAuthor()));
      await Future.wait(stories.map((story) => story.fetchEvent()));
      return stories;
    }();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(children: [
        Row(children: [
          IconButton(
            onPressed: () {
              // TODO: open image picker
            },
            icon: const Icon(Icons.account_circle_outlined, size: 64),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.pushRoute(const ProfileEditRoute()),
            child: Text(widget.profile.displayName, style: theme.textTheme.titleLarge),
          )
        ]),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: widget.profile.bio,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            alignLabelWithHint: true,
            labelText: l10n.bio,
          ),
          readOnly: true,
          minLines: 2,
          maxLines: null,
          onTap: () => context.pushRoute(const ProfileEditRoute()),
        ),
        const SizedBox(height: 8),
        StoryListView(stories: stories),
      ]),
    );
  }
}
