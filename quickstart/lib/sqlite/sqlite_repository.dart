import 'package:quickstart/models/subtask_model.dart';
import 'package:quickstart/models/task_model.dart';
import 'package:quickstart/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConfiguration {
  static final DatabaseConfiguration _instance =
      DatabaseConfiguration.internal();

  factory DatabaseConfiguration() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  DatabaseConfiguration.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'quickstart.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE User (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          full_name TEXT NOT NULL,
          birth_date TEXT,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          phone TEXT
        )''');

        await db.execute('''
        CREATE TABLE Task (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          completion_date TEXT,
          creation_date TEXT,
          description TEXT,
          state String NOT NULL,
          user_id INTEGER,
          FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
        )''');

        await db.execute('''
        CREATE TABLE Subtask (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          state String NOT NULL,
          task_id INTEGER,
          FOREIGN KEY (task_id) REFERENCES Task(id) ON DELETE CASCADE
        )''');

        // Índice para otimizar consultas de subtarefas de uma tarefa
        await db.execute('''
        CREATE INDEX idx_task_id ON Subtask (task_id)
      ''');
      },
    );
  }

  // ------------------- LOGIN - REGISTER ------------------------- //

  Future<int> insertUser(Map<String, dynamic> user) async {
    var dbClient = await db;
    return await dbClient.insert('User', user);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    var dbClient = await db;
    return await dbClient.query('User');
  }

  Future<bool> getCredentials(String email, String password) async {
    var dbClient = await db;

    final List<Map<String, dynamic>> result = await dbClient.query(
      'User',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Método para validar o login do usuário
  Future<bool> loginUser(String email, String password) async {
    var dbClient = await db;

    try {
      // Verifica se o email e a senha estão corretos
      List<Map<String, dynamic>> consult = (await dbClient.rawQuery(
        'SELECT * FROM user WHERE email = ? AND password = ? LIMIT 1',
        [email, password],
      ));
      var result = consult.first;
      // Se a consulta retornar algo, o login foi bem-sucedido
      if (result.isNotEmpty) {
        UserModel user = UserModel.fromMap(result);
        await _setLoginState(user); // Define o usuário como logado
        return true;
      }
    } catch (wrapDatabaseException) {
      return false;
    }

    return false;
  }

  // Método para verificar se o usuário está logado
  Future<bool> isUserLoggedIn() async {
    // Aqui, vamos usar o SharedPreferences para armazenar o estado de login
    return await _getLoginState(); // Verifica se o usuário está logado
  }

  // Método para armazenar o estado de login usando SharedPreferences
  Future<void> _setLoginState(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('logged_user', user.toJson());
  }

  Future<UserModel?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonUser = prefs.getString('logged_user');
    if (jsonUser != null && jsonUser.isNotEmpty) {
      return UserModel.fromJson(jsonUser);
    }
    return null;
  }

  // Método para recuperar o estado de login usando SharedPreferences
  Future<bool> _getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Método para deslogar o usuário (chame este método para deslogar o usuário)
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool('is_logged_in', false);
  }



  // ------------------------ TASK ------------------------------- //


  // Método para buscar todas as Tasks de um usuário específico
  Future<List<TaskModel>> getAllTasks(int userID) async {
    var dbClient = await db;
    List<TaskModel> taskList = [];

    try {
      // Consulta para obter todas as tasks associadas ao user_id
      List<Map<String, dynamic>> consult = await dbClient.rawQuery(
        'SELECT * FROM Task WHERE user_id = ?',
        [userID],
      );

      // Converte cada Map em um objeto TaskModel e adiciona à lista
      for (Map<String, dynamic> item in consult) {
        TaskModel task =
            TaskModel.fromMap(item); // Converte o item para TaskModel
        taskList.add(task);
      }
      return taskList;
    } catch (e) {
      // Captura exceções e retorna uma lista vazia em caso de erro
      print("Erro ao buscar tasks: $e");
      return [];
    }
  }

  Future<int> addTask(TaskModel task) async {
    var dbClient = await db;

    try {
      // Converte o objeto TaskModel em um Map e insere no banco de dados
      int taskId = await dbClient.insert(
        'Task',
        task.toMap(),
      );
      return taskId;
    } catch (e) {
      print("Erro ao adicionar task: $e");
      return -1; // Retorna -1 em caso de erro
    }
  }

  Future<void> deleteTask(TaskModel task) async {
    var dbClient = await db;

    try {
      // Exclui a tarefa do banco de dados usando o ID da tarefa
      await dbClient.delete(
        'Task',
        where: 'id = ?',
        whereArgs: [task.id], // Substitua pelo ID da tarefa a ser deletada
      );
      print("Task removida");
    } catch (e) {
      print("Erro ao excluir task: $e");
    }
  }

  // Método para atualizar o estado da task
  Future<void> updateTaskState(int taskId, String newState) async {
    final dbClient = await db;

    await dbClient.update(
      'Task',
      {'state': newState}, // novo estado
      where: 'id = ?',
      whereArgs: [taskId], // id da task a ser atualizada
    );
  }

  // ========================== SubtaskModel ==============================

  // Método para buscar todas as Tasks de um usuário específico
  Future<List<SubtaskModel>> getAllSubtasks(int taskId) async {
    var dbClient = await db;
    List<SubtaskModel> subTaskList = [];

    try {
      // Consulta para obter todas as tasks associadas ao user_id
      List<Map<String, dynamic>> consult = await dbClient.rawQuery(
        'SELECT * FROM Subtask WHERE task_id = ?',
        [taskId.toString()],
      );

      // Converte cada Map em um objeto TaskModel e adiciona à lista
      for (Map<String, dynamic> item in consult) {
        SubtaskModel task =
        SubtaskModel.fromMap(item); // Converte o item para TaskModel
        subTaskList.add(task);
      }
      return subTaskList;
    } catch (e) {
      // Captura exceções e retorna uma lista vazia em caso de erro
      print("Erro ao buscar subtasks: $e");
      return [];
    }
  }

  Future<int> addSubtask(SubtaskModel subtask) async {
    var dbClient = await db;

    try {
      // Converte o objeto TaskModel em um Map e insere no banco de dados
      int taskId = await dbClient.insert(
        'Subtask',
        subtask.toMap(),
      );
      return taskId;
    } catch (e) {
      print("Erro ao adicionar task: $e");
      return -1; // Retorna -1 em caso de erro
    }
  }

  Future<void> deleteSubtask(SubtaskModel task) async {
    var dbClient = await db;

    try {
      // Exclui a tarefa do banco de dados usando o ID da tarefa
      await dbClient.delete(
        'Subtask',
        where: 'id = ?',
        whereArgs: [task.id], // Substitua pelo ID da tarefa a ser deletada
      );
      print("Task removida");
    } catch (e) {
      print("Erro ao excluir task: $e");
    }
  }

  // Método para atualizar o estado da task
  Future<void> updateSubtaskState(int subtaskId, String newState) async {
    final dbClient = await db;

    await dbClient.update(
      'Subtask',
      {'state': newState}, // novo estado
      where: 'id = ?',
      whereArgs: [subtaskId], // id da task a ser atualizada
    );
  }
}