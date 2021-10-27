import 'package:desafio/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const SplashScreen(),
    );
  }
}
