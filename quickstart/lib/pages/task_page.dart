import 'package:flutter/material.dart';
import 'package:quickstart/models/subtask_model.dart';
import 'package:quickstart/models/task_model.dart';
import 'package:quickstart/sqlite/sqlite_repository.dart';
import 'package:quickstart/widgets/add_subtask.dart';
import 'package:quickstart/widgets/subtask_list_item_widget.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required this.task});

  final TaskModel task;

  @override
  State<TaskPage> createState() => _TaskPageState(task);
}

class _TaskPageState extends State<TaskPage> {
  _TaskPageState(this.task);

  final TaskModel task;
  late List<SubtaskModel> allSubtasks = [];
  late DatabaseConfiguration dbConfiguration = DatabaseConfiguration();

  @override
  void initState() {
    super.initState();
    loadSubtasks();
  }

  Future<List<SubtaskModel>> loadSubtasks() async {
    var tasks = await dbConfiguration.getAllSubtasks(task.id!);
    allSubtasks = tasks;
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title!,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // FutureBuilder para exibir a lista de subtasks
                    FutureBuilder(
                      future: Future.wait([
                        loadSubtasks(), // o futuro que carrega suas subtasks
                        Future.delayed(Duration(milliseconds: 200)), // garante o atraso mínimo de 1s
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else
                          if (snapshot.hasError) {
                          return const Center(
                              child: Text("Erro ao carregar subtasks"));
                        } else {
                          // Exibe a lista de subtasks quando carregadas
                          return Column(
                            children: [
                              _buildPendingTaskList(allSubtasks),
                              _buildCompletedTaskList(allSubtasks)
                            ],
                          );
                        }
                      },
                    ),
                    // _buildPendingTaskList(),
                    // _buildCompletedTaskList(),
                    _buildAddSubtaskButton(
                        '+ Adicionar passo', Colors.teal[100]),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(Icons.alarm, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Text('Lembre-me',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Text('Adicionar data de conclusão',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Adicionar descrição ...',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Criado às 20:13',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddSubtaskButton(String text, Color? color) {
    return TextButton(
      onPressed: () {
        setState(() {
          _showDialog();
          loadSubtasks();
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ),
      ),
    );
  }

  Widget _buildPendingTaskList(List<SubtaskModel> subtaskList) {
    final pendingTasks =
        subtaskList.where((task) => task.state == TaskState.pending).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pendingTasks.length,
      itemBuilder: (context, index) {
        final task = pendingTasks[index];
        return SubtaskListItem(
          task: task,
          onDelete: _onDelete,
          onDone: _onDone,
        );
      },
    );
  }

  Widget _buildCompletedTaskList(List<SubtaskModel> subtaskList) {
    final completedTasks =
        subtaskList.where((task) => task.state == TaskState.completed).toList();
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
            return SubtaskListItem(
              task: task,
              onDelete: _onDelete,
              onDone: _onDone,
            );
          },
        )
      ],
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
                  AddSubtaskWidget(
                    addTask: _addSubtask,
                    taskId: task.id!,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _addSubtask(SubtaskModel subtask) async {
    setState(() {
      dbConfiguration.addSubtask(subtask);
      Navigator.of(context).pop();
      loadSubtasks();
    });
  }

  void _onDelete(SubtaskModel task) async {
    await dbConfiguration.deleteSubtask(task); // Delete a subtask
    setState(() {
      loadSubtasks(); // Reload the subtasks list
    });

    // Notifica com um SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tarefa \"${task.title}\" foi removida!"),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () async {
            await dbConfiguration.addSubtask(task);
            setState(() {
              loadSubtasks(); // Reload the subtasks list after undo
            });// Undo the delete
          },
        ),
      ),
    );
  }

  void _onDone(SubtaskModel task) async {
    await dbConfiguration.updateSubtaskState(
        task.id!, TaskState.completed.name);
    setState(() {
      loadSubtasks(); // Reload the subtasks list
    });// Update the subtask state

    // Notifica com um SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tarefa \"${task.title}\" concluída!"),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () async {
            await dbConfiguration.updateSubtaskState(
                task.id!, TaskState.pending.name);
            setState(() {
              loadSubtasks();// Reload the subtasks list after undo
            });
          },
        ),
      ),
    );
  }
}
