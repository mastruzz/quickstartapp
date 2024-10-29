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
      'taskId': taskId,
    };
  }

  // Converter Map para objeto Subtask (ao recuperar do banco de dados)
  factory SubtaskModel.fromMap(Map<String, dynamic> map) {
    return SubtaskModel(
      id: map['id'],
      title: map['title'],
      state: TaskState.values[map['state']],
      taskId: map['taskId'],
    );
  }

  // Converter objeto Subtask para String JSON
  String toJson() {
    final mapData = {
      'id': id,
      'title': title,
      'state': state?.name,
      'taskId': taskId,
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
      taskId: json['taskId'],
    );
  }

  // Método auxiliar para retornar Map (caso precise ser usado como Map diretamente)
  Map<String, dynamic> toJsonMap() {
    return {
      'id': id,
      'title': title,
      'state': state?.index,
      'taskId': taskId,
    };
  }
}