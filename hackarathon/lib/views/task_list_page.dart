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
