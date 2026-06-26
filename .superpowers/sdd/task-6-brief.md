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
