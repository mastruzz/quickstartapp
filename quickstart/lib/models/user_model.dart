import 'dart:convert';

class User {
  int? id;
  String? fullName;
  String? birthDate;
  String? email;
  String? password;
  String? phone;

  User({
    this.id,
    required this.fullName,
    this.birthDate,
    required this.email,
    required this.password,
    this.phone,
  });

  // Método para converter o objeto User para JSON
  String toJson() {
    return jsonEncode(toMap()); // Converte o Map para uma string JSON
  }

  // Converter objeto User para Map (para salvar no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'birth_date': birthDate,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }

  // Converter Map para objeto User (ao recuperar do banco de dados)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['full_name'],
      birthDate: map['birth_date'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
    );
  }

  // Converte uma string JSON para um objeto User
  factory User.fromJson(String source) {
    return User.fromMap(jsonDecode(source));
  }
}
