import 'package:quickstart/models/task_model.dart';

class Subtask {
  int? id;
  String title;
  TaskState state;
  int taskId;

  // Construtor
  Subtask({
    this.id,
    required this.title,
    required this.state,
    required this.taskId,
  });

  // Converter objeto Subtask para Map (para salvar no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'state': state,
      'taskId': taskId,
    };
  }

  // Converter Map para objeto Subtask (ao recuperar do banco de dados)
  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(
      id: map['id'],
      title: map['title'],
      state: map['state'],
      taskId: map['taskId'],
    );
  }
}
