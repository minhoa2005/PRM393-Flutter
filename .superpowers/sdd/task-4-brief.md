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

