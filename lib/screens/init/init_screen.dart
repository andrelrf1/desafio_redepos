import 'package:desafio/screens/init/widgets/to_do_tile_widget.dart';
import 'package:desafio/screens/init/widgets/user_app_bar_widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> with TickerProviderStateMixin {
  late final TabController _tabCtrl;
  bool _animateExpand = false;
  bool _showUserData = false;

  @override
  void initState() {
    _tabCtrl = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 95.0,
            margin: const EdgeInsets.only(top: 95.0),
            child: Scrollbar(
              child: ListView.separated(
                itemCount: 5,
                padding: const EdgeInsets.only(
                  right: 20.0,
                  left: 20.0,
                  top: 35.0,
                ),
                itemBuilder: (_, index) => ToDoTileWidget(
                  title: 'Tarefa $index',
                ),
                separatorBuilder: (_, __) => const DottedLine(),
              ),
            ),
          ),
          if (_animateExpand)
            InkWell(
              onTap: () {
                setState(() {
                  _animateExpand = !_animateExpand;
                  _showUserData = false;
                });
              },
              splashColor: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height - 95.0,
                margin: const EdgeInsets.only(top: 95.0),
              ),
            ),
          UserAppBarWidget(
            userName: 'User name',
            email: 'email@email.com',
            toDoCompleted: 0,
            toDoRemaining: 0,
            animateExpand: _animateExpand,
            showUserData: _showUserData,
            onTap: () {
              setState(() {
                _animateExpand = !_animateExpand;
                _showUserData = false;
              });
            },
            onAnimationEnd: () {
              setState(() {
                if (_animateExpand) {
                  _showUserData = true;
                }
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.withOpacity(0.2),
        elevation: 0.0,
        shape: AutomaticNotchedShape(
          ContinuousRectangleBorder(),
          RoundedRectangleBorder(
            side: BorderSide(width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        // notchMargin: 22.0,
        child: Container(
          height: kToolbarHeight,
          child: TabBar(
            padding: EdgeInsets.only(right: 95),
            controller: _tabCtrl,
            tabs: [
              Tab(
                text: 'Em progresso',
              ),
              Tab(
                text: 'Concluidos',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onPressed: () {},
        child: const Icon(Icons.add),
        elevation: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
