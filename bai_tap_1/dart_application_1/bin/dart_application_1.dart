import 'dart:io';

import 'package:dart_application_1/dart_application_1.dart'
    as dart_application_1;
import 'package:dart_application_1/entities/car.dart';
import 'package:dart_application_1/entities/electric_car.dart';

void main(List<String> arguments) {
  int choice = 0;
  while (choice != 5) {
    print("1. Exercise 1");
    print("2. Exercise 2");
    print("3. Exercise 3");
    print("4. Exercise 4");
    print("5. Exit");
    print("Enter your choice: ");
    try {
      choice = int.parse(stdin.readLineSync()!);
      switch (choice) {
        case 1:
          dart_application_1.ex1();
          break;
        case 2:
          dart_application_1.ex2();
          break;
        case 3:
          dart_application_1.ex3();
          break;
        case 4:
          Car car = Car("Toyota");
          car.start();
          ElectricCar electricCar = ElectricCar("VinFast");
          electricCar.start();
          break;
        default:
          print("Exit");
      }
    } catch (e) {
      print("Invalid input, please enter a number");
    }
  }
}
