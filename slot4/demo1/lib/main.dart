import 'package:demo1/data/datasources/auth_local_datasource.dart';
import 'package:demo1/data/repositories/auth_repository_impl.dart';
import 'package:demo1/domain/usecases/login_usecase.dart';
import 'package:demo1/presentation/pages/login_page.dart';
import 'package:demo1/presentation/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final authLocalDatasource = AuthLocalDatasource();
  final authRepository = AuthRepositoryImpl(authLocalDatasource);
  final loginUseCase = LoginUsecase(authRepository);

  runApp(MyApp(loginUsecase: loginUseCase));
}

class MyApp extends StatelessWidget {
  final LoginUsecase loginUsecase;

  const MyApp({super.key, required this.loginUsecase});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(loginUsecase),
      child: MaterialApp(
        title: 'Layered Login Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF2B74C8),
          scaffoldBackgroundColor: const Color(0xFFEAF2FF),
          useMaterial3: false,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
