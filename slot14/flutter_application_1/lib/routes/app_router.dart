import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();
  static const String login = '/';
  static const String home = '/home';
  static const String task = '/tasks';
  static const String addTask = '/add-task';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case task:
        final taskArgs = settings.arguments as Map<String, String>?;
        return MaterialPageRoute(builder: (_) => TaskPage(taskData: taskArgs));
      case addTask:
        return MaterialPageRoute(builder: (_) => const AddTaskPage());
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}
