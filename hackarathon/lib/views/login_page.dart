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
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.home),
          child: const Text('Open Home'),
        ),
      ),
    );
  }
}
