import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.controller,
    this.suffix,
  });

  final TextEditingController? controller;
  final Widget? suffix;

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
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(Icons.search_outlined),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: l10n.searchHint,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (suffix != null) suffix!
      ]),
    );
  }
}
