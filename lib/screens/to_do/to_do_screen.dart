import 'package:desafio/core/error_catalog.dart';
import 'package:desafio/core/http_client.dart' as client;
import 'package:desafio/models/to_do.dart';
import 'package:desafio/models/user.dart';
import 'package:desafio/screens/login/login_screen.dart';
import 'package:desafio/screens/widgets/app_alert_dialog.dart';
import 'package:desafio/screens/widgets/app_alert_dialog_button.dart';
import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ToDoScreen extends StatefulWidget {
  final ToDo? toDo;

  const ToDoScreen({this.toDo, Key? key}) : super(key: key);

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _detailsCtrl;
  bool _saveAndDeleExit = false;

  Future<void> _save({bool? update}) async {
    setState(() {
      _saveAndDeleExit = true;
    });
    try {
      Map<String, dynamic> result;
      if (widget.toDo != null) {
        ToDo newToDo = widget.toDo!;
        newToDo.title = _titleCtrl.text;
        newToDo.text = _detailsCtrl.text;
        newToDo.done = update != null ? !update : false;
        result = await client.HttpClient.createToDo(
          context.read<User>().tokenJWT!,
          newToDo,
        );
      } else {
        result = await client.HttpClient.createToDo(
          context.read<User>().tokenJWT!,
          ToDo(
            id: const Uuid().v1(),
            type: 'todo',
            title: _titleCtrl.text,
            text: _detailsCtrl.text,
            done: false,
          ),
        );
      }
      if (!result['success']) {
        setState(() {
          _saveAndDeleExit = false;
        });
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
        Navigator.pop(context, true);
      }
    } on DioError catch (_) {
      setState(() {
        _saveAndDeleExit = false;
      });
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
      setState(() {
        _saveAndDeleExit = false;
      });
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

  Future<void> _delete() async {
    setState(() {
      _saveAndDeleExit = true;
    });
    try {
      if (widget.toDo == null) {
        Navigator.pop(context);
      } else {
        Map<String, dynamic> result = await client.HttpClient.deleteToDo(
          context.read<User>().tokenJWT!,
          widget.toDo!.id!,
        );
        if (!result['success']) {
          setState(() {
            _saveAndDeleExit = true;
          });
          showDialog(
            context: context,
            builder: (context) => AppAlertDialog(
              alertType: AlertType.error,
              message: ErrorCatalog.getErrorMessage(
                result['error']['code'],
              ),
              actions: [
                AppAlertDialogButton(
                  onPressed: () => Navigator.pop(context),
                  text: 'Fechar',
                ),
              ],
            ),
          );
        } else {
          Navigator.pop(context, true);
        }
      }
    } on DioError catch (_) {
    } catch (_) {
      setState(() {
        _saveAndDeleExit = true;
      });
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

  Future<void> _toggleStatus() async {
    await _save(update: widget.toDo!.done!);
  }

  @override
  void initState() {
    _titleCtrl = TextEditingController(
      text: widget.toDo != null ? widget.toDo!.title : null,
    );
    _detailsCtrl = TextEditingController(
      text: widget.toDo != null ? widget.toDo!.text : null,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_saveAndDeleExit) {
          return true;
        } else if (((_titleCtrl.text.isNotEmpty ||
                    _titleCtrl.text.isNotEmpty) &&
                widget.toDo == null) ||
            (widget.toDo != null &&
                (_titleCtrl.text != widget.toDo!.title ||
                    _detailsCtrl.text != widget.toDo!.text))) {
          return await showDialog(
            context: context,
            builder: (context) => AppAlertDialog(
              alertType: AlertType.warning,
              message: 'Sair e descartar mudanças?',
              actions: [
                AppAlertDialogButton(
                  onPressed: () => Navigator.pop(context, false),
                  text: 'Cancelar',
                ),
                AppAlertDialogButton(
                  onPressed: () => Navigator.pop(context, true),
                  text: 'Sair',
                ),
              ],
            ),
          );
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: _save,
              icon: const Icon(Icons.save_rounded),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: _delete,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.delete_rounded),
                      SizedBox(width: 10),
                      Text('Apagar'),
                    ],
                  ),
                ),
                if (widget.toDo != null)
                  PopupMenuItem(
                    onTap: _toggleStatus,
                    child: widget.toDo!.done!
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.close_rounded),
                              SizedBox(width: 10),
                              Text('Não concluída'),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.task_alt_rounded),
                              SizedBox(width: 10),
                              Text('Concluída'),
                            ],
                          ),
                  ),
              ],
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      hintText: 'Título',
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                    maxLength: 25,
                  ),
                  const DottedLine(),
                  TextField(
                    controller: _detailsCtrl,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Detalhes',
                    ),
                    minLines: 30,
                    maxLines: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
