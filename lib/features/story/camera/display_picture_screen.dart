import "dart:ffi";

import "dart:io";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: there has to be a better way for it
          context.pop();
          context.pop();
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
