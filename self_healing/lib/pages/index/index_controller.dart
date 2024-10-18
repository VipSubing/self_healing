import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_page.dart';
import 'package:self_healing/toolkit/log.dart';

class IndexController extends GetxController {
  var pages = <Widget>[
    const SizedBox(),
    const SizedBox(),
    MindfulnessPage(),
    const SizedBox(),
    const SizedBox(),
  ].obs;
  var pageIndex = 2.obs;

  get tabItems {
    return [
      const BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/icons/sport_tab.png")),
          label: "运动"),
      const BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/icons/society_tab.png")),
          label: "社会支持"),
      const BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/icons/mindfulness_tab.png")),
          label: "正念练习"),
      const BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/icons/cbt_tab.png")),
          label: "CBT"),
      const BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/icons/me_tab.png")), label: "我的"),
    ];
  }

  @override
  void onInit() {
    logDebug("IndexController init");
    super.onInit();
  }

  @override
  void onClose() {
    logDebug("IndexController close");
    super.onClose();
  }
  // void onDel

  void onSelected(int index) {
    log_("tab selected $index");
    pageIndex.value = index;
    var page = pages[index];
    if (page is SizedBox) {
      pages[index] = const SizedBox();
      page = pages[index];
    }
  }
}
