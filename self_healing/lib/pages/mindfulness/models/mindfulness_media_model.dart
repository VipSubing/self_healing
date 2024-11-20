import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_service.dart';

part 'mindfulness_media_model.g.dart';

@JsonSerializable()
class MindfulnessMediaModel {
  String name;
  int duration;
  bool isVideo = false;
  String src;
  String? desc;
  MindfulnessMediaType type;
  String? cover;

  MindfulnessMediaModel(
      {required this.name,
      required this.duration,
      required this.src,
      required this.type,
      this.isVideo = false,
      this.cover,
      this.desc});

  // String get typeString {
  //   return type.name;
  // }

  // set typeString(String str) {
  //   type = MindfulnessMediaType.values
  //       .firstWhere((element) => element.name == str);
  // }

  factory MindfulnessMediaModel.fromJson(Map<String, dynamic> json) =>
      _$MindfulnessMediaModelFromJson(json);
  Map<String, dynamic> toJson() => _$MindfulnessMediaModelToJson(this);

  MindfulnessMediaModel copy() {
    return MindfulnessMediaModel(
        name: name,
        duration: duration,
        type: type,
        src: src,
        cover: cover,
        desc: desc,
        isVideo: isVideo);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is MindfulnessMediaModel && other.src == src;
  }

  @override
  int get hashCode => src.hashCode;
}

@JsonEnum(valueField: 'name')
enum MindfulnessMediaType {
  sport("运动"), // 运动
  soga("瑜伽"), // 瑜伽
  meditation("静坐"), // 静坐
  bodyScanning("身体扫描"), //身体扫描
  walk("行走"), //行走
  breathe("呼吸"), //呼吸
  diet("饮食"), //饮食
  compassion("慈悲心"), //慈悲心
  other("其他"), //其他
  ;

  final String name;
  const MindfulnessMediaType(this.name);
}

extension Ex on MindfulnessMediaModel {
  bool get isLoved {
    final controller = Get.find<MindfulnessService>();
    var list = controller.mediaList.value;
    for (var item in list) {
      if (item.src == src) {
        return true;
      }
    }
    return false;
  }

  bool get isPlaying {
    final controller = Get.find<MindfulnessService>();
    return controller.media.value.src == src;
  }
}
