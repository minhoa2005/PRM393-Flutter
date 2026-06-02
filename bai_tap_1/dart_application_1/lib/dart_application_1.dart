//ex1
import 'dart:io';

void ex1() {
  int a = 10;
  double b = 2.12;
  String c = "Minh";
  bool d = false;
  print("$a, $b, $c, $d");
}

void ex2() {
  List<int> list = [1, 2, 3, 4, 5];
  print(list);
  for (int i = 0; i < list.length; i++) {
    for (int j = i + 1; j < list.length; j++) {
      if (i < j) {
        int temp = list[i];
        list[i] = list[j];
        list[j] = temp;
      }
    }
  }
  print(list);
  Set<int> set = {1, 2, 3, 4, 5};
  print("Set: $set");
  Map<String, int> map = {"a": 1, "b": 2, "c": 3};
  print("Map: $map");
  set.remove(2);
  print("Remove 2 from set: $set");
  set.add(6);
  print("Add 6 to set: $set");
  print("Access value of key b in map: ${map["b"]}");
}

void ex3() {
  bool check = false;
  while (check == false) {
    try {
      print("Enter score: ");
      double score = double.parse(stdin.readLineSync()!);
      check = true;
      if (score >= 8) {
        print("Very good");
      } else if (score >= 6) {
        print("Good");
      } else if (score >= 5) {
        print("Average");
      } else {
        print("Poor");
      }
    } catch (e) {
      print("Invalid input, please enter a number");
    }
  }
  check = false;
  while (check == false) {
    try {
      print("Enter day: ");
      int day = int.parse(stdin.readLineSync()!);
      check = true;
      switch (day) {
        case 2:
          print("Monday");
          break;
        case 3:
          print("Tuesday");
          break;
        case 4:
          print("Wednesday");
          break;
        case 5:
          print("Thursday");
          break;
        case 6:
          print("Friday");
          break;
        case 7:
          print("Saturday");
          break;
        case 8:
          print("Sunday");
          break;
        default:
          print("Invalid day");
      }
    } catch (e) {
      print("Invalid input, please enter a number");
    }
  }
  List<int> list = [1, 2, 3, 4, 5];
  print("Using for loop:");
  for (int i = 0; i < list.length; i++) {
    print(list[i]);
  }
  print("Using for-in loop:");
  for (int i in list) {
    print(i);
  }
  print("Using forEach loop:");
  list.forEach((i) => print(i));
}
