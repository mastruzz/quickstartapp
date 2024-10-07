import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:runtask/models/task_model.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({super.key, required this.task, required this.onDelete, required this.onDone});

  final TaskModel task;
  final Function(TaskModel) onDelete;
  final Function(TaskModel) onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Slidable(
        actionPane: const SlidableStrechActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            icon: Icons.delete,
            caption: 'Deletar',
            onTap: () {
              onDelete(task);
            },
          )
        ],
        actionExtentRatio: 0.25,
        actions: [
          IconSlideAction(
            color: Colors.green,
            icon: Icons.done,
            caption: 'Concluido',
            onTap: () {
              onDone(task);
            },
          )
        ],
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: getTaskBackgroudColor(task.state),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  getFormatedDate(),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getFormatedDate() {
    return DateFormat('dd/MM/yyyy - HH:mm:ss').format(task.doneDate);
  }

  Color getTaskBackgroudColor(TaskState taskState) {
    switch (taskState) {
      case TaskState.pending:
        return Colors.grey.shade200;
      case TaskState.completed:
        return Colors.lightGreen.shade300;
      case TaskState.cancelled:
        return Colors.redAccent;
    }
  }
}
