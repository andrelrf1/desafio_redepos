import 'dart:ui';
import 'package:desafio/core/error_catalog.dart';
import 'package:desafio/core/http_client.dart' as client;
import 'package:desafio/models/to_do.dart';
import 'package:desafio/models/user.dart';
import 'package:desafio/screens/init/widgets/app_bar_button.dart';
import 'package:desafio/screens/init/widgets/to_do_list.dart';
import 'package:desafio/screens/init/widgets/user_app_bar_widget.dart';
import 'package:desafio/screens/login/login_screen.dart';
import 'package:desafio/screens/to_do/to_do_screen.dart';
import 'package:desafio/screens/widgets/app_alert_dialog.dart';
import 'package:desafio/screens/widgets/app_alert_dialog_button.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  late final User _userDetails;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<ToDo> _doneToDos = [];
  List<ToDo> _toDos = [];
  int _index = 0;
  bool _animateExpand = false;
  bool _showUserData = false;

  Future<void> _getToDos() async {
    try {
      Map<String, dynamic> result = await client.HttpClient.listToDos(
        context.read<User>().tokenJWT!,
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
        List<ToDo> newToDos = [];
        List<ToDo> newDoneToDos = [];
        List<Map<String, dynamic>> toDoData = result['data'];
        for (Map<String, dynamic> data in toDoData) {
          if (data['done']) {
            newDoneToDos.add(ToDo(
              id: data['id'],
              title: data['title'],
              text: data['text'],
              type: data['type'],
              done: data['done'],
            ));
          } else {
            newToDos.add(ToDo(
              id: data['id'],
              title: data['title'],
              text: data['text'],
              type: data['type'],
              done: data['done'],
            ));
          }
        }
        if (mounted) {
          setState(() {
            _toDos = newToDos;
            _doneToDos = newDoneToDos;
          });
        }
      }
    } on DioError catch (_) {
      AppAlertDialog(
        alertType: AlertType.error,
        message: ErrorCatalog.getErrorMessage(1101),
        actions: [
          AppAlertDialogButton(
            onPressed: () => Navigator.pop(context),
            text: 'Fechar',
          ),
        ],
      );
    } catch (_) {
      AppAlertDialog(
        alertType: AlertType.error,
        message: ErrorCatalog.getErrorMessage(1102),
        actions: [
          AppAlertDialogButton(
            onPressed: () => Navigator.pop(context),
            text: 'Fechar',
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    _userDetails = context.read<User>();
    _getToDos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ToDoList(
            toDos: _index == 0 ? _toDos : _doneToDos,
            onRefresh: _getToDos,
            refreshKey: _refreshIndicatorKey,
          ),
          Visibility(
            visible: _animateExpand,
            child: InkWell(
              onTap: () {
                setState(() {
                  _animateExpand = !_animateExpand;
                  _showUserData = false;
                });
              },
              splashColor: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height - 95.0,
                margin: const EdgeInsets.only(top: 95.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
          UserAppBarWidget(
            userName: _userDetails.name!,
            email: _userDetails.email,
            animateExpand: _animateExpand,
            showUserData: _showUserData,
            onTap: () {
              setState(() {
                _animateExpand = !_animateExpand;
                _showUserData = false;
              });
            },
            onAnimationEnd: () {
              setState(() {
                if (_animateExpand) {
                  _showUserData = true;
                }
              });
            },
            buttons: [
              AppBarButton(
                icon: const Icon(Icons.summarize_rounded),
                buttonText: 'Em progresso',
                border: _index == 0
                    ? Border.all(
                        color: Colors.grey.withOpacity(0.8),
                        width: 2.5,
                      )
                    : null,
                onPress: () {
                  if (_index != 0) {
                    setState(() {
                      _index = 0;
                      _animateExpand = !_animateExpand;
                      _showUserData = false;
                    });
                  }
                },
              ),
              const SizedBox(width: 10.0),
              AppBarButton(
                icon: const Icon(Icons.task),
                buttonText: 'Concluído',
                border: _index == 1
                    ? Border.all(
                        color: Colors.grey.withOpacity(0.8),
                        width: 2.5,
                      )
                    : null,
                onPress: () {
                  if (_index != 1) {
                    setState(() {
                      _index = 1;
                      _animateExpand = !_animateExpand;
                      _showUserData = false;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: !_animateExpand,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () async {
            bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ToDoScreen(),
              ),
            );
            if (result != null && result) {
              _refreshIndicatorKey.currentState!.show();
            }
          },
          child: const Icon(Icons.add),
          elevation: 0.0,
        ),
      ),
    );
  }
}
