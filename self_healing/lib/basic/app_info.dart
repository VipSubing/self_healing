/// App 信息
class AppInfo {
  static AppInfo? _shared;
  static AppInfo get shared {
    _shared ??= AppInfo._internal();
    return _shared!;
  }

  AppInfo._internal();

  String appName = "焦虑自救";
  String appVersion = "0.0.1";
  String slogan = "疗愈自己，快乐人生";
  String anxietyIntro =
      "现代社会，焦虑成为普遍问题，严重影响了我们的生活质量。那如何才能治愈焦虑呢？科学表明，我们的神经细胞具有极强自愈力，这为我们的自我疗愈提供无限可能。";
  String goForIt = "治愈良机";
}
