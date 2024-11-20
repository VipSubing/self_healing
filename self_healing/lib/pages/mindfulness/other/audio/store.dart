import 'package:hive/hive.dart';
import 'package:self_healing/basic/const.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';

class MindfulessStore {
  static String mindfulness = "mindfulness";
  static MindfulessStore? _shared;
  static MindfulessStore get shared {
    _shared ??= MindfulessStore._internal();
    return _shared!;
  }

  MindfulessStore._internal();

  final Box _hive = Hive.box(mindfulness);

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

  set historyTime(int secs) {
    _hive.put("historyTime", secs);
  }

  int get historyTime {
    var value = _hive.get("historyTime") as int?;
    value = value ?? 0;
    return value;
  }

  set historyStatistics(Map<String, int> map) {
    _hive.put("historyStatistics", map);
  }

  Map<String, int> get historyStatistics {
    Map<dynamic, dynamic> val =
        _hive.get("historyStatistics") ?? <dynamic, dynamic>{};
    return Map<String, int>.from(val);
  }

  set tips(List<String> list) {
    _hive.put("tips", list);
  }

  List<String> get tips {
    List<String> val = _hive.get("tips") ?? ["允许一切发生"];

    return val;
  }
}
