import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_router.dart';
import 'package:flutter_application_1/core/network/api_client.dart';
import 'package:flutter_application_1/feature/application/services/implements/auth_service_impl.dart';
import 'package:flutter_application_1/feature/application/services/interfaces/i_auth_service.dart';
import 'package:flutter_application_1/feature/data/datasources/auth_local_data_source.dart';
import 'package:flutter_application_1/feature/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_application_1/feature/data/mappers/user_mapper/user_mapper.dart';
import 'package:flutter_application_1/feature/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/feature/domain/repositories/i_auth_repository.dart';
import 'package:flutter_application_1/feature/presentation/viewmodel/login_viewmodel.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Dio>(create: (_) => ApiClient.createDio()),

        Provider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSource(context.read<Dio>()),
        ),

        Provider<AuthLocalDataSource>(
          create: (_) => AuthLocalDataSource(const FlutterSecureStorage()),
        ),

        Provider<UserMapper>(create: (_) => UserMapper()),

        Provider<IAuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSource>(),
            localDataSource: context.read<AuthLocalDataSource>(),
            userMapper: context.read<UserMapper>(),
          ),
        ),

        Provider<IAuthService>(
          create: (context) => AuthServiceImpl(context.read<IAuthRepository>()),
        ),

        ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel(context.read<IAuthService>()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter MVVM Login',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        initialRoute: AppRouter.login,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
