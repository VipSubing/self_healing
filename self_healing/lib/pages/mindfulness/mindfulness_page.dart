import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_controller.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/pages/mindfulness/widgets/list_sheet/list_sheet.dart';
import 'package:self_healing/pages/mindfulness/widgets/list_sheet/list_sheet_controller.dart';
import 'package:self_healing/pages/mindfulness/widgets/mindfulness_control_w.dart';
import 'package:self_healing/pages/mindfulness/widgets/mindfulness_info_w.dart';
import 'package:self_healing/pages/mindfulness/widgets/mindfulness_tips_w.dart';
import 'package:self_healing/routes/routes.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:self_healing/widgets/brightness/image.dart';
import 'package:self_healing/widgets/dialog/alert.dart';
import 'package:tuple/tuple.dart';

class MindfulnessPage extends GetView<MindfulnessController>
    implements MindfulnessControlWDelegate, ListSheetDelegate {
  MindfulnessPage({super.key}) {
    Get.put(MindfulnessController());
  }
  ListSheetController? sheetController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.only(
            left: AppStyle.horizontalPadding,
            right: AppStyle.horizontalPadding),
        child: Stack(
          children: [
            Obx(() {
              "${controller.forceUpdate.value}";
              return Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  MindfulnessTips(tipsText: "允许一切发生\n", onPress: () {}),
                  SizedBox(
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
            Positioned(
                right: 0,
                top: 10,
                child: PopupMenuButton<int>(
                  padding: EdgeInsets.all(15),
                  onSelected: onPressMore,
                  icon: const BrightnessIcon(
                    src: "assets/icons/more_icon.png",
                    size: Size(25, 25),
                  ),
                  itemBuilder: (context) {
                    return <PopupMenuEntry<int>>[
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text('更多正念'),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text('新建正念'),
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
      showAlert(Get.context!, title: "提示", content: "取消红心将会把当前资源从播放列表移除",
          sureCallback: () {
        controller.setupLoved(controller.media.value, !loved);
        controller.forceUpdate.value += 1;
      });
    } else {
      controller.setupLoved(controller.media.value, !loved);
      controller.forceUpdate.value += 1;
    }
  }

  @override
  void mediaControlListOnCallback() {
    sheetController = showListSheet(context: Get.context!, delegate: this);
    sheetController?.models.value = controller.mediaList.value;
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

  @override
  listSheetOnPressLove(ListSheet sheet, int index, bool isLoved) {
    int time = DateTime.now().millisecondsSinceEpoch;

    task() {
      controller.removeMediaAlertTime = time;
      controller.setupLoved(sheetController!.models.value[index], !isLoved);
      sheetController?.models.value = controller.mediaList.value;
      sheetController?.forceUpdate.value += 1;
      controller.forceUpdate.value += 1;
    }

    if (time > controller.removeMediaAlertTime + 1000 * 5) {
      // 超过5s

      showAlert(Get.context!, title: "提示", content: "取消红心将会把当前资源从播放列表移除",
          sureCallback: () {
        task();
      });
    } else {
      task();
    }
  }

  @override
  listSheetItemOnPress(ListSheet sheet, int index) {
    controller.setupPlayIndex(index: index);
    sheetController?.forceUpdate.value += 1;
  }

  @override
  listSheetItemReorder(ListSheet sheet, List<MindfulnessMediaModel> newModels) {
    controller.setupReorder(newModels);
  }
}
