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
      providers: [ChangeNotifierProvider(create: (_) => LoginViewModel())],
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
