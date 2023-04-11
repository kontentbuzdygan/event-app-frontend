import "package:event_app/api/models/profile.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final Profile profile;

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
            onTap: () => context.pushNamed("editProfile"),
            child: Text(profile.displayName, style: theme.textTheme.titleLarge),
          )
        ]),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: profile.bio,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            alignLabelWithHint: true,
            labelText: l10n.bio,
          ),
          readOnly: true,
          minLines: 2,
          maxLines: null,
          onTap: () => context.pushNamed("editProfile"),
        )
      ]),
    );
  }
}
