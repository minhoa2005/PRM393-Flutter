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

