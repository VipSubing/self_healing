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
  const MindfulnessMediaType( this.name);
}

extension Ex on MindfulnessMediaModel {
  bool get isCollected {
    return true;
  }
}
