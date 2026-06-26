# Review Package Task 2

Base: 27060e5
Head: c082390fdd7c89c978f10fd89cf6a87e0db52b01

## Commits

c082390 feat: add login page and validation

## Diff Stat

 hackarathon/lib/main.dart                         |  31 +++---
 hackarathon/lib/view_models/login_view_model.dart |  29 ++++++
 hackarathon/lib/views/login_page.dart             | 117 ++++++++++++++++++++--
 hackarathon/test/app_smoke_test.dart              |   4 +-
 hackarathon/test/login_view_model_test.dart       |  24 +++++
 5 files changed, 185 insertions(+), 20 deletions(-)

## Diff

diff --git a/hackarathon/lib/main.dart b/hackarathon/lib/main.dart
index 0c06049..b198b71 100644
--- a/hackarathon/lib/main.dart
+++ b/hackarathon/lib/main.dart
@@ -1,35 +1,40 @@
 import 'package:flutter/material.dart';
+import 'package:provider/provider.dart';
 
 import 'app_routes.dart';
+import 'view_models/login_view_model.dart';
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
-    return MaterialApp(
-      title: 'Student Task Manager App',
-      debugShowCheckedModeBanner: false,
-      theme: ThemeData(
-        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
-        useMaterial3: true,
+    return MultiProvider(
+      providers: [ChangeNotifierProvider(create: (_) => LoginViewModel())],
+      child: MaterialApp(
+        title: 'Student Task Manager App',
+        debugShowCheckedModeBanner: false,
+        theme: ThemeData(
+          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
+          useMaterial3: true,
+        ),
+        initialRoute: AppRoutes.login,
+        routes: {
+          AppRoutes.login: (_) => const LoginPage(),
+          AppRoutes.home: (_) => const HomePage(),
+          AppRoutes.taskList: (_) => const TaskListPage(),
+          AppRoutes.addTask: (_) => const AddTaskPage(),
+        },
       ),
-      initialRoute: AppRoutes.login,
-      routes: {
-        AppRoutes.login: (_) => const LoginPage(),
-        AppRoutes.home: (_) => const HomePage(),
-        AppRoutes.taskList: (_) => const TaskListPage(),
-        AppRoutes.addTask: (_) => const AddTaskPage(),
-      },
     );
   }
 }
diff --git a/hackarathon/lib/view_models/login_view_model.dart b/hackarathon/lib/view_models/login_view_model.dart
new file mode 100644
index 0000000..0353909
--- /dev/null
+++ b/hackarathon/lib/view_models/login_view_model.dart
@@ -0,0 +1,29 @@
+import 'package:flutter/foundation.dart';
+
+class LoginViewModel extends ChangeNotifier {
+  static const String validEmail = 'admin@gmail.com';
+  static const String validPassword = '123456';
+  static const String invalidMessage = 'Invalid email or password';
+
+  String? _errorMessage;
+
+  String? get errorMessage => _errorMessage;
+
+  bool login(String email, String password) {
+    final isValid = email.trim() == validEmail && password == validPassword;
+
+    _errorMessage = isValid ? null : invalidMessage;
+    notifyListeners();
+
+    return isValid;
+  }
+
+  void clearError() {
+    if (_errorMessage == null) {
+      return;
+    }
+
+    _errorMessage = null;
+    notifyListeners();
+  }
+}
diff --git a/hackarathon/lib/views/login_page.dart b/hackarathon/lib/views/login_page.dart
index 93ca6ea..32ebf54 100644
--- a/hackarathon/lib/views/login_page.dart
+++ b/hackarathon/lib/views/login_page.dart
@@ -1,21 +1,126 @@
 import 'package:flutter/material.dart';
+import 'package:provider/provider.dart';
 
 import '../app_routes.dart';
+import '../view_models/login_view_model.dart';
 
