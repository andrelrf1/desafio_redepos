import 'package:flutter/material.dart';

class SubmitButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Text buttonName;

  const SubmitButtonWidget({
    required this.onPressed,
    required this.buttonName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45.0)),
      minWidth: double.infinity,
      height: 45.0,
      color: Theme.of(context).primaryColor,
      child: buttonName,
    );
  }
}
