import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/pages/mindfulness/widgets/list_sheet/list_sheet_controller.dart';
import 'package:self_healing/toolkit/extension/list.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:self_healing/widgets/brightness/builder.dart';
import 'package:self_healing/widgets/brightness/container.dart';
import 'package:self_healing/widgets/image.dart';
import 'package:self_healing/widgets/love.dart';
import 'package:self_healing/widgets/tag_w.dart';

showListSheet(
    {required BuildContext context, required ListSheetDelegate delegate}) {
  final controller = ListSheetController();
  Get.delete<ListSheetController>();
  Get.put(controller);
  showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      builder: (builder) => ListSheet(
            delegate: delegate,
          ));
  return controller;
}

abstract class ListSheetDelegate {
  listSheetOnPressLove(ListSheet sheet, int index, bool isLoved);
  listSheetItemOnPress(ListSheet sheet, int index);
  listSheetItemReorder(ListSheet sheet, List<MindfulnessMediaModel> newModels);
}

class ListSheet extends GetView<ListSheetController> {
  const ListSheet({Key? key, required this.delegate}) : super(key: key);
  final ListSheetDelegate delegate;

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
                      color: Color.fromARGB(255, 108, 108, 108)),
                )
              ]));
            }),
            SizedBox(
              height: 20,
            ),
            Expanded(child: Obx(() {
              "${controller.forceUpdate}";
              return ReorderableListView(
                itemExtent: 70,
                children: controller.models.value.mapE((model, i) {
                  return _ItemWidget(
                    key: Key(model.src),
                    model: model,
                    onLoved: (isLoved) {
                      delegate.listSheetOnPressLove(this, i, isLoved);
                    },
                    onPress: (_) {
                      delegate.listSheetItemOnPress(this, i);
                    },
                  );
                }),
                onReorder: (int oldIndex, int newIndex) {
                  log_("onReorder $oldIndex , $newIndex");
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  controller.models.value.exchangeE(oldIndex, newIndex);
                  controller.forceUpdate.value += 1;
                  delegate.listSheetItemReorder(this, controller.models.value);
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
      {Key? key,
      required this.model,
      required this.onPress,
      required this.onLoved})
      : super(key: key);
  final MindfulnessMediaModel model;
  final Function(MindfulnessMediaModel) onPress;
  final Function(bool isLoved) onLoved;
  @override
  Widget build(BuildContext context) {
    BoxDecoration? box;
    final _state = context.findAncestorStateOfType<BrightnessContainerState>();
    if (_state is BrightnessContainerState) {
      final _box = (_state).container.decoration;
      if (_box is BoxDecoration) {
        box = _box;
      }
    }

    return GestureDetector(
      onTap: () => onPress(model),
      child: Container(
        color: box?.color,
        // height: 70,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppStyle.imgCornerSmallRadius),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: MiniNetImage(src: model.cover),
                )),
            SizedBox(
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
            SizedBox(
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
            style: AppTextStyle.font14.copyWith(color: color),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                time,
                style: AppTextStyle.font12.copyWith(color: color),
              ),
              SizedBox(
                width: 10,
              ),
              TagW(
                text: tag,
                textStyle: TextStyle(color: color, fontSize: 12),
              )
            ],
          )
        ],
      ),
    );
  }
}
