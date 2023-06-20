import "dart:async";

import "package:camera/camera.dart";
import "package:flutter/material.dart";

class TakePicturePage extends StatefulWidget {
  const TakePicturePage({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePicturePageState createState() => TakePicturePageState();
}

class TakePicturePageState extends State<TakePicturePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final mediaSize = MediaQuery.of(context).size;
            final scale =
                1 / (_controller.value.aspectRatio * mediaSize.aspectRatio);

            return ClipRect(
                clipper: _MediaSizeClipper(mediaSize),
                child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topCenter,
                    child: CameraPreview(_controller)));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            if (!mounted) return;

            // context.push("/displayPicture", extra: image.path);
          } catch (e) {
            return;
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;
  const _MediaSizeClipper(this.mediaSize);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
