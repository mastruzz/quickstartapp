class TaskModel {

  String title;
  DateTime date;
  TaskState state;


  TaskModel(this.title, this.date, this.state);
}

enum TaskState {
  pending,
  completed,
  cancelled,
}