import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickstart/models/task_model.dart';
import 'package:quickstart/pages/settings_page.dart';
import 'package:quickstart/pages/task_list_page.dart';
import 'package:quickstart/sqlite/sqlite_repository.dart';
import 'package:quickstart/widgets/add_task_widget.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.dbHelper});

  DatabaseConfiguration dbHelper;

  static String tag = '/home';

  @override
  State<HomePage> createState() => _HomePageState(dbHelper);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.dbHelper);

  DatabaseConfiguration dbHelper;

  List<TaskModel> taskList = [];
  int selected = 0;
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
          opacity: 0.3,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(
              Icons.list,
            ),
            title: const Text('Tarefas'),
          ),
          BottomBarItem(
            icon: const Icon(
              Icons.settings,
            ),
            selectedIcon: const Icon(
              Icons.settings,
            ),
            title: const Text(
              'Configuração',
            ),
          ),
        ],
        iconSpace: 5.0,
        hasNotch: true,
        currentIndex: selected,
        notchStyle: NotchStyle.square,
        onTap: (index) {
          controller.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          setState(() {
            selected = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showDialog();
          });
        },
        backgroundColor: Colors.white,
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.green,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            // Atualiza o índice 'selected' quando deslizar para a direita/esquerda
            setState(() {
              selected = index;
            });
          },
          children: [
            Center(
              child: TaskListPage(
                taskList: taskList,
              ),
            ),
            Center(
                child: SettingsPage(
              dbHelper: dbHelper,
            )),
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF4F4F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    // Pill
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF595959),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  AddTaskWidget(addTask: addTask),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void addTask(TaskModel taskModel) {
    setState(() {
      taskList.add(taskModel);
    });
  }
}
