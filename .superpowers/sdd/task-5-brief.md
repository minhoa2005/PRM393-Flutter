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

