import "package:event_app/api/models/event_tag.dart";
import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:event_app/features/events/tags/tags_selectable.dart";

class TagsStep extends StatefulWidget {
  const TagsStep({
    super.key,
    required this.formKey,
    required this.selectedTags,
  });

  final List<EventTag> selectedTags;
  final GlobalKey<FormBuilderState> formKey;

  @override
  State<TagsStep> createState() => _State();
}

class _State extends State<TagsStep> {
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: SelectableTags(selectedTags: widget.selectedTags),
    );
  }
}
