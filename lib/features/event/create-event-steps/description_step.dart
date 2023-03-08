import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";


class DescriptionStep extends StatefulWidget {
  const DescriptionStep({
    super.key,
    required this.formKey,
    required this.descriptionController,
    required this.titleController,
  });

  final TextEditingController descriptionController;
  final TextEditingController titleController;
  final GlobalKey<FormBuilderState> formKey;

  @override
  State<DescriptionStep> createState() => _State();
}

class _State extends State<DescriptionStep> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FormBuilder(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          FormBuilderTextField(
            name: "title",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: widget.titleController,
            maxLength: 50,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value!.isEmpty) {
                return l10n.titleInput;
              }
              if (value.length > 50) {
                return l10n.titleTooLong;
              }
              return null;
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: l10n.titleExample,
              labelText: l10n.title,
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderTextField(
            name: "description",
            controller: widget.descriptionController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLines: 5,
            maxLength: 1000,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value!.isEmpty) {
                return l10n.descriptionInput;
              }
              if (value.length > 1000) {
                return l10n.descriptionTooLong;
              }
              return null;
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: l10n.descriptionExample,
              labelText: l10n.description,
            ),
          ),
        ],
      ),
    );
  }
}
