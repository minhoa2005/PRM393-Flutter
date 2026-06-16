import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_router.dart';
import 'package:flutter_application_1/feature/presentation/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final viewModel = context.read<LoginViewModel>();
    await viewModel.logout();

    if (!context.mounted) {
      return;
    }

    if (viewModel.status == LoginStatus.initial || viewModel.status == LoginStatus.success) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    final user = viewModel.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            tooltip: 'Đăng xuất',
            onPressed: viewModel.isLoading ? null : () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  if (viewModel.status == LoginStatus.failure && viewModel.errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onErrorContainer),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              viewModel.errorMessage!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: user == null
                        ? const Center(child: Text('Không tìm thấy thông tin người dùng.'))
                        : Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: Card(
                                margin: const EdgeInsets.all(24),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 44,
                                        backgroundImage: user.imageUrl.isNotEmpty
                                            ? NetworkImage(user.imageUrl)
                                            : null,
                                        child: user.imageUrl.isEmpty
                                            ? const Icon(Icons.person, size: 44)
                                            : null,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        user.fullName,
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(user.email),
                                      const SizedBox(height: 4),
                                      Text('Username: ${user.username}'),
                                      const SizedBox(height: 24),
                                      FilledButton.icon(
                                        onPressed: () => Navigator.pushNamed(
                                          context,
                                          AppRouter.userManagement,
                                        ),
                                        icon: const Icon(
                                          Icons.supervised_user_circle_outlined,
                                        ),
                                        label: const Text('Quản lý người dùng'),
                                      ),
                                      const SizedBox(height: 8),
                                      FilledButton.icon(
                                        onPressed: () => _logout(context),
                                        icon: const Icon(Icons.logout),
                                        label: const Text('Đăng xuất'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
