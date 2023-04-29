class TimeStamp {
  getTimeStamp(int seconds, int nanoseconds) {
    int timestamp = seconds * 1000 + nanoseconds ~/ 1000000;

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return dateTime;
  }
}
