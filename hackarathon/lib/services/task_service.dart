import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';
import 'task_store.dart';

class TaskService implements TaskStore {
  static const String _databaseName = 'student_task_manager.db';
  static const String _tableName = 'tasks';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final databasesPath = await getDatabasesPath();
    final databasePath = path.join(databasesPath, _databaseName);

    _database = await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: _createDatabase,
    );

    return _database!;
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        deadline TEXT NOT NULL,
        status INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  @override
  Future<List<Task>> getTasks() async {
    final db = await database;
    final rows = await db.query(_tableName, orderBy: 'id DESC');

    return rows.map(Task.fromMap).toList();
  }

  @override
  Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert(
      _tableName,
      task.toMap(includeId: false),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> updateTaskStatus(int id, int status) async {
    final db = await database;
    return db.update(
      _tableName,
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
