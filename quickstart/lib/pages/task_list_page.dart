import 'package:flutter/material.dart';
import 'package:quickstart/models/task_model.dart';
import '../widgets/task_list_item_widget.dart';

class TaskListPage extends StatefulWidget {
  final List<TaskModel> taskList;

  const TaskListPage({super.key, required this.taskList});

  @override
  State<TaskListPage> createState() => _TaskListPageState(taskList);
}

class _TaskListPageState extends State<TaskListPage> {
  _TaskListPageState(this.allTasks);

  final List<TaskModel> allTasks;
  final TextEditingController taskTextField = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<TaskModel> filteredTaskList = [];
  bool isDropdownVisible = false;

  @override
  void initState() {
    super.initState();
    filteredTaskList = [];
    _searchController.addListener(_onSearchChanged);
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
          .where((task) => task.title.toLowerCase().contains(query))
          .toList();
      isDropdownVisible = filteredTaskList.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          isDropdownVisible = false;
        });
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F9),
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
                    const Text(
                      "Tarefas",
                      style: TextStyle(color: Colors.black, fontSize: 32),
                    ),
                    const SizedBox(height: 20),
                    _buildPendingTaskList(),
                    _buildCompletedTaskList()
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
        decoration: InputDecoration(
          hintText: "Pesquisar tarefas...",
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredTaskList.length,
            itemBuilder: (context, index) {
              final task = filteredTaskList[index];
              return ListTile(
                title: Text(task.title),
                onTap: () {
                  _searchController.text = task.title;
                  _onSearchChanged();
                  FocusScope.of(context).unfocus();
                  setState(() {
                    isDropdownVisible = false;
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPendingTaskList() {
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
        );
      },
    );
  }

  Widget _buildCompletedTaskList() {
    final completedTasks =
        allTasks.where((task) => task.state == TaskState.completed).toList();
    String completedText = completedTasks.isEmpty ? '' : 'Concluídos';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          completedText,
          style: const TextStyle(
            fontSize: 15,
          ),
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
            );
          },
        )
      ],
    );
  }

  void _onDelete(TaskModel task) {
      setState(() {
        allTasks.remove(task);
        filteredTaskList = allTasks
            .where((task) => task.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tarefa \"${task.title}\" foi removida!"),
        ),
      );
  }

  void _onDone(TaskModel task) {
        setState(() {
          task.state = TaskState.completed;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Tarefa \"${task.title}\" concluída!"),
            action: SnackBarAction(
                label: "desfazer",
                onPressed: () {
                  setState(() {
                    task.state = TaskState.pending;
                  });
                }),
          ),
        );
  }
}
