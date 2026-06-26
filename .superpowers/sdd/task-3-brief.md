### Task 3: Task Model, Storage Interface, and SQLite Task Service

**Files:**
- Create: `lib/models/task.dart`
- Create: `lib/services/task_store.dart`
- Create: `lib/services/task_service.dart`
- Create: `test/task_model_test.dart`

**Interfaces:**
- Produces: `Task` with `id`, `title`, `description`, `deadline`, `status`, `isCompleted`, `statusText`, `toMap()`, `fromMap()`, and `copyWith()`.
- Produces: `abstract class TaskStore` with `getTasks`, `insertTask`, `updateTaskStatus`, and `deleteTask`.
- Produces: `TaskService implements TaskStore` backed by Sqflite table `tasks`.

- [ ] **Step 1: Write failing Task model tests**

Create `test/task_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:student_task_manager/models/task.dart';

void main() {
  test('Task converts to and from a SQLite map', () {
    final task = Task(
      id: 7,
      title: 'Math homework',
      description: 'Finish chapter 3 exercises',
      deadline: '2026-06-30',
      status: 1,
    );

    final map = task.toMap();
    final restored = Task.fromMap(map);

    expect(restored.id, 7);
    expect(restored.title, 'Math homework');
    expect(restored.description, 'Finish chapter 3 exercises');
    expect(restored.deadline, '2026-06-30');
    expect(restored.status, 1);
    expect(restored.isCompleted, isTrue);
    expect(restored.statusText, 'Completed');
  });

  test('Task defaults to pending', () {
    final task = Task(
      title: 'Read Flutter docs',
      description: 'Review state management',
      deadline: '2026-07-01',
    );

    expect(task.status, 0);
    expect(task.isCompleted, isFalse);
    expect(task.statusText, 'Pending');
  });
}
```

- [ ] **Step 2: Run the failing Task model test**

Run:

```powershell
flutter test test/task_model_test.dart
```

Expected: FAIL because `Task` does not exist yet.

- [ ] **Step 3: Implement the Task model**

Create `lib/models/task.dart`:

```dart
class Task {
  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    this.status = 0,
  });

  final int? id;
  final String title;
  final String description;
  final String deadline;
  final int status;

  bool get isCompleted => status == 1;

  String get statusText => isCompleted ? 'Completed' : 'Pending';

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? deadline,
    int? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
    );
  }

  Map<String, Object?> toMap({bool includeId = true}) {
    final map = <String, Object?>{
      'title': title,
      'description': description,
      'deadline': deadline,
      'status': status,
    };

    if (includeId && id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory Task.fromMap(Map<String, Object?> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      deadline: map['deadline'] as String,
      status: map['status'] as int,
    );
  }
}
```

- [ ] **Step 4: Create the storage interface used by view models**

Create `lib/services/task_store.dart`:

```dart
import '../models/task.dart';

abstract class TaskStore {
  Future<List<Task>> getTasks();

  Future<int> insertTask(Task task);

  Future<int> updateTaskStatus(int id, int status);

  Future<int> deleteTask(int id);
}
```

- [ ] **Step 5: Implement SQLite Task Service**

Create `lib/services/task_service.dart`:

```dart
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
    final rows = await db.query(
      _tableName,
      orderBy: 'id DESC',
    );

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
    return db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
```

- [ ] **Step 6: Run tests**

Run:

```powershell
dart format lib test
flutter analyze
flutter test
```

Expected: all current tests pass. SQLite service is compiled by analyze; CRUD behavior will be verified through app flow in later tasks.

- [ ] **Step 7: Commit**

```powershell
git add lib test
git commit -m "feat: add task model and sqlite service"
```

Expected: one commit containing model, storage interface, SQLite service, and model tests.

---

