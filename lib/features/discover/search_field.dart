import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class SearchField extends StatelessWidget {
  const SearchField({super.key, this.controller});

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 60,
      child: Row(children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            margin: EdgeInsets.zero,
            elevation: 5,
            child: Center(
              child: TextFormField(
                controller: controller,
                maxLines: 1,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_outlined),
                  hintText: l10n.searchHint,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        // TODO: Implement profiles searching
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.people_outlined),
        )
      ]),
    );
  }
}
