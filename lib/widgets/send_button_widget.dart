import 'package:flutter/material.dart';

class SendButtonWidget extends StatefulWidget {
  const SendButtonWidget({
    Key? key,
    required this.onSended,
  }) : super(key: key);
  final VoidCallback onSended;

  @override
  State<SendButtonWidget> createState() => _SendButtonWidgetState();
}

class _SendButtonWidgetState extends State<SendButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onSended,
      icon: const Icon(
        Icons.send,
        color: Colors.white,
      ),
    );
  }
}
