import 'package:flutter/material.dart';
import 'package:flutter_application_1/feature/presentation/view/user/add_user.dart';
import 'package:flutter_application_1/feature/presentation/view/home_page.dart';
import 'package:flutter_application_1/feature/presentation/view/login_page.dart';
import 'package:flutter_application_1/feature/presentation/view/user/user_detail.dart';
import 'package:flutter_application_1/feature/presentation/view/user/user_management_page.dart';

class AppRouter {
  AppRouter._();

  static const String login = '/';
  static const String home = '/home';
  static const String userManagement = '/home/user-management';
  static const String addUser = '/home/user-management/add';
  static const String userDetail = '/home/user-management/detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case userManagement:
        return MaterialPageRoute(builder: (_) => const UserManagementPage());
      case addUser:
        final addUserArgs = settings.arguments as Map<String, String>?;
        return MaterialPageRoute(
          builder: (_) => AddUser(userToEdit: addUserArgs),
        );
      case userDetail:
        final detailArgs = settings.arguments as Map<String, String>?;
        return MaterialPageRoute(builder: (_) => UserDetail(data: detailArgs));
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}
