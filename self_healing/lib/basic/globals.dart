String formatSeconds(int seconds) {
  int hours = seconds ~/ 3600;
  seconds %= 3600;
  int minutes = seconds ~/ 60;
  seconds %= 60;
  String text =
      "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  if (hours > 0) {
    text = "${hours.toString().padLeft(2, '0')}:" + text;
  }
  return text;
}

String formatMinutes(int seconds) {
  return "${(seconds / 60).toInt()}分钟";
}
