class Delay {
  void delayed(Duration duration, void Function() callback) {
    Future.delayed(duration, callback);
  }
}
