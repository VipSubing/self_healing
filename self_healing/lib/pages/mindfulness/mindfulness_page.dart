import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_service.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/pages/mindfulness/widgets/list_sheet.dart';
import 'package:self_healing/pages/mindfulness/widgets/mindfulness_control_w.dart';
import 'package:self_healing/pages/mindfulness/widgets/mindfulness_info_w.dart';
import 'package:self_healing/pages/mindfulness/widgets/mindfulness_tips_w.dart';
import 'package:self_healing/routes/routes.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:self_healing/widgets/brightness/image.dart';
import 'package:self_healing/widgets/dialog/alert.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MindfulnessPage extends GetView<MindfulnessService>
    implements MindfulnessControlWDelegate {
  const MindfulnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    MindfulnessService.shared();
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.only(
            left: AppStyle.horizontalPadding,
            right: AppStyle.horizontalPadding),
        child: Stack(
          children: [
            Obx(() {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  MindfulnessTips(onPress: () {
                    Get.toNamed(Routes.mindfulnessTips);
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  MindfulnessInfoW(
                    name: controller.media.value.name,
                    time: formatMinutes(controller.media.value.duration),
                    tag: controller.media.value.type.name,
                    isLoved: controller.media.value.isLoved,
                    cover: controller.media.value.cover,
                    loveCallback: onPressMainLove,
                  ),
                  const Spacer(),
                  Obx(() {
                    return MindfulnessControlW(
                        secs: controller.mediaController.secs.value,
                        totalSecs: controller.mediaController.totalSecs.value,
                        mode: controller.mediaController.mode.value.raw,
                        playing: controller.mediaController.isPlaying.value,
                        delegate: this);
                  }),
                  const SizedBox(
                    height: 40,
                  )
                ],
              );
            }),
            Positioned(
                right: 0,
                top: 10,
                child: PopupMenuButton<int>(
                  padding: const EdgeInsets.all(15),
                  onSelected: onPressMore,
                  icon: const BrightnessIcon(
                    src: "assets/icons/more_icon.png",
                    size: Size(25, 25),
                  ),
                  itemBuilder: (context) {
                    return <PopupMenuEntry<int>>[
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text(
                          '社区资源',
                          style: AppTextStyle.font18,
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text(
                          '新建正念',
                          style: AppTextStyle.font18,
                        ),
                      ),
                    ];
                  },
                ))
          ],
        ),
      )),
    );
  }

  onPressMore(int index) {
    log_("go more");
    switch (index) {
      case 0:
        Get.toNamed(Routes.mindfulnessShop);
        break;
      case 1:
        Get.toNamed(Routes.mindfulnessCreate);
        break;
      default:
    }
  }

  // 点击主界面Love
  onPressMainLove(bool loved) {
    log_("press loved :${!loved}");
    if (loved) {
      showPlainAlert(Get.context!, title: "提示", content: "取消红心将会把当前资源从播放列表移除",
          sureCallback: () {
        controller.setupLoved(controller.media.value, !loved);
      });
    } else {
      controller.setupLoved(controller.media.value, !loved);
    }
  }

  @override
  void mediaControlListOnCallback() {
    showListSheet(context: Get.context!);
  }

  @override
  void mediaControlModeOnCallback(int currentMode) {
    controller.mediaController.setupMode(currentMode);
  }

  @override
  void mediaControlPlayOnCallback(bool currentPlaying) {
    controller.mediaController.setupPlay(!currentPlaying);
  }

  @override
  void mediaControlSliderValOnCallback(double destinationVal) {
    controller.mediaController.setupVal(destinationVal);
  }
}
