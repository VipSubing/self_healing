import 'package:get/get.dart';
import 'package:self_healing/basic/const.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_controller.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/toolkit/extension/list.dart';

class MediaShopController extends GetxController {
  Rx<List<MindfulnessMediaModel>> list = () {
    var rx = Rx<List<MindfulnessMediaModel>>([]);
    rx.equalityRebuild = true;
    return rx;
  }();
  List<MindfulnessMediaModel> totalList = [];
  int page = 0;
  bool hasMore = false;
  var forceUpdate = 0.obs;
  int removeMediaAlertTime = 0;
  
  request(int page) async {
    final jsons = defaultMediaJsonList;
    if (page == 0) {
      this.totalList.clear();
    }
    this.totalList.addAll(
        jsons.map((item) => MindfulnessMediaModel.fromJson(item)).toList());

    this.list.value = this.totalList;
    this.page = page;
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
    this.list.value = this.totalList;
  }

  addToList(MindfulnessMediaModel media, bool isLoved) {
    // Get.find<MindfulnessController>().setupAddPlay(media);
    Get.find<MindfulnessController>().setupLoved(media, isLoved);
    forceUpdate.value += 1;
  }
}
