import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConfiguration {
  static final DatabaseConfiguration _instance = DatabaseConfiguration.internal();
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
    String path = join(databasesPath, 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE User (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name TEXT NOT NULL,
            last_name TEXT NOT NULL,
            birth_date TEXT,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            phone TEXT
          )'''
        );

        await db.execute('''
          CREATE TABLE Task (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            due_date TEXT,
            description TEXT,
            state INTEGER NOT NULL,
            user_id INTEGER,
            FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE
          )'''
        );

        await db.execute('''
          CREATE TABLE Subtask (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            state INTEGER NOT NULL,
            task_id INTEGER,
            FOREIGN KEY (task_id) REFERENCES Task(id) ON DELETE CASCADE
          )'''
        );
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
}
