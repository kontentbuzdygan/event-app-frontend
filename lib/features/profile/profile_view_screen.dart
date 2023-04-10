import "package:event_app/api/models/profile.dart";
import "package:event_app/api/models/story.dart";
import "package:event_app/features/story/story_list_view.dart";
import "package:event_app/main.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key, this.id});

  final int? id;

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  late final Future<Profile> profile =
      widget.id != null ? Profile.find(widget.id!) : Profile.me();  
  late final Future<List<Story>> allStories;

  @override
  void initState() {
    super.initState();

    allStories = () async {
      final stories = await fetchRandomStoriesByAuthorId(widget.id ?? 0);
      await Future.wait(stories.map((story) => story.fetchAuthor()));
      await Future.wait(stories.map((story) => story.fetchEvent()));
      return stories;
    }();
  }

  @override
  Widget build(context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: profile,
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data?.displayName ?? ""),
          actions: [
            if (widget.id == null) ...[
              IconButton(
                onPressed: () => context.pushNamed("editProfile"),
                tooltip: l10n.editProfile,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: App.authState.signOut,
                tooltip: l10n.logOut,
                icon: const Icon(Icons.logout_outlined),
              ),
            ]
          ],
        ),
        body: () {
          if (snapshot.hasData) return ProfileView(profile: snapshot.data!, stories: allStories,);

          return Center(
            child: snapshot.hasError
                ? Text(snapshot.error.toString())
                : const CircularProgressIndicator(),
          );
        }(),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.profile, required this.stories});

  final Profile profile;
  final Future<List<Story>> stories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          if (profile.bio != null) Text(profile.bio!),
          StoryListView(stories: stories),
        ],
      ),
    );
  }
}
