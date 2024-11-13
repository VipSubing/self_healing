import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:self_healing/toolkit/oss.dart';

class MediaCreateController extends GetxController {
  MindfulnessMediaModel? media;
  var name = Rx<String?>(null);
  var type = Rx<String?>(null);
  var duration = Rx<int?>(null);
  var mediaSrc = Rx<String?>(null);
  var description = Rx<String?>(null);
  var coverSrc = Rx<String?>(null);

  var isCommitEnable = false.obs;

  final audioPlayer = AudioPlayer();

  @override
  onInit() {
    super.onInit();

    everAll([name, mediaSrc, type], (_) {
      isCommitEnable.value = (name.value != null &&
              mediaSrc.value != null &&
              type.value != null) &&
          name.value!.length > 0 &&
          mediaSrc.value!.length > 0 &&
          type.value!.length > 0;
    });

    audioPlayer.onDurationChanged.listen((Duration d) {
      duration.value = d.inSeconds;
    });
    audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  @override
  void onClose() {
    super.onClose();
    audioPlayer.release();
    audioPlayer.dispose();
  }

  Future<bool> setMedia(String src) async {
    var res = true;
    await audioPlayer.release();
    try {
      await audioPlayer.setSourceDeviceFile(src);
    } catch (e) {
      res = false;
    }
    if (res) {
      mediaSrc.value = src;
    }
    return res;
  }

  Future<String> upload() async {
    var mediaUrl = await Oss.shared
        .uploadSimple(srcPath: mediaSrc.value!, type: OSSType.media);
    var coverUrl = coverSrc.value != null
        ? await Oss.shared
            .uploadSimple(srcPath: coverSrc.value!, type: OSSType.img)
        : null;

    var model = MindfulnessMediaModel(
        duration: duration.value!,
        name: name.value!,
        src: mediaUrl,
        cover: coverUrl,
        desc: description.value,
        type: MindfulnessMediaType.values
            .where((item) => type.value! == item.name)
            .first);
    String jsonString = jsonEncode(model.toJson());
    Uint8List uint8List = utf8.encode(jsonString);
    return await Oss.shared
        .uploadSimple(byteArr: uint8List, type: OSSType.json);
  }
}
