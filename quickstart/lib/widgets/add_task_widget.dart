import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickstart/models/task_model.dart';
import 'package:quickstart/models/user_model.dart';
import 'package:quickstart/sqlite/sqlite_repository.dart';

class AddTaskWidget extends StatefulWidget {
  AddTaskWidget({super.key, required this.addTask});

  final Function(TaskModel) addTask;

  @override
  _AddTaskWidgetState createState() => _AddTaskWidgetState(addTask);
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final titleTextFieldController = TextEditingController();
  final descriptionTextFieldController = TextEditingController();
  final DatabaseConfiguration dbHelper = DatabaseConfiguration();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Color calendarIconColor = Colors.black;

  _AddTaskWidgetState(this.addTask);

  final Function(TaskModel) addTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nova Tarefa',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: titleTextFieldController,
            decoration: const InputDecoration(
              hintText: 'Título',
              filled: true,
              focusColor: Colors.white,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              counterText: '',
            ),
            maxLines: 1,
            maxLength: 40,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: descriptionTextFieldController,
            decoration: const InputDecoration(
              hintText: 'Descrição',
              filled: true,
              focusColor: Colors.white,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            ),
            maxLines: 3,
            maxLength: 100,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 20),
          getBottonRow(context),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate != null) {
        selectedDate = pickedDate;
        _selectTime(context);
      }
    });
  }

  void _selectTime(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then(
      (pickedTime) {
        if (pickedTime != null) {
          selectedTime = pickedTime;
          setState(() {
            calendarIconColor = Colors.green;
          });
        }
      },
    );
  }

  // Widget getBottonRow() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Row(
  //           children: [
  //             IconButton(
  //               onPressed: () {
  //                 print('Notificações clicado');
  //               },
  //               icon: const Icon(
  //                 Icons.notifications_none,
  //                 size: 25,
  //               ),
  //             ),
  //             IconButton(
  //               onPressed: () {
  //                 _selectDate(context);
  //               },
  //               icon: const Icon(
  //                 Icons.calendar_month_outlined,
  //                 size: 25,
  //               ),
  //               color: calendarIconColor,
  //             ),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: const Color(0xFFE8595A),
  //               ),
  //               child: const Text(
  //                 'Cancelar',
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //             const SizedBox(width: 10),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 var title = titleTextFieldController.value.text;
  //                 var description = descriptionTextFieldController.value.text;
  //
  //                 if (title.isEmpty || description.isEmpty) {
  //                   var mensagem;
  //                   if (title.isEmpty && description.isEmpty) {
  //                     mensagem = 'Preencha os campos obrigatórios.';
  //                   } else if (title.isEmpty && description.isNotEmpty) {
  //                     mensagem = 'Campo \"Titulo\" não pode ser vazio.';
  //                   } else {
  //                     mensagem = 'Campo \"Descrição\" não pode ser vazio.';
  //                   }
  //
  //                   ScaffoldMessenger.of(context).clearSnackBars();
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(
  //                         content: Text(
  //                           mensagem,
  //                           style: TextStyle(color: Colors.blueGrey.shade900),
  //                         ),
  //                         backgroundColor: Colors.grey.shade200,
  //                         showCloseIcon: false),
  //                   );
  //                   Navigator.of(context).pop();
  //                   return;
  //                 }
  //
  //                 var combinedDateTime = DateTime.now();
  //                 if (selectedDate != null && selectedTime != null) {
  //                   combinedDateTime = DateTime(
  //                     selectedDate!.year,
  //                     selectedDate!.month,
  //                     selectedDate!.day,
  //                     selectedTime!.hour,
  //                     selectedTime!.minute,
  //                   );
  //                 }
  //
  //                 var user = await getUser();
  //                 var taskModel = TaskModel(
  //                   title: titleTextFieldController.value.text,
  //                   completionDate: DateFormat('dd/MM/yyyy - HH:mm:ss')
  //                       .format(combinedDateTime),
  //                   creationDate: DateFormat('dd/MM/yyyy - HH:mm:ss')
  //                       .format(DateTime.now()),
  //                   state: TaskState.pending,
  //                   description: descriptionTextFieldController.value.text,
  //                   userId: user!.id,
  //                 );
  //
  //                 addTask(taskModel);
  //                 Navigator.of(context).pop();
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: const Color(0xFF53CC84),
  //               ),
  //               child: const Text(
  //                 'Concluir',
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  bool _isLoading = false;

  Widget getBottonRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  print('Notificações clicado');
                },
                icon: const Icon(
                  Icons.notifications_none,
                  size: 25,
                ),
              ),
              IconButton(
                onPressed: () {
                  _selectDate(context);
                },
                icon: const Icon(
                  Icons.calendar_month_outlined,
                  size: 25,
                ),
                color: calendarIconColor,
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8595A),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  await _handleTaskCreation(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF53CC84),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  'Concluir',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleTaskCreation(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      var title = titleTextFieldController.value.text;
      var description = descriptionTextFieldController.value.text;

      if (title.isEmpty || description.isEmpty) {
        var mensagem;
        if (title.isEmpty && description.isEmpty) {
          mensagem = 'Preencha os campos obrigatórios.';
        } else if (title.isEmpty) {
          mensagem = 'Campo "Título" não pode ser vazio.';
        } else {
          mensagem = 'Campo "Descrição" não pode ser vazio.';
        }

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              mensagem,
              style: TextStyle(color: Colors.blueGrey.shade900),
            ),
            backgroundColor: Colors.grey.shade200,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      var combinedDateTime = DateTime.now();
      if (selectedDate != null && selectedTime != null) {
        combinedDateTime = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        );
      }

      var user = await getUser();
      if (user == null) {
        throw Exception('Usuário não encontrado');
      }

      var taskModel = TaskModel(
        title: title,
        completionDate: DateFormat('dd/MM/yyyy - HH:mm:ss').format(combinedDateTime),
        creationDate: DateFormat('dd/MM/yyyy - HH:mm:ss').format(DateTime.now()),
        state: TaskState.pending,
        description: description,
        userId: user.id,
      );

      await addTask(taskModel);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tarefa adicionada com sucesso!',
            style: TextStyle(color: Colors.blueGrey.shade900),
          ),
          backgroundColor: Colors.green.shade200,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao adicionar tarefa: $e',
            style: TextStyle(color: Colors.blueGrey.shade900),
          ),
          backgroundColor: Colors.red.shade200,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<UserModel?> getUser() async {
    if (await dbHelper.isUserLoggedIn()) {
      return await dbHelper.getLoggedInUser();
    }
    return null;
  }
}
