import 'package:flutter/material.dart';
import 'package:quickstart/models/task_model.dart';
import '../widgets/task_list_item_widget.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key, required this.taskList});

  final List<TaskModel> taskList;

  @override
  State<TodoListPage> createState() => _TodoListPageState(taskList);
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController taskTextField = TextEditingController();

  _TodoListPageState(this.taskList);

 final List<TaskModel> taskList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (TaskModel task in taskList)
                        // if (task.state.name == "pending")
                        Row(
                          children: [
                            Expanded(
                              child: TaskListItem(
                                  task: task,
                                  onDelete: onDelete,
                                  onDone: onDone),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                              "Voce possui ${taskList.length} tarefas pendentes!")),
                      ElevatedButton(
                        onPressed: () {
                          if (taskList.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                    "Adicione uma tarefa para limpar a lista!",
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade900),
                                  ),
                                  backgroundColor: Colors.grey.shade200,
                                  showCloseIcon: false),
                            );
                            return;
                          }
                          showTaskDeleteConfirmationDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          backgroundColor: Colors.lightBlueAccent,
                          padding: const EdgeInsets.all(10),
                        ),
                        child: const Text(
                          "Limpar tudo",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 8), // Padding lateral de 8 pixels
            child: AlertDialog(
              title: Text("Qual é sua nova tarefa?"),
              content: getAddTaskRow(),
            ),
          ),
        ],
      ),
    );
  }

  void showTaskDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Limpar tudo."),
        content:
            const Text("Voce tem certeza que deseja apagar todas as tarefas?"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.indigo,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancelar",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {
              deleteAllTasks();
              Navigator.of(context).pop();
            },
            child: const Text(
              "Limpar tudo",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAddTaskRow() {
    return Column(
      children: [
        TextField(
          controller: taskTextField,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Adicione uma tarefa",
              hintText: "Ex. Limpar o lustre."),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: taskTextField,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Adiciona uma descrição",
              hintText: "Ex. Pedido do josé"),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (taskTextField.text.isEmpty) {
                return;
              }
              TaskModel task = TaskModel(
                  taskTextField.text, DateTime.now(), TaskState.pending, 'nada');
              taskList.add(task);
              taskTextField.clear();
            });
          },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            enableFeedback: true,
            backgroundColor: Colors.lightBlueAccent,
            padding: const EdgeInsets.all(16),
          ),
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void onDelete(TaskModel task) {
    int taskPosition = taskList.indexOf(task);

    setState(() {
      taskList.remove(task);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            "Tarefa \"${task.title}\" foi removida!",
            style: TextStyle(color: Colors.blueGrey.shade900),
          ),
          backgroundColor: Colors.grey.shade200,
          action: SnackBarAction(
            label: 'Recuperar',
            textColor: Colors.green,
            onPressed: () {
              setState(() {
                taskList.insert(taskPosition, task);
              });
            },
          ),
          showCloseIcon: false),
    );
  }

  void onDone(TaskModel task) {
    setState(() {
      task.state = TaskState.completed;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            "Tarefa \"${task.title}\" completa!",
            style: TextStyle(color: Colors.blueGrey.shade900),
          ),
          backgroundColor: Colors.grey.shade200,
          action: SnackBarAction(
            label: 'Desfazer',
            textColor: Colors.green,
            onPressed: () {
              setState(() {
                task.state = TaskState.pending;
              });
            },
          ),
          showCloseIcon: false),
    );
  }

  void deleteAllTasks() {
    setState(() {
      taskList.clear();
    });
  }

  Widget addNewTask() {
    return FloatingActionButton(
      onPressed: () {
        showAddTaskDialog();
      },
      backgroundColor: Colors.blue,
      heroTag: "Adicionar tarefa",
      tooltip: 'Adicionar tarefa',
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Widget float2() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.blue,
      heroTag: "home",
      tooltip: 'Home',
      child: const Icon(
        Icons.home,
        color: Colors.white,
      ),
    );
  }
}
