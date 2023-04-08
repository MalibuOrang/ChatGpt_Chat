import 'package:flutter/material.dart';
import 'package:flutter_chargpt_chat/widgets/text_message_widget.dart';
import '../constants/constants.dart';

class AlertDialogDeleteWidget extends StatelessWidget {
  const AlertDialogDeleteWidget({
    super.key,
    required this.labelMessage,
    required this.labelYes,
    required this.labelNo,
    required this.onPressed,
  });
  final String labelMessage;
  final String labelYes;
  final String labelNo;
  final double labelSize = 17;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: scaffoldBackgroundColor,
      title: TextMessageWidget(
        lable: labelMessage,
        fontSize: labelSize,
        fontWeight: FontWeight.bold,
      ),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: TextMessageWidget(
            lable: labelYes,
            fontSize: labelSize,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: TextMessageWidget(
            lable: labelNo,
            fontSize: labelSize,
          ),
        ),
      ],
    );
  }
}
