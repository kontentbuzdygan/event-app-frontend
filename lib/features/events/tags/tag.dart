import "package:event_app/api/models/event_tag.dart";
import "package:flutter/material.dart";

class Tag extends StatelessWidget {
  const Tag({super.key, required this.tag});

  final EventTag tag;

  @override
  Widget build(BuildContext context) {
    return Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelPadding: const EdgeInsets.all(2.0),
      label: Text(
        tag.content,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: const EdgeInsets.all(8.0),
      shape: const StadiumBorder(
          side: BorderSide(
        width: 1,
      )),
    );
  }
}
