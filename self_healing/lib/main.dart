import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:self_healing/basic/app_info.dart';
import 'package:self_healing/basic/app_prefference.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:self_healing/pages/mindfulness/other/audio/audio.dart';
import 'package:self_healing/routes/routes.dart';
import 'package:self_healing/toolkit/log.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(AppPrefference.prefferenceBox);
  await initAudioService();
  log_("app will loads");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppInfo.shared.appName,
      theme: AppStyle.shared.light,
      locale: const Locale('zh', 'CN'), // 设置为中文简体

      darkTheme: AppStyle.shared.dark,
      initialRoute:
          AppPrefference.shared.isFirstLoad ? Routes.guide : Routes.index,
      routes: Routes.shared.pages(),
      // here
      navigatorObservers: [FlutterSmartDialog.observer],
      // here
      builder: FlutterSmartDialog.init(),
    );
  }
}
