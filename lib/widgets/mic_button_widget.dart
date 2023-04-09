import 'package:flutter/material.dart';

class MicroButton extends StatelessWidget {
  final VoidCallback onLongPressed;
  final VoidCallback onLongPressedEnd;
  final bool isButtonAnimated;

  const MicroButton(
      {super.key,
      required this.onLongPressed,
      required this.isButtonAnimated,
      required this.onLongPressedEnd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        onLongPressed();
      },
      onLongPressEnd: (details) async {
        onLongPressedEnd();
      },
      child: Transform.scale(
        scale: 0.8,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.white,
          child: Icon(
            isButtonAnimated ? Icons.mic : Icons.mic_none,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
