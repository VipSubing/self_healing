import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_service.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/widgets/brightness/image.dart';
import 'package:self_healing/widgets/dialog/alert.dart';
import 'package:self_healing/widgets/image.dart';
import 'package:self_healing/widgets/love.dart';
import 'package:self_healing/widgets/tag_w.dart';

class MediaDetailsPage extends GetView<MindfulnessService> {
  MediaDetailsPage({super.key}) : media = Get.arguments;
  MindfulnessMediaModel media;

  onLoved(bool isLoved) {
    if (isLoved) {
      showPlainAlert(Get.context!, title: "提示", content: "取消红心将会把当前资源从播放列表移除",
          sureCallback: () {
        controller.setupLoved(media, !isLoved);
      });
    } else {
      controller.setupLoved(media, !isLoved);
    }
  }

  onPlay() {
    controller.setupAddPlay(media);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "详情",
          ),
        ),
        actions: [
          Obx(() {
            "${controller.mediaList}";
            return LoveWidget(
              isLoved: media.isLoved,
              onPress: onLoved,
              width: 30,
              height: 30,
            );
          }),
          SizedBox(
            width: AppStyle.horizontalPadding,
          )
        ],
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.only(
            left: AppStyle.horizontalPadding,
            right: AppStyle.horizontalPadding),
        child: ListView(
          children: [
            media.cover != null
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppStyle.imgCornerRadius),
                    child: NetImage(
                      src: media.cover,
                      width: MediaQuery.of(context).size.width -
                          AppStyle.horizontalPadding * 2,
                    ))
                : const SizedBox(),
            const SizedBox(
              height: 20,
            ),
            Text(
              media.name,
              style: AppTextStyle.font28.weight700(),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                TagW(
                  text: media.type.name,
                  textStyle: AppTextStyle.font16,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  formatMinutes(media.duration),
                  style: AppTextStyle.font16,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "199次收藏",
                  style: AppTextStyle.font16,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              media.desc ?? "",
              style: AppTextStyle.font18,
              maxLines: null,
            )
          ],
        ),
      )),
    );
  }
}
