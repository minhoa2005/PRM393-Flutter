abstract class Student {
  void goToSchool();

  int id;
  String name;
  int mark;

  Student(this.id, this.name, this.mark);

  String checkRank() {
    if (mark >= 8) {
      return "Tốt";
    } else if (mark >= 6) {
      return "Khá";
    } else if (mark >= 5) {
      return "Trung bình";
    } else {
      return "Không đánh giá";
    }
  }

  void getInfo() {
    print("ID: $id, Name: $name, Mark: $mark, Rank: ${checkRank()}\n");
  }
}
