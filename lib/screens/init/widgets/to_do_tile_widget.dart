import 'package:desafio/core/http_client.dart' as client;
import 'package:desafio/models/to_do.dart';
import 'package:desafio/models/user.dart';
import 'package:desafio/screens/to_do/to_do_screen.dart';
import 'package:desafio/screens/widgets/app_alert_dialog.dart';
import 'package:desafio/screens/widgets/app_alert_dialog_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ToDoTileWidget extends StatefulWidget {
  final ToDo toDo;
  final GlobalKey<RefreshIndicatorState> refreshKey;

  const ToDoTileWidget({
    required this.toDo,
    required this.refreshKey,
    Key? key,
  }) : super(key: key);

  @override
  State<ToDoTileWidget> createState() => _ToDoTileWidgetState();
}

class _ToDoTileWidgetState extends State<ToDoTileWidget> {
  late bool checked;

  Future<void> _toggleDone() async {
    try {
      widget.toDo.done = !widget.toDo.done!;
      Map<String, dynamic> result = await client.HttpClient.createToDo(
        context.read<User>().tokenJWT!,
        widget.toDo,
      );
      if (!result['success']) {
        showDialog(
          context: context,
          builder: (context) => AppAlertDialog(
            alertType: AlertType.error,
            message: 'Erro ao salvar nota, tente novamente!',
            actions: [
              AppAlertDialogButton(
                onPressed: () => Navigator.pop(context),
                text: 'Fechar',
              ),
            ],
          ),
        );
      } else {
        widget.refreshKey.currentState!.show();
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AppAlertDialog(
          alertType: AlertType.error,
          message: 'Erro inesperado, tente novamente!',
          actions: [
            AppAlertDialogButton(
              onPressed: () => Navigator.pop(context),
              text: 'Fechar',
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    checked = widget.toDo.done!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.toDo.title!),
      leading: Checkbox(
        shape: const CircleBorder(),
        value: checked,
        onChanged: (value) {
          setState(() {
            checked = value!;
          });
          _toggleDone();
        },
      ),
      onTap: () async {
        bool? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ToDoScreen(
              toDo: widget.toDo,
            ),
          ),
        );
        if (result != null && result) {
          widget.refreshKey.currentState!.show();
        }
      },
    );
  }
}
