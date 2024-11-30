import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickstart/config/notification_configuration.dart';
import 'package:quickstart/models/task_model.dart';
import 'package:quickstart/models/user_model.dart';
import 'package:quickstart/pages/task_page.dart';
import 'package:quickstart/sqlite/sqlite_repository.dart';
import 'package:quickstart/widgets/default_colors.dart';
import '../widgets/task_list_item_widget.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => TaskListPageState();
}

class TaskListPageState extends State<TaskListPage> {
  List<TaskModel> allTasks = [];
  final DatabaseConfiguration dbHelper = DatabaseConfiguration();
  final TextEditingController taskTextField = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final notificationConfig = NotificationConfig();
  List<TaskModel> filteredTaskList = [];
  bool isDropdownVisible = false;
  bool isLoadingTasks = false;

  @override
  void initState() {
    super.initState();
    filteredTaskList = [];
    loadTasks(true);
    _searchController.addListener(_onSearchChanged);
  }

  void updatePage() {
    setState(() {
      loadTasks(true);
    });
  }

  Future<List<TaskModel>> loadTasks(bool loadingTask) async {
    print("atualizando pagina? $loadingTask");
    isLoadingTasks = loadingTask;
    UserModel? user = await dbHelper.getLoggedInUser();
    if (await dbHelper.isUserLoggedIn() && user != null) {
      var tasks = await dbHelper.getAllTasks(user.id!);
      allTasks = tasks;
      return tasks;
    }
    return allTasks;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredTaskList = allTasks
          .where((task) => task.title!.toLowerCase().contains(query))
          .toList();
      isDropdownVisible = filteredTaskList.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).unfocus();
          isDropdownVisible = false;
        });
      },
      child: Scaffold(
        backgroundColor: DefaultColors.background,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    Text(
                      "Tarefas",
                      style:
                          TextStyle(color: DefaultColors.title, fontSize: 32),
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder(
                      future: Future.wait([
                        loadTasks(isLoadingTasks),
                        // o futuro que carrega suas subtasks
                        // Future.delayed(Duration(milliseconds: 200)),
                        // garante o atraso mínimo de 200ms
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            isLoadingTasks == true) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text("Erro ao carregar tasks"));
                        } else {
                          isLoadingTasks = false;
                          // Exibe a lista de subtasks quando carregadas
                          return Column(
                            children: [
                              _buildPendingTaskList(allTasks),
                              _buildCompletedTaskList(allTasks)
                            ],
                          );
                        }
                      },
                    ),

                    // _buildPendingTaskList(),
                    // _buildCompletedTaskList()
                  ],
                ),
              ),
            ),
            if (isDropdownVisible) _buildDropdownSuggestions(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: DefaultColors.title), // Cor do texto digitado
        cursorColor: DefaultColors.cardBackgroud, // Cor do cursor
        decoration: InputDecoration(
          hintText: "Buscar...",
          hintStyle: TextStyle(color: DefaultColors.title),
          prefixIcon: Icon(Icons.search, color: DefaultColors.title),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: DefaultColors.searchBarBackground,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        ),
      ),
    );
  }

  Widget _buildDropdownSuggestions() {
    return Positioned(
      left: 10,
      right: 10,
      top: 80,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 200),
          // Limita a altura do dropdown
          decoration: BoxDecoration(
            color: DefaultColors.searchBarBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredTaskList.length,
            itemBuilder: (context, index) {
              final task = filteredTaskList[index];
              return ListTile(
                title: Text(
                  task.title!,
                  style: TextStyle(color: DefaultColors.title),
                ),
                onTap: () {
                  _searchController.text = task.title!;
                  _onSearchChanged();
                  FocusScope.of(context).unfocus();
                  setState(() {
                    isDropdownVisible = false;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskPage(task: task),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPendingTaskList(List<TaskModel> allTasks) {
    final pendingTasks =
        allTasks.where((task) => task.state == TaskState.pending).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pendingTasks.length,
      itemBuilder: (context, index) {
        final task = pendingTasks[index];
        return TaskListItem(
          task: task,
          onDelete: _onDelete,
          onDone: _onDone,
          unDone: _unDone,
          onEdit: _onEdit,
        );
      },
    );
  }

  Widget _buildCompletedTaskList(List<TaskModel> allTasks) {
    final completedTasks =
        allTasks.where((task) => task.state == TaskState.completed).toList();
    String completedText = completedTasks.isEmpty ? '' : 'Concluídos';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          completedText,
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: DefaultColors.title),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: completedTasks.length,
          itemBuilder: (context, index) {
            final task = completedTasks[index];
            return TaskListItem(
              task: task,
              onDelete: _onDelete,
              onDone: _onDone,
              unDone: _unDone,
              onEdit: _onEdit,
            );
          },
        )
      ],
    );
  }

  void _onDelete(TaskModel task) {
    setState(() {
      dbHelper.deleteTask(task);
      loadTasks(true);
      filteredTaskList = allTasks
          .where((task) => task.title!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tarefa \"${task.title}\" foi removida!"),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () {
            setState(() {
              dbHelper.addTask(task);
              loadTasks(true);
            });
          },
        ),
      ),
    );
  }

  void _onDone(TaskModel task) {
    setState(() {
      dbHelper.updateTaskState(task.id!, TaskState.completed.name);
      setState(() {
        loadTasks(true);
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tarefa \"${task.title}\" concluída!"),
        action: SnackBarAction(
            label: "desfazer",
            onPressed: () {
              setState(() {
                dbHelper.updateTaskState(task.id!, TaskState.pending.name);
                loadTasks(true);
              });
            }),
      ),
    );
  }

  void _unDone(TaskModel task) {
    setState(() {
      dbHelper.updateTaskState(task.id!, TaskState.pending.name);
      loadTasks(true);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tarefa \"${task.title}\" esta pendente!"),
        action: SnackBarAction(
            label: "desfazer",
            onPressed: () {
              setState(() {
                dbHelper.updateTaskState(task.id!, TaskState.completed.name);
                loadTasks(true);
              });
            }),
      ),
    );
  }

  void _onEdit(TaskModel taskModel) async {
    final int id = await dbHelper.editTask(taskModel);
    if (taskModel.completionDate != null &&
        taskModel.completionDate!.isNotEmpty) {
      String dateString =
          taskModel.completionDate!; // Exemplo de data no formato definido
      DateFormat format = DateFormat('dd/MM/yyyy - HH:mm:ss');

      DateTime parsedDate = format.parse(dateString);

      notificationConfig.scheduleNotifications(
          id, taskModel.title!, parsedDate);
    }
    Navigator.of(context).pop();
    setState(() {
      loadTasks(true);
    });
  }
}
