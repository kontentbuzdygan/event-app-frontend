import "package:flutter/material.dart";

class CommentInput extends StatelessWidget {
  const CommentInput({super.key, required this.onSubmit});

  final void Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Expanded(
        child: TextField(
          decoration: InputDecoration(hintText: "Add a comment…"),
          maxLines: null,
        ),
      ),
      IconButton(onPressed: onSubmit, icon: const Icon(Icons.send_outlined))
    ]);
  }
}
