import "package:flutter/material.dart";

class CommentInput extends StatelessWidget {
  const CommentInput({super.key, required this.onSubmit});

  final void Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Add a comment…",
        suffixIcon: IconButton(
          onPressed: onSubmit,
          icon: const Icon(Icons.send_outlined),
        ),
      ),
      maxLines: null,
    );
  }
}
