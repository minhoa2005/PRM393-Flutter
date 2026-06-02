import 'package:demo1/core/constrants/app_colors.dart';
import 'package:demo1/presentation/pages/login_page.dart';
import 'package:demo1/presentation/pages/manage_user_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String fullName;

  const HomePage({super.key, required this.fullName});

  void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: AppBar(
        title: const Text('Trang chủ'),
        backgroundColor: AppColors.primaryBlue,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Xin chào, $fullName!',
              style: const TextStyle(
                fontSize: 22,
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 32),

            _buildMenuButton(icon: Icons.search, title: 'Tra cứu'),

            const SizedBox(height: 16),

            _buildMenuButton(
              icon: Icons.people,
              title: 'Quản lý người dùng',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageUserPage()),
                );
              },
            ),

            const SizedBox(height: 16),

            _buildMenuButton(
              icon: Icons.logout,
              title: 'Đăng xuất',
              onTap: () => logout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(width: 18),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 19),
            ),
          ],
        ),
      ),
    );
  }
}
