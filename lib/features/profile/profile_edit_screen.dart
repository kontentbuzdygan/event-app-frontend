import "package:event_app/api/models/profile.dart";
import "package:event_app/router.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:form_validator/form_validator.dart";

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final Future<Profile> profile = Profile.me();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          title: Text(l10n.editProfile),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          child: Center(
            child: FutureBuilder(
              future: profile,
              builder: (_, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                if (snapshot.hasError) return Text(snapshot.error!.toString());

                return ProfileEditForm(profile: snapshot.data!);
              },
            ),
          ),
        ));
  }
}

class ProfileEditForm extends StatefulWidget {
  const ProfileEditForm({super.key, required this.profile});

  final Profile profile;

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  late final displayNameController =
      TextEditingController(text: widget.profile.displayName);

  late final bioController = TextEditingController(text: widget.profile.bio);

  final form = GlobalKey<FormState>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: form,
      child: Column(
        children: [
          TextFormField(
            enabled: !loading,
            controller: displayNameController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.displayName,
            ),
            validator: ValidationBuilder().required().minLength(2).build(),
          ),
          const SizedBox(height: 8),
          TextFormField(
            enabled: !loading,
            minLines: 2,
            maxLines: 3,
            controller: bioController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
              labelText: l10n.bio,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: loading ? null : handleSubmit,
              child: Text(l10n.save),
            ),
          )
        ],
      ),
    );
  }

  Future<void> handleSubmit() async {
    if (!form.currentState!.validate()) return;

    setState(() => loading = true);

    widget.profile.displayName = displayNameController.text;
    widget.profile.bio = bioController.text;

    await widget.profile
        .update()
        .then((_) => MyProfileViewRoute().go(context))
        .catchError((_) => setState(() => loading = false));
  }
}
