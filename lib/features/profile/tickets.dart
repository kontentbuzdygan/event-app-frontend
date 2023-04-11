import "package:flutter/material.dart";
import "package:qr_flutter/qr_flutter.dart";

class Tickets extends StatelessWidget {
  const Tickets({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Center(
            child: QrImage(
              data: "czesc ${index + 1}",
              size: 256,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
