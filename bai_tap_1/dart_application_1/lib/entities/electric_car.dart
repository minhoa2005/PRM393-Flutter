import 'package:dart_application_1/entities/car.dart';

class ElectricCar extends Car {
  ElectricCar(super.name);

  @override
  void start() {
    print("$name is starting using electric");
  }
}
