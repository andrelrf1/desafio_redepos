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
      child: const Text('Ainda não tem uma conta?'),
    );
  }
}
