import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';

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

final MindfulnessMediaModel defaultMedia = MindfulnessMediaModel(
    name: "正念Sample",
    duration: 3200,
    type: MindfulnessMediaType.breathe,
    src:
        "https://public-1-1309961435.cos.ap-chengdu.myqcloud.com/mbct/audios/brahmcentre/jz-45.mp3");

final defaultPlayList = [
  MindfulnessMediaModel(
      name: "正念Sample1",
      duration: 3200,
      type: MindfulnessMediaType.breathe,
      src:
          "https://public-1-1309961435.cos.ap-chengdu.myqcloud.com/mbct/audios/brahmcentre/jz-45.mp3"),
  MindfulnessMediaModel(
      name: "正念Sample2",
      duration: 3200,
      type: MindfulnessMediaType.breathe,
      src:
          "https://public-1-1309961435.cos.ap-chengdu.myqcloud.com/mbct/audios/brahmcentre/jz-10.mp3"),
  MindfulnessMediaModel(
      name: "正念Sample3",
      duration: 3200,
      type: MindfulnessMediaType.breathe,
      src:
          "https://public-1-1309961435.cos.ap-chengdu.myqcloud.com/mbct/audios/brahmcentre/stsm-10.mp4")
];
