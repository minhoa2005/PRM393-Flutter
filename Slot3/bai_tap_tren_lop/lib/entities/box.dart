import 'package:bai_tap_tren_lop/common/can_run.dart';

class Box<T> with CanRun {
  T value;
  Box(this.value);
  void display() {
    print("$value");
    run();
  }
}
