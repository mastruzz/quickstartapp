// Modelo para Subtask
import 'dart:convert';

import 'package:quickstart/models/task_model.dart';

class SubtaskModel {
  int? id;
  String? title;
  TaskState? state;  // Estado da subtarefa
  int? taskId;  // FK para Task

  // Construtor
  SubtaskModel({
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
      'state': state?.name,  // Armazena o índice do enum
      'task_id': taskId,
    };
  }

  // Converter Map para objeto Subtask (ao recuperar do banco de dados)
  factory SubtaskModel.fromMap(Map<String, dynamic> map) {
    return SubtaskModel(
      id: map['id'],
      title: map['title'],
      state: TaskState.values.firstWhere(
            (e) => e.toString().split('.').last == map['state'],
        orElse: () => TaskState.pending,
      ),
      taskId: map['task_id'],
    );
  }

  // Converter objeto Subtask para String JSON
  String toJson() {
    final mapData = {
      'id': id,
      'title': title,
      'state': state?.name,
      'task_id': taskId,
    };
    return jsonEncode(mapData);
  }

  // Converter JSON String para objeto Subtask
  factory SubtaskModel.fromJson(String source) {
    final json = jsonDecode(source);
    return SubtaskModel.fromJsonMap(json);
  }

  // Método auxiliar para converter Map para objeto Subtask
  factory SubtaskModel.fromJsonMap(Map<String, dynamic> json) {
    return SubtaskModel(
      id: json['id'],
      title: json['title'],
      state: json['state'] != null ? TaskState.values[json['state']] : null,
      taskId: json['task_id'],
    );
  }

  // Método auxiliar para retornar Map (caso precise ser usado como Map diretamente)
  Map<String, dynamic> toJsonMap() {
    return {
      'id': id,
      'title': title,
      'state': state?.index,
      'task_id': taskId,
    };
  }
}