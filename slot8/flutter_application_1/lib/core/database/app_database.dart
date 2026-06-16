import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const String databaseName = 'flutter_sqlite_mvvm.db';
  static const int databaseVersion = 1;

  static const String usersTable = 'users';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = join(directory.path, databaseName);
    return openDatabase(dbPath, version: databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $usersTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        full_name TEXT NOT NULL,
        email TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
        ) 
    ''');
    final now = DateTime.now().toIso8601String();
    await db.insert(usersTable, {
      'username': 'admin',
      'password': 'admin123',
      'full_name': 'Admin User',
      'email': 'admin@example.com',
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<void> close() async {
    final db = await database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
