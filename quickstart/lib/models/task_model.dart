class TaskModel {

  String title;
  String description;
  DateTime doneDate;
  TaskState state;

  TaskModel(this.title, this.doneDate, this.state, this.description);

}

enum TaskState {
  pending,
  completed,
  cancelled,
}

class Task {
  int? id;
  String title;
  String? completionDate;  // Usando String para armazenar datas
  String? description;
  TaskState state;  // Supondo que 'state' seja um inteiro que representa o status da tarefa
  int userId; // FK para User

  // Construtor
  Task({
    this.id,
    required this.title,
    this.completionDate,
    this.description,
    required this.state,
    required this.userId,
  });

  // Converter objeto Task para Map (para salvar no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'completionDate': completionDate,
      'description': description,
      'state': state,
      'userId': userId,
    };
  }

  // Converter Map para objeto Task (ao recuperar do banco de dados)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      completionDate: map['completionDate'],
      description: map['description'],
      state: map['state'],
      userId: map['userId'],
    );
  }
}
