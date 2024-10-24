import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:self_healing/basic/app_prefference.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/pages/guide/guide1_controller.dart';
import 'package:self_healing/pages/index/index_page.dart';
import 'package:self_healing/routes/routes.dart';
import 'package:self_healing/toolkit/extension/list.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:self_healing/widgets/builder.dart';
import 'package:self_healing/widgets/container.dart';

class Guide2Page extends GetView {
  Guide2Page({super.key}) : this.modelList = Get.arguments;

  final totalPlanModels = [
    _PlanItem(
        name: "药物",
        icon: "assets/icons/medicine_icon.png",
        exposition:
            "服用药物（如帕罗西汀,西酞普兰等，请注意它的副作用），可以快速改善焦虑抑郁。经过治疗期（时长一般在1.5-2.5年）后可断药。",
        grade: 1,
        iconColor: Colors.blueAccent),
    _PlanItem(
        name: "正念",
        icon: "assets/icons/mindfulness_tab.png",
        exposition: "正念Mindfulness，正在飞速发展的治疗焦虑抑郁的工具，经过长期的科学实践，对改善焦虑抑郁非常有效。",
        grade: 1,
        iconColor: Color.fromARGB(255, 79, 242, 131)),
    _PlanItem(
        name: "CBT",
        icon: "assets/icons/cbt_tab.png",
        exposition: "认知行为疗法(CBT)，源自于心理咨询，针对人格中的不合理信念和错误认知有纠正作用，从而改善焦虑。",
        grade: 0,
        iconColor: Color.fromARGB(255, 79, 218, 242)),
    _PlanItem(
        name: "支持",
        icon: "assets/icons/society_tab.png",
        exposition: "社会支持，从人际关系角度来缓解焦虑，获得他人的爱和支持，给焦虑一个释放的出口。",
        grade: 0,
        iconColor: Colors.pink),
    _PlanItem(
        name: "运动",
        icon: "assets/icons/sport_tab.png",
        exposition: "运动过程释放多巴胺，缓解紧张，放松大脑",
        grade: 0,
        iconColor: Color.fromARGB(255, 224, 14, 14)),
  ];

  final List<LevelOfSpiritModel> modelList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("治愈计划")),
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              AppStyle.horizontalPadding, 0, AppStyle.horizontalPadding, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: 20,
              // ),
              // _conditionW(
              //     context, "焦虑", Get.arguments[0] as LevelOfSpiritModel, false),
              // _conditionW(
              //     context, "抑郁", Get.arguments[1] as LevelOfSpiritModel, false),
              // _conditionW(
              //     context, "躯体症", Get.arguments[2] as LevelOfSpiritModel, true),
              _stateW(context, modelList),
              SizedBox(
                height: 20,
              ),
              Text(
                _conditionSummary(),
                style: AppTextStyle.font18.weight700(),
              ),
              ..._itemModels().map((itemModel) {
                return _planItemW(context, itemModel);
              }),
              SizedBox(
                height: 60,
              ),
              ElevatedButton(
                  onPressed: () {
                    log_("touch 开始治愈");
                    AppPrefference.shared.isFirstLoad = false;
                    Get.offAllNamed(Routes.index);
                  },
                  child: Text("治愈"))
            ],
          ),
        )
      ]),
    );
  }

  Widget _stateW(BuildContext context, List<LevelOfSpiritModel> list) {
    Widget _circleWidget(
        BuildContext context, LevelOfSpiritModel model, String text) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: model.color,
            ),
          ),
          SizedBox(height: 5),
          Text(text, textAlign: TextAlign.center, style: AppTextStyle.font16),
        ],
      );
    }

    final topList = list.sublist(0, 3);
    var topTextList = [];
    for (var i = 0; i < topList.length; i++) {
      if (i == 0) {
        topTextList.add("${topList[i].name}焦虑");
      } else if (i == 1) {
        topTextList.add(topList[i].level == 0 ? "无抑郁" : "抑郁发作");
      } else if (i == 2) {
        topTextList.add(topList[i].level == 0 ? "无惊恐" : "惊恐发作");
      }
    }
    return BrightnessContainer(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppStyle.cardCornerRadius),
              ),
          padding: EdgeInsets.all(AppStyle.sizeBoxPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...topList.mapE((model, i) {
                    // log_(i);
                    return _circleWidget(context, model, topTextList[i]);
                  })
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "躯体症${list[3].name}",
                style: AppTextStyle.font20,
              )
            ],
          ));
  }

  // 状态统计
  Widget _conditionW(BuildContext context, String title,
      LevelOfSpiritModel model, bool isPlainText) {
    return SizedBox(
      height: 55,
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: AppTextStyle.font18,
            ),
          ),
          isPlainText
              ? Text(
                  model.name,
                  style: AppTextStyle.font18,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: model.color,
                      ),
                    ),

                    // SizedBox(height: 5),
                    Text(model.name,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.font12),
                  ],
                )
        ],
      ),
    );
  }

  // plan item
  Widget _planItemW(BuildContext context, _PlanItem itemModel) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppStyle.cardCornerRadius)),
              color: AppStyle.themeColor,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(child: BrightnessBuilder(builder:  (context , isDark) {
            return BrightnessContainer(
              decoration:  BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppStyle.cardCornerRadius),
                  border: Border.all(
                      width: 1,
                      color: AppStyle.borderLineColor(isDark))),
              child: Padding(
                padding: EdgeInsets.all(AppStyle.sizeBoxPadding),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _planItem_headerW(context, itemModel),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Text(
                      itemModel.exposition,
                      style: AppTextStyle.font16,
                      softWrap: true,
                      maxLines: null,
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        itemModel.gradeText(),
                        style: AppTextStyle.font18
                            .weight700()
                            .copyWith(color: AppStyle.themeColor),
                      ),
                    )
                  ],
                ),
              ),
            );
          }))
        ],
      ),
    );
  }

  Widget _planItem_headerW(BuildContext context, _PlanItem itemModel) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: itemModel.iconColor,
          ),
          child: Center(
            child: Image.asset(
              itemModel.icon,
              fit: BoxFit.contain,
              width: 20,
              height: 20,
            ),
          ),
        ),
        Text(
          itemModel.name,
          style: AppTextStyle.font12
              .weight700()
              .copyWith(color: AppStyle.themeColor),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  List<_PlanItem> _itemModels() {
    if (_takeMedicine()) {
      return totalPlanModels;
    }
    return totalPlanModels.sublist(1);
  }

  String _conditionSummary() {
    final model1 = modelList[0];
    final model2 = modelList[1];
    final model3 = modelList[2];
    if (model1.level == 0 && model2.level == 0) {
      // 没有焦虑和抑郁

      return "你的状态良好。";
    }
    return """
你当下处境困难，精神痛苦。
如果你想走出来，请按照下面${_itemModels().length}条建议去做，效果显著！（甘露：10分建议去做；良药：8分建议去做；）
    """;
  }

  bool _takeMedicine() {
    final model1 = modelList[0];
    final model2 = modelList[1];
    final model3 = modelList[2];

    return (model1.level > 0 && model2.level > 0) ||
        model1.level >= 2 ||
        (model1.level > 0 && model3.level > 1);
  }
}

class _PlanItem {
  final String name;
  final String icon;
  final String exposition;
  final int grade;
  final Color iconColor;

  _PlanItem(
      {required this.name,
      required this.icon,
      required this.exposition,
      required this.grade,
      required this.iconColor});

  String gradeText() {
    return ["良药", "甘露"][grade];
  }
}
