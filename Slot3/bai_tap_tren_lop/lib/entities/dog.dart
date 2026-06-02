import 'package:bai_tap_tren_lop/entities/pet.dart';

class Dog extends Pet {
  Dog(super.name);
  @override
  void sound() {
    print("Gâu Gâu");
  }

  @override
  String toString() {
    return "Chó: $name";
  }
}
