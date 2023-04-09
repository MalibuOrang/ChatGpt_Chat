import 'package:flutter/material.dart';
import 'alert_dialog_delete_widget.dart';

class DeleteButtonWidget extends StatelessWidget {
  final VoidCallback onDeleteMes;
  final Icon iconBut;
  final String labelMes;
  const DeleteButtonWidget(
      {super.key,
      required this.onDeleteMes,
      required this.iconBut,
      required this.labelMes});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialogDeleteWidget(
                labelMessage: labelMes,
                labelYes: "Так",
                labelNo: "Ні",
                onPressed: () {
                  onDeleteMes();
                },
              );
            });
      },
      icon: iconBut,
    );
  }
}
