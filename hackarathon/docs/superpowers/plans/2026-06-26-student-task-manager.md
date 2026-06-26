# Student Task Manager App Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a runnable Flutter mobile application for managing student study tasks with login, dashboard statistics, SQLite CRUD, and a simple MVVM structure.

**Architecture:** Use MVVM with `views/` for screens, `view_models/` for `ChangeNotifier` state, `models/` for data objects, and `services/` for SQLite persistence. The app uses Provider for dependency injection and state updates, with hardcoded login credentials from the spec.

**Tech Stack:** Flutter, Dart, Provider `^6.1.2`, Sqflite `^2.4.2+1`, Path `^1.9.0`, Flutter test.

## Global Constraints

- App name shown to users: `Student Task Manager App`.
- Required login email: `admin@gmail.com`.
- Required login password: `123456`.
- Invalid login message: `Invalid email or password`.
- Required task fields: title, description, deadline, status.
- Task status values: `0` means Pending, `1` means Completed.
- SQLite is required for task storage.
- Required dependencies: `provider: ^6.1.2`, `sqflite: ^2.4.2+1`, `path: ^1.9.0`.
- Required app flow: Login Page -> Home Page -> Task List Page -> Add Task Page.
- Required CRUD: add task, display tasks, update completed/pending status, delete task.
- Required submission artifacts: source code, README.md, screenshots, live demo.

---

## File Structure

- Create/modify `pubspec.yaml`: Flutter project metadata and dependencies.
- Create/modify `lib/main.dart`: app entry point, theme, Provider setup, routes.
- Create `lib/app_routes.dart`: route name constants.
- Create `lib/models/task.dart`: `Task` data model and SQLite map conversion.
- Create `lib/services/task_store.dart`: testable storage interface consumed by view models.
- Create `lib/services/task_service.dart`: Sqflite implementation of `TaskStore`.
- Create `lib/view_models/login_view_model.dart`: login validation state.
- Create `lib/view_models/task_view_model.dart`: task list state, statistics, CRUD orchestration.
- Create `lib/views/login_page.dart`: email/password form.
- Create `lib/views/home_page.dart`: welcome screen, dashboard statistics, navigation.
- Create `lib/views/task_list_page.dart`: ListView, checkbox status update, delete button.
- Create `lib/views/add_task_page.dart`: task form and DatePicker deadline selection.
- Create `test/app_smoke_test.dart`: verifies app boots to Login Page.
- Create `test/login_view_model_test.dart`: verifies login success/failure logic.
- Create `test/task_model_test.dart`: verifies SQLite map conversion.
- Create `test/task_view_model_test.dart`: verifies dashboard stats and task operations with a fake store.
- Create `README.md`: required team/demo instructions.

---

### Task 1: Project Setup, Folders, Routes, and Placeholder Screens

**Files:**
- Create/modify: `pubspec.yaml`
- Create: `lib/app_routes.dart`
- Modify: `lib/main.dart`
- Create: `lib/views/login_page.dart`
- Create: `lib/views/home_page.dart`
- Create: `lib/views/task_list_page.dart`
- Create: `lib/views/add_task_page.dart`
- Create: `test/app_smoke_test.dart`

**Interfaces:**
- Produces: `AppRoutes.login`, `AppRoutes.home`, `AppRoutes.taskList`, `AppRoutes.addTask`.
- Produces: placeholder widgets `LoginPage`, `HomePage`, `TaskListPage`, `AddTaskPage`.
- Later tasks replace placeholder screen bodies while keeping the same route names.

- [ ] **Step 1: Create the Flutter project in the current empty workspace**

Run:

```powershell
flutter create --project-name student_task_manager --platforms=android,ios .
```

Expected: `pubspec.yaml`, `lib/main.dart`, `android/`, `ios/`, and `test/` are created.

- [ ] **Step 2: Add required dependencies**

Run:

```powershell
flutter pub add provider:^6.1.2 sqflite:^2.4.2+1 path:^1.9.0
```

Expected: `pubspec.yaml` contains `provider`, `sqflite`, and `path` under `dependencies`.

- [ ] **Step 3: Create the MVVM folders**

Run:

```powershell
New-Item -ItemType Directory -Force lib\models,lib\services,lib\view_models,lib\views | Out-Null
```

Expected: the four folders exist under `lib/`.

- [ ] **Step 4: Create route constants**

Create `lib/app_routes.dart`:

```dart
class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String taskList = '/tasks';
  static const String addTask = '/tasks/add';
}
```

