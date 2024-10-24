import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:self_healing/basic/app_prefference.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_controller.dart';

part 'mindfulness_media_model.g.dart';

@JsonSerializable()
class MindfulnessMediaModel {
  String name;
  int duration;
  bool isVideo = false;
  String src;
  MindfulnessMediaType type;
  String? cover;

  MindfulnessMediaModel(
      {required this.name,
      required this.duration,
      required this.src,
      required this.type,
      this.isVideo = false,
      this.cover});

  String get typeString {
    return type.name;
  }

  set typeString(String str) {
    type = MindfulnessMediaType.values
        .firstWhere((element) => element.name == str);
  }

  factory MindfulnessMediaModel.fromJson(Map<String, dynamic> json) =>
      _$MindfulnessMediaModelFromJson(json);
  Map<String, dynamic> toJson() => _$MindfulnessMediaModelToJson(this);

  MindfulnessMediaModel copy() {
    return MindfulnessMediaModel(
        name: name, duration: duration, type: type, src: src, cover: cover);
  }
}

enum MindfulnessMediaType {
  other("其他"), //其他
  soga(" 瑜伽"), // 瑜伽
  meditation("静坐"), // 静坐
  bodyScanning("身体扫描"), //身体扫描
  walk("行走"), //行走
  breathe("呼吸"), //呼吸
  diet("饮食"), //饮食
  compassion("慈悲心") //慈悲心
  ;

  final String name;
  const MindfulnessMediaType(this.name);
}

extension Ex on MindfulnessMediaModel {
  bool get isCollected {
    final controller = Get.find<MindfulnessController>();
    var list = controller.mediaList.value;
    for (var item in list) {
      if (item.src == src) {
        return true;
      }
    }
    return false;
  }

  set isCollected(bool val) {
    final controller = Get.find<MindfulnessController>();
    if (val) {
      controller.mediaList.value.add(this.copy());
      // controller.mediaList.value = List.from(controller.mediaList.value);
    } else {
      controller.mediaList.value.removeWhere((item) {
        return item.src == src;
      });
    }
  }

  bool get isPlaying {
    final controller = Get.find<MindfulnessController>();
    return controller.media.value.src == src;
  }
}
