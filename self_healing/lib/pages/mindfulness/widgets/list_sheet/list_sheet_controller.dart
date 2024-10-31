import 'package:get/get.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/toolkit/log.dart';

class ListSheetController extends GetxController {
  Rx<List<MindfulnessMediaModel>> models = Rx<List<MindfulnessMediaModel>>([]);
  var forceUpdate = 0.obs;
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    log_("ListSheetController dispose");
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    log_("ListSheetController onClose");
  }
}
