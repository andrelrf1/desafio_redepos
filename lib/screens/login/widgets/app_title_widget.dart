import 'package:flutter/material.dart';

class AppTitleWidget extends StatelessWidget {
  const AppTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/logo.png',
          width: 45.0,
        ),
        const SizedBox(width: 8.0),
        const Text(
          'Tarefas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ],
    );
  }
}
