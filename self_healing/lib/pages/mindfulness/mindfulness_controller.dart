import 'package:get/get.dart';
import 'package:self_healing/basic/app_prefference.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_media_controller.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/toolkit/extension/list.dart';
import 'package:self_healing/toolkit/log.dart';

class MindfulnessController extends GetxController
    implements MindfulnessMediaControllerDelegate {
  late Rx<MindfulnessMediaModel> media;
  Rx<int> playIndex = () {
    Rx<int> rx = 0.obs;
    rx.equalityRebuild = true;
    return rx;
  }();
  late Rx<List<MindfulnessMediaModel>> mediaList;
  late MindfulnessMediaController mediaController;
  var forceUpdate = 0.obs;
  int removeMediaAlertTime = 0;
  MindfulnessController() {
    playIndex.value = AppPrefference.shared.currentMediaIndex;
    mediaList = Rx<List<MindfulnessMediaModel>>(AppPrefference.shared.playList);
    if (mediaList.value.length <= playIndex.value) {
      playIndex.value = 0;
    }
    media = mediaList.value[playIndex.value].obs;

    mediaController = MindfulnessMediaController(delegate: this);

    mediaController.setupPlayList(mediaList.value.mapE((item, i) {
      return item.src;
    }));
    mediaController.mediaSetup(src: media.value.src, autoPlay: false);
  }
  @override
  onInit() {
    super.onInit();
    ever(mediaList, (_) {
      mediaController.setupPlayList(mediaList.value.mapE((item, i) {
        return item.src;
      }));
      logDebug("set mediaList:${_.map((item) => item.name)}", methodCount: 3);
      AppPrefference.shared.playList = mediaList.value;
    });
    ever(playIndex, (_) {
      log_("set playIndex:$_");
      media.value = mediaList.value[playIndex.value];
      AppPrefference.shared.currentMediaIndex = playIndex.value;
    });
  }

  //播放
  setupPlay({required MindfulnessMediaModel media, bool autoPlay = true}) {
    if (media.src == this.media.value.src) {
      return;
    }
    int index = mediaList.value.indexWhere((item) => item.src == media.src);
    playIndex.value = index;
    mediaController.mediaSetup(src: media.src, autoPlay: autoPlay);
  }

  //播放
  setupPlayIndex({required int index, bool autoPlay = true}) {
    MindfulnessMediaModel media = mediaList.value[index];
    setupPlay(media: media, autoPlay: autoPlay);
  }

  // 重排
  setupReorder(List<MindfulnessMediaModel> list) {
    mediaList.value = list.copyE();
    playIndex.value = list.indexWhere((item) => item.isPlaying);
  }

  setupAddPlay(MindfulnessMediaModel media) {
    setupLoved(media, true);
    setupPlay(media: media, autoPlay: true);
  }

  // 收藏
  setupLoved(MindfulnessMediaModel media, bool isLoved) {
    if (isLoved) {
      if (!mediaList.value.contains(media)) {
        mediaList.value.insert(0, media.copy());
        mediaList.value = mediaList.value.copyE();
        playIndex.value += 1;
      }
    } else {
      int index = mediaList.value.indexOf(media);
      if (index != -1 && mediaList.value.length > 1) {
        mediaList.value.removeAt(index);
        mediaList.value = mediaList.value.copyE();
        if (playIndex.value == index) {
          // 正在播放这个Media,切换到下一个
          if (playIndex.value >= mediaList.value.length) {
            // index溢出 ,播放第一个
            setupPlayIndex(index: 0, autoPlay: false);
          } else {
            setupPlayIndex(index: playIndex.value, autoPlay: false);
          }
        } else if (playIndex.value < index) {
        } else if (playIndex.value > index) {
          playIndex.value -= 1;
        }
      }
    }
  }

  /* MindfulnessMediaControllerDelegate */
  @override
  void mediaControllerPreparePlay(String src) {
    if (media.value.src == src) {
      return;
    }
    int index = mediaList.value.indexWhere((item) => item.src == src);
    playIndex.value = index;
  }
}
