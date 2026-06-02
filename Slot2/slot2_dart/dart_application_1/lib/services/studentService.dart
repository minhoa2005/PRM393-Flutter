import 'package:dart_application_1/entities/student.dart';

class StudentService {
  List<Student> students = [];
  void addStudent(Student student) {
    students.add(student);
  }

  void displayStudents() {
    for (int i = 0; i < students.length; i++) {
      students[i].getInfo();
    }
  }

  void updateStudentInfo(int id, String name, int mark) {
    for (int i = 0; i < students.length; i++) {
      if (students[i].id == id) {
        if (name.isNotEmpty) {
          students[i].name = name;
        }
        if (!mark.isNaN) {
          students[i].mark = mark;
        }
        break;
      }
    }
  }

  void deleteStudent(int id) {
    for (int i = 0; i < students.length; i++) {
      if (students[i].id == id) {
        students.removeAt(i);
        break;
      }
    }
  }

  void searchStudentByName(String name) {
    for (int i = 0; i < students.length; i++) {
      if (students[i].name == name) {
        students[i].getInfo();
        break;
      }
    }
  }

  void sortStudentsByMark(bool isGreater, int mark) {
    if (isGreater) {
      for (int i = 0; i < students.length; i++) {
        if (students[i].mark >= mark) {
          students[i].getInfo();
        }
      }
    } else {
      for (int i = 0; i < students.length; i++) {
        if (students[i].mark <= mark) {
          students[i].getInfo();
        }
      }
    }
  }
}
