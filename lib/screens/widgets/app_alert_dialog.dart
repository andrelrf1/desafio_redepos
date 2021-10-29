import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final AlertType alertType;
  final String message;
  final List<Widget> actions;

  const AppAlertDialog({
    required this.alertType,
    required this.message,
    required this.actions,
    Key? key,
  }) : super(key: key);

  Widget _generateTitle() {
    switch (alertType) {
      case AlertType.warning:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.warning_rounded,
              color: Colors.orange,
            ),
            SizedBox(width: 10.0),
            Text('Atenção!'),
          ],
        );

      case AlertType.success:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.task_alt_rounded,
              color: Colors.green,
            ),
            SizedBox(width: 10.0),
            Text('Sucesso!'),
          ],
        );

      case AlertType.error:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.error_rounded,
              color: Colors.red,
            ),
            SizedBox(width: 10.0),
            Text('Houve um erro!'),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _generateTitle(),
      content: Text(message),
      actions: actions,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}

enum AlertType {
  warning,
  error,
  success,
}
