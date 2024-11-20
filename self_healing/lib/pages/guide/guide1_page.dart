import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/pages/guide/guide1_controller.dart';
import 'package:self_healing/routes/routes.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:self_healing/widgets/button.dart';
import 'package:self_healing/widgets/brightness/container.dart';

class Guide1Page extends GetView<Guide1Controller> {
  Guide1Page({super.key}) {
    Get.put(Guide1Controller());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("你的近况")),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                AppStyle.horizontalPadding, 0, AppStyle.horizontalPadding, 0),
            child: Obx(() {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  _Guide1Card(
                      title: "焦虑状况",
                      list: controller.anxietyList,
                      selectedIndex: controller.levelOfAnxiety.value,
                      onPress: (index) {
                        log_("press anxiety at $index");
                        controller.levelOfAnxiety.value = index;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  _Guide1Card(
                      title: "是否抑郁发作",
                      list: controller.depressionList,
                      selectedIndex: controller.levelOfDepression.value,
                      onPress: (index) {
                        log_("press depression at $index");
                        controller.levelOfDepression.value = index;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  _Guide1Card(
                      title: "是否惊恐发作",
                      list: controller.panicList,
                      selectedIndex: controller.panicAttack.value,
                      onPress: (index) {
                        log_("press panic attack at $index");
                        controller.panicAttack.value = index;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  _Guide1SomatizationWidget(
                    title: "躯体症状",
                    selectedIndex: controller.numOfSomatization.value,
                    list: controller.somatizationList,
                    onPress: (index) {
                      controller.numOfSomatization.value = index;
                    },
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ElevatedButton(
                      onPressed: controller.isEnableToPlan
                          ? () {
                              log_("obtain self healing plan");

                              Get.toNamed(Routes.guide2, arguments: [
                                controller.anxietyList[
                                    controller.levelOfAnxiety.value!],
                                controller.depressionList[
                                    controller.levelOfDepression.value!],
                                controller
                                    .panicList[controller.panicAttack.value!],
                                controller.somatizationList[
                                    controller.numOfSomatization.value!]
                              ]);
                            }
                          : null,
                      child: const Text("获取治愈计划"))
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Guide1Card extends StatelessWidget {
  const _Guide1Card(
      {required this.title,
      required this.list,
      this.selectedIndex,
      required this.onPress});

  final String title;
  final List<LevelOfSpiritModel> list;
  final int? selectedIndex;
  final void Function(int index) onPress;

  @override
  Widget build(BuildContext context) {
    return BrightnessContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppStyle.cardCornerRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyle.font18.weight600(),
            ),
            const SizedBox(
              height: 25,
            ),
            _rowWidget(context)
          ],
        ),
      ),
    );
  }

  //  焦虑等级Row
  Widget _rowWidget(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    Color _borderColor(int level) {
      return level == selectedIndex
          ? Theme.of(context).primaryColor
          : const Color.fromARGB(0, 0, 0, 0);
    }

    // ignore: no_leading_underscores_for_local_identifiers
    Color? _textColor(int level) {
      return level == selectedIndex
          ? Theme.of(context).primaryColor
          : null;
    }

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      double space = 20;
      int maxCount = 5;
      final itemW = (width - space * (maxCount - 1)) / maxCount;
      logDebug("itemW $itemW");
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: list.map((LevelOfSpiritModel model) {
          return GestureDetector(
            key: Key(model.level.toString()),
            onTap: () => onPress(model.level),
            child: SizedBox(
              child: Column(
                children: [
                  Container(
                    width: itemW,
                    height: itemW,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: model.color,
                        border: Border.all(
                            width: 3, color: _borderColor(model.level))),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    model.name,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.font16
                        .copyWith(color: _textColor(model.level)),
                  )
                ],
              ),
            ).marginOnly(right: model.level != list.length - 1 ? space : 0),
          );
        }).toList(),
      );
    });
  }
}

class _Guide1SomatizationWidget extends StatelessWidget {
  const _Guide1SomatizationWidget(
      {required this.title,
      required this.list,
      this.selectedIndex,
      required this.onPress});

  final String title;
  final List<LevelOfSpiritModel> list;
  final int? selectedIndex;
  final void Function(int index) onPress;

  @override
  Widget build(BuildContext context) {
    return BrightnessContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppStyle.cardCornerRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyle.font18.weight600(),
            ),
            const SizedBox(
              height: 25,
            ),
            _itemWidget(context),
            const SizedBox(
              height: 20,
            ),
            Image.asset("assets/imgs/guide1_anxiety_somatization.jpeg",
                fit: BoxFit.fitWidth)
          ],
        ),
      ),
    );
  }

  Widget _itemWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: list.map((LevelOfSpiritModel model) {
        double space = 20;
        return SizedBox(
            height: 40,
            width: 80,
            child: SelectedButton(
              isSelected: selectedIndex == model.level,
              onPressed: () => onPress(model.level),
              child: Text(model.name),
            )).marginOnly(right: model.level != list.length - 1 ? space : 0);
      }).toList(),
    );
  }
}
