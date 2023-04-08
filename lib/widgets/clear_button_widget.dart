import 'package:flutter/material.dart';
import 'alert_dialog_delete_widget.dart';

class ClearButtonWidget extends StatelessWidget {
  final VoidCallback onSended;
  const ClearButtonWidget({super.key, required this.onSended});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialogDeleteWidget(
                labelMessage: "Ви дійсно хочете видалити всі повідомлення?",
                labelYes: "Так",
                labelNo: "Ні",
                onPressed: onSended,
              );
            });
      },
      icon: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
