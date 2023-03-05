import "package:event_app/api/models/profile.dart";
import "package:flutter/material.dart";

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key, required this.id});

  final int id;

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  late final Future<Profile> profile = Profile.find(widget.id);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: profile,
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
          leadingWidth: 20,
          centerTitle: false,
          title: Text(snapshot.data?.displayName ?? ""),
        ),
        body: () {
          if (snapshot.hasData) return ProfileView(profile: snapshot.data!);

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
  const ProfileView({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          if (profile.avatar != null) Text(profile.avatar!),
          if (profile.bio != null) Text("bio: ${profile.bio!}")
        ],
      ),
    );
  }
}
