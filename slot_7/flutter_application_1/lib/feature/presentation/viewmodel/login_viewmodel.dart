import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/errors/app_exception.dart';
import 'package:flutter_application_1/feature/application/services/interfaces/i_auth_service.dart';
import 'package:flutter_application_1/feature/domain/entities/user.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginViewModel extends ChangeNotifier {
  final IAuthService _authService;
  LoginViewModel(this._authService);
  LoginStatus _status = LoginStatus.initial;
  String? _errorMessage;
  User? _currentUser;

  LoginStatus get status => _status;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  bool get isLoading => _status == LoginStatus.loading;

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _status = LoginStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _authService.login(
        username: username,
        password: password,
      );
      _status = LoginStatus.success;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = 'Mat khau hoac tai khoan khong chinh xac';
      _status = LoginStatus.failure;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _status = LoginStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.logout();
      _currentUser = null;
      _status = LoginStatus.initial;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _status = LoginStatus.failure;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _status = LoginStatus.failure;
      notifyListeners();
    }
  }
}
