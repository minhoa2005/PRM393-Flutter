import 'package:demo1/domain/entities/user.dart';
import 'package:demo1/domain/interface_repositories/iauth_repository.dart';

class LoginUsecase {
  final IAuthRepository repository;

  LoginUsecase(this.repository);

  Future<User?> excute(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username and password must not be empty');
    }

    return await repository.login(username, password);
  }
}
