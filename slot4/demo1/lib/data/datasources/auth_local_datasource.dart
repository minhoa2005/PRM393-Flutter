import 'package:demo1/data/models/user_model.dart';

class AuthLocalDatasource {
  Future<UserModel?> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (username == 'admin' && password == 'admin') {
      return UserModel(username: 'admin', fullName: 'Hoang Trong Hieu');
    }

    return null;
  }
}
