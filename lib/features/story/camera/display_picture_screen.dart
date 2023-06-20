import "dart:io";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";

class DisplayPicturePage extends StatelessWidget {
  final String imagePath;

  const DisplayPicturePage({super.key, required this.imagePath});

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
          // Fo sho ma man ;) 
          context.router.popUntilRouteWithPath("da path");
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
