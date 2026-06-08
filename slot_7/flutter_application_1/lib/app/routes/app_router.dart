import 'package:flutter/material.dart';
import 'package:flutter_application_1/feature/presentation/view/home_page.dart';
import 'package:flutter_application_1/feature/presentation/view/login_page.dart';

class AppRouter {
  AppRouter._();

  static const String login = '/';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}
