import 'dart:convert';
import 'dart:ffi';

import 'package:quickstart/models/subtask_model.dart';

enum TaskState {
  pending,
  completed,
  cancelled,
}

class TaskModel {
  int? id;
  String? title;
  String? completionDate;  // Usando String para armazenar datas
  String? creationDate;  // Usando String para armazenar datas
  String? description;
  TaskState? state;  // Representa o status da tarefa
  int? userId; // FK para User
  List<SubtaskModel>? subtasks; // Lista de subtarefas

  // Construtor
  TaskModel({
    this.id,
    required this.title,
    this.completionDate,
    required this.creationDate,
    this.description,
    required this.state,
    required this.userId,
    this.subtasks,
  });

  // Converter objeto Task para Map (para salvar no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'completion_date': completionDate,
      'creation_date': creationDate,
      'description': description,
      'state': state?.name,  // Armazena o índice do enum
      'user_id': userId,
    };
  }

  // Converter Map para objeto Task (ao recuperar do banco de dados)
  factory TaskModel.fromMap(Map<String, dynamic> map, {List<SubtaskModel>? subtasks}) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      completionDate: map['completion_date'],
      creationDate: map['creation_date'],
      description: map['description'],
      state: TaskState.values.firstWhere(
            (e) => e.toString().split('.').last == map['state'],
        orElse: () => TaskState.pending,
      ),
      userId: map['user_id'],
      subtasks: subtasks,
    );
  }

  // Converter objeto Task para String JSON
  String toJson() {
    final mapData = {
      'id': id,
      'title': title,
      'completion_date': completionDate,
      'creation_date': creationDate,
      'description': description,
      'state': state?.index,
      'user_id': userId,
      'subtasks': subtasks?.map((subtask) => subtask.toJsonMap()).toList(),
    };
    return jsonEncode(mapData);
  }

  // Converter JSON String para objeto Task
  factory TaskModel.fromJson(String source) {
    final json = jsonDecode(source);
    return TaskModel.fromJsonMap(json);
  }

  // Método auxiliar para converter Map para objeto Task
  factory TaskModel.fromJsonMap(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      completionDate: json['completion_date'],
      creationDate: json['creation_date'],
      description: json['description'],
      state: json['state'] != null ? TaskState.values[json['state']] : null,
      userId: json['user_id'],
      subtasks: (json['subtasks'] as List<dynamic>?)
          ?.map((subtaskJson) => SubtaskModel.fromJsonMap(subtaskJson))
          .toList(),
    );
  }

  // Método auxiliar para retornar Map (caso precise ser usado como Map diretamente)
  Map<String, dynamic> toJsonMap() {
    return {
      'id': id,
      'title': title,
      'completion_date': completionDate,
      'creation_date': creationDate,
      'description': description,
      'user_id': userId,
      'state': state?.index,
      'subtasks': subtasks?.map((subtask) => subtask.toJsonMap()).toList(),
    };
  }
}