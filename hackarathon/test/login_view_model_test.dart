import 'package:flutter_test/flutter_test.dart';
import 'package:student_task_manager/view_models/login_view_model.dart';

void main() {
  group('LoginViewModel', () {
    test('accepts the configured admin account', () {
      final viewModel = LoginViewModel();

      final result = viewModel.login('admin@gmail.com', '123456');

      expect(result, isTrue);
      expect(viewModel.errorMessage, isNull);
    });

    test('rejects an incorrect account with the required message', () {
      final viewModel = LoginViewModel();

      final result = viewModel.login('wrong@gmail.com', 'bad-password');

      expect(result, isFalse);
      expect(viewModel.errorMessage, 'Invalid email or password');
    });
  });
}
