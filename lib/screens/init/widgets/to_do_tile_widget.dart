import 'package:desafio/core/error_catalog.dart';
import 'package:desafio/core/http_client.dart' as client;
import 'package:desafio/models/to_do.dart';
import 'package:desafio/models/user.dart';
import 'package:desafio/screens/login/login_screen.dart';
import 'package:desafio/screens/to_do/to_do_screen.dart';
import 'package:desafio/screens/widgets/app_alert_dialog.dart';
import 'package:desafio/screens/widgets/app_alert_dialog_button.dart';
import 'package:dio/dio.dart';
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
            message: ErrorCatalog.getErrorMessage(
              result['error']['code'],
            ),
            actions: [
              AppAlertDialogButton(
                onPressed: () => result['error']['code'] != 1012
                    ? Navigator.pop(context)
                    : Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                text: 'Fechar',
              ),
            ],
          ),
        );
      } else {
        widget.refreshKey.currentState!.show();
      }
    } on DioError catch (_) {
      showDialog(
        context: context,
        builder: (context) => AppAlertDialog(
          alertType: AlertType.error,
          message: ErrorCatalog.getErrorMessage(1101),
          actions: [
            AppAlertDialogButton(
              onPressed: () => Navigator.pop(context),
              text: 'Fechar',
            ),
          ],
        ),
      );
    } catch (_) {
      showDialog(
        context: context,
        builder: (context) => AppAlertDialog(
          alertType: AlertType.error,
          message: ErrorCatalog.getErrorMessage(1102),
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
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.toDo.title!),
      leading: IconButton(
        icon: Icon(
          widget.toDo.done!
              ? Icons.task_alt_rounded
              : Icons.radio_button_unchecked_rounded,
        ),
        onPressed: () {
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
