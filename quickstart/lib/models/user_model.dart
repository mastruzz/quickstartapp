import 'dart:convert';

import 'package:quickstart/models/task_model.dart';

class UserModel {
  int? id;
  String? fullName;
  String? birthDate; // Usando String para armazenar datas
  String? email;
  String? password;
  String? phone;
  List<TaskModel>? tasks; // Lista de tarefas associadas ao usuário

  // Construtor
  UserModel({
    this.id,
    required this.fullName,
    this.birthDate,
    required this.email,
    required this.password,
    this.phone,
    this.tasks,
  });

  // Converter objeto User para Map (para salvar no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'birth_date': birthDate,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }

  // Converter Map para objeto User (ao recuperar do banco de dados)
  factory UserModel.fromMap(Map<String, dynamic> map,
      {List<TaskModel>? tasks}) {
    return UserModel(
      id: map['id'],
      fullName: map['full_name'],
      birthDate: map['birth_date'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
      tasks: tasks,
    );
  }

  // Converter objeto User para String JSON
  String toJson() {
    final mapData = {
      'id': id,
      'full_name': fullName,
      'birth_date': birthDate,
      'email': email,
      'password': password,
      'phone': phone,
      'tasks': tasks?.map((task) => task.toJsonMap()).toList(),
      // Converter tasks para Map
    };
    return jsonEncode(mapData); // Converte o Map para String JSON
  }

  // Converter JSON String para objeto User
  factory UserModel.fromJson(String source) {
    final json = jsonDecode(source);
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      birthDate: json['birth_date'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      tasks: (json['tasks'] as List<dynamic>?)
          ?.map((taskJson) => TaskModel.fromJsonMap(taskJson))
          .toList(),
    );
  }

  // Método auxiliar para retornar Map (caso precise ser usado como Map diretamente)
  Map<String, dynamic> toJsonMap() {
    return {
      'id': id,
      'full_name': fullName,
      'birth_date': birthDate,
      'email': email,
      'password': password,
      'phone': phone,
      'tasks': tasks?.map((task) => task.toJsonMap()).toList(),
    };
  }
}
