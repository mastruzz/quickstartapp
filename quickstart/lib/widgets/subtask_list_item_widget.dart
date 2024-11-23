import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quickstart/models/subtask_model.dart';
import 'package:quickstart/models/task_model.dart';
import 'package:quickstart/widgets/default_colors.dart';

class SubtaskListItem extends StatefulWidget {
  const SubtaskListItem(
      {super.key,
      required this.task,
      required this.onDelete,
      required this.onDone,
      required this.unDone});

  final SubtaskModel task;
  final Function(SubtaskModel) onDelete;
  final Function(SubtaskModel) onDone;
  final Function(SubtaskModel) unDone;

  @override
  State<SubtaskListItem> createState() =>
      _SubtaskListItem(task, onDelete, onDone, unDone);
}

class _SubtaskListItem extends State<SubtaskListItem>
    with SingleTickerProviderStateMixin {
  _SubtaskListItem(this.task, this.onDelete, this.onDone, this.unDone);

  late final controller = SlidableController(this);
  SubtaskModel task;
  final Function(SubtaskModel) onDelete;
  final Function(SubtaskModel) onDone;
  final Function(SubtaskModel) unDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
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
              onPressed: (context) {
                onDelete(task);
              },
              borderRadius: BorderRadius.circular(30),
              autoClose: true,
              backgroundColor: DefaultColors.cardBorder,
              icon: Icons.delete,
              label: 'Deletar',
            ),
            const SizedBox(
              width: 4,
            ),
          ],
        ),
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
                    color: DefaultColors.subtitle,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
        // foregroundColor:DefaultColors.cardBackgroud ,
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
      foregroundColor: DefaultColors.subtitle,
      icon: Icons.cancel,
      label: 'Desconcluir',
    );
  }
}
