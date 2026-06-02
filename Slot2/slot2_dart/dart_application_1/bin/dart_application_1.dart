import 'dart:io';

import 'package:dart_application_1/dart_application_1.dart'
    as dart_application_1;
import 'package:dart_application_1/entities/student.dart';
import 'package:dart_application_1/services/studentService.dart';

void main(List<String> arguments) {
  // print('Hello world: ${dart_application_1.calculate()}!');

  // int a = 10;
  // String name = "Minh";

  // print("Tên: $name");

  // List<int> array = [1, 2, 3, 4, 5];
  // array.add(6);
  // print("Mảng: $array");
  // stdout.write("Nhập tên: ");
  // String fullName = stdin.readLineSync()!;
  // stdout.write("Nhập tuổi: ");
  // int age = int.parse(stdin.readLineSync()!);
  // print("Full Name: $fullName, Age: $age");
  StudentService studentList = StudentService();
  int choice;
  do {
    stdout.write(
      "Chọn:\n 1. Thêm sinh viên\n 2. Hiển thị sinh viên\n 3. Cập nhật thông tin sinh viên\n 4. Xóa sinh viên\n 5. Tìm kiếm sinh viên theo tên\n 6. Lọc sinh viên theo điểm\n 7. Thoát\n",
    );
    choice = int.parse(stdin.readLineSync()!);
    switch (choice) {
      case 1:
        stdout.write("Nhập tên: ");
        String fullName = stdin.readLineSync()!;
        int mark;
        try {
          stdout.write("Nhập điểm: ");
          mark = int.parse(stdin.readLineSync()!);
        } catch (e) {
          print("Điểm không hợp lệ");
          break;
        }
        if (fullName.isEmpty || mark.isNegative) {
          print("Vui lòng nhập đầy đủ thông tin");
        } else {
          if (studentList.students.length == 0) {
            Student student = Student(0, fullName, mark);
            studentList.addStudent(student);
          } else {
            Student student = Student(
              studentList.students.length,
              fullName,
              mark,
            );
            studentList.addStudent(student);
          }
        }
        break;
      case 2:
        studentList.displayStudents();
        break;
      case 3:
        stdout.write("Nhập id: ");
        int id = int.parse(stdin.readLineSync()!);
        stdout.write("Nhập tên mới: ");
        String name = stdin.readLineSync()!;
        int mark;
        try {
          stdout.write("Nhập điểm mới: ");
          mark = int.parse(stdin.readLineSync()!);
        } catch (e) {
          print("Điểm không hợp lệ");
          break;
        }
        studentList.updateStudentInfo(id, name, mark);
        break;
      case 4:
        stdout.write("Nhập id: ");
        int id;
        try {
          id = int.parse(stdin.readLineSync()!);
        } catch (e) {
          print("ID không hợp lệ");
          break;
        }
        if (id.isNaN || id.isNegative) {
          print("Không hợp lệ");
          break;
        }
        studentList.deleteStudent(id);
        break;
      case 5:
        stdout.write("Nhập tên: ");
        String name = stdin.readLineSync()!;
        if (name.isEmpty) {
          print("Không hợp lệ");
          break;
        }
        studentList.searchStudentByName(name);
        break;
      case 6:
        bool isGreater;
        stdout.write(
          "1. Lọc sinh viên có điểm lớn hơn\n 2. Lọc sinh viên có điểm nhỏ hơn\n",
        );
        int select;
        try {
          select = int.parse(stdin.readLineSync()!);
        } catch (e) {
          print("Lựa chọn không hợp lệ");
          break;
        }

        if (select == 1) {
          isGreater = true;
        } else if (select == 2) {
          isGreater = false;
        } else {
          print("Lựa chọn không hợp lệ");
          break;
        }
        stdout.write("Nhập điểm: ");
        int mark;
        try {
          mark = int.parse(stdin.readLineSync()!);
        } catch (e) {
          print("Điểm không hợp lệ");
          break;
        }
        if (mark.isNaN) {
          print("Không hợp lệ");
          break;
        }
        studentList.sortStudentsByMark(isGreater, mark);
        break;
      default:
        print("Lựa chọn không hợp lệ");
    }
  } while (choice != 7);
}