- [ ] **Step 5: Replace `lib/main.dart` with a routed app shell**

```dart
import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'views/add_task_page.dart';
import 'views/home_page.dart';
import 'views/login_page.dart';
import 'views/task_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudentTaskManagerApp());
}

class StudentTaskManagerApp extends StatelessWidget {
  const StudentTaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Task Manager App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.taskList: (_) => const TaskListPage(),
        AppRoutes.addTask: (_) => const AddTaskPage(),
      },
    );
  }
}
```

- [ ] **Step 6: Create placeholder Login Page**

Create `lib/views/login_page.dart`:

```dart
import 'package:flutter/material.dart';

import '../app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Task Manager App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
          child: const Text('Open Home'),
        ),
      ),
    );
  }
}
```

- [ ] **Step 7: Create placeholder Home Page**

Create `lib/views/home_page.dart`:

```dart
import 'package:flutter/material.dart';

import '../app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to Student Task Manager App',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.taskList),
              child: const Text('Go to Task List'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 8: Create placeholder Task List Page**

Create `lib/views/task_list_page.dart`:

```dart
import 'package:flutter/material.dart';

import '../app_routes.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task List')),
      body: const Center(child: Text('No tasks yet')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addTask),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

- [ ] **Step 9: Create placeholder Add Task Page**

Create `lib/views/add_task_page.dart`:

```dart
import 'package:flutter/material.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: const Center(child: Text('Task form will be added here')),
    );
  }
}
```

- [ ] **Step 10: Replace the default widget test with an app smoke test**

Delete `test/widget_test.dart` if Flutter created it, then create `test/app_smoke_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:student_task_manager/main.dart';

void main() {
  testWidgets('app starts on the login page', (tester) async {
    await tester.pumpWidget(const StudentTaskManagerApp());

    expect(find.text('Student Task Manager App'), findsOneWidget);
    expect(find.text('Open Home'), findsOneWidget);
  });
}
```

- [ ] **Step 11: Run format, analyze, and tests**

Run:

```powershell
dart format lib test
flutter analyze
flutter test
```

Expected: all commands finish without errors.

- [ ] **Step 12: Commit**

```powershell
git add pubspec.yaml pubspec.lock lib test
git commit -m "chore: scaffold student task manager app"
```

Expected: one commit containing the Flutter scaffold and placeholder screens.

---

### Task 2: Login Page and Login ViewModel

**Files:**
- Create: `lib/view_models/login_view_model.dart`
- Modify: `lib/main.dart`
- Replace: `lib/views/login_page.dart`
- Create: `test/login_view_model_test.dart`
- Modify: `test/app_smoke_test.dart`

**Interfaces:**
- Produces: `LoginViewModel.login(String email, String password) -> bool`.
- Produces: `LoginViewModel.errorMessage -> String?`.
- Consumes: `AppRoutes.home` after successful login.

- [ ] **Step 1: Write failing Login ViewModel tests**

Create `test/login_view_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:student_task_manager/view_models/login_view_model.dart';

void main() {
  group('LoginViewModel', () {
    test('accepts the configured admin account', () {
      final viewModel = LoginViewModel();

      final result = viewModel.login('admin@gmail.com', '123456');

      expect(result, isTrue);
      expect(viewModel.errorMessage, isNull);
    });

    test('rejects an incorrect account with the required message', () {
      final viewModel = LoginViewModel();

      final result = viewModel.login('wrong@gmail.com', 'bad-password');

      expect(result, isFalse);
      expect(viewModel.errorMessage, 'Invalid email or password');
    });
  });
}
```

- [ ] **Step 2: Run the failing test**

Run:

```powershell
flutter test test/login_view_model_test.dart
```

Expected: FAIL because `LoginViewModel` does not exist yet.

- [ ] **Step 3: Implement Login ViewModel**

Create `lib/view_models/login_view_model.dart`:

```dart
import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  static const String validEmail = 'admin@gmail.com';
  static const String validPassword = '123456';
  static const String invalidMessage = 'Invalid email or password';

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool login(String email, String password) {
    final isValid = email.trim() == validEmail && password == validPassword;

    _errorMessage = isValid ? null : invalidMessage;
    notifyListeners();

    return isValid;
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }
    _errorMessage = null;
    notifyListeners();
  }
}
```

- [ ] **Step 4: Register the Login ViewModel in `main.dart`**

