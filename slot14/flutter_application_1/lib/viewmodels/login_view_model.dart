import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final String _validEmail = 'admin@gmail.com';
  final String _validPassword = '123456';

  String? _errorMessage;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  bool login(String email, String password) {
    _isLoading = true;
    notifyListeners();

    if (email == _validEmail && password == _validPassword) {
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
