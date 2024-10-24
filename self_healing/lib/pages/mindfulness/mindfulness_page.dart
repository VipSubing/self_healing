import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_controller.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/pages/mindfulness/widgets/list_sheet.dart';
import 'package:self_healing/pages/mindfulness/widgets/mindfulness_control_w.dart';
import 'package:self_healing/pages/mindfulness/widgets/mindfulness_info_w.dart';
import 'package:self_healing/pages/mindfulness/widgets/mindfulness_tips_w.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:tuple/tuple.dart';

class MindfulnessPage extends GetView<MindfulnessController>
    implements MindfulnessControlWDelegate {
  MindfulnessPage({super.key}) {
    Get.put(MindfulnessController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.only(
            left: AppStyle.horizontalPadding,
            right: AppStyle.horizontalPadding),
        child: Obx(() {
          "${controller.forceUpdate.value}";
          return Column(
            children: [
              MindfulnessTips(
                  tipsText: "MindfulnessTips\n2\n2", onPress: () {}),
              SizedBox(
                height: 20,
              ),
              MindfulnessInfoW(
                name: controller.media.value.name,
                time: formatMinutes(controller.media.value.duration),
                tag: controller.media.value.type.name,
                isLoved: controller.media.value.isCollected,
                cover: controller.media.value.cover,
                loveCallback: (bool loved) {
                  log_("press loved :${!loved}");
                  controller.media.value.isCollected = !loved;
                  controller.forceUpdate.value += 1;
                },
              ),
              Spacer(),
              Obx(() {
                "force build ${controller.mediaController.forceUpdate}";
                return MindfulnessControlW(
                    secs: controller.mediaController.secs,
                    totalSecs: controller.mediaController.totalSecs,
                    mode: controller.mediaController.mode.value.raw,
                    playing: controller.mediaController.isPlaying.value,
                    delegate: this);
              }),
              SizedBox(
                height: 40,
              )
            ],
          );
        }),
      )),
    );
  }

  @override
  void mediaControlListOnCallback() {
    showListSheet(context: Get.context!,models: controller.mediaList.value);
  }

  @override
  void mediaControlModeOnCallback(int currentMode) {
    controller.mediaController.setupMode(currentMode);
  }

  @override
  void mediaControlPlayOnCallback(bool currentPlaying) {
    controller.mediaController.setupPlay(currentPlaying);
  }

  @override
  void mediaControlSliderValOnCallback(double destinationVal) {
    controller.mediaController.setupVal(destinationVal);
  }
}
