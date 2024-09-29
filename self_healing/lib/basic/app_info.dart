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
  String anxietyEssence =
      "焦虑总是带来精神痛苦。但痛苦其实是焦虑在欺骗大脑，它夸大和灾难化事实。科学表明，焦虑本质是大脑神经的亚健康化，而我们的大脑神经有极强自愈力。这为我们的自我疗愈提供无限可能。";
  String goForIt = "开启自愈";
}
