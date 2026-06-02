import 'package:dart_application_1/entities/student.dart';

class StudentFu extends Student {
  String id;
  String name;

  StudentFu(this.id, this.name);

  @override
  void goToSchool() {
    print("Di hoc tren Hola");
  }
}
