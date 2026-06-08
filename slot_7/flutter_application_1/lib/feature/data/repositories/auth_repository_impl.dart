import 'package:flutter_application_1/feature/data/datasources/auth_local_data_source.dart';
import 'package:flutter_application_1/feature/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_application_1/feature/data/dtos/login/login_request_dto.dart';
import 'package:flutter_application_1/feature/data/mappers/user_mapper/user_mapper.dart';
import 'package:flutter_application_1/feature/domain/entities/user.dart';
import 'package:flutter_application_1/feature/domain/repositories/i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final UserMapper _userMapper;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required UserMapper userMapper,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _userMapper = userMapper;

  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    final request = LoginRequestDto(username: username, password: password);
    final response = await _remoteDataSource.login(request);
    await _localDataSource.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return _userMapper.map(response);
  }

  @override
  Future<bool> isLoggedIn() async {
    return _localDataSource.hasTokens();
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearTokens();
  }
}
