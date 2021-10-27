import 'package:desafio/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class UserAppBarWidget extends StatefulWidget {
  final String userName;
  final String email;
  final int toDoCompleted;
  final int toDoRemaining;
  final VoidCallback onTap;
  final VoidCallback onAnimationEnd;
  final bool animateExpand;
  final bool showUserData;

  const UserAppBarWidget({
    required this.userName,
    required this.email,
    required this.toDoCompleted,
    required this.toDoRemaining,
    required this.onTap,
    required this.onAnimationEnd,
    required this.animateExpand,
    required this.showUserData,
    Key? key,
  }) : super(key: key);

  @override
  _UserAppBarWidgetState createState() => _UserAppBarWidgetState();
}

class _UserAppBarWidgetState extends State<UserAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(40.0),
      ),
      onTap: widget.onTap,
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width,
        height: widget.animateExpand ? 168.0 : 130.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.fastOutSlowIn,
        constraints: widget.animateExpand
            ? const BoxConstraints(minHeight: 0.0, maxHeight: 300.0)
            : const BoxConstraints(maxHeight: 200.0),
        decoration: BoxDecoration(
          color: widget.animateExpand
              ? Theme.of(context).primaryColor
              : const Color(0xffFCE399),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(40.0),
          ),
        ),
        onEnd: widget.onAnimationEnd,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          maxRadius: 30.0,
                          child: Icon(Icons.person_outline_rounded),
                        ),
                        const SizedBox(width: 10.0),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userName,
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            Text(widget.email),
                          ],
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: const Text(
                        'Sair',
                        style: TextStyle(color: Color(0xff211D14)),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.showUserData)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15.0,
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.radio_button_unchecked_rounded,
                            color: Color(0xff211D14),
                          ),
                          const SizedBox(width: 8.0),
                          Text(widget.toDoRemaining.toString()),
                        ],
                      ),
                      const SizedBox(width: 15.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.task_alt_rounded,
                            color: Color(0xff211D14),
                          ),
                          const SizedBox(width: 8.0),
                          Text(widget.toDoCompleted.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
