import 'package:demo1/domain/entities/user.dart';

interface class IAuthRepository {
  Future<User?> login(String username, String password) {
    throw UnimplementedError();
  }
}
