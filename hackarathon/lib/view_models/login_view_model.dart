import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  static const String validEmail = 'admin@gmail.com';
  static const String validPassword = '123456';
  static const String invalidMessage = 'Invalid email or password';

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool login(String email, String password) {
    final isValid = email.trim() == validEmail && password == validPassword;

    _errorMessage = isValid ? null : invalidMessage;
    notifyListeners();

    return isValid;
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;
    notifyListeners();
  }
}
