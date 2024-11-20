import 'dart:async';

import 'package:get/get.dart';
// import 'package:self_healing/basic/const.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_service.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/toolkit/extension/list.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:self_healing/toolkit/oss.dart';

class MediaShopController extends GetxController {
  Rx<List<MindfulnessMediaModel>> list = Rx<List<MindfulnessMediaModel>>([]);
  List<MindfulnessMediaModel> totalList = [];
  int page = 0;
  bool hasMore = false;
  var forceUpdate = 0.obs;
  int removeMediaAlertTime = 0;

  Future request(int page) async {
    var result = await Oss.shared.getJsons(page == 0);
    hasMore = result.item2;

    if (page == 0) {
      totalList.clear();
    }
    final jsons = result.item1;
    totalList.addAll(
        jsons.map((item) => MindfulnessMediaModel.fromJson(item)).toList());

    list.value = totalList;
    this.page = page;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    log_("MediaShopController onInit");
  }

  @override
  onReady() {
    super.onReady();
    log_("MediaShopController onReady");
  }

  @override
  onClose() {
    super.onClose();
    log_("MediaShopController onClose");
  }

  search(String text) {
    list.value = totalList.findE((item, index) {
      if (item.name.contains(text) || item.type.name.contains(text)) {
        return true;
      }
      return false;
    });
  }

  cancleSearch() {
    list.value = totalList;
  }

  addToList(MindfulnessMediaModel media, bool isLoved) {
    Get.find<MindfulnessService>().setupLoved(media, isLoved);
    forceUpdate.value += 1;
  }
}
