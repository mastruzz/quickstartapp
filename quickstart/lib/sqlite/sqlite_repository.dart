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
            due_date TEXT,
            description TEXT,
            state INTEGER NOT NULL,
            user_id INTEGER,
            FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
          )''');

        await db.execute('''
          CREATE TABLE Subtask (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            state INTEGER NOT NULL,
            task_id INTEGER,
            FOREIGN KEY (task_id) REFERENCES Task(id) ON DELETE CASCADE
          )''');
      },
    );
  }

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
        User user = User.fromMap(result);
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
  Future<void> _setLoginState(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('logged_user', user.toJson());
  }

  Future<User?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonUser = prefs.getString('logged_user');
    if (jsonUser != null && jsonUser.isNotEmpty) {
      return User.fromJson(jsonUser);
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
}
