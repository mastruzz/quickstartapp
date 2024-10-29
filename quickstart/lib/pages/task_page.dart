import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TaskPage(),
    );
  }
}

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[200],
        // appBar: AppBar(
        //   backgroundColor: Colors.grey[800],
        //   elevation: 0,
        // ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tarefa 1',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              _buildSubtaskButton('Subtarefa 1', Colors.amber[100]),
              _buildSubtaskButton('Subtarefa 2', Colors.amber[200]),
              _buildSubtaskButton('Subtarefa 3', Colors.lightBlue[100]),
              _buildSubtaskButton('Subtarefa 3', Colors.lightBlue[200]),
              _buildSubtaskButton('+ Adicionar passo', Colors.teal[100]),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.alarm, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text('Lembre-me', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text('Adicionar data de conclusão',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Adicionar descrição ...',
                  border: UnderlineInputBorder(),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Criado às 20:13',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtaskButton(String text, Color? color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ),
      ),
    );
  }
}
