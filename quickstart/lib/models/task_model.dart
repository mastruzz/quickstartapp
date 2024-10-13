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