import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Guide1Controller extends GetxController {
  var levelOfAnxiety = Rx<int?>(null);
  var levelOfDepression = Rx<int?>(null);
  var numOfSomatization = Rx<int?>(null);
  var panicAttack = Rx<int?>(null);

  bool get isEnableToPlan {
    return levelOfAnxiety.value != null &&
        levelOfDepression.value != null &&
        numOfSomatization.value != null &&
        numOfSomatization.value != null;
  }

  final anxietyList = [
    LevelOfSpiritModel(
        name: "良好", color: const Color.fromARGB(255, 164, 243, 168), level: 0),
    LevelOfSpiritModel(
        name: "轻度", color: Colors.deepOrangeAccent.shade100, level: 1),
    LevelOfSpiritModel(
        name: "中度", color: Colors.deepOrangeAccent.shade200, level: 2),
    LevelOfSpiritModel(
        name: "重度", color: Colors.deepOrangeAccent.shade700, level: 3)
  ];
  final depressionList = [
    LevelOfSpiritModel(
        name: "良好", color: const Color.fromARGB(255, 164, 243, 168), level: 0),
    LevelOfSpiritModel(
        name: "抑郁", color: const Color.fromARGB(255, 182, 179, 178), level: 1)
  ];

  final somatizationList = [
    LevelOfSpiritModel(name: "0项", level: 0),
    LevelOfSpiritModel(name: "1-3项", level: 1),
    LevelOfSpiritModel(name: "大于3项", level: 2),
  ];

  final panicList = [
    LevelOfSpiritModel(
        name: "良好", color: const Color.fromARGB(255, 164, 243, 168), level: 0),
    LevelOfSpiritModel(
        name: "惊恐", color: const Color.fromARGB(255, 227, 39, 6), level: 1)
  ];

  final String introducesAnxiety = "焦虑整体的状况，通过专业自评工具或者医生诊断给出";
  final String introducesDepression = "一般情况，长期焦虑下会伴生抑郁";
  final String introducesSomatization = "长期焦虑下会有躯体症状，它应该是非病理性的";
}

class LevelOfSpiritModel {
  String name;
  Color? color;
  int level;
  LevelOfSpiritModel({required this.name, this.color, required this.level});
}
