import 'package:flutter/material.dart';

import '../services/voice_handler_services.dart';

class TextFieldWidget extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final bool isKeyboardVisible;
  final VoiceHandler voiceHandler;
  final Function(String) onSubmitted;
  const TextFieldWidget(
      {super.key,
      required this.voiceHandler,
      required this.focusNode,
      required this.textEditingController,
      required this.isKeyboardVisible,
      required this.onSubmitted});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        focusNode: widget.focusNode,
        style: const TextStyle(color: Colors.white),
        controller: widget.textEditingController,
        onSubmitted: widget.onSubmitted,
        decoration: const InputDecoration.collapsed(
          hintText: "Чим я можу допомогти тобі?",
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
