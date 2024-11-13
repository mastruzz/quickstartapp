import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickstart/models/subtask_model.dart';
import 'package:quickstart/models/task_model.dart';
import 'package:quickstart/models/user_model.dart';
import 'package:quickstart/sqlite/sqlite_repository.dart';

class AddSubtaskWidget extends StatefulWidget {
  AddSubtaskWidget({super.key, required this.addTask, required this.taskId});

  final Function(SubtaskModel) addTask;
  final int taskId;

  @override
  _AddSubtaskWidgetState createState() => _AddSubtaskWidgetState(addTask, taskId);
}

class _AddSubtaskWidgetState extends State<AddSubtaskWidget> {
  final titleTextFieldController = TextEditingController();
  final DatabaseConfiguration dbHelper = DatabaseConfiguration();

  _AddSubtaskWidgetState(this.addTask, this.taskId);

  final Function(SubtaskModel) addTask;
  final int taskId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Novo Passo',
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
          getBottonRow(context),
        ],
      ),
    );
  }

  bool _isLoading = false;

  Widget getBottonRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
                    ? const CircularProgressIndicator(
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

      if (title.isEmpty) {
        var mensagem;

        if (title.isEmpty) {
          mensagem = 'Campo "Título" não pode ser vazio.';
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

      var user = await getUser();
      if (user == null) {
        throw Exception('Usuário não encontrado');
      }

      var taskModel = SubtaskModel(
        title: title,
        state: TaskState.pending,
        taskId: taskId
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
