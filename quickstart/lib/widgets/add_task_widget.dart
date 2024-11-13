import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickstart/models/task_model.dart';
import 'package:quickstart/models/user_model.dart';
import 'package:quickstart/sqlite/sqlite_repository.dart';
import 'package:quickstart/widgets/default_colors.dart';

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
  Color calendarIconColor = DefaultColors.title;

  _AddTaskWidgetState(this.addTask);

  final Function(TaskModel) addTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nova Tarefa',
            style: TextStyle(
              color: DefaultColors.title,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: titleTextFieldController,
            decoration: InputDecoration(
              hintText: 'Título',
              hintStyle: TextStyle(
                color: DefaultColors.title
              ),
              filled: true,
              focusColor: DefaultColors.addWidgetTextFieldBackground,
              fillColor: DefaultColors.addWidgetTextFieldBackground,
              enabledBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: DefaultColors.cardBorder),
                borderRadius: const BorderRadius.all(Radius.circular(100)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: DefaultColors.cardBorder),
                borderRadius: const BorderRadius.all(Radius.circular(100)),
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
            decoration: InputDecoration(
              hintText: 'Descrição',
              hintStyle: TextStyle(
                  color: DefaultColors.title
              ),
              filled: true,
              focusColor: DefaultColors.addWidgetTextFieldBackground,
              fillColor: DefaultColors.addWidgetTextFieldBackground,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            ),
            maxLines: 3,
            maxLength: 100,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 20),
          _getBottonRow(context),
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

  bool _isLoading = false;

  Widget _getBottonRow(BuildContext context) {
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
                icon: Icon(
                  color: DefaultColors.title,
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
                  backgroundColor: Colors.transparent,
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: DefaultColors.title),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  await _handleTaskCreation(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DefaultColors.successButton,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text(
                  'Concluir',
                  style: TextStyle(color: DefaultColors.title),
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
        String mensagem;
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
            style: TextStyle(color: Colors.blueGrey.shade900,),
          ),
          backgroundColor: Colors.green.shade50,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao adicionar tarefa: $e',
            style: TextStyle(color: Colors.blueGrey.shade900,),
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
