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
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.login),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
