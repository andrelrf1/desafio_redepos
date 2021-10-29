import 'package:flutter/material.dart';

class GoToSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoToSignInButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'Ainda não tem uma conta?',
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}
