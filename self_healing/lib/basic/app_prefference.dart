import 'package:hive/hive.dart';
import '../toolkit/log.dart';
import 'package:json_annotation/json_annotation.dart';

// part 'app_prefference.g.dart';

@JsonSerializable()

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

  // factory AppPrefference.fromJson(Map<String, dynamic> json) =>
  //     _$AppPrefferenceFromJson(json);
  // Map<String, dynamic> toJson() => _$AppPrefferenceToJson(this);

  init() {
    log_("AppPrefference load");
    _hive = Hive.box("prefference");
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
}
