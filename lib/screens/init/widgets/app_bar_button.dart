import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final VoidCallback onPress;
  final String buttonText;
  final Icon icon;
  final Border? border;

  const AppBarButton({
    required this.onPress,
    required this.buttonText,
    required this.icon,
    required this.border,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _appBarButtonsWidth = (MediaQuery.of(context).size.width - 60) / 3;
    return Material(
      borderRadius: BorderRadius.circular(20.0),
      color: const Color(0xffFCE399),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: onPress,
        child: Container(
          height: 80.0,
          width: _appBarButtonsWidth,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: border,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              Text(buttonText),
            ],
          ),
        ),
      ),
    );
  }
}
