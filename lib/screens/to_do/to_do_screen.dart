import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _detailsCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save_rounded),
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
    );
  }
}
