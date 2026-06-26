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

