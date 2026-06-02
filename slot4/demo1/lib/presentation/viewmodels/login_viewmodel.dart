import 'package:demo1/domain/entities/user.dart';
import 'package:demo1/domain/usecases/login_usecase.dart';
import 'package:flutter/widgets.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUsecase loginUsecase;

  LoginViewModel(this.loginUsecase);

  bool isLoading = false;
  String? errorMessage;
  User? currentUser;

  Future<bool> login(String username, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final user = await loginUsecase.excute(username, password);
      if (user == null) {
        errorMessage = 'Sai mat khau hoac ten dang nhap';
        return false;
      }

      currentUser = user;
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