-class LoginPage extends StatelessWidget {
+class LoginPage extends StatefulWidget {
   const LoginPage({super.key});
 
+  @override
+  State<LoginPage> createState() => _LoginPageState();
+}
+
+class _LoginPageState extends State<LoginPage> {
+  final _formKey = GlobalKey<FormState>();
+  final _emailController = TextEditingController();
+  final _passwordController = TextEditingController();
+
+  @override
+  void dispose() {
+    _emailController.dispose();
+    _passwordController.dispose();
+    super.dispose();
+  }
+
+  void _submit() {
+    if (!_formKey.currentState!.validate()) {
+      return;
+    }
+
+    final viewModel = context.read<LoginViewModel>();
+    final isLoggedIn = viewModel.login(
+      _emailController.text,
+      _passwordController.text,
+    );
+
+    if (!isLoggedIn) {
+      return;
+    }
+
+    Navigator.pushReplacementNamed(context, AppRoutes.home);
+  }
+
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: const Text('Student Task Manager App')),
-      body: Center(
-        child: ElevatedButton(
-          onPressed: () =>
-              Navigator.pushReplacementNamed(context, AppRoutes.home),
-          child: const Text('Open Home'),
+      body: SafeArea(
+        child: Center(
+          child: SingleChildScrollView(
+            padding: const EdgeInsets.all(24),
+            child: Form(
+              key: _formKey,
+              child: Column(
+                crossAxisAlignment: CrossAxisAlignment.stretch,
+                children: [
+                  const Icon(Icons.school, size: 72, color: Colors.teal),
+                  const SizedBox(height: 16),
+                  const Text(
+                    'Login',
+                    textAlign: TextAlign.center,
+                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
+                  ),
+                  const SizedBox(height: 24),
+                  TextFormField(
+                    controller: _emailController,
+                    keyboardType: TextInputType.emailAddress,
+                    decoration: const InputDecoration(
+                      labelText: 'Email',
+                      border: OutlineInputBorder(),
+                      prefixIcon: Icon(Icons.email_outlined),
+                    ),
+                    validator: (value) {
+                      if (value == null || value.trim().isEmpty) {
+                        return 'Email is required';
+                      }
+                      return null;
+                    },
+                    onChanged: (_) =>
+                        context.read<LoginViewModel>().clearError(),
+                  ),
+                  const SizedBox(height: 16),
+                  TextFormField(
+                    controller: _passwordController,
+                    obscureText: true,
+                    decoration: const InputDecoration(
+                      labelText: 'Password',
+                      border: OutlineInputBorder(),
+                      prefixIcon: Icon(Icons.lock_outline),
+                    ),
+                    validator: (value) {
+                      if (value == null || value.isEmpty) {
+                        return 'Password is required';
+                      }
+                      return null;
+                    },
+                    onChanged: (_) =>
+                        context.read<LoginViewModel>().clearError(),
+                  ),
+                  const SizedBox(height: 12),
+                  Consumer<LoginViewModel>(
+                    builder: (context, viewModel, child) {
+                      if (viewModel.errorMessage == null) {
+                        return const SizedBox.shrink();
+                      }
+
+                      return Text(
+                        viewModel.errorMessage!,
+                        textAlign: TextAlign.center,
+                        style: TextStyle(
+                          color: Theme.of(context).colorScheme.error,
+                        ),
+                      );
+                    },
+                  ),
+                  const SizedBox(height: 20),
+                  FilledButton(onPressed: _submit, child: const Text('Login')),
+                ],
+              ),
+            ),
+          ),
         ),
       ),
     );
   }
 }
diff --git a/hackarathon/test/app_smoke_test.dart b/hackarathon/test/app_smoke_test.dart
index 1ad0ea4..bc6290e 100644
--- a/hackarathon/test/app_smoke_test.dart
+++ b/hackarathon/test/app_smoke_test.dart
@@ -1,11 +1,13 @@
 import 'package:flutter_test/flutter_test.dart';
 import 'package:student_task_manager/main.dart';
 
 void main() {
   testWidgets('app starts on the login page', (tester) async {
     await tester.pumpWidget(const StudentTaskManagerApp());
 
     expect(find.text('Student Task Manager App'), findsOneWidget);
-    expect(find.text('Open Home'), findsOneWidget);
+    expect(find.text('Login'), findsNWidgets(2));
+    expect(find.text('Email'), findsOneWidget);
+    expect(find.text('Password'), findsOneWidget);
   });
 }
diff --git a/hackarathon/test/login_view_model_test.dart b/hackarathon/test/login_view_model_test.dart
new file mode 100644
index 0000000..f2f237c
--- /dev/null
+++ b/hackarathon/test/login_view_model_test.dart
@@ -0,0 +1,24 @@
+import 'package:flutter_test/flutter_test.dart';
+import 'package:student_task_manager/view_models/login_view_model.dart';
+
+void main() {
+  group('LoginViewModel', () {
+    test('accepts the configured admin account', () {
+      final viewModel = LoginViewModel();
+
+      final result = viewModel.login('admin@gmail.com', '123456');
+
+      expect(result, isTrue);
+      expect(viewModel.errorMessage, isNull);
+    });
+
+    test('rejects an incorrect account with the required message', () {
+      final viewModel = LoginViewModel();
+
+      final result = viewModel.login('wrong@gmail.com', 'bad-password');
+
+      expect(result, isFalse);
+      expect(viewModel.errorMessage, 'Invalid email or password');
+    });
+  });
+}
