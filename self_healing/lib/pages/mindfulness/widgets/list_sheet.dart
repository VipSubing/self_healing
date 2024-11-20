import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_service.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/toolkit/extension/list.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:self_healing/widgets/brightness/builder.dart';
import 'package:self_healing/widgets/brightness/container.dart';
import 'package:self_healing/widgets/dialog/alert.dart';
import 'package:self_healing/widgets/image.dart';
import 'package:self_healing/widgets/love.dart';
import 'package:self_healing/widgets/tag_w.dart';

showListSheet({required BuildContext context}) {
  showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      builder: (builder) => const ListSheet());
}

class ListSheet extends GetView<MindfulnessService> {
  const ListSheet({super.key});
  onLove(MindfulnessMediaModel media, bool isLoved) {
    int time = DateTime.now().millisecondsSinceEpoch;

    task() {
      controller.removeMediaAlertTime = time;
      controller.setupLoved(media, !isLoved);
    }

    if (time > controller.removeMediaAlertTime + 1000 * 5) {
      // 超过5s

      showPlainAlert(Get.context!, title: "提示", content: "取消红心将会把当前资源从播放列表移除",
          sureCallback: () {
        task();
      });
    } else {
      task();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BrightnessContainer(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppStyle.cardCornerRadius)),
      height: MediaQuery.of(context).size.height / 5 * 5,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
          left: AppStyle.horizontalPadding,
          right: AppStyle.horizontalPadding,
          top: 20),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BrightnessBuilder(builder: (context, isDark) {
              return Text.rich(TextSpan(children: [
                TextSpan(
                  text: "当前播放列表",
                  style: AppTextStyle.font18.weight600(),
                ),
                TextSpan(
                  text: "(长按拖动可调整播放顺序)",
                  style: AppTextStyle.font18.brightnessColor(
                      color: const Color.fromARGB(255, 108, 108, 108)),
                )
              ]));
            }),
            const SizedBox(
              height: 20,
            ),
            Expanded(child: Obx(() {
              "${controller.playIndex}";
              return ReorderableListView(
                itemExtent: 70,
                children: controller.mediaList.value.mapE((model, i) {
                  return _ItemWidget(
                    key: Key(model.src),
                    model: model,
                    onLoved: (isLoved) {
                      onLove(controller.mediaList.value[i], isLoved);
                    },
                    onPress: (_) {
                      controller.setupPlayIndex(index: i);
                    },
                  );
                }),
                onReorder: (int oldIndex, int newIndex) {
                  log_("onReorder $oldIndex , $newIndex");
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  var list = controller.mediaList.value.copyE();
                  list.exchangeE(oldIndex, newIndex);
                  controller.setupReorder(list);
                },
              );
            }))
          ],
        ),
      ),
    );
  }
}

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
    BoxDecoration? box;
    final state = context.findAncestorStateOfType<BrightnessContainerState>();
    if (state is BrightnessContainerState) {
      final box0 = (state).container.decoration;
      if (box0 is BoxDecoration) {
        box = box0;
      }
    }

    return GestureDetector(
      onTap: () => onPress(model),
      child: Container(
        color: box?.color,
        // height: 70,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppStyle.imgCornerSmallRadius),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: NetImage(src: model.cover),
                )),
            const SizedBox(
              width: 10,
            ),
            _textW(context, model.name, formatMinutes(model.duration),
                model.type.name, model.isPlaying),
            const Spacer(),
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
            SizedBox(
              height: 20,
              width: 20,
              child: model.isPlaying
                  ? Image.asset(
                      "assets/icons/player_playing_icon.png",
                      fit: BoxFit.contain,
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }

  Widget _textW(BuildContext context, String name, String time, String tag,
      bool isSelected) {
    final color = isSelected ? Theme.of(context).primaryColor : null;
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            maxLines: 1,
            style: AppTextStyle.font14.copyWith(color: color),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              TagW(
                text: tag,
                textStyle: TextStyle(color: color, fontSize: 12),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                time,
                style: AppTextStyle.font12.copyWith(color: color),
              ),
            ],
          )
        ],
      ),
    );
  }
}
