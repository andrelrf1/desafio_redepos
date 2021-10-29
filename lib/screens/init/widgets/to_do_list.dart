import 'package:desafio/models/to_do.dart';
import 'package:desafio/screens/init/widgets/to_do_tile_widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class ToDoList extends StatelessWidget {
  final List<ToDo> toDos;
  final RefreshCallback onRefresh;
  final GlobalKey<RefreshIndicatorState> refreshKey;

  const ToDoList({
    required this.toDos,
    required this.onRefresh,
    required this.refreshKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 120.0,
      margin: const EdgeInsets.only(top: 120.0),
      child: Scrollbar(
        child: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            await onRefresh();
          },
          child: toDos.isNotEmpty
              ? ListView.separated(
                  itemCount: toDos.length,
                  padding: const EdgeInsets.only(
                    right: 20.0,
                    left: 20.0,
                    top: 35.0,
                  ),
                  itemBuilder: (_, index) => ToDoTileWidget(
                    toDo: toDos[index],
                    refreshKey: refreshKey,
                  ),
                  separatorBuilder: (_, __) => const DottedLine(),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 120.0,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          size: 150.0,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          'Tudo quieto aqui por enquanto...',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
