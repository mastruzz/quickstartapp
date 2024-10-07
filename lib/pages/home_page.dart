import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:runtask/models/task_model.dart';
import 'package:runtask/pages/todo_list_page.dart';
import 'package:runtask/widgets/add_task_widget.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
              Icons.task_sharp,
            ),
            title: const Text('Tarefas'),
          ),
          BottomBarItem(
            icon: const Icon(
              Icons.settings,
            ),
            selectedIcon: const Icon(
              Icons.settings_applications,
            ),
            title: const Text(
              'Configuração',
            ),
          ),
        ],
        hasNotch: true,
        currentIndex: selected,
        notchStyle: NotchStyle.square,
        onTap: (index) {
          if (index == selected) return;
          controller.jumpToPage(index);
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
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: [
            Center(child: TodoListPage(taskList: taskList,)),
            const Center(child: Text('Configuração')),
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
                  Container( // Pill
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