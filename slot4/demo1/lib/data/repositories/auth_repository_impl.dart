import 'package:demo1/data/datasources/auth_local_datasource.dart';
import 'package:demo1/domain/entities/user.dart';
import 'package:demo1/domain/interface_repositories/iauth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthLocalDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<User?> login(String username, String password) async {
    return await datasource.login(username, password);
  }
}
