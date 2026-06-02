import 'package:bai_tap_tren_lop/common/delay.dart';
import 'package:bai_tap_tren_lop/entities/box.dart';
import 'package:bai_tap_tren_lop/entities/dog.dart';

void main(List<String> arguments) async {
  Dog dog = Dog("Mike");
  Box<Dog> box = Box(dog);
  Delay delay = Delay();
  print("Trì hoãn 2 giây");
  delay.delayed(Duration(seconds: 2), () {
    print("Thành công");
    box.display();
  });
  Stream<int> stream() async* {
    for (int i = 0; i <= 5; i++) {
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }

  await for (int value in stream()) {
    print(value);
  }
}
