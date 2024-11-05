import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
// import 'package:flutter_easyrefresh/flutter_easyrefresh.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_controller.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/pages/mindfulness/pages/shop/media_shop_controller.dart';
import 'package:self_healing/routes/routes.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:self_healing/widgets/brightness/builder.dart';
import 'package:self_healing/widgets/brightness/container.dart';
import 'package:self_healing/widgets/brightness/image.dart';
import 'package:self_healing/widgets/brightness/text.dart';
import 'package:self_healing/widgets/dialog/alert.dart';
import 'package:self_healing/widgets/image.dart';
import 'package:self_healing/widgets/love.dart';
import 'package:self_healing/widgets/tag_w.dart';

class MediaShopPage extends GetView<MediaShopController> {
  MediaShopPage({super.key}) {
    var controller = MediaShopController();
    Get.put(controller);

    controller.request(controller.page);
  }
  final refreshController = EasyRefreshController();
  final searchController = TextEditingController();
  final playerController = Get.find<MindfulnessController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("更多正念")),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.only(
            left: AppStyle.horizontalPadding,
            right: AppStyle.horizontalPadding),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width -
                      AppStyle.horizontalPadding * 2 -
                      60,
                  child: SearchBar(
                      controller: searchController,
                      leading: const Icon(Icons.search),
                      hintText: "搜索",
                      elevation: WidgetStateProperty.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.focused)) {
                            return 0.5;
                          }
                          return 0;
                        },
                      ),
                      //控制内容与搜索框的边距
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16),
                      ),
                      textInputAction: TextInputAction.search,
                      //修改形状
                      shape: WidgetStatePropertyAll<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onSubmitted: search,
                      onTapOutside: (p) {
                        FocusScope.of(context).unfocus();
                      }),
                ),
                SizedBox(
                    width: 60,
                    child: TextButton(
                        onPressed: onCancleSearch,
                        child: BrightnessText(
                          "取消",
                          color: Colors.black,
                          style: AppTextStyle.font16,
                        )))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Obx(() {
                "${controller.forceUpdate}";
                "${playerController.mediaList}";
                return EasyRefresh(
                  controller: refreshController,
                  // onRefresh: () async {
                  //   controller.request(controller.page);
                  // },
                  child: ListView.builder(
                    itemExtent: 80,
                    itemCount: controller.list.value.length,
                    itemBuilder: (context, index) {
                      return _ItemWidget(
                        key: ValueKey(index),
                        model: controller.list.value[index],
                        onLoved: (isLoved) =>
                            onLoved(controller.list.value[index], isLoved),
                        onPress: onItemPress,
                      );
                    },
                  ),
                );
              }),
            )
          ],
        ),
      )),
    );
  }

  search(String text) {
    log_("search words: $text");
    if (text.isNotEmpty) {
      controller.search(text);
    }
  }

  onLoved(MindfulnessMediaModel media, bool isLoved) {
    if (isLoved) {
      int time = DateTime.now().millisecondsSinceEpoch;

      if (time > controller.removeMediaAlertTime + 1000 * 5) {
        // 超过5s
        showAlert(Get.context!, title: "提示", content: "取消红心将会把当前资源从播放列表移除",
            sureCallback: () {
          controller.addToList(media, !isLoved);
        });
      } else {
        controller.addToList(media, !isLoved);
      }
      controller.removeMediaAlertTime = time;
    } else {
      controller.addToList(media, !isLoved);
    }
  }

  onItemPress(MindfulnessMediaModel media) {
    Get.toNamed(Routes.mindfulnessDetails, arguments: media.copy());
    // logDebug("onItemPress");
  }

  onCancleSearch() {
    controller.cancleSearch();
    searchController.clear();
  }
}

/// List  Item
class _ItemWidget extends StatelessWidget {
  const _ItemWidget(
      {super.key,
      required this.model,
      required this.onPress,
      required this.onLoved});
  final MindfulnessMediaModel model;
  final Function(MindfulnessMediaModel) onPress;
  final Function(bool isLoved) onLoved;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(model),
      child: BrightnessBuilder(builder: (context, isDark) {
        return Container(
          color: AppStyle.backgroundColor(isDark),
          // height: 70,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppStyle.imgCornerSmallRadius),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: NetImage(src: model.cover),
                  )),
              const SizedBox(
                width: 10,
              ),
              _textW(context, model.name, formatMinutes(model.duration),
                  model.type.name, model.isPlaying),
              Spacer(),
              LoveWidget(
                width: 30,
                height: 30,
                isLoved: model.isLoved,
                onPress: (isLoved) {
                  log_("list on loved :$isLoved");
                  onLoved(isLoved);
                },
              ),
              const SizedBox(
                width: 30,
              ),
              const BrightnessIcon(
                src: "assets/icons/arrow_right_icon.png",
                size: Size(30, 30),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _textW(BuildContext context, String name, String time, String tag,
      bool isSelected) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTextStyle.font14,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              TagW(
                text: tag,
                textStyle: AppTextStyle.font12,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                time,
                style: AppTextStyle.font12,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "199次收藏",
                style: AppTextStyle.font12,
              ),
            ],
          )
        ],
      ),
    );
  }
}
