import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickstart/models/task_model.dart';
import 'package:quickstart/models/user_model.dart';
import 'package:quickstart/sqlite/sqlite_repository.dart';
import 'package:quickstart/widgets/default_colors.dart';

class EditTaskWidget extends StatefulWidget {
  EditTaskWidget({super.key, required this.editTask, required this.taskModel});

  final Function(TaskModel) editTask;
  final TaskModel taskModel;

  @override
  _EditTaskWidgetState createState() =>
      _EditTaskWidgetState(editTask, taskModel);
}

class _EditTaskWidgetState extends State<EditTaskWidget> {
  final titleTextFieldController = TextEditingController();
  final descriptionTextFieldController = TextEditingController();
  final DatabaseConfiguration dbHelper = DatabaseConfiguration();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Color calendarIconColor = DefaultColors.title;

  _EditTaskWidgetState(this.editTask, this.taskModel);

  final Function(TaskModel) editTask;
  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Editar Tarefa',
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
              hintText:
                  taskModel.title!.isNotEmpty ? taskModel.title : "titulo",
              hintStyle: TextStyle(
                color: DefaultColors.title.withAlpha(90),
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              focusColor: DefaultColors.addWidgetTextFieldBackground,
              fillColor: DefaultColors.addWidgetTextFieldBackground,
              enabledBorder: OutlineInputBorder(
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
            cursorColor: DefaultColors.cardBackgroud,
            // Define a cor do cursor
            style: TextStyle(
              color: DefaultColors.title, // Define a cor do texto digitado
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: descriptionTextFieldController,
            decoration: InputDecoration(
              hintText: taskModel.description!.isNotEmpty
                  ? taskModel.description
                  : 'Descrição',
              hintStyle: TextStyle(
                color: DefaultColors.title.withAlpha(90),
                fontWeight: FontWeight.w400,
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
            maxLength: 50,
            keyboardType: TextInputType.multiline,
            cursorColor: DefaultColors.cardBackgroud,
            // Define a cor do cursor
            style: TextStyle(
              color: DefaultColors.title, // Define a cor do texto digitado
            ),
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: DefaultColors.cardBackgroud,
            // Cor do cabeçalho e dos botões
            colorScheme: ColorScheme.dark(
              primary: DefaultColors.cardBackgroud,
              // Cor do botão de confirmação (OK)
              onSurface: DefaultColors.title, // Cor dos textos
            ),
            dialogBackgroundColor:
                DefaultColors.background, // Cor de fundo do diálogo
          ),
          child: child!,
        );
      },
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: DefaultColors.cardBackgroud,
            // Cor do cabeçalho e botões
            colorScheme: ColorScheme.dark(
              primary: DefaultColors.cardBackgroud,
              // Cor do botão de confirmação (OK)
              onSurface: DefaultColors.title, // Cor dos textos
            ),
            dialogBackgroundColor:
                DefaultColors.background, // Cor de fundo do diálogo
          ),
          child: child!,
        );
      },
    ).then((pickedTime) {
      if (pickedTime != null) {
        selectedTime = pickedTime;
        setState(() {
          calendarIconColor = Colors.green;
        });
      }
    });
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
                onPressed: _isLoading
                    ? null
                    : () async {
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

    TaskModel localTaskModel = taskModel;

    try {
      var title = titleTextFieldController.value.text;
      var description = descriptionTextFieldController.value.text;

      DateTime? combinedDateTime;
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
          title: title.isNotEmpty ? title : localTaskModel.title,
          completionDate: combinedDateTime != null
              ? DateFormat('dd/MM/yyyy - HH:mm:ss').format(combinedDateTime)
              : localTaskModel.completionDate,
          creationDate: localTaskModel.completionDate ??
              DateFormat('dd/MM/yyyy - HH:mm:ss').format(DateTime.now()),
          state: localTaskModel.state ?? TaskState.pending,
          description:
              description.isNotEmpty ? description : localTaskModel.description,
          userId: user.id,
          id: localTaskModel.id);

      await editTask(taskModel);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tarefa editada com sucesso!',
            style: TextStyle(
              color: Colors.blueGrey.shade900,
            ),
          ),
          backgroundColor: Colors.green.shade50,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao editar tarefa: $e',
            style: TextStyle(
              color: Colors.blueGrey.shade900,
            ),
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
