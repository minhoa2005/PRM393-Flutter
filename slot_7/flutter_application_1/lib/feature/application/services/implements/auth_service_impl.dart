import 'package:flutter_application_1/core/errors/app_exception.dart';
import 'package:flutter_application_1/feature/application/services/interfaces/i_auth_service.dart';
import 'package:flutter_application_1/feature/domain/entities/user.dart';
import 'package:flutter_application_1/feature/domain/repositories/i_auth_repository.dart';

class AuthServiceImpl implements IAuthService {
  final IAuthRepository _authRepository;
  AuthServiceImpl(this._authRepository);

  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    final normalizedUsername = username.trim();
    if (normalizedUsername.isEmpty) {
      throw const AppException('Username khong duoc de trong');
    }
    if (password.isEmpty) {
      throw const AppException('Password khong duoc de trong');
    }
    if (password.length < 6) {
      throw const AppException('Password phai co it nhat 6 ky tu');
    }
    return _authRepository.login(
      username: normalizedUsername,
      password: password,
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    return _authRepository.isLoggedIn();
  }

  @override
  Future<void> logout() async {
    await _authRepository.logout();
  }
}
