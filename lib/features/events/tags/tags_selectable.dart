import "package:event_app/api/models/event_tag.dart";
import "package:flutter/material.dart";

class SelectableTags extends StatefulWidget {
  const SelectableTags({super.key, required this.selectedTags});
  final List<EventTag> selectedTags;

  @override
  State<SelectableTags> createState() => _State();
}

class _State extends State<SelectableTags> {

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 6.0,
        children: tags.map((tag) {
          return ChoiceChip(
            label: Text(tag.content),
            selected: widget.selectedTags.any((item) => item.id == tag.id),
            onSelected: (selected) {
              setState(() {
                widget.selectedTags.any((item) => item.id == tag.id)
                    ? widget.selectedTags.removeWhere((item) => item.id == tag.id)
                    : widget.selectedTags.add(tag);
              });
            },
          );
        }).toList());
  }
}
