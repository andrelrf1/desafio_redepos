import 'package:desafio/screens/to_do/to_do_screen.dart';
import 'package:flutter/material.dart';

class ToDoTileWidget extends StatelessWidget {
  final String title;

  const ToDoTileWidget({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ToDoScreen(),
          ),
        );
      },
    );
  }
}
