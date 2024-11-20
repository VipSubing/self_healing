import 'package:get/get.dart';
import 'package:self_healing/pages/mindfulness/mindfulness_media_controller.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/pages/mindfulness/other/audio/store.dart';
import 'package:self_healing/toolkit/extension/list.dart';
import 'package:self_healing/toolkit/log.dart';

class MindfulnessService extends GetxService
    implements MindfulnessMediaControllerDelegate {
  final store = MindfulessStore.shared;
  late Rx<MindfulnessMediaModel> media;

  static bool inited = false;

  static MindfulnessService shared() {
    if (!inited) {
      inited = true;
      Get.put(MindfulnessService());
    }
    return Get.find<MindfulnessService>();
  }

  Rx<int> playIndex = 0.obs;
  late Rx<List<MindfulnessMediaModel>> mediaList;
  late MindfulnessMediaController mediaController;
  int removeMediaAlertTime = 0;
  int statisticsTime = 0;
  MindfulnessService() {
    playIndex.value = store.currentMediaIndex;
    mediaList = Rx<List<MindfulnessMediaModel>>(store.playList);
    if (mediaList.value.length <= playIndex.value) {
      playIndex.value = 0;
    }
    media = mediaList.value[playIndex.value].obs;

    mediaController = MindfulnessMediaController(delegate: this);

    mediaController.setupPlayList(mediaList.value.mapE((item, i) {
      return item.src;
    }));
    mediaController.mediaSetup(src: media.value.src, autoPlay: false);

    mediaController.isPlaying.listen((isPlaying) {
      int time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (isPlaying) {
        statisticsTime = time;
      } else {
        if (statisticsTime != 0) {
          store.historyTime += time - statisticsTime;
        }
      }
    });
  }
  @override
  onInit() {
    super.onInit();
    ever(mediaList, (_) {
      mediaController.setupPlayList(mediaList.value.mapE((item, i) {
        return item.src;
      }));
      logDebug("set mediaList:${_.map((item) => item.name)}", methodCount: 3);
      store.playList = mediaList.value;
    });
    ever(playIndex, (_) {
      log_("set playIndex:$_");
      media.value = mediaList.value[playIndex.value];
      store.currentMediaIndex = playIndex.value;
    });
  }

  @override
  void onClose() {
    super.onClose();
    mediaController.disposeAudio();
  }

  //播放
  setupPlay({required MindfulnessMediaModel media, bool autoPlay = true}) {
    if (media.src == this.media.value.src) {
      return;
    }
    mediaController.mediaSetup(src: media.src, autoPlay: autoPlay);
  }

  //播放
  setupPlayIndex({required int index, bool autoPlay = true}) {
    MindfulnessMediaModel media = mediaList.value[index];
    setupPlay(media: media, autoPlay: autoPlay);
  }

  // 重排
  setupReorder(List<MindfulnessMediaModel> list) {
    mediaList.trigger(list);
    playIndex.trigger(list.indexWhere((item) => item.isPlaying));
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
        mediaList.update((_) {});
        playIndex.value += 1;
      }
    } else {
      int index = mediaList.value.indexOf(media);
      if (index != -1 && mediaList.value.length > 1) {
        mediaList.value.removeAt(index);
        mediaList.update((_) {});
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
    var map = store.historyStatistics;
    map[src] = (map[src] ?? 0) + 1;
    store.historyStatistics = map;

    int index = mediaList.value.indexWhere((item) => item.src == src);
    playIndex.trigger(index);
  }

  @override
  MindfulnessMediaModel? mediaControllerGetName(String src) {
    for (var i = 0; i < mediaList.value.length; i++) {
      if (mediaList.value[i].src == src) {
        return mediaList.value[i];
      }
    }
    return null;
  }
}
