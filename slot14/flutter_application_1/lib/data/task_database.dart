import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  static Database? _database;

  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('task_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        deadline TEXT NOT NULL,
        status INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> insert(TaskModel task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<TaskModel>> getAll() async {
    final db = await database;
    final result = await db.query('tasks', orderBy: 'id DESC');
    return result.map((map) => TaskModel.fromMap(map)).toList();
  }

  Future<int> update(TaskModel task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
