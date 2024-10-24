import 'dart:async';

import 'package:get/get.dart';
import 'package:self_healing/basic/app_prefference.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_media_controller.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/toolkit/extension/list.dart';
import 'package:self_healing/toolkit/log.dart';

class MindfulnessController extends GetxController
    implements MindfulnessMediaControllerDelegate {
  late Rx<MindfulnessMediaModel> media;

  late Rx<List<MindfulnessMediaModel>> mediaList;
  late MindfulnessMediaController mediaController;
  var forceUpdate = 0.obs;
  
  MindfulnessController() {
    media = AppPrefference.shared.currentMedia.obs;

    mediaList = Rx<List<MindfulnessMediaModel>>(AppPrefference.shared.playList);
    mediaController = MindfulnessMediaController(delegate: this);
    mediaController.mediaSetup(src: media.value.src, autoPlay: false);
    mediaController.setupPlayList(mediaList.value.mapE((item, i) {
      return item.src;
    }));

    ever(mediaList, (_) {
      mediaController.setupPlayList(mediaList.value.mapE((item, i) {
        return item.src;
      }));
      AppPrefference.shared.playList = mediaList.value;
    });
    ever(media, (_) {
      AppPrefference.shared.currentMedia = media.value;
    });
  }
  //
  setup(MindfulnessMediaModel media_) {
    if (media_.src == media.value.src) {
      return;
    }
    media.value = media_;
    mediaController.mediaSetup(src: media_.src);
  }

  /* MindfulnessMediaControllerDelegate */
  @override
  void mediaControllerPreparePlay(String src) {
    if (media.value.src == src) {
      return;
    }
    media.value = mediaList.value.findE((item, i) {
      return item.src == src;
    }).first;
  }
}
