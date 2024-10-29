import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:quickstart/models/task_model.dart';
import 'package:quickstart/widgets/default_colors.dart';

class TaskListItem extends StatefulWidget {
  const TaskListItem(
      {super.key,
      required this.task,
      required this.onDelete,
      required this.onDone});

  final TaskModel task;
  final Function(TaskModel) onDelete;
  final Function(TaskModel) onDone;

  @override
  State<TaskListItem> createState() => _TaskListItem(task, onDelete, onDone);
}

class _TaskListItem extends State<TaskListItem>
    with SingleTickerProviderStateMixin {
  _TaskListItem(this.task, this.onDelete, this.onDone);

  late final controller = SlidableController(this);
  TaskModel task;
  final Function(TaskModel) onDelete;
  final Function(TaskModel) onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                onDone(task);
              },
              autoClose: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              borderRadius: BorderRadius.circular(30),
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.done,
              label: 'Concluir',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                onDelete(task);
              },
              borderRadius: BorderRadius.circular(30),
              autoClose: true,
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Deletar',
            )
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: DefaultColors.purple,
              width: 3,
            ),
            color: getTaskBackgroudColor(task.state),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  task.title!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  task.description!,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Text(
                  '1 de 10',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getFormatedDate() {
    if(task.completionDate != null) {
      return task.completionDate!;
    } else {
      return "Não há data de Conclusão.";
    }
  }

  Color getTaskBackgroudColor(TaskState? taskState) {
    switch (taskState) {
      case TaskState.pending:
        return DefaultColors.yellow;
      case TaskState.completed:
        return DefaultColors.oceanGreen;
      case TaskState.cancelled:
        return Colors.redAccent;
      case null:
        return DefaultColors.yellow;
    }
  }
}