Replace `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_routes.dart';
import 'view_models/login_view_model.dart';
import 'views/add_task_page.dart';
import 'views/home_page.dart';
import 'views/login_page.dart';
import 'views/task_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudentTaskManagerApp());
}

class StudentTaskManagerApp extends StatelessWidget {
  const StudentTaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: MaterialApp(
        title: 'Student Task Manager App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.home: (_) => const HomePage(),
          AppRoutes.taskList: (_) => const TaskListPage(),
          AppRoutes.addTask: (_) => const AddTaskPage(),
        },
      ),
    );
  }
}
```

- [ ] **Step 5: Replace Login Page with the real form**

Replace `lib/views/login_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../view_models/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = context.read<LoginViewModel>();
    final isLoggedIn = viewModel.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!isLoggedIn) {
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Task Manager App')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.school, size: 72, color: Colors.teal),
                  const SizedBox(height: 16),
                  const Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                    onChanged: (_) => context.read<LoginViewModel>().clearError(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    onChanged: (_) => context.read<LoginViewModel>().clearError(),
                  ),
                  const SizedBox(height: 12),
                  Consumer<LoginViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.errorMessage == null) {
                        return const SizedBox.shrink();
                      }

                      return Text(
                        viewModel.errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _submit,
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 6: Update the smoke test for the real Login Page**

Replace `test/app_smoke_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:student_task_manager/main.dart';

