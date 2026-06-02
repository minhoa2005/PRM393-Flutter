import 'package:dart_application_1/common/logger.dart';
import 'package:dart_application_1/services/interfaces/iStudent.dart';

class StudentImpl with Logger implements IStudent {
  void input() {
    log("Du lieu dau vao");
  }
}
