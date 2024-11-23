import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickstart/config/notification_configuration.dart';
import 'package:quickstart/models/task_model.dart';
import 'package:quickstart/pages/settings_page.dart';
import 'package:quickstart/pages/settings_page.dart';
import 'package:quickstart/pages/task_list_page.dart';
import 'package:quickstart/sqlite/sqlite_repository.dart';
import 'package:quickstart/widgets/add_task_widget.dart';
import 'package:quickstart/widgets/default_colors.dart';
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
  final notificationConfig = NotificationConfig();

  final GlobalKey<TaskListPageState> taskListKey = GlobalKey<TaskListPageState>();

  int selected = 0;
  final controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      bottomNavigationBar: StylishBottomBar(
        backgroundColor: DefaultColors.navbarBackground,
        elevation: 0,
        option: AnimatedBarOptions(
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.Default,
          inkColor: DefaultColors.navbarBackground,
          opacity: 0.5,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(
              Icons.list,
            ),
            selectedColor: DefaultColors.navbarSelectedIcons,
            unSelectedColor: DefaultColors.navbarIcons,
            title: const Text(
              'Tarefas',
              style: TextStyle(),
            ),
          ),
          BottomBarItem(
            icon: InkWell(
              onTap: _showDialog,
              child: const Icon(
                Icons.add_rounded,
              ),
            ),
            selectedColor: DefaultColors.navbarSelectedIcons,
            unSelectedColor: DefaultColors.navbarIcons,
            title: InkWell(
              onTap: _showDialog,
              child: const Text(
                'Nova Tarefa',
                style: TextStyle(),
              ),
            ),
          ),
          BottomBarItem(
            icon: const Icon(
              Icons.settings,
            ),
            selectedColor: DefaultColors.navbarSelectedIcons,
            unSelectedColor: DefaultColors.navbarIcons,
            title: const Text(
              'Configuração',
            ),
          ),
        ],
        iconSpace: 5.0,
        hasNotch: true,
        currentIndex: selected,
        notchStyle: NotchStyle.themeDefault,
        onTap: (index) {
          if (index == 1) {
            _showDialog;
            return;
          }
          controller.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);

          setState(() {
            selected = index;
          });
        },
      ),
      body: SafeArea(
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            if (index == 1) index++;
            // Atualiza o índice 'selected' quando deslizar para a direita/esquerda
            setState(() {
              selected = index;
            });
          },
          children: [
            Center(
              child: TaskListPage(key: taskListKey),
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
            decoration: BoxDecoration(
              color: DefaultColors.background,
              borderRadius: const BorderRadius.only(
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
                      color: DefaultColors.title,
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

  void addTask(TaskModel taskModel) async {
    final int id = await dbHelper.addTask(taskModel);
    if(taskModel.completionDate != null && taskModel.completionDate!.isNotEmpty) {
      String dateString = taskModel.completionDate!; // Exemplo de data no formato definido
      DateFormat format = DateFormat('dd/MM/yyyy - HH:mm:ss');

      DateTime parsedDate = format.parse(dateString);

      notificationConfig.scheduleNotifications(id, taskModel.title!, parsedDate);
    }
    Navigator.of(context).pop();
    taskListKey.currentState?.updatePage();
    setState(() {});
  }
}