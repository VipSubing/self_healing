import 'package:hive/hive.dart';
import 'package:self_healing/basic/const.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import '../toolkit/log.dart';

/// APP偏好设置
class AppPrefference {
  static String prefferenceBox = "prefference";
  static AppPrefference? _shared;
  static AppPrefference get shared {
    _shared ??= AppPrefference._internal();
    return _shared!;
  }

  AppPrefference._internal() {
    init();
  }

  late Box _hive;

  init() {
    log_("AppPrefference load");
    _hive = Hive.box("prefference");
    // _hive.clear();
  }

  /* These are attributes at prefference   */

  /// whether the app is frist load
  set isFirstLoad(bool value) {
    _hive.put("isFirstLoad", value);
  }

  bool get isFirstLoad {
    var value = _hive.get("isFirstLoad") as bool?;
    value = value ?? true;
    return value;
  }

  set playerMode(int mode) {
    _hive.put("playerMode", mode);
  }

  int get playerMode {
    var value = _hive.get("playerMode") as int?;
    value = value ?? 0;
    return value;
  }

  set currentMediaIndex(int mediaIndex) {
    _hive.put("currentMediaIndex", mediaIndex);
  }

  int get currentMediaIndex {
    int? val = _hive.get("currentMediaIndex");
    return val ?? 0;
  }

  set playList(List<MindfulnessMediaModel> list) {
    final jsonList = list.map((item) {
      return item.toJson();
    }).toList();

    _hive.put("playList", jsonList);
  }

  List<MindfulnessMediaModel> get playList {
    List<dynamic> val = _hive.get("playList") ?? defaultMediaJsonList;
    List<Map<String, dynamic>> jsonList = val.map((item) {
      final json = item as Map<dynamic, dynamic>;
      return Map<String, dynamic>.from(json);
    }).toList();

    return jsonList.map((item) {
      return MindfulnessMediaModel.fromJson(item);
    }).toList();
  }
}
