import "package:event_app/api/models/profile.dart";
import "package:flutter/material.dart";

class ProfileCompact extends StatelessWidget {
  const ProfileCompact({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(64),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  profile.displayName,
                  style: theme.textTheme.titleMedium,
                ),
                if (profile.bio != null) Text(profile.bio ?? ""),
              ],
            ),
          ],
        ),
        OutlinedButton(onPressed: () {}, child: const Text("Follow"))
      ],
    );
  }
}
