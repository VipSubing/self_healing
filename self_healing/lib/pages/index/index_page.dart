import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:self_healing/pages/index/index_controller.dart';
import 'package:self_healing/toolkit/log.dart';

class IndexPage extends GetView<IndexController> {
  IndexPage({super.key}) {
    Get.put(IndexController());
    logDebug("IndexPage init");
  }

  // onInint
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Test"),
        ),
        body: Obx(() => IndexedStack(
              index: controller.pageIndex.value,
              children: controller.pages,
            )),
        bottomNavigationBar: _navigationBar(context));
  }

  Widget _navigationBar(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          elevation: 1,
          currentIndex: controller.pageIndex.value,
          items: controller.tabItems,
          onTap: controller.onSelected,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? const Color.fromARGB(255, 239, 237, 237)
              : const Color.fromARGB(255, 36, 36, 40),
          type: BottomNavigationBarType.fixed,
          // selectedLabelStyle: TextStyle(color: primaryColor),
          iconSize: 28,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedItemColor: Theme.of(context).primaryColor,
          // unselectedItemColor: Colors.transparent,
        ));
  }
}
