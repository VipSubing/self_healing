import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:self_healing/basic/app_info.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/routes/routes.dart';
import 'package:self_healing/toolkit/log.dart';

class GuidePage extends GetView {
  GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    log_("GuidePage build");
    // TODO: implement build
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: EdgeInsets.fromLTRB(
          AppStyle.horizontalPadding, 30, 20, AppStyle.horizontalPadding),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(AppStyle.imgCornerRadius),
            child:
                Image.asset("assets/imgs/guide_1.jpeg", fit: BoxFit.fitWidth)),
        const SizedBox(height: 40),
        Text(AppInfo.shared.slogan,
            textAlign: TextAlign.center,
            style: AppTextStyle.font36.weight200()),
        const SizedBox(height: 15),
        Text(
          AppInfo.shared.anxietyIntro,
          style: AppTextStyle.font18,
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            log_("start self healing");
            Get.toNamed(Routes.guide1);
          },
          child: Text(AppInfo.shared.goForIt),
        )
      ]),
    )));
  }
}