void main() {
  testWidgets('app starts on the login page', (tester) async {
    await tester.pumpWidget(const StudentTaskManagerApp());

    expect(find.text('Student Task Manager App'), findsOneWidget);
    expect(find.text('Login'), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
```

- [ ] **Step 7: Run tests**

Run:

```powershell
dart format lib test
flutter analyze
flutter test
```

Expected: all tests pass and analyze reports no issues.

- [ ] **Step 8: Commit**

```powershell
git add lib test
git commit -m "feat: add login page and validation"
```

Expected: one commit containing Login Page, login validation, and tests.

---

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

### Task 4: Task ViewModel and Home Dashboard

**Files:**
- Create: `lib/view_models/task_view_model.dart`
- Modify: `lib/main.dart`
- Replace: `lib/views/home_page.dart`
- Create: `test/task_view_model_test.dart`

**Interfaces:**
- Consumes: `TaskStore` and `Task`.
- Produces: `TaskViewModel.tasks`, `totalTasks`, `completedTasks`, `pendingTasks`, `loadTasks()`, `addTask()`, `toggleTaskStatus()`, and `deleteTask()`.
- Home Page consumes `TaskViewModel` for dashboard statistics.

- [ ] **Step 1: Write failing Task ViewModel tests**

Create `test/task_view_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:student_task_manager/models/task.dart';
import 'package:student_task_manager/services/task_store.dart';
import 'package:student_task_manager/view_models/task_view_model.dart';

class FakeTaskStore implements TaskStore {
  FakeTaskStore(this.rows);

  List<Task> rows;
  int _nextId = 100;

  @override
  Future<List<Task>> getTasks() async {
    return List<Task>.from(rows);
  }

  @override
  Future<int> insertTask(Task task) async {
    final id = _nextId++;
    rows = [
      task.copyWith(id: id),
      ...rows,
    ];
    return id;
  }

  @override
  Future<int> updateTaskStatus(int id, int status) async {
    rows = rows
        .map((task) => task.id == id ? task.copyWith(status: status) : task)
        .toList();
    return 1;
  }

  @override
  Future<int> deleteTask(int id) async {
    rows = rows.where((task) => task.id != id).toList();
    return 1;
  }
}

void main() {
  test('loads dashboard statistics from tasks', () async {
    final store = FakeTaskStore([
      const Task(
        id: 1,
        title: 'Project',
        description: 'Finish prototype',
        deadline: '2026-06-30',
        status: 0,
      ),
      const Task(
        id: 2,
        title: 'Exam',
        description: 'Revise chapter 5',
        deadline: '2026-07-02',
        status: 1,
      ),
    ]);
    final viewModel = TaskViewModel(store);

    await viewModel.loadTasks();

    expect(viewModel.totalTasks, 2);
    expect(viewModel.completedTasks, 1);
    expect(viewModel.pendingTasks, 1);
    expect(viewModel.errorMessage, isNull);
  });

  test('adds a pending task and reloads the list', () async {
    final store = FakeTaskStore([]);
    final viewModel = TaskViewModel(store);

    await viewModel.addTask(
      title: 'Read notes',
      description: 'Mobile programming lesson 1',
      deadline: '2026-07-10',
    );

    expect(viewModel.totalTasks, 1);
    expect(viewModel.tasks.first.title, 'Read notes');
    expect(viewModel.tasks.first.status, 0);
  });
}
```

- [ ] **Step 2: Run the failing Task ViewModel tests**

Run:

```powershell
flutter test test/task_view_model_test.dart
```

Expected: FAIL because `TaskViewModel` does not exist yet.

- [ ] **Step 3: Implement Task ViewModel**

Create `lib/view_models/task_view_model.dart`:

```dart
import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../services/task_store.dart';

class TaskViewModel extends ChangeNotifier {
  TaskViewModel(this._taskStore);

  final TaskStore _taskStore;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Task> get tasks => List.unmodifiable(_tasks);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get totalTasks => _tasks.length;

  int get completedTasks => _tasks.where((task) => task.isCompleted).length;

  int get pendingTasks => totalTasks - completedTasks;

  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _taskStore.getTasks();
    } catch (_) {
      _errorMessage = 'Cannot load tasks';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask({
    required String title,
    required String description,
    required String deadline,
  }) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _taskStore.insertTask(
        Task(
          title: title.trim(),
          description: description.trim(),
          deadline: deadline.trim(),
          status: 0,
        ),
      );
      await loadTasks();
    } catch (_) {
      _errorMessage = 'Cannot add task';
      notifyListeners();
    }
  }

  Future<void> toggleTaskStatus(Task task, bool isCompleted) async {
    if (task.id == null) {
      return;
    }

    _errorMessage = null;
    notifyListeners();

    try {
      await _taskStore.updateTaskStatus(task.id!, isCompleted ? 1 : 0);
      await loadTasks();
    } catch (_) {
      _errorMessage = 'Cannot update task status';
      notifyListeners();
    }
  }

  Future<void> deleteTask(Task task) async {
    if (task.id == null) {
      return;
    }

    _errorMessage = null;
    notifyListeners();

    try {
      await _taskStore.deleteTask(task.id!);
      await loadTasks();
    } catch (_) {
      _errorMessage = 'Cannot delete task';
      notifyListeners();
    }
  }
}
```

- [ ] **Step 4: Register TaskService and TaskViewModel in `main.dart`**

Replace `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_routes.dart';
import 'services/task_service.dart';
import 'services/task_store.dart';
import 'view_models/login_view_model.dart';
import 'view_models/task_view_model.dart';
import 'views/add_task_page.dart';
import 'views/home_page.dart';
import 'views/login_page.dart';
import 'views/task_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudentTaskManagerApp());
}

class StudentTaskManagerApp extends StatelessWidget {
  const StudentTaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        Provider<TaskStore>(create: (_) => TaskService()),
        ChangeNotifierProvider(
          create: (context) => TaskViewModel(context.read<TaskStore>())..loadTasks(),
        ),
      ],
      child: MaterialApp(
        title: 'Student Task Manager App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.home: (_) => const HomePage(),
          AppRoutes.taskList: (_) => const TaskListPage(),
          AppRoutes.addTask: (_) => const AddTaskPage(),
        },
      ),
    );
  }
}
```

- [ ] **Step 5: Replace Home Page with dashboard statistics**

Replace `lib/views/home_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../view_models/task_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<TaskViewModel>().loadTasks(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 24),
              const Text(
                'Welcome to Student Task Manager App',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Consumer<TaskViewModel>(
                builder: (context, viewModel, child) {
                  return Column(
                    children: [
                      _StatTile(
                        label: 'Total Tasks',
                        value: viewModel.totalTasks,
                        icon: Icons.assignment_outlined,
                        color: Colors.blue,
                      ),
                      _StatTile(
                        label: 'Completed Tasks',
                        value: viewModel.completedTasks,
                        icon: Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      _StatTile(
                        label: 'Pending Tasks',
                        value: viewModel.pendingTasks,
                        icon: Icons.pending_actions_outlined,
                        color: Colors.orange,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.taskList),
                icon: const Icon(Icons.list_alt),
                label: const Text('Go to Task List'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label),
        trailing: Text(
          value.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
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

Expected: all tests pass and analyze reports no issues.

- [ ] **Step 7: Commit**

```powershell
git add lib test
git commit -m "feat: add task view model and home dashboard"
```

Expected: one commit containing dashboard statistics and task state management.

---

### Task 5: Task List, Add Task, Update Status, and Delete Task

**Files:**
- Replace: `lib/views/task_list_page.dart`
- Replace: `lib/views/add_task_page.dart`
- Modify: `test/task_view_model_test.dart`

**Interfaces:**
- Consumes: `TaskViewModel.tasks`, `addTask`, `toggleTaskStatus`, and `deleteTask`.
- Produces: Task List UI with title, description, deadline, status, checkbox, delete button.
- Produces: Add Task UI with title, description, and DatePicker-backed deadline.

- [ ] **Step 1: Extend Task ViewModel tests for update and delete**

Replace `test/task_view_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:student_task_manager/models/task.dart';
import 'package:student_task_manager/services/task_store.dart';
import 'package:student_task_manager/view_models/task_view_model.dart';

class FakeTaskStore implements TaskStore {
  FakeTaskStore(this.rows);

  List<Task> rows;
  int _nextId = 100;

  @override
  Future<List<Task>> getTasks() async {
    return List<Task>.from(rows);
  }

  @override
  Future<int> insertTask(Task task) async {
    final id = _nextId++;
    rows = [
      task.copyWith(id: id),
      ...rows,
    ];
    return id;
  }

  @override
  Future<int> updateTaskStatus(int id, int status) async {
    rows = rows
        .map((task) => task.id == id ? task.copyWith(status: status) : task)
        .toList();
    return 1;
  }

  @override
  Future<int> deleteTask(int id) async {
    rows = rows.where((task) => task.id != id).toList();
    return 1;
  }
}

void main() {
  test('loads dashboard statistics from tasks', () async {
    final store = FakeTaskStore([
      const Task(
        id: 1,
        title: 'Project',
        description: 'Finish prototype',
        deadline: '2026-06-30',
        status: 0,
      ),
      const Task(
        id: 2,
        title: 'Exam',
        description: 'Revise chapter 5',
        deadline: '2026-07-02',
        status: 1,
      ),
    ]);
    final viewModel = TaskViewModel(store);

    await viewModel.loadTasks();

    expect(viewModel.totalTasks, 2);
    expect(viewModel.completedTasks, 1);
    expect(viewModel.pendingTasks, 1);
    expect(viewModel.errorMessage, isNull);
  });

  test('adds a pending task and reloads the list', () async {
    final store = FakeTaskStore([]);
    final viewModel = TaskViewModel(store);

    await viewModel.addTask(
      title: 'Read notes',
      description: 'Mobile programming lesson 1',
      deadline: '2026-07-10',
    );

    expect(viewModel.totalTasks, 1);
    expect(viewModel.tasks.first.title, 'Read notes');
    expect(viewModel.tasks.first.status, 0);
  });

  test('marks a task completed and pending again', () async {
    final task = const Task(
      id: 1,
      title: 'Quiz',
      description: 'Prepare answers',
      deadline: '2026-07-03',
      status: 0,
    );
    final store = FakeTaskStore([task]);
    final viewModel = TaskViewModel(store);

    await viewModel.loadTasks();
    await viewModel.toggleTaskStatus(task, true);

    expect(viewModel.tasks.single.status, 1);
    expect(viewModel.completedTasks, 1);

    await viewModel.toggleTaskStatus(viewModel.tasks.single, false);

    expect(viewModel.tasks.single.status, 0);
    expect(viewModel.pendingTasks, 1);
  });

  test('deletes a task and reloads the list', () async {
    final task = const Task(
      id: 1,
      title: 'Essay',
      description: 'Write introduction',
      deadline: '2026-07-04',
      status: 0,
    );
    final store = FakeTaskStore([task]);
    final viewModel = TaskViewModel(store);

    await viewModel.loadTasks();
    await viewModel.deleteTask(task);

    expect(viewModel.tasks, isEmpty);
    expect(viewModel.totalTasks, 0);
  });
}
```

- [ ] **Step 2: Run the extended Task ViewModel tests**

Run:

```powershell
flutter test test/task_view_model_test.dart
```

Expected: PASS because Task 4 already implemented the required ViewModel operations.

- [ ] **Step 3: Replace Task List Page with the real ListView**

Replace `lib/views/task_list_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../models/task.dart';
import '../view_models/task_view_model.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task List')),
      body: Consumer<TaskViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.tasks.isEmpty) {
            return RefreshIndicator(
              onRefresh: viewModel.loadTasks,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 160),
                  Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Center(child: Text('No tasks yet')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.loadTasks,
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: viewModel.tasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final task = viewModel.tasks[index];
                return _TaskCard(task: task);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.addTask);
          if (context.mounted) {
            await context.read<TaskViewModel>().loadTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task});

  final Task task;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete task?'),
          content: Text('Delete "${task.title}" from your task list?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await context.read<TaskViewModel>().deleteTask(task);
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = task.isCompleted ? Colors.green : Colors.orange;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                context.read<TaskViewModel>().toggleTaskStatus(task, value ?? false);
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(task.description),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.event, size: 18),
                        label: Text(task.deadline),
                      ),
                      Chip(
                        label: Text(task.statusText),
                        labelStyle: TextStyle(color: statusColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Replace Add Task Page with the real form**

Replace `lib/views/add_task_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/task_view_model.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (selected == null) {
      return;
    }

    _deadlineController.text = _formatDate(selected);
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await context.read<TaskViewModel>().addTask(
          title: _titleController.text,
          description: _descriptionController.text,
          deadline: _deadlineController.text,
        );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _deadlineController,
                  readOnly: true,
                  onTap: _pickDeadline,
                  decoration: const InputDecoration(
                    labelText: 'Deadline',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event),
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deadline is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _saveTask,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Run tests and static checks**

Run:

```powershell
dart format lib test
flutter analyze
flutter test
```

Expected: all tests pass and analyze reports no issues.

- [ ] **Step 6: Manually verify the required app flow on an emulator or device**

Run:

```powershell
flutter run
```

Verify:

```text
1. App opens on Login Page.
2. Login with admin@gmail.com / 123456 opens Home Page.
3. Home Page shows Total Tasks, Completed Tasks, and Pending Tasks.
4. Go to Task List.
5. Tap + and add a task with title, description, and deadline.
6. The new task appears in Task List after saving.
7. Check the task checkbox and confirm status changes to Completed.
8. Uncheck the task checkbox and confirm status changes to Pending.
9. Delete the task and confirm it disappears.
10. Restart the app and confirm remaining tasks are loaded from SQLite.
```

- [ ] **Step 7: Commit**

```powershell
git add lib test
git commit -m "feat: implement task crud screens"
```

Expected: one commit containing Task List, Add Task, update status, delete, and tests.

---

### Task 6: README, Screenshots, and Demo Preparation

**Files:**
- Create: `README.md`
- Create folder: `screenshots/`

**Interfaces:**
- Consumes: completed app from Tasks 1-5.
- Produces: submission documentation and demo checklist.

- [ ] **Step 1: Create screenshots folder**

Run:

```powershell
New-Item -ItemType Directory -Force screenshots | Out-Null
```

Expected: `screenshots/` exists.

- [ ] **Step 2: Create README**

Create `README.md`:

```markdown
# Student Task Manager App

## Team Information

Team Name: Student Task Manager Team

Members:

1. Student 1 - Project Setup Developer
2. Student 2 - Login Developer
3. Student 3 - Home Developer
4. Student 4 - Database Developer
5. Student 5 - Feature Integration Developer

## Topic

Student Task Manager App

## Login Account

Email: admin@gmail.com

Password: 123456

## Completed Features

- Login
- Home Page
- Task List
- Add Task
- Update Task Status
- Delete Task
- SQLite Storage
- DatePicker deadline selection
- Status color display

## Uncompleted Features

- Search task by title
- Filter tasks by status

## Contribution

Student 1: Project setup, routing, initial pages

Student 2: Login page and login logic

Student 3: Home page and dashboard statistics

Student 4: Task model, SQLite database, task service

Student 5: Task list, add task, delete task, update status

## How to Run

1. flutter pub get
2. flutter run

## Demo Script

1. Login with admin@gmail.com and 123456.
2. Show Home Page dashboard statistics.
3. Open Task List.
4. Add a new task with title, description, and deadline.
5. Mark the task as completed.
6. Mark the task as pending again.
7. Delete the task.
8. Explain each member's contribution.
```

- [ ] **Step 3: Capture screenshots**

Run the app:

```powershell
flutter run
```

Capture these screens manually and save them with these file names:

```text
screenshots/01-login.png
screenshots/02-home.png
screenshots/03-task-list.png
screenshots/04-add-task.png
```

Expected: the four screenshots show the main screens required by the assignment.

- [ ] **Step 4: Final verification**

Run:

```powershell
flutter pub get
dart format lib test
flutter analyze
flutter test
```

Expected: all commands complete successfully.

- [ ] **Step 5: Commit**

```powershell
git add README.md screenshots
git commit -m "docs: add submission readme and screenshots"
```

Expected: one commit containing README and screenshots.

---

## Optional Bonus Task: Search and Filter Tasks

Start this task only after Tasks 1-6 pass. DatePicker deadline selection and status colors are already included in Task 5, so this task adds the remaining two bonus items: search by title and filter by status.

**Files:**
- Modify: `lib/view_models/task_view_model.dart`
- Modify: `lib/views/task_list_page.dart`
- Modify: `test/task_view_model_test.dart`

**Interfaces:**
- Produces: `TaskStatusFilter` enum with `all`, `pending`, `completed`.
- Produces: `TaskViewModel.visibleTasks`, `searchText`, `statusFilter`, `setSearchText()`, and `setStatusFilter()`.

- [ ] **Step 1: Add tests for search and filter**

Append these tests inside the existing `main()` in `test/task_view_model_test.dart`:

```dart
  test('filters visible tasks by title search text', () async {
    final store = FakeTaskStore([
      const Task(
        id: 1,
        title: 'Math homework',
        description: 'Chapter 3',
        deadline: '2026-07-01',
        status: 0,
      ),
      const Task(
        id: 2,
        title: 'History essay',
        description: 'World history',
        deadline: '2026-07-02',
        status: 0,
      ),
    ]);
    final viewModel = TaskViewModel(store);

    await viewModel.loadTasks();
    viewModel.setSearchText('math');

    expect(viewModel.visibleTasks.length, 1);
    expect(viewModel.visibleTasks.single.title, 'Math homework');
  });

  test('filters visible tasks by completion status', () async {
    final store = FakeTaskStore([
      const Task(
        id: 1,
        title: 'Pending task',
        description: 'Still open',
        deadline: '2026-07-01',
        status: 0,
      ),
      const Task(
        id: 2,
        title: 'Completed task',
        description: 'Done',
        deadline: '2026-07-02',
        status: 1,
      ),
    ]);
    final viewModel = TaskViewModel(store);

    await viewModel.loadTasks();
    viewModel.setStatusFilter(TaskStatusFilter.completed);

    expect(viewModel.visibleTasks.length, 1);
    expect(viewModel.visibleTasks.single.title, 'Completed task');
  });
```

- [ ] **Step 2: Run the failing bonus tests**

Run:

```powershell
flutter test test/task_view_model_test.dart
```

Expected: FAIL because `visibleTasks`, `setSearchText`, `setStatusFilter`, and `TaskStatusFilter` do not exist yet.

- [ ] **Step 3: Replace Task ViewModel with the bonus-ready version**

Replace `lib/view_models/task_view_model.dart`:

```dart
import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../services/task_store.dart';

enum TaskStatusFilter {
  all,
  pending,
  completed,
}

class TaskViewModel extends ChangeNotifier {
  TaskViewModel(this._taskStore);

  final TaskStore _taskStore;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchText = '';
  TaskStatusFilter _statusFilter = TaskStatusFilter.all;

  List<Task> get tasks => List.unmodifiable(_tasks);

  List<Task> get visibleTasks {
    return _tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchText.toLowerCase());
      final matchesStatus = switch (_statusFilter) {
        TaskStatusFilter.all => true,
        TaskStatusFilter.pending => !task.isCompleted,
        TaskStatusFilter.completed => task.isCompleted,
      };

      return matchesSearch && matchesStatus;
    }).toList(growable: false);
  }

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  String get searchText => _searchText;

  TaskStatusFilter get statusFilter => _statusFilter;

  int get totalTasks => _tasks.length;

  int get completedTasks => _tasks.where((task) => task.isCompleted).length;

  int get pendingTasks => totalTasks - completedTasks;

  void setSearchText(String value) {
    _searchText = value.trim();
    notifyListeners();
  }

  void setStatusFilter(TaskStatusFilter value) {
    _statusFilter = value;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _taskStore.getTasks();
    } catch (_) {
      _errorMessage = 'Cannot load tasks';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask({
    required String title,
    required String description,
    required String deadline,
  }) async {
    _errorMessage = null;
    notifyListeners();

    try {
      await _taskStore.insertTask(
        Task(
          title: title.trim(),
          description: description.trim(),
          deadline: deadline.trim(),
          status: 0,
        ),
      );
      await loadTasks();
    } catch (_) {
      _errorMessage = 'Cannot add task';
      notifyListeners();
    }
  }

  Future<void> toggleTaskStatus(Task task, bool isCompleted) async {
    if (task.id == null) {
      return;
    }

    _errorMessage = null;
    notifyListeners();

    try {
      await _taskStore.updateTaskStatus(task.id!, isCompleted ? 1 : 0);
      await loadTasks();
    } catch (_) {
      _errorMessage = 'Cannot update task status';
      notifyListeners();
    }
  }

  Future<void> deleteTask(Task task) async {
    if (task.id == null) {
      return;
    }

    _errorMessage = null;
    notifyListeners();

    try {
      await _taskStore.deleteTask(task.id!);
      await loadTasks();
    } catch (_) {
      _errorMessage = 'Cannot delete task';
      notifyListeners();
    }
  }
}
```

- [ ] **Step 4: Replace Task List Page with the bonus-ready version**

Replace `lib/views/task_list_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../models/task.dart';
import '../view_models/task_view_model.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task List')),
      body: Consumer<TaskViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _TaskFilters(viewModel: viewModel),
              Expanded(
                child: _TaskResults(viewModel: viewModel),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.addTask);
          if (context.mounted) {
            await context.read<TaskViewModel>().loadTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskFilters extends StatelessWidget {
  const _TaskFilters({required this.viewModel});

  final TaskViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search by title',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: viewModel.setSearchText,
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<TaskStatusFilter>(
              segments: const [
                ButtonSegment(
                  value: TaskStatusFilter.all,
                  label: Text('All'),
                  icon: Icon(Icons.list),
                ),
                ButtonSegment(
                  value: TaskStatusFilter.pending,
                  label: Text('Pending'),
                  icon: Icon(Icons.pending_actions),
                ),
                ButtonSegment(
                  value: TaskStatusFilter.completed,
                  label: Text('Completed'),
                  icon: Icon(Icons.check_circle_outline),
                ),
              ],
              selected: {viewModel.statusFilter},
              onSelectionChanged: (selection) {
                viewModel.setStatusFilter(selection.single);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskResults extends StatelessWidget {
  const _TaskResults({required this.viewModel});

  final TaskViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final visibleTasks = viewModel.visibleTasks;

    if (visibleTasks.isEmpty) {
      final message = viewModel.tasks.isEmpty ? 'No tasks yet' : 'No matching tasks';

      return RefreshIndicator(
        onRefresh: viewModel.loadTasks,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 120),
            const Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Center(child: Text(message)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.loadTasks,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        itemCount: visibleTasks.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final task = visibleTasks[index];
          return _TaskCard(task: task);
        },
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task});

  final Task task;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete task?'),
          content: Text('Delete "${task.title}" from your task list?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await context.read<TaskViewModel>().deleteTask(task);
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = task.isCompleted ? Colors.green : Colors.orange;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                context.read<TaskViewModel>().toggleTaskStatus(task, value ?? false);
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(task.description),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.event, size: 18),
                        label: Text(task.deadline),
                      ),
                      Chip(
                        label: Text(task.statusText),
                        labelStyle: TextStyle(color: statusColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Run bonus verification**

Run:

```powershell
dart format lib test
flutter analyze
flutter test
```

Expected: all tests pass and analyze reports no issues.

- [ ] **Step 6: Commit**

```powershell
git add lib test README.md
git commit -m "feat: add task search and status filter"
```

Expected: one commit containing the remaining bonus features.

---

## Self-Review

**Spec coverage:**

- Login Page: covered by Task 2.
- Correct login navigates to Home Page: covered by Task 2 manual UI flow and Login Page code.
- Incorrect login shows `Invalid email or password`: covered by Task 2 tests and UI.
- Home Page welcome text and statistics: covered by Task 4.
- Go to Task List and Logout buttons: covered by Task 4.
- SQLite task table and CRUD methods: covered by Task 3 and Task 5 manual verification.
- Task List fields title, description, deadline, status: covered by Task 5.
- Checkbox update status: covered by Task 5.
- Delete Button: covered by Task 5.
- Add Task form with required title, description, deadline: covered by Task 5.
- SQLite persistence after restart: covered by Task 5 manual verification.
- MVVM organization: covered by the file structure and all tasks.
- README and screenshots: covered by Task 6.
- Bonus DatePicker and status color: covered by Task 5.
- Bonus search/filter: covered by Optional Bonus Task.

**Placeholder scan:**

- No implementation step uses `TBD`, `TODO`, `implement later`, or undefined function names.
- The README uses role-based names because the assignment provides roles but not real student names.

**Type consistency:**

- `TaskStore` method names match `TaskService`, `TaskViewModel`, and fake test store.
- `Task.status` values match the spec: `0` pending, `1` completed.
- Route constants are defined once in `AppRoutes` and consumed by all screens.
