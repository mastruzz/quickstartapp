import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quickstart/models/task_model.dart';
import 'package:quickstart/pages/task_page.dart';
import 'package:quickstart/widgets/default_colors.dart';
import 'package:quickstart/widgets/edit_task_widget.dart';

class TaskListItem extends StatefulWidget {
  const TaskListItem(
      {super.key,
      required this.task,
      required this.onDelete,
      required this.onEdit,
      required this.unDone,
      required this.onDone});

  final TaskModel task;
  final Function(TaskModel) onDelete;
  final Function(TaskModel) onDone;
  final Function(TaskModel) unDone;
  final Function(TaskModel) onEdit;

  @override
  State<TaskListItem> createState() =>
      _TaskListItem(task, onDelete, onDone, unDone, onEdit);
}

class _TaskListItem extends State<TaskListItem>
    with SingleTickerProviderStateMixin {
  _TaskListItem(
      this.task, this.onDelete, this.onDone, this.unDone, this.onEdit);

  late final controller = SlidableController(this);
  TaskModel task;
  final Function(TaskModel) onDelete;
  final Function(TaskModel) onDone;
  final Function(TaskModel) unDone;
  final Function(TaskModel) onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            const SizedBox(
              width: 4,
            ),
            getDoneButton(),
            const SizedBox(
              width: 4,
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            const SizedBox(
              width: 4,
            ),
            SlidableAction(
              onPressed: (BuildContext context) {
                _showDialog(context);
              },
              borderRadius: BorderRadius.circular(30),
              autoClose: true,
              backgroundColor: DefaultColors.cardBorder,
              // foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Editar',
            ),
            const SizedBox(
              width: 4,
            ),
            SlidableAction(
              onPressed: (context) {
                onDelete(task);
              },
              borderRadius: BorderRadius.circular(30),
              autoClose: true,
              backgroundColor: DefaultColors.cardBorder,
              // foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Deletar',
            ),
            const SizedBox(
              width: 4,
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskPage(task: task),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: DefaultColors.cardBorder,
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
                    style: TextStyle(
                      color: DefaultColors.title,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    task.description!,
                    style: TextStyle(
                      color: DefaultColors.subtitle,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getFormatedDate() {
    if (task.completionDate != null) {
      return task.completionDate!;
    } else {
      return "Não há data de Conclusão.";
    }
  }

  Color getTaskBackgroudColor(TaskState? taskState) {
    switch (taskState) {
      case TaskState.pending:
        return DefaultColors.cardBackgroud;
      case TaskState.completed:
        return DefaultColors.doneCardBackgroud;
      case TaskState.cancelled:
        return Colors.redAccent;
      case null:
        return DefaultColors.yellow;
    }
  }

  SlidableAction getDoneButton() {
    if (task.state! == TaskState.pending) {
      return SlidableAction(
        onPressed: (context) {
          onDone(task);
        },
        spacing: 2.0,
        autoClose: true,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        borderRadius: BorderRadius.circular(30),
        backgroundColor: DefaultColors.doneCardBackgroud,
        // foregroundColor: Colors.white,
        icon: Icons.done,
        label: 'Concluir',
      );
    }
    return SlidableAction(
      onPressed: (context) {
        unDone(task);
      },
      autoClose: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      borderRadius: BorderRadius.circular(30),
      backgroundColor: DefaultColors.cardBackgroud,
      // foregroundColor: Colors.white,
      icon: Icons.cancel,
      label: 'Desconcluir',
    );
  }

  void _showDialog(BuildContext context) {
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
                  EditTaskWidget(
                    editTask: onEdit,
                    taskModel: task,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
